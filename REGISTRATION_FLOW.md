# Registration Flow - Detailed Explanation

## Overview
The registration flow in this Flutter app uses phone number-based OTP authentication with a 2-step process. The user provides personal information (first name, last name, phone number) and verifies their phone number with an OTP code.

---

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    REGISTRATION FLOW                         │
└─────────────────────────────────────────────────────────────┘

STEP 1: User Input & Validation
├── User enters:
│   ├── First Name (required, min 2 chars, alphabets only)
│   ├── Last Name (required)
│   └── Phone Number (required, min 10 digits)
│
└──→ Validates form fields

STEP 2: Check Phone Number Availability
├──→ checkChannelsByPhoneNumber(isLogin: false)
│   ├── Sends GraphQL query: GetChannelsByCustomerPhoneNumber
│   │
│   ├── Expected Response Scenarios:
│   │   ├── ✅ "Customer is not registered" error
│   │   │   └──→ PROCEED (expected for new registration)
│   │   │
│   │   ├── ✅ Empty channels array
│   │   │   └──→ PROCEED (no existing account)
│   │   │
│   │   └── ❌ Channels found
│   │       └──→ SHOW ERROR: "Account already exists, please login"
│   │
│   └──→ Returns true/false
│
└──→ If check fails → STOP (show error)

STEP 3: Send OTP
├──→ sendOtp(context, isLogin: false)
│   ├── Validates phone number format
│   ├── Calls checkChannelsByPhoneNumber (already done, but double-check)
│   │
│   ├── Sends GraphQL mutation: SendPhoneOtp
│   │   └── Variables: { phoneNumber: "8825767296" }
│   │
│   ├── Response Handling:
│   │   ├── ✅ Success → setOtpSent(true)
│   │   └── ❌ Error → Show error dialog
│   │
│   └──→ Navigate to OTP verification step
│
└──→ User receives OTP via SMS

STEP 4: Verify OTP & Register
├──→ verifyOtpForRegistration(context)
│   ├── Validates:
│   │   ├── OTP length (must be 4 digits)
│   │   ├── First Name (min 2 chars, alphabets only)
│   │   └── Last Name (not empty)
│   │
│   ├── Sends GraphQL mutation: Authenticate
│   │   └── Variables: {
│   │         phoneNumber: "8825767296",
│   │         code: "1234",
│   │         firstName: "John",
│   │         lastName: "Doe"
│   │       }
│   │
│   ├── Response Types:
│   │   ├── ✅ CurrentUser
│   │   │   └──→ Proceed to _handleSuccessfulAuthentication
│   │   │
│   │   ├── ❌ InvalidCredentialsError
│   │   │   └──→ Show error: "Invalid OTP"
│   │   │
│   │   └── ❌ Other errors
│   │       └──→ Show generic error
│   │
│   └──→ If successful → Continue to post-authentication
│
└──→ _handleSuccessfulAuthentication(isRegistration: true)

STEP 5: Post-Authentication Setup
├──→ Extract auth token from response headers
│   └──→ Key: 'vendure-auth-token'
│
├──→ Save auth token
│   └──→ GraphqlService.setToken(key: 'auth', token: authToken)
│
├──→ Skip channel fetching (for registration)
│   └──→ Channel will be set when user selects postal code on home page
│
├──→ Mark user as logged in
│   └──→ setLoggedIn(true)
│
├──→ Reset form fields
│   └──→ resetFormField()
│
└──→ Navigate to home page
    └──→ NavigationHelper.redirectToIntendedRoute()
```

---

## Detailed Step-by-Step Breakdown

### **STEP 1: User Input & Validation**

**Location:** `lib/pages/signup_page.dart`

**User Actions:**
1. User enters First Name (required, minimum 2 characters, alphabets only)
2. User enters Last Name (required)
3. User enters Phone Number (required, minimum 10 digits)

**Validation Rules:**
- **First Name:**
  - Must not be empty
  - Minimum 2 characters
  - Only alphabets and spaces allowed (regex: `^[a-zA-Z\s]+$`)
  
- **Last Name:**
  - Must not be empty
  
- **Phone Number:**
  - Must be valid (minimum 10 digits after removing non-digit characters)
  - Validated by `_isValidPhoneNumber()` method

**Code Reference:**
```dart
// In signup_page.dart
if (_step1Key.currentState!.validate()) {
  await _processSendOtp();
}
```

---

### **STEP 2: Check Phone Number Availability**

**Location:** `lib/controllers/authentication/authenticationcontroller.dart`
**Method:** `checkChannelsByPhoneNumber(isLogin: false)`

**Purpose:** Verify that the phone number is not already registered (for registration flow).

**Process:**
1. Validates phone number format
2. Sends GraphQL query: `GetChannelsByCustomerPhoneNumber`
   ```graphql
   query GetChannelsByCustomerPhoneNumber($phoneNumber: String!) {
     getChannelsByCustomerPhoneNumber(phoneNumber: $phoneNumber) {
       id
       code
       name
       token
     }
   }
   ```

**Response Scenarios:**

| Scenario | Response | Action |
|----------|----------|--------|
| **Customer not registered** | Error: "Customer is not registered" | ✅ **PROCEED** (expected for new user) |
| **No channels found** | Empty channels array | ✅ **PROCEED** (no existing account) |
| **Channels found** | Non-empty channels array | ❌ **STOP** - Show error: "Account already exists, please login" |

**Key Code Logic:**
```dart
// Check for "Customer is not registered" error
if (isCustomerNotFoundError && !isLogin) {
  // For registration, this is EXPECTED - proceed with OTP
  return true; // ✅ Continue registration
}

// If channels exist during registration
if (channels.isNotEmpty && !isLogin) {
  ErrorDialog.showError('An account already exists with this phone number. Please login instead.');
  return false; // ❌ Stop registration
}
```

**Why This Step?**
- Prevents duplicate registrations
- Ensures user doesn't already have an account
- Provides clear error message if account exists

---

### **STEP 3: Send OTP**

**Location:** `lib/controllers/authentication/authenticationcontroller.dart`
**Method:** `sendOtp(context, isLogin: false)`

**Process:**
1. Validates phone number again
2. Calls `checkChannelsByPhoneNumber(isLogin: false)` to double-check
3. Sets loading state: `setLoading(true)`
4. Sends GraphQL mutation: `SendPhoneOtp`
   ```graphql
   mutation SendPhoneOtp($phoneNumber: String!) {
     sendPhoneOtp(phoneNumber: $phoneNumber)
   }
   ```

**Response Handling:**
- **Success:** `setOtpSent(true)` → Navigate to OTP verification step
- **Error:** Show error dialog → Stay on current step

**After Success:**
- User receives OTP via SMS
- UI navigates to Step 2 (OTP verification screen)
- SMS autofill service starts listening for OTP

**Code Reference:**
```dart
// In signup_page.dart
Future<void> _processSendOtp() async {
  final success = await _authController.sendOtp(context, isLogin: false);
  if (success) {
    await _startSmsAutofill(); // Start listening for SMS OTP
    _animateToPage(1); // Navigate to OTP step
  }
}
```

---

### **STEP 4: Verify OTP & Register**

**Location:** `lib/controllers/authentication/authenticationcontroller.dart`
**Method:** `verifyOtpForRegistration(context)`

**Pre-Verification Validations:**
1. OTP length must be 4 digits
2. First Name validation:
   - Not empty
   - Minimum 2 characters
   - Only alphabets (regex: `^[a-zA-Z\s]+$`)
3. Last Name must not be empty

**Process:**
1. Sets loading state: `setLoading(true)`
2. Trims and validates first name and last name
3. Sends GraphQL mutation: `Authenticate`
   ```graphql
   mutation Authenticate($phoneNumber: String!, $code: String!, $firstName: String, $lastName: String) {
     authenticate(input: {
       phoneOtp: {
         phoneNumber: $phoneNumber
         code: $code
         firstName: $firstName
         lastName: $lastName
       }
     }) {
       __typename
       ... on CurrentUser {
         id
         identifier
       }
       ... on InvalidCredentialsError {
         message
       }
     }
   }
   ```

**Response Types:**

| Response Type | Action |
|--------------|--------|
| **CurrentUser** | ✅ Success → Call `_handleSuccessfulAuthentication(isRegistration: true)` |
| **InvalidCredentialsError** | ❌ Show error: "Invalid OTP" |
| **Other errors** | ❌ Show generic error: "OTP verification failed" |

**Key Difference from Login:**
- Registration uses `Authenticate` mutation **with** `firstName` and `lastName`
- Login uses `LoginWithPhoneOtp` mutation **without** `firstName` and `lastName`

**Code Reference:**
```dart
// Registration mutation
final response = await GraphqlService.client.value.mutate$Authenticate(
  Options$Mutation$Authenticate(
    variables: Variables$Mutation$Authenticate(
      phoneNumber: phoneNumber.text,
      code: otpController.text,
      firstName: firstName,  // ✅ Required for registration
      lastName: lastName,    // ✅ Required for registration
    ),
  ),
);
```

---

### **STEP 5: Post-Authentication Setup**

**Location:** `lib/controllers/authentication/authenticationcontroller.dart`
**Method:** `_handleSuccessfulAuthentication(context, currentUser, response, isRegistration: true)`

**This step happens after successful OTP verification and creates the user account.**

#### **5.1 Extract Auth Token**

**Process:**
- Extracts `vendure-auth-token` from HTTP response headers
- This token is used for all authenticated API requests

**Code:**
```dart
final authToken = response.context.entry<HttpLinkResponseContext>()
    ?.headers?['vendure-auth-token'];
```

#### **5.2 Save Auth Token**

**Process:**
- Saves auth token to GraphQL service
- Token is stored in memory and used for subsequent requests

**Code:**
```dart
await GraphqlService.setToken(key: 'auth', token: authToken);
```

#### **5.3 Skip Channel Fetching (Registration Only)**

**Why Skip?**
- For new registrations, channels are not fetched during registration
- Channel will be set when user selects a postal code on the home page
- This simplifies the registration flow and avoids potential delays

**Note:** Channel fetching with retry logic is still performed for **login** flows, but not for registration.

#### **5.4 Mark User as Logged In**

**Process:**
- Sets `isLoggedIn = true`
- This updates the app state to reflect authenticated status

**Code:**
```dart
setLoggedIn(true);
```

#### **5.5 Reset Form Fields**

**Process:**
- Clears all input fields:
  - First name
  - Last name
  - Phone number
  - OTP
- Resets OTP sent flag

**Code:**
```dart
resetFormField();
```

#### **5.6 Navigate to Home Page**

**Process:**
- Uses `NavigationHelper.redirectToIntendedRoute()`
- Typically navigates to home page
- User is now fully registered and logged in

---

## Error Handling

### **Common Error Scenarios:**

| Error | When It Occurs | User Action |
|-------|----------------|-------------|
| **"Account already exists"** | Phone number already registered | User should login instead |
| **"Customer is not registered"** | During registration check | ✅ Expected - proceed (handled automatically) |
| **"Invalid OTP"** | Wrong OTP entered | User should re-enter OTP or resend |
| **"Failed to send OTP"** | Network/server error | User should retry |
| **"Channel fetch failed"** | Post-login channel setup fails (not applicable for registration) | User should try logging in again |

### **Error Dialog Locations:**

- **Registration-specific errors:** Shown in `checkChannelsByPhoneNumber()`
- **OTP errors:** Shown in `verifyOtpForRegistration()`
- **Post-auth errors:** Shown in `_handleSuccessfulAuthentication()`

---

## Key Differences: Registration vs Login

| Aspect | Registration | Login |
|--------|--------------|-------|
| **Phone Check** | Expects "not registered" | Expects "registered" |
| **Mutation** | `Authenticate` (with firstName/lastName) | `LoginWithPhoneOtp` (no firstName/lastName) |
| **Validation** | Requires first name & last name | No name validation |
| **Error on "not registered"** | ✅ Proceed (expected) | ❌ Show error |
| **Error on "registered"** | ❌ Show error | ✅ Proceed |
| **Channel Fetching** | ❌ Skipped (set when user selects postal code) | ✅ Fetched with retry |

---

## Data Flow Summary

```
User Input
  ↓
Form Validation
  ↓
Check Phone Availability (GetChannelsByCustomerPhoneNumber)
  ↓
Send OTP (SendPhoneOtp)
  ↓
User Enters OTP
  ↓
Verify OTP & Register (Authenticate mutation)
  ↓
Extract Auth Token
  ↓
Save Auth Token
  ↓
Mark as Logged In
  ↓
Navigate to Home
  ↓
User selects postal code (on home page)
  ↓
Channel is set based on postal code
```

---

## Files Involved

1. **UI Layer:**
   - `lib/pages/signup_page.dart` - Registration UI and navigation

2. **Controller Layer:**
   - `lib/controllers/authentication/authenticationcontroller.dart` - Main registration logic

3. **Service Layer:**
   - `lib/services/graphql_client.dart` - GraphQL client and token management
   - `lib/services/sms_autofill_service.dart` - SMS OTP autofill

4. **GraphQL:**
   - `lib/graphql/authenticate.graphql` - Authentication mutations
   - `lib/graphql/Customer.graphql` - Customer-related queries

---

## Security Considerations

1. **OTP Validation:**
   - OTP is validated server-side
   - Invalid OTPs are rejected

2. **Token Management:**
   - Auth tokens are stored securely
   - Tokens are sent in HTTP headers for authenticated requests

3. **Phone Number Validation:**
   - Phone numbers are validated before sending OTP
   - Prevents duplicate registrations

4. **Channel Security:**
   - Channel tokens are required for accessing channel-specific data
   - Channels are associated with user accounts

---

## Testing Scenarios

### **Happy Path:**
1. ✅ Enter valid first name, last name, phone number
2. ✅ Phone number not registered → OTP sent
3. ✅ Enter correct OTP → Registration successful
4. ✅ User logged in → Navigate to home → Channel set when user selects postal code

### **Error Scenarios:**
1. ❌ Phone already registered → Show error
2. ❌ Invalid OTP → Show error
3. ❌ Network error → Show error

---

## Debug Logs

The registration flow includes extensive debug logging. Key log prefixes:
- `[AuthController]` - Main authentication controller logs
- `[PhoneAuth]` - Phone authentication specific logs
- `[SignupPage]` - UI layer logs

Example logs:
```
[AuthController] ========== CHECK CHANNELS BY PHONE START ==========
[AuthController] Is Login: false
[AuthController] ✅ Register - customer not registered, proceeding with OTP
[PhoneAuth] ========== VERIFY OTP FOR REGISTRATION STARTED ==========
[PhoneAuth] ✅ Registration validation passed
✅ [PhoneAuth] ========== REGISTRATION SUCCESSFUL ==========
```

---

## Conclusion

The registration flow is a secure, multi-step process that:
1. Validates user input
2. Checks for existing accounts
3. Sends and verifies OTP
4. Creates user account
5. Logs user in automatically
6. Channel is set when user selects postal code on home page

All steps include proper error handling and user feedback.
