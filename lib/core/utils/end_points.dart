class EndPoints {
  static String baseUrl =
      "https://transformyourmind-server.onrender.com/api/v1/";
  static String registerApi = "signup";
  static String verifyOtp = "verify-otp";
  static String login = "login";
  static String getFocus = "get-focus?created_by=";
  static String updateFocuses = "update-focus?id=";
  static String updateUser = "update-user?id=";
  static String forgotPassword = "forgot-password";
  static String resetPassword = "reset-password";
  static String addAffirmation = "add-affirmation";
  static String deleteFocus = "delete-focus?id=";
  static String deleteAffirmation = "delete-affirmation?id=";
  static String getCategory = "get-category?type=";
  static String getAffirmation = "get-affirmation?isDefault=true";
  static String getYourAffirmation = "get-affirmation?created_by=";
  static String updateAffirmation = "update-affirmation?id=";
  static String categoryAffirmation = "get-affirmation?category=";
}
