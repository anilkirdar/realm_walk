import '../../../../core/constants/app/app_const.dart';

enum GenderEnum { male, female, other, notSelected }

extension GenderEnumString on GenderEnum {
  String? get rawValue {
    switch (this) {
      case GenderEnum.male:
        return AppConst.maleEnum;
      case GenderEnum.female:
        return AppConst.femaleEnum;
      case GenderEnum.other:
        return null;
      default:
        return null;
    }
  }
}

extension StringToGenderEnum on String {
  GenderEnum? get toGenderEnum {
    switch (toUpperCase()) {
      case AppConst.maleEnum:
        return GenderEnum.male;
      case AppConst.femaleEnum:
        return GenderEnum.female;
      default:
        return GenderEnum.other;
    }
  }
}

class GenderManager {
}
