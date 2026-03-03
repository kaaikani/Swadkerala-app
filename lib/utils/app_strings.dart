/// Centralized string constants for the application
/// All text values should be referenced from this file for maintainability and localization support
class AppStrings {
  AppStrings._(); // Private constructor to prevent instantiation

  // ==================== COMMON ACTIONS ====================
  static const String add = 'Add';
  static const String addAddress = 'Add Address';
  static const String addToCart = 'Add to Cart';
  static const String addedToCartMsg = 'Added to cart!';
  static const String change = 'Change';
  static const String goBack = 'Go Back';
  static const String showMore = 'Show More';
  static const String showLess = 'Show Less';
  static const String select = 'Select';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String proceed = 'Proceed';
  static const String apply = 'Apply';
  static const String remove = 'Remove';
  static const String share = 'Share';
  static const String close = 'Close';
  static const String retry = 'Retry';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String loading = 'Loading...';
  static const String searching = 'Searching...';
  static const String refreshing = 'Refreshing...';
  static const String pleaseWait = 'Please wait';

  // ==================== NAVIGATION ====================
  static const String home = 'Home';
  static const String homeLabel = 'Home';
  static const String category = 'Category';
  static const String categoryLabel = 'Category';
  static const String cart = 'Cart';
  static const String cartLabel = 'Cart';
  static const String account = 'Account';
  static const String orders = 'Orders';
  static const String favorites = 'Favorites';
  static const String settings = 'Settings';

  // ==================== PRODUCT RELATED ====================
  static const String product = 'Product';
  static const String productName = 'Product Name';
  static const String productDetails = 'Product Details';
  static const String productNotFound = 'Product not found';
  static const String aboutProduct = 'About Product';
  static const String selectVariant = 'Select Variant';
  static const String selectQuantity = 'Select Quantity';
  static const String enterQuantity = 'Enter Quantity';
  static const String enterCustomQuantity = 'Enter Custom Quantity';
  static const String quantity = 'Quantity';
  static const String quantityMaxPlaceholder = 'Quantity (Max: {max})';
  static const String quantityMax = 'Quantity (Max: {max})';
  static const String inStock = 'In Stock';
  static const String outOfStock = 'Out of Stock';
  static const String lowStock = 'Low Stock';
  static const String doubleTapToLike = 'Double tap to like';

  // ==================== CART RELATED ====================
  static const String emptyCart = 'Your cart is empty';
  static const String cartItems = 'Cart Items';
  static const String items = 'Items';
  static const String itemCount = 'Items ({count})';
  static const String removeItem = 'Remove Item';
  static const String clearCart = 'Clear Cart';
  static const String continueShopping = 'Continue Shopping';
  static const String proceedToCheckout = 'Proceed to Checkout';
  static const String viewCart = 'View Cart';

  // ==================== CHECKOUT RELATED ====================
  static const String checkout = 'Checkout';
  static const String deliveryAddress = 'Delivery Address';
  static const String noDeliveryAddressSelected = 'No delivery address selected';
  static const String paymentMethod = 'Payment Method';
  static const String selectPaymentMethod = 'Select Payment Method';
  static const String orderSummary = 'Order Summary';
  static const String placeOrder = 'Place Order';
  static const String placeOrderWithAmount = 'Place Order - {amount}';
  static const String deliveryCharge = 'Delivery Charge';
  static const String free = 'FREE';
  static const String freeShipping = 'Free Shipping';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
  static const String shipping = 'Shipping';
  static const String discount = 'Discount';
  static const String couponDiscount = 'Coupon Discount';
  static const String coupon = 'Coupon';
  static const String couponCode = 'Coupon Code';
  static const String applyCoupon = 'Apply Coupon';
  static const String removeCoupon = 'Remove Coupon';
  static const String browseCoupons = 'Apply Coupon Code';
  static const String minOrder = 'Min order {amount}';
  static const String spendMoreToUnlockCoupon = 'Add {amount} more to unlock coupon \'{code}\'';
  static const String spendMoreToApplyCoupon = 'Spend {amount} more to Apply {code}';

  // ==================== LOYALTY POINTS ====================
  static const String loyaltyPoints = 'Loyalty Points';
  static const String loyaltyPointsDiscount = 'Loyalty Points Discount';
  static const String loyaltyPointsUsed = 'Loyalty Points ({points})';
  static const String useLoyaltyPoints = 'Use Loyalty Points';
  static const String enterPointsManually = 'Enter points manually';
  static const String pointsBalance = 'Points Balance';
  static const String pleaseEnterLoyaltyPoints = 'Please enter loyalty points';
  static const String pleaseEnterValidLoyaltyPoints = 'Please enter valid loyalty points';
  static const String loyaltyPointsAppliedSuccessfully = 'Loyalty points applied successfully';
  static const String failedToApplyLoyaltyPoints = 'Failed to apply loyalty points';
  static const String loyaltyPointsRemovedSuccessfully = 'Loyalty points removed successfully';
  static const String failedToRemoveLoyaltyPoints = 'Failed to remove loyalty points';

  // ==================== ORDER RELATED ====================
  static const String myOrders = 'My Orders';
  static const String myFavorites = 'My Favorites';
  static const String viewAllOrders = 'View All Orders';
  static const String orderDetails = 'Order Details';
  static const String orderPlaced = 'Order Placed';
  static const String orderConfirmed = 'Order Confirmed';
  static const String orderPlacedSuccessfully = 'Order placed successfully!';
  static const String orderNumber = 'Order Number';
  static const String orderDate = 'Order Date';
  static const String orderStatus = 'Order Status';
  static const String orderTotal = 'Order Total';
  static const String priceBreakdown = 'Price Breakdown';
  static const String deliveryInfo = 'Delivery Information';
  static const String billingInfo = 'Billing Information';
  static const String paymentInfo = 'Payment Information';
  static const String shareInvoice = 'Share Invoice';
  static const String orderCancelled = 'Cancelled';
  static const String orderCancellationRequested = 'Cancellation Requested';
  static const String orderPaid = 'Paid';
  static const String startShopping = 'Start Shopping';

  // ==================== ADDRESS RELATED ====================
  static const String addresses = 'Addresses';
  static const String myAddresses = 'My Addresses';
  static const String addNewAddress = 'Add New Address';
  static const String editAddress = 'Edit Address';
  static const String deleteAddress = 'Delete Address?';
  static const String deleteAddressConfirm = 'Are you sure you want to delete this address?';
  static const String setAsDefault = 'Set as Default';
  static const String defaultAddress = 'Default Address';
  static const String defaultLabel = 'Default';
  static const String fullName = 'Full Name';
  static const String phoneNumber = 'Phone Number';
  static const String streetAddress = 'Street Address';
  static const String city = 'City';
  static const String state = 'State';
  static const String postalCode = 'Postal Code';
  static const String country = 'Country';
  static const String autoFilled = 'Auto-filled';

  // ==================== PAYMENT RELATED ====================
  static const String cashOnDelivery = 'Cash on Delivery';
  static const String onlinePayment = 'Online Payment';
  static const String paymentFailed = 'Payment failed';
  static const String paymentSuccess = 'Payment successful';
  static const String paymentPending = 'Payment pending';
  static const String paymentSettled = 'Payment Settled';
  static const String paymentAuthorized = 'Payment Authorized';

  // ==================== ACCOUNT RELATED ====================
  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String myAccount = 'My Account';
  static const String logout = 'Logout';
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String forgotPassword = 'Forgot Password?';

  // ==================== HELP & SUPPORT ====================
  static const String helpSupport = 'Help & Support';
  static const String help = 'Help';
  static const String support = 'Support';
  static const String contactUs = 'Contact Us';
  static const String phoneSupport = 'Phone Support';
  static const String emailSupport = 'Email Support';
  static const String whatsapp = 'WhatsApp';
  static const String chatWithUsOnWhatsApp = 'Chat with us on WhatsApp';
  static const String frequentlyAskedQuestions = 'FAQ';
  static const String customerService = 'Customer Service';

  // ==================== ERRORS & MESSAGES ====================
  static const String error = 'Error';
  static const String somethingWentWrong = 'Something went wrong';
  static const String tryAgain = 'Try Again';
  static const String networkError = 'Network Error';
  static const String connectionError = 'Connection Error';
  static const String serverError = 'Server Error';
  static const String invalidInput = 'Invalid Input';
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Invalid email address';
  static const String invalidPhoneNumber = 'Invalid phone number';
  static const String operationFailed = 'Operation failed';
  static const String featureNotAvailable = 'Feature Not Available';
  static const String pleaseSpecifyReason = 'Please specify your reason...';
  static const String shippingMethodSelected = 'Shipping method selected';
  static const String pleaseSelectShippingMethod = 'Please select a shipping method';
  static const String pleaseSelectPaymentMethod = 'Please select a payment method';
  static const String pleaseSelectDeliveryAddress = 'Please select a delivery address';
  static const String failedToShareProduct = 'Failed to share product';
  static const String invalidVariantId = 'Invalid variant ID';
  static const String failedToAddToCart = 'Failed to add to cart';
  static const String failedToSetShippingMethod = 'Failed to set shipping method';
  static const String failedToSetShippingAddress = 'Failed to set shipping address. Please try again.';
  static const String failedToGenerateBill = 'Failed to generate bill';
  static const String couldNotMakePhoneCall = 'Could not make phone call';
  static const String errorOpeningPhone = 'Error opening phone';
  static const String couldNotOpenWhatsApp = 'Could not open WhatsApp';
  static const String errorOpeningWhatsApp = 'Error opening WhatsApp';
  static const String couldNotOpenEmailApp = 'Could not open email app';
  static const String errorOpeningEmail = 'Error opening email';
  static const String sessionExpired = 'Session Expired';
  static const String userNotFoundLoginAgain = 'User not found. Please login again.';
  static const String noCustomerDataLoginAgain = 'No customer data found. Please login again.';
  static const String orderNotFound = 'Order not found';
  static const String noTransactionsFound = 'No transactions found';
  static const String orderConfirmation = 'Order Confirmation';

  // ==================== SUCCESS MESSAGES ====================
  static const String success = 'Success';
  static const String saved = 'Saved';
  static const String updated = 'Updated';
  static const String deleted = 'Deleted';
  static const String added = 'Added';

  // ==================== VALIDATION MESSAGES ====================
  static const String enterValidEmail = 'Please enter a valid email address';
  static const String enterValidPhone = 'Please enter a valid phone number';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String enterFullName = 'Please enter your full name';
  static const String enterAddress = 'Please enter your address';
  static const String enterCity = 'Please enter your city';
  static const String enterPostalCode = 'Please enter postal code';

  // ==================== MISCELLANEOUS ====================
  static const String noResultsFound = 'No results found';
  static const String noDataAvailable = 'No data available';
  static const String pullToRefresh = 'Pull to refresh';
  static const String lastUpdated = 'Last Updated';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';
  static const String clear = 'Clear';
  static const String all = 'All';
  static const String seeAll = 'See All';
  static const String seeMore = 'See More';
  static const String seeLess = 'See Less';
  static const String defaultCartCount = '0';
  
  // ==================== PLACEHOLDERS ====================
  static const String enterText = 'Enter text';
  static const String searchProducts = 'Search products...';
  static const String searchForFreshCuts = 'Search for fresh cuts...';
  static const String enterName = 'Enter name';
  static const String enterEmail = 'Enter email';
  static const String enterPhone = 'Enter phone number';
  static const String enterAddressValue = 'Enter address';
  static const String enterCityName = 'Enter city';
  static const String enterPostalCodeValue = 'Enter postal code';

  // ==================== UTILITY METHODS ====================
  /// Replace placeholder {placeholder} with actual value
  static String replace(String template, Map<String, dynamic> values) {
    String result = template;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value.toString());
    });
    return result;
  }
}

