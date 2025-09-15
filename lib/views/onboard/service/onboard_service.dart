import 'package:vexana/vexana.dart';

import '../../../core/init/network/model/error_model_custom.dart';
import 'i_onboard_service.dart';

class OnboardService extends IOnboardService {
  OnboardService(super.manager);

  // @override
  // Future<bool> createUser(UserProfileModel userProfile) async {
  //   final response = await manager.send<UserProfileModel, UserProfileModel>(
  //     APIConst.createProfile,
  //     parseModel: UserProfileModel(),
  //     method: RequestType.POST,
  //     data: userProfile.toJson(),
  //   );
  //   return response.error == null ? true : false;
  // }

  // @override
  // Future<bool> bindUserToLanguages(
  //     BindUserToLanguagesModel languageModel) async {
  //   final response =
  //       await manager.send<BindUserToLanguagesModel, BindUserToLanguagesModel>(
  //     APIConst.bindLanguages,
  //     parseModel: BindUserToLanguagesModel(),
  //     method: RequestType.POST,
  //     data: languageModel.toJson(),
  //   );

  //   return response.error == null ? true : false;
  // }

  // @override
  // Future<bool> bindUserToPracticeGoal(
  //     PracticeGoalModel practiceGoalModel) async {
  //   final response = await manager.send<PracticeGoalModel, PracticeGoalModel>(
  //       APIConst.bindPracticeGoal,
  //       parseModel: PracticeGoalModel(),
  //       method: RequestType.POST,
  //       data: practiceGoalModel.toJson());

  //   return response.error == null ? true : false;
  // }

  // @override
  // Future<bool> bindUserToTopics(List<int> favTopicsIdList) async {
  //   final response = await manager.send<FavTopicsModel, FavTopicsModel>(
  //       APIConst.bindFavTopics,
  //       parseModel: FavTopicsModel(),
  //       method: RequestType.POST,
  //       data: {"topicIds": favTopicsIdList});

  //   return response.error == null ? true : false;
  // }
}
