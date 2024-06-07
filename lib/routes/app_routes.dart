
import 'package:get/get.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/affirmation_alarm_screen.dart';
import 'package:transform_your_mind/presentation/affirmation_alarm_screen/binding/affirmation_alarm_binding.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/binding/forgot_binding.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/forgot_password_screen.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/new_password_screen.dart';
import 'package:transform_your_mind/presentation/auth/forgot_password_screen/verification_screen.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/binding/login_binding.dart';
import 'package:transform_your_mind/presentation/auth/login_screen/login_screen.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/binding/register_binding.dart';
import 'package:transform_your_mind/presentation/auth/ragister_screen/register_screen.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/binding/dash_board_binding.dart';
import 'package:transform_your_mind/presentation/dash_board_screen/dash_board_screen.dart';
import 'package:transform_your_mind/presentation/explore_screen/binding/explore_binding.dart';
import 'package:transform_your_mind/presentation/explore_screen/explore_screen.dart';
import 'package:transform_your_mind/presentation/home_screen/binding/home_binding.dart';
import 'package:transform_your_mind/presentation/home_screen/home_screen.dart';
import 'package:transform_your_mind/presentation/intro_screen/about_page.dart';
import 'package:transform_your_mind/presentation/intro_screen/select_your_focus_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/binding/journal_binding.dart';
import 'package:transform_your_mind/presentation/journal_screen/journal_screen.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/add_gratitude_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_affirmation_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_gratitude_page.dart';
import 'package:transform_your_mind/presentation/journal_screen/widget/my_notes_page.dart';
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
import 'package:transform_your_mind/presentation/positive_moment/positive_controller.dart';
import 'package:transform_your_mind/presentation/positive_moment/positive_screen.dart';
import 'package:transform_your_mind/presentation/profile_screen/binding/profile_binding.dart';
import 'package:transform_your_mind/presentation/profile_screen/profile_screen.dart';
import 'package:transform_your_mind/presentation/splash_screen/binding/splash_binding.dart';
import 'package:transform_your_mind/presentation/splash_screen/splash_screen.dart';
import 'package:transform_your_mind/presentation/subscription_screen/binding/subscription_binding.dart';
import 'package:transform_your_mind/presentation/subscription_screen/subscription_screen.dart';
import 'package:transform_your_mind/presentation/today_cleanse_screen/binding/cleanse_binding.dart';
import 'package:transform_your_mind/presentation/today_cleanse_screen/today_cleanse_screen.dart';
import 'package:transform_your_mind/presentation/today_gratitude_screen/binding/gratitude_binding.dart';
import 'package:transform_your_mind/presentation/today_gratitude_screen/gratitude_screen.dart';
import 'package:transform_your_mind/presentation/tools_screen/binding/tools_binding.dart';
import 'package:transform_your_mind/presentation/tools_screen/tools_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';
  static const String splashScreen = '/splash_screen';
  static const String registerScreen = '/register_screen';
  static const String successPopupScreen = '/success_popup_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String forgotScreen = '/forgotScreen';
  static const String verificationsScreen = '/verificationsScreen';
  static const String newPasswordScreen = '/newPasswordScreen';
  static const String dashBoardScreen = '/dashBoardScreen';
  static const String meScreen = '/meScreen';
  static const String homeScreen = '/homeScreen';
  static const String exploreScreen = '/exploreScreen';
  static const String toolsScreen = '/toolsScreen';
  static const String initialRoute = '/initialRoute';
  static const String nowPlayingScreen = '/now_playing_screen';
  static const String gratitudeScreen = '/gratitudeScreen';
  static const String todayCleanseScreen = '/todayCleanseScreen';
  static const String journalScreen = '/journalScreen';
  static const String settingScreen = '/setting_screen';
  static const String accountScreen = '/account_screen';
  static const String myGratitudePage = '/myGratitudePage';
  static const String addGratitudePage = '/addGratitudePage';
  static const String myAffirmationPage = '/myAffirmationPage';
  static const String editProfileScreen = '/edit_profile_screen';
  static const String fullScreenImage = '/fullScreenImage';
  static const String aboutPage = '/aboutPage';
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
      name: loginScreen,
      page: () => LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: initialRoute,
      page: () => LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),


    GetPage(
      transition: Transition.rightToLeft,
      name: registerScreen,
      page: () => RegisterScreen(),
      bindings: [
        RegisterBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: forgotScreen,
      page: () => ForgotPasswordScreen(),
      bindings: [
        ForgotBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: verificationsScreen,
      page: () => VerificationsScreen(),
      bindings: [
        ForgotBinding(),
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: newPasswordScreen,
      page: () => NewPasswordScreen(),
      bindings: [
        ForgotBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: dashBoardScreen,
      page: () =>  DashBoardScreen(),
      bindings: [
        DashBoardBinding(),
      ],
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
      name: exploreScreen,
      page: () =>  ExploreScreen(),
      bindings: [
        ExploreBinding(),
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
      page: () =>  SettingScreen(),
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
      page: () =>  EditProfileScreen(),
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
      page: () =>  NotificationSettingScreen(),
      bindings: [
        NotificationSettingBinding(),
      ],
    ),


    GetPage(
      transition: Transition.rightToLeft,
      name: gratitudeScreen,
      page: () => const GratitudeScreen(),
      bindings: [
        GratitudeBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: todayCleanseScreen,
      page: () => const TodayCleanseScreen(),
      bindings: [
        CleanseBinding(),
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
      page: () =>  const AddGratitudePage( isFromMyGratitude: true,registerUser: false,),
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
      name: myNotesPage,
      page: () =>  const MyNotesPage(),
      bindings: [
        JournalBinding(),
      ],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: aboutPage,
      page: () =>  const AboutPage(),
      bindings: [
       DashBoardBinding()
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: selectYourFocusPage,
      page: () =>  const SelectYourFocusPage(isFromMe: false),
      bindings: [
       DashBoardBinding()
      ],
    ),

    GetPage(
      transition: Transition.rightToLeft,
      name: personalizationScreen,
      page: () => PersonalizationScreenScreen(),
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
      page: () =>  const MotivationalMessageScreen(),
      bindings: [MotivationalBinding()],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: affirmationAlarmScreen,
      page: () =>  const AffirmationAlarmScreen(),
      bindings: [AffirmationAlarmBinding()],
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: positiveScreen,
      page: () =>   const PositiveScreen(),
      bindings: [PositiveBinding()],
    ),

    ///
    // GetPage(
    //   transition: Transition.rightToLeft,
    //   name: initialRoute,
    //   page: () => SplashScreen(),
    //   bindings: [
    //     SplashBinding(),
    //   ],
    // )

  ];
}
