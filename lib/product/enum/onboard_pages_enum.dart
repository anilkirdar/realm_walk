import '../../core/constants/app/app_const.dart';

enum OnBoardPage {
  onGenderWidget,
  onAgeWidget,
  onCountryWidget,
  onNativeLangWidget,
  onEnglishLevelWidget,
  onPracticeGoalWidget,
  onFavouriteTopics,
  onAppLanguage
}

extension OnBoardPagesString on OnBoardPage {
  String get enumValue {
    switch (this) {
      case OnBoardPage.onGenderWidget:
        return AppConst.onGender;
      case OnBoardPage.onAgeWidget:
        return AppConst.onAge;
      case OnBoardPage.onCountryWidget:
        return AppConst.onCountry;
      case OnBoardPage.onNativeLangWidget:
        return AppConst.onNativeLanguage;
      case OnBoardPage.onEnglishLevelWidget:
        return AppConst.onEnglishLevel;
      case OnBoardPage.onPracticeGoalWidget:
        return AppConst.onPracticeGoal;
      case OnBoardPage.onFavouriteTopics:
        return AppConst.onFavouriteTopics;
      case OnBoardPage.onAppLanguage:
        return AppConst.onAppLanguage;
    }
  }
}
