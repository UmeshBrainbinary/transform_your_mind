


enum AppContentType {
  focus('Focus', 1),
  affirmation('Affirmation', 2),
  meditation('Meditation', 3),
  sound('Sleep', 4),
  pods('Shoorah Pods', 5),
  gratitude('Gratitude', 6),
  rituals('Rituals', 7),
  cleanse('CLEANSE', 8),
  goals('GOALS', 9),
  notepad('NOTEPAD', 10),
  other('Other', 100);

  final String name;
  final int value;

  const AppContentType(this.name, this.value);
}

extension AppContentTypeExtension on int {
  AppContentType get getAppContentTypeFromInt {
    switch (this) {
      case 1:
        return AppContentType.focus;
      case 2:
        return AppContentType.affirmation;
      case 3:
        return AppContentType.meditation;
      case 4:
        return AppContentType.sound;
      case 5:
        return AppContentType.pods;
      case 6:
        return AppContentType.affirmation;
      case 7:
        return AppContentType.rituals;
      default:
        return AppContentType.other;
    }
  }
}

// enum AppBadgesType {
//   bronze('Bronze', 1, AppAssets.icBronzeBadge, AppAssets.icBronzeBadgeDisable,
//       AppColors.bronzeColor),
//   silver('Silver', 2, AppAssets.icSilverBadge, AppAssets.icSilverBadgeDisable,
//       AppColors.silverColor),
//   gold('Gold', 3, AppAssets.icGoldBadge, AppAssets.icGoldBadgeDisable,
//       AppColors.goldColor),
//   platinum('Platinum', 4, AppAssets.icPlatinumBadge,
//       AppAssets.icPlatinumBadgeDisable, AppColors.platinumTextColor),
//   diamond('Diamond', 5, AppAssets.icDiamondBadge,
//       AppAssets.icDiamondBadgeDisable, AppColors.diamondTextColor),
//   shoorahGuru('ShoorahGuru', 6, AppAssets.icShoorahGuruBadge,
//       AppAssets.icShoorahGuruBadgeDisable, AppColors.bronzeColor);
//
//   final String name;
//   final int badgeIndex;
//   final String badgeImage;
//   final String badgeImageDisable;
//   final Color fontColor;
//
//   const AppBadgesType(
//     this.name,
//     this.badgeIndex,
//     this.badgeImage,
//     this.badgeImageDisable,
//     this.fontColor,
//   );
// }

enum ActivityType {
  affirmation(1),
  shoorahPod(5),
  gratitude(6),
  cleanse(7),
  listenMeditation(8),
  listenSound(9),
  ritualsCompleted(10);

  final int activityIndex;
  const ActivityType(
    this.activityIndex,
  );
}

enum SelectMinutes {
  min_0(0, 'OFF'),
  min_1(1, '1 Min'),
  min_5(5, '5 Min'),
  min_15(15, '15 Min'),
  min_30(30, '30 Min'),
  hours_1(60, '1 Hour'),
  hours_2(120, '2 Hours'),
  hours_3(180, '3 Hours'),
  hours_5(300, '5 Hours'),
  hours_10(600, '10 Hours');

  const SelectMinutes(this.value, this.name);

  final int value;
  final String name;
}

// ignore: constant_identifier_names
enum SubscriptionStatus { INITIAL_USER, SUBSCRIBED, EXPIRED ,TRIAL }
