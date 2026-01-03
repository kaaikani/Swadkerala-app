# Registration Flow - Continue Button Click

## When "Continue" Button is Clicked in Step 1 (Registration Form)

### Flow Diagram:
```
User Clicks "Continue" Button
    ↓
_nextStep() [signup_page.dart:69]
    ↓
FocusScope.of(context).unfocus() - Closes keyboard
    ↓
Check: _currentStep == 0 (Step 1)
    ↓
_step1Key.currentState!.validate() - Validates form fields
    ├─ First Name: min 2 chars, only alphabets
    ├─ Last Name: min 1 char
    └─ Phone Number: exactly 10 digits
    ↓
If validation passes:
    ↓
_processSendOtp() [signup_page.dart:103]
    ↓
┌─────────────────────────────────────────────────────────┐
│ AuthController.sendOtp(context) [auth_controller:255]   │
│                                                          │
│ 1. Validates phone number format                        │
│ 2. Sets loading state: utilityController.setLoadingState(true) │
│ 3. GraphQL Mutation: SendPhoneOtp                        │
│    Variables: { phoneNumber: phoneNumber.text }         │
│ 4. Checks response for errors                          │
│ 5. If successful:                                       │
│    - Sets OTP sent flag: setOtpSent(true)              │
│    - Updates reactive state: _isOtpSent.value = true    │
│ 6. Sets loading state: utilityController.setLoadingState(false) │
│ 7. Returns true/false                                   │
└─────────────────────────────────────────────────────────┘
    ↓
If sendOtp successful:
    ↓
_startSmsAutofill() [signup_page.dart:56]
    ↓
SmsAutofillService.startListening()
    - Starts listening for SMS with OTP
    - Auto-fills OTP when received
    - Calls _handleFinalSubmit() when 4 digits received
    ↓
_animateToPage(1) [signup_page.dart:94]
    ↓
setState(() => _currentStep = 1)
    - Updates UI to show Step 2 (OTP verification)
    ↓
_pageController.animateToPage(1)
    - Animates PageView to OTP step
    - Duration: 400ms
    - Curve: Curves.easeInOutQuart
```

## When "Continue" Button is Clicked in Step 2 (OTP Verification)

### Flow Diagram:
```
User Clicks "Verify & Finish" Button
    ↓
_nextStep() [signup_page.dart:69]
    ↓
FocusScope.of(context).unfocus() - Closes keyboard
    ↓
Check: _currentStep == 1 (Step 2)
    ↓
_step2Key.currentState!.validate() - Validates OTP (4 digits)
    ↓
If validation passes:
    ↓
_handleFinalSubmit() [signup_page.dart:119]
    ↓
┌─────────────────────────────────────────────────────────┐
│ AuthController.verifyOtp(context) [auth_controller:304] │
│                                                          │
│ 1. Validates OTP length (must be 4 digits)             │
│ 2. Sets loading state: utilityController.setLoadingState(true) │
│ 3. Trims first name and last name                       │
│ 4. GraphQL Mutation: Authenticate                        │
│    Variables: {                                          │
│      phoneNumber: phoneNumber.text,                     │
│      code: otpController.text,                          │
│      firstName: firstname.text.trim() or null,          │
│      lastName: lastname.text.trim() or null             │
│    }                                                    │
│ 5. Extracts auth token from response headers            │
│    - Header: 'vendure-auth-token'                      │
│ 6. Saves auth token:                                    │
│    GraphqlService.setToken(key: 'auth', token: authToken) │
│ 7. Fetches channel information:                         │
│    checkEmailAndGetChannel(context) [up to 3 retries]  │
│    - GraphQL Query: GetChannelList                      │
│    - Saves channel_code and channel_token               │
│    - Sets channel token in GraphqlService               │
│ 8. Sets logged in state:                                 │
│    - setLoggedIn(true)                                  │
│    - Updates reactive state: _isLoggedIn.value = true  │
│ 9. Resets form: resetFormField()                        │
│    - Clears all text controllers                        │
│    - Sets OTP sent to false                             │
│ 10. Sets loading state: utilityController.setLoadingState(false) │
│ 11. Returns true/false                                  │
└─────────────────────────────────────────────────────────┘
    ↓
If verifyOtp successful:
    ↓
NavigationHelper.redirectToIntendedRoute()
    - Redirects user to intended route (usually home page)
```

## Controller Methods Triggered

### AuthController Methods:
1. **sendOtp(context)** [Line 255]
   - Validates phone number
   - Mutates SendPhoneOtp
   - Sets OTP sent flag
   - Returns boolean

3. **verifyOtp(context)** [Line 304]
   - Validates OTP
   - Mutates Authenticate (with firstName, lastName, phoneNumber, code)
   - Extracts and saves auth token
   - Calls checkEmailAndGetChannel() to get channel info
   - Sets logged in state
   - Resets form fields
   - Returns boolean

3. **checkEmailAndGetChannel(context)** [Line 155] (called from verifyOtp)
   - Queries GetChannelList
   - Saves channel_code and channel_token
   - Sets channel token in GraphqlService

4. **setLoading(bool)** [Line 45]
   - Calls utilityController.setLoadingState(value)
   - Updates reactive loading state

5. **setOtpSent(bool)** [Line 44]
   - Updates reactive state: _isOtpSent.value = value

6. **setLoggedIn(bool)** [Line 43]
   - Updates reactive state: _isLoggedIn.value = value

7. **resetFormField()** [Line 759]
   - Clears firstname, lastname, phoneNumber, otpController
   - Sets OTP sent to false

### UtilityController Methods:
1. **setLoadingState(bool)** [via AuthController]
   - Updates isLoadingRx reactive variable
   - Used for showing loading indicators

### GraphQLService Methods:
1. **setToken(key: 'auth', token: authToken)**
   - Saves auth token to storage
   - Updates GraphQL client headers

2. **setToken(key: 'channel', token: channelToken)**
   - Saves channel token to storage
   - Updates GraphQL client headers

### GraphQL Operations:
1. **Query: GetChannelList**
   - Used in checkEmailAndGetChannel()

2. **Mutation: SendPhoneOtp**
   - Used in sendOtp()
   - Sends OTP to phone number

3. **Mutation: Authenticate**
   - Used in verifyOtp()
   - Verifies OTP and creates/authenticates user
   - Returns CurrentUser or error

## State Changes

### Reactive Variables Updated:
- `_authController.isLoading` (via UtilityController)
- `_authController.isOtpSent`
- `_authController.isLoggedIn`
- `_currentStep` (local state in SignupPage)

### Storage Updates:
- `auth_token` - Saved after OTP verification
- `channel_token` - Saved after OTP verification
- `channel_code` - Saved after OTP verification

## Error Handling

### Error Scenarios:
1. **Form Validation Fails**
   - Shows inline error messages
   - Prevents proceeding to next step

2. **OTP Send Fails**
   - Shows error dialog
   - Returns false, user stays on Step 1

4. **OTP Verification Fails**
   - Shows error dialog
   - User stays on Step 2

5. **Channel Fetch Fails**
   - Retries up to 3 times with 500ms delay
   - Shows error if all retries fail

