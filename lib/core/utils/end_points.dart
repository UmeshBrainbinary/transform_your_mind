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
  static String addAffirmation = "${baseUrl}add-affirmation";
  static String deleteFocus = "delete-focus?id=";
  static String deleteAffirmation = "delete-affirmation?id=";
  static String getCategory = "get-category?type=";
  static String getAffirmation = "get-affirmation?isDefault=true";
  static String getYourAffirmation = "get-affirmation?created_by=";
  static String updateAffirmation = "update-affirmation?id=";
  static String categoryAffirmation = "get-affirmation?category=";
  static String getUser = "${baseUrl}user-details?id=";
  static String getMoment = "${baseUrl}get-moment";
  static String getPod = "${baseUrl}get-pod";
  static String createPositiveMoment = "${baseUrl}add-moment";
  static String deletePositiveMoment = "${baseUrl}delete-moment?id=";
  static String updatePositiveMoment = "${baseUrl}update-moment?id=";
  static String getFaqApi = "${baseUrl}get-faq";
  static String getGuideApi = "${baseUrl}get-guideline";
  static String addAlarm = "${baseUrl}add-alarm";
  static String addFeedback = "${baseUrl}add-feedback";
  static String getFeedback = "${baseUrl}get-feedback?created_by=";
  static String updateFeedback = "${baseUrl}update-feedback?id=";
  static String randomFeedback = "${baseUrl}random-message?userId=";
  static String userProgress = "${baseUrl}user-progress?userId=";
  static String todayGratitude = "${baseUrl}today-gratitude?created_by=";
  static String todayAffirmation = "${baseUrl}today-affirmation?created_by=";
  static String weeklyGratitude = "${baseUrl}weekly-gratitude?created_by=";
  static String weeklyAffirmation = "${baseUrl}weekly-affirmation?created_by=";
  static String morningQuestions = "${baseUrl}morning-questions";
  static String eveningQuestions = "${baseUrl}evening-questions";
  static String moodChart = "${baseUrl}mood-chart?created_by=";
  static String sleepChart = "${baseUrl}sleep-chart?created_by=";
  static String stressChart = "${baseUrl}stress-chart?created_by=";
  static String getPersonalAudio = "${baseUrl}get-personal-audio";
}
