# Guest cart → logged-in account (Vendure server + Flutter)

For the Orders dashboard to show the **customer** instead of **Guest** after login, the app uses **claimGuestOrder** and optionally the guest token.

## How ClaimGuestOrder runs in the shop API

- **Endpoint:** The Flutter app sends the mutation to the **shop API** URL from `.env`: `SHOP_API_URL` (e.g. `https://kaaikani.co.in/shop-api` or `http://192.168.31.194:80/shop-api`). All app GraphQL requests (queries and mutations) go to this URL via `GraphqlService.client` (`lib/services/graphql_client.dart`).
- **Request:** `ClaimGuestOrder` is sent as a normal GraphQL **mutation** over HTTP POST to that URL. The body includes the operation name, the mutation document (from `lib/graphql/order.graphql`), and variables: `{ "guestOrderCode": "<saved_code>" }`.
- **Headers:** The client sends:
  - **Authorization:** `Bearer <auth_token>` (the logged-in user’s token; set after login).
  - **vendure-token:** channel token (e.g. Madurai) so the shop API knows which channel/shop.
  - Other app headers (e.g. `x-device-medium`, `Content-Type`, etc.).
- **When it runs:** Only **after** login success. The app reads the saved guest order code (from storage), then calls `mutate$ClaimGuestOrder` with that code. No guest token is required for this call; the shop API links the order to the customer identified by the auth token.

So: **ClaimGuestOrder runs in the shop API** = Flutter POSTs the mutation to `SHOP_API_URL` with the user’s auth token and channel token; the Vendure shop API executes the `claimGuestOrder` resolver and returns the claimed order.

## 1. Flutter: claimGuestOrder flow (implemented)

1. **Guest adds items** → `getActiveOrder()` returns order with `code` (e.g. `"3SSCDHL5A19U1ZHW"`) → app saves it as guest order code (storage).
2. **User logs in** (OTP / Google / Apple).
3. **After login** → app calls `claimGuestOrder(guestOrderCode: savedCode)` with the saved code.
4. **Cart is linked to customer** → app then calls `getActiveOrder()` and `getActiveCustomer()`; the cart is now the claimed order.

The Vendure server must expose the mutation:

```graphql
mutation ClaimGuestOrder($code: String!) {
  claimGuestOrder(guestOrderCode: $code) {
    id
    code
    lines { id, quantity, productVariant { name } }
  }
}
```

## 2. Flutter: send guest token with login request (optional, done in app)

Vendure merges the guest cart only if the **authenticate** mutation is sent with the **same session** as the guest (same bearer token).

The app does this:

1. **Save guest token** – When a guest adds to cart or the app calls `getActiveOrder`, the response header `vendure-auth-token` is stored as the guest token (in memory).
2. **Use guest token on requests** – While the user is not logged in, the GraphQL client sends `Authorization: Bearer <guestToken>` so all guest requests (including the first `getActiveOrder` / `addItemToOrder`) use the same session.
3. **Login with guest token** – The authenticate (login) mutation is sent with the same `Authorization: Bearer <guestToken>` header, so Vendure sees the same session and can merge the cart.
4. **After login** – The new auth token from the login response is saved and the guest token is cleared; all later requests use the new token.

So the Flutter app already sends the guest token with the login request when the user had previously added to cart or opened cart as a guest.

## 3. Vendure server: claimGuestOrder + optional merge strategy

In your Vendure server config (e.g. `vendure-config.ts`), set a **merge orders strategy** so that when a guest logs in, their active order is assigned to that customer:

```ts
import { MergeOrdersStrategy } from '@vendure/core';

export const config: VendureConfig = {
  // ...
  orderOptions: {
    mergeOrdersStrategy: new MergeOrdersStrategy(),
    // Or: UseGuestIfExistingEmptyStrategy – use guest cart if customer has no order
    // Or: UseGuestStrategy – always use guest cart after login
  },
};
```

- **MergeOrdersStrategy** – merge guest and customer orders (e.g. combine line items).
- **UseGuestIfExistingEmptyStrategy** – use guest order if the customer has no order; otherwise keep customer order.
- **UseGuestStrategy** – after login, use the guest order (replace any existing customer order).

Without one of these, the guest order stays anonymous and keeps showing as “Guest” in the Orders dashboard.

## App-side behavior

After login (OTP, Google, Apple), the app:

1. Saves the auth token.
2. If a guest order code was saved, calls **claimGuestOrder(guestOrderCode)** to link that order to the customer.
3. Calls **getActiveOrder()** and **getActiveCustomer()** so the cart and account are up to date.
4. Redirects to the intended route (e.g. cart).

The server must implement **claimGuestOrder** (custom mutation). Optionally, also configure `orderOptions.mergeOrdersStrategy` if you use session-based merge in addition.
