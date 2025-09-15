import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/components/button/adaptive_gradient_button.dart';
import '../../../../core/components/media/image/base_asset_image.dart';
import '../../../../core/constants/assets/image_const.dart';
import '../../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../../core/constants/utils/ui_constants/sized_box_const.dart';
import '../../../../core/constants/utils/ui_constants/text_style_const.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/notifier/custom_theme.dart';
import '../../../../core/init/theme/app_color_scheme.dart';
import '../viewmodel/user_choice_viewmodel.dart';

part '../modules/user_choice_card.dart';
part '../enums/user_type.dart';

class UserChoiceView extends StatelessWidget {
  const UserChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<UserChoiceViewModel>(
      viewName: 'UserChoiceView',
      viewModel: UserChoiceViewModel(),
      onModelReady: (viewModel) {
        viewModel.setContext(context);
        viewModel.init();
      },
      onDispose: (viewModel) => viewModel.dispose(),
      onPageBuilder: (context, viewModel) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Observer(
            builder: (_) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.isError) {
                return Center(
                  child: Text(
                    context.s.formErrorGeneral,
                    style: TextStyleConst.instance.generalTextStyle1().copyWith(
                      color: CustomColors.red,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBoxConst.height60,

                    // Illustration
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: context.width * 0.8,
                        child: BaseAssetImage(
                          ImageConst
                              .instance
                              .userChoice, // Bu image'ı assets'e eklemeniz gerekecek
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBoxConst.height40,

                    Padding(
                      padding: PaddingConst.horizontal32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.s.userChoiceTitle, // "Hesap Türünü Seçin"
                            style: TextStyleConst.instance.onboardTitle(),
                            textAlign: TextAlign.center,
                          ),
                          SizedBoxConst.height8,
                          Text(
                            context
                                .s
                                .userChoiceSubtitle, // "Size uygun olan seçeneği belirleyin"
                            style: TextStyleConst.instance
                                .onboardSubtitle()
                                .copyWith(height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          SizedBoxConst.height48,

                          // Parent Choice Card
                          Observer(
                            builder:
                                (_) => UserChoiceCard(
                                  title: context.s.parentChoice, // "Ebeveyn"
                                  subtitle:
                                      context
                                          .s
                                          .parentChoiceDescription, // "Çocuğunuzun güvenliğini takip edin"
                                  icon: Icons.family_restroom,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColorScheme.instance.primary,
                                      AppColorScheme.instance.primary
                                          .withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  isSelected:
                                      viewModel.selectedUserType ==
                                      UserType.parent,
                                  onTap:
                                      () => viewModel.selectUserType(
                                        UserType.parent,
                                      ),
                                ),
                          ),

                          SizedBoxConst.height24,

                          // Child Choice Card
                          Observer(
                            builder:
                                (_) => UserChoiceCard(
                                  title: context.s.childChoice, // "Çocuk"
                                  subtitle:
                                      context
                                          .s
                                          .childChoiceDescription, // "Güvenli bir şekilde keşfet"
                                  icon: Icons.child_care,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4ECDC4),
                                      Color(0xFF44A08D),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  isSelected:
                                      viewModel.selectedUserType ==
                                      UserType.child,
                                  onTap:
                                      () => viewModel.selectUserType(
                                        UserType.child,
                                      ),
                                ),
                          ),

                          SizedBoxConst.height48,

                          // Continue Button
                          Observer(
                            builder:
                                (_) => AdaptiveGradientButton(
                                  onPressed:
                                      viewModel.selectedUserType != null &&
                                              !viewModel.isProcessing
                                          ? viewModel.navigateToAuth
                                          : null,
                                  child:
                                      viewModel.isProcessing
                                          ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                              ),
                                              SizedBoxConst.width8,
                                              Text(
                                                context.s.continueButton,
                                                style: TextStyleConst.instance
                                                    .generalTextStyle1()
                                                    .copyWith(
                                                      color: Colors.white,
                                                      letterSpacing: 0.3,
                                                    ),
                                              ),
                                            ],
                                          )
                                          : Text(
                                            context
                                                .s
                                                .continueButton, // "Devam Et"
                                            style: TextStyleConst.instance
                                                .generalTextStyle1()
                                                .copyWith(
                                                  color: Colors.white,
                                                  letterSpacing: 0.3,
                                                ),
                                          ),
                                ),
                          ),

                          SizedBoxConst.height32,

                          // Back to Login Link
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  context.s.alreadyHaveAccount,
                                  style: TextStyleConst.instance
                                      .onboardSubtitle()
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                SizedBoxConst.height4,
                                GestureDetector(
                                  onTap: viewModel.navigateToAuth,
                                  child: Text(
                                    context.s.loginButton,
                                    style:
                                        TextStyleConst.instance
                                            .onboardTextLink(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBoxConst.height40,
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
