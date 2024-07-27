
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/audio_content_screen.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/binding/audio_binding.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/binding/now_playing_binding.dart';
import 'package:transform_your_mind/presentation/audio_content_screen/screen/now_playing_screen/now_playing_screen.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/binding/forgot_binding.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_password_screen.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/verification_screen.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/binding/login_binding.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_preview_view.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_screen.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/binding/register_binding.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_screen.dart';
import 'package:transform_your_mind/presentation/breath_screen/binding/breath_binding.dart';
import 'package:transform_your_mind/presentation/breath_screen/breath_screen.dart';
import 'package:transform_your_mind/presentation/breath_screen/notice_how_you_feel_screen.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/binding/dash_board_binding.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/presentation/feedback_screen/binding/feedback_binding.dart';
import 'package:transform_your_mind/presentation/feedback_screen/feedback_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/binding/home_binding.dart';
import 'package:transform_your_mind/presentation/home_screen/home_screen.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_focus_page.dart';
import 'package:transform_your_mind/presentation/intro_screen/welcome_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/binding/journal_binding.dart';
import 'package:transform_your_mind/presentation/journal_screen/journal_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_gratitude_page.dart';
import 'package:transform_your_mind/presentation/me_screen/binding/me_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/me_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/account_screen/account_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/account_screen/binding/account_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/change_password_screen/binding/change_password_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/change_password_screen/change_password_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/binding/edit_profile_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/edit_profile_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/edit_profile_screen/widget/view_fullscreen_image.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/binding/notification_setting_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/notification_setting_screen/notification_setting_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/binding/personalisations_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/personalisations_screen/personalisations_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/privacy_policy_screen/binding/privacy_policy_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/Page/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/binding/setting_binding.dart';
import 'package:transform_your_mind/presentation/me_screen/screens/setting_screen/setting_screen.dart';
import 'package:transform_your_mind/presentation/motivational_message/binding/motivational_binding.dart';
import 'package:transform_your_mind/presentation/motivational_message/motivational_message.dart';
import 'package:transform_your_mind/presentation/positive_moment/binding/positive_binding.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_screen.dart';
import 'package:transform_your_mind/presentation/profile_screen/binding/profile_binding.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_screen.dart';
import 'package:transform_your_mind/presentation/splash_screen/binding/splash_binding.dart';
import 'package:transform_your_mind/presentation/splash_screen/information_screen.dart';
import 'package:transform_your_mind/presentation/splash_screen/intro_screen.dart';
import 'package:transform_your_mind/presentation/splash_screen/splash_screen.dart';
import 'package:transform_your_mind/presentation/subscription_screen/binding/subscription_binding.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/presentation/tools_screen/binding/tools_binding.dart';
import 'package:transform_your_mind/presentation/tools_screen/tools_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String loginPreviewScreen = '/loginPreviewScreen';
  static const String splashScreen = '/splash_screen';
  static const String registerScreen = '/register_screen';
  static const String successPopupScreen = '/success_popup_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String forgotScreen = '/forgotScreen';
  static const String verificationsScreen = '/verificationsScreen';
  static const String dashBoardScreen = '/dashBoardScreen';
  static const String meScreen = '/meScreen';
  static const String homeScreen = '/homeScreen';
  static const String audioScreen = '/audioScreen';
  static const String toolsScreen = '/toolsScreen';
  static const String initialRoute = '/initialRoute';
  static const String welcomeScreen = '/welcomeScreen';
  static const String nowPlayingScreen = '/now_playing_screen';
  static const String todayCleanseScreen = '/todayCleanseScreen';
  static const String journalScreen = '/journalScreen';
  static const String settingScreen = '/setting_screen';
  static const String accountScreen = '/account_screen';
  static const String myGratitudePage = '/myGratitudePage';
  static const String addGratitudePage = '/addGratitudePage';
  static const String myAffirmationPage = '/myAffirmationPage';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String fullScreenImage = '/fullScreenImage';
  static const String selectYourFocusPage = '/selectYourFocusPage';
  static const String myNotesPage = '/myNotesPage';
  static const String changePassword = '/change_password_screen';
  static const String notificationSetting = '/notification_setting_screen';
  static const String privacyPolicy = '/privacy_policy_screen';
  static const String personalizationScreen = '/personalizationScreen';
  static const String profileScreen = '/profileScreen';
  static const String subscriptionScreen = '/subscriptionScreen';
  static const String motivationalMessageScreen = '/motivationalMessageScreen';
  static const String affirmationAlarmScreen = '/affirmationAlarmScreen';
  static const String positiveScreen = '/positiveScreen';
  static const String feedbackScreen = '/feedbackScreen';
  static const String nowPlayScreen = '/nowPlayScreen';
  static const String introScreen = '/introScreen';
  static const String informationScreen = '/informationScreen';
  static const String breathScreen = '/breathScreen';
  static const String noticeHowYouFeel = '/noticeHowYouFeel';

  static List<GetPage> pages = [

    GetPage(
      transition: Transition.rightToLeft,
      name: splashScreen,
      page: () => const SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
 GetPage(
      transition: Transition.rightToLeft,
      name: introScreen,
      page: () => const IntroScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: informationScreen,
      page: () => const InformationScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: loginScreen,
      page: () => const LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ), GetPage(
      transition: Transition.rightToLeft,
      name: loginPreviewScreen,
      page: () => const LoginPreviewView(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: initialRoute,
      page: () => const LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),    GetPage(
      transition: Transition.rightToLeft,
      name: welcomeScreen,
      page: () => const WelcomeScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),


    GetPage(
      transition: Transition.rightToLeft,
      name: registerScreen,
      page: () => const RegisterScreen(),
      bindings: [
        RegisterBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: forgotScreen,
      page: () => const ForgotPasswordScreen(),
      bindings: [
        ForgotBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: verificationsScreen,
      page: () => const VerificationsScreen(),
      bindings: [
        ForgotBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: dashBoardScreen,
      page: () =>  const DashBoardScreen(),
      bindings: [
        DashBoardBinding(), NowPlayingBinding()],
    ),
   GetPage(
      transition: Transition.rightToLeft,
      name: meScreen,
      page: () => const MeScreen(),
      bindings: [
        MeBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: homeScreen,
      page: () => const HomeScreen(),
      bindings: [
        HomeBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: audioScreen,
      page: () =>  const AudioContentScreen(),
      bindings: [
        AudioContentBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: toolsScreen,
      page: () => const ToolsScreen(),
      bindings: [
        ToolsBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: settingScreen,
      page: () =>  const SettingScreen(),
      bindings: [
        SettingBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: accountScreen,
      page: () =>  AccountScreen(),
      bindings: [
        AccountBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: editProfileScreen,
      page: () =>  const EditProfileScreen(),
      bindings: [
        EditProfileBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
        name: fullScreenImage,
      page: () => const ViewFullScreenImage(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: changePassword,
      page: () =>  ChangePasswordScreen(),
      bindings: [
        ChangePasswordBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      bindings: [
        PrivacyPolicyBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: notificationSetting,
      page: () =>  const NotificationSettingScreen(),
      bindings: [
        NotificationSettingBinding(),
      ],
    ),



    GetPage(
      transition: Transition.rightToLeft,
      name: journalScreen,
      page: () => const JournalScreen(),
      bindings: [
        JournalBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: myGratitudePage,
      page: () => const MyGratitudePage(),
      bindings: [
        JournalBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: addGratitudePage,
      page: () =>   AddGratitudePage( isFromMyGratitude: true,registerUser: false,),
      bindings: [
        JournalBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: myAffirmationPage,
      page: () =>  const MyAffirmationPage(),
      bindings: [
        JournalBinding(),
      ],
    ),


    GetPage(
      transition: Transition.rightToLeft,
      name: selectYourFocusPage,
      page: () =>   SelectYourFocusPage(isFromMe: false,setting: false,),
      bindings: [
       DashBoardBinding()
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: personalizationScreen,
      page: () => const PersonalizationScreenScreen(),
      bindings: [
        PersonalisationsBinding()
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: profileScreen,
      page: () => const ProfileScreen(),
      bindings: [ProfileBinding()],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: subscriptionScreen,
      page: () =>  SubscriptionScreen(skip: false),
      bindings: [SubscriptionBinding()],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: motivationalMessageScreen,
      page: () =>   MotivationalMessageScreen(),
      bindings: [MotivationalBinding()],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: positiveScreen,
      page: () =>   const PositiveScreen(),
      bindings: [PositiveBinding()],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: feedbackScreen,
      page: () => const FeedbackScreen(),
      bindings: [FeedbackBinding()],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: nowPlayScreen,
      page: () =>   NowPlayingScreen(),
      bindings: [NowPlayingBinding()],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: breathScreen,
      page: () =>    BreathScreen(),
      bindings: [BreathBinding()],
    ),
  GetPage(
      transition: Transition.rightToLeft,
      name: noticeHowYouFeel,
      page: () =>    NoticeHowYouFeelScreen(),
      bindings: [BreathBinding()],
    ),


  ];
}
