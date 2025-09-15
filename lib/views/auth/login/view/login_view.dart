import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../core/components/media/image/base_asset_image.dart';
import '../../../../core/constants/assets/image_const.dart';
import '../../../../core/constants/utils/ui_constants/font_size_const.dart';
import '../../modules/auth_password_field.dart';
import '../../modules/auth_text_field.dart';
import '../../modules/social_icon.dart';
import '../viewmodel/login_viewmodel.dart';
import '../../../../core/components/button/adaptive_gradient_button.dart';
import '../../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../../core/constants/utils/ui_constants/sized_box_const.dart';
import '../../../../core/constants/utils/ui_constants/text_style_const.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/notifier/custom_theme.dart';
import '../../../../core/init/theme/app_color_scheme.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewName: 'LoginView',
      viewModel: LoginViewModel(),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBoxConst.height60,

                    // Character Illustration
                    // Center(
                    //   child: SizedBox(
                    //     width: context.width * 0.7,
                    //     height: 200,
                    //     child: Stack(
                    //       children: [
                    //         // Background circle
                    //         Positioned(
                    //           left: 20,
                    //           top: 20,
                    //           child: Container(
                    //             width: 120,
                    //             height: 120,
                    //             decoration: BoxDecoration(
                    //               color: Colors.pink.shade50,
                    //               shape: BoxShape.circle,
                    //             ),
                    //           ),
                    //         ),
                    //         // Character sitting at desk
                    //         Positioned(
                    //           right: 10,
                    //           bottom: 20,
                    //           child: Container(
                    //             width: 90,
                    //             height: 110,
                    //             child: Stack(
                    //               children: [
                    //                 // Desk/Monitor
                    //                 Positioned(
                    //                   right: 0,
                    //                   top: 20,
                    //                   child: Container(
                    //                     width: 35,
                    //                     height: 25,
                    //                     decoration: BoxDecoration(
                    //                       color: const Color(0xFF2D3142),
                    //                       borderRadius: BorderRadius.circular(
                    //                         4,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // Monitor stand
                    //                 Positioned(
                    //                   right: 12,
                    //                   top: 45,
                    //                   child: Container(
                    //                     width: 10,
                    //                     height: 8,
                    //                     color: const Color(0xFF2D3142),
                    //                   ),
                    //                 ),
                    //                 // Head
                    //                 Positioned(
                    //                   left: 15,
                    //                   top: 0,
                    //                   child: Container(
                    //                     width: 40,
                    //                     height: 40,
                    //                     decoration: const BoxDecoration(
                    //                       color: Color(0xFFFFDBD1),
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child: const Icon(
                    //                       Icons.person,
                    //                       size: 20,
                    //                       color: Color(0xFF2D3142),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // Body - Pink shirt
                    //                 Positioned(
                    //                   left: 10,
                    //                   top: 35,
                    //                   child: Container(
                    //                     width: 50,
                    //                     height: 45,
                    //                     decoration: BoxDecoration(
                    //                       color:
                    //                           AppColorScheme.instance.primary,
                    //                       borderRadius: BorderRadius.circular(
                    //                         8,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // Legs - Sitting position
                    //                 Positioned(
                    //                   left: 5,
                    //                   bottom: 0,
                    //                   child: Container(
                    //                     width: 60,
                    //                     height: 25,
                    //                     decoration: BoxDecoration(
                    //                       color: const Color(0xFF4ECDC4),
                    //                       borderRadius: BorderRadius.circular(
                    //                         12,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //         // Decorative dots
                    //         Positioned(
                    //           left: 10,
                    //           top: 10,
                    //           child: CircleDot(color: Colors.orange, size: 8),
                    //         ),
                    //         Positioned(
                    //           right: 40,
                    //           top: 30,
                    //           child: CircleDot(color: Colors.yellow, size: 6),
                    //         ),
                    //         Positioned(
                    //           left: 40,
                    //           bottom: 40,
                    //           child: CircleDot(color: Colors.purple, size: 10),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: context.width * 0.9,
                        child: BaseAssetImage(
                          ImageConst.instance.login,
                          fit: BoxFit.contain,
                          // shouldSetColor: false,
                          // width: context.width * 0.85,
                        ),
                      ),
                    ),

                    SizedBoxConst.height40,

                    Padding(
                      padding: PaddingConst.horizontal32,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.s.welcomeBackTitle,
                            style: TextStyleConst.instance.onboardTitle(),
                          ),
                          SizedBoxConst.height8,
                          Text(
                            context.s.welcomeBackSubtitle,
                            style: TextStyleConst.instance
                                .onboardSubtitle()
                                .copyWith(height: 1.5),
                          ),
                          SizedBoxConst.height32,

                          Form(
                            key: viewModel.formKey,
                            child: Column(
                              children: [
                                AuthTextField(
                                  controller: viewModel.emailController,
                                  label: context.s.emailLabel,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: viewModel.validateEmail,
                                ),
                                SizedBoxConst.height24,
                                Observer(
                                  builder:
                                      (_) => AuthPasswordField(
                                        controller:
                                            viewModel.passwordController,
                                        label: context.s.passwordLabel,
                                        isVisible: viewModel.isPasswordVisible,
                                        toggleVisibility:
                                            viewModel.togglePasswordVisibility,
                                        validator: viewModel.validatePassword,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          SizedBoxConst.height16,

                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: viewModel.navigateToForgotPassword,
                              child: Text(
                                context.s.forgotPasswordText,
                                style: TextStyleConst.instance
                                    .onboardTextLink()
                                    .copyWith(
                                      fontSize: FontSizeConst.small - 1,
                                    ),
                              ),
                            ),
                          ),

                          SizedBoxConst.height40,

                          Center(
                            child: Observer(
                              builder:
                                  (_) => AdaptiveGradientButton(
                                    onPressed:
                                        viewModel.isLoggingIn
                                            ? null
                                            : viewModel.login,
                                    child:
                                        viewModel.isLoggingIn
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
                                                  context.s.loginButton,
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
                                              context.s.loginButton,
                                              style: TextStyleConst.instance
                                                  .generalTextStyle1()
                                                  .copyWith(
                                                    color: Colors.white,
                                                    letterSpacing: 0.3,
                                                  ),
                                            ),
                                  ),
                            ),
                          ),

                          SizedBoxConst.height32,

                          Center(
                            child: Text(
                              context.s.connectWithText,
                              style: TextStyleConst.instance
                                  .onboardSubtitle()
                                  .copyWith(
                                    color: AppColorScheme.instance.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          SizedBoxConst.height16,

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Observer(
                                builder:
                                    (_) => SocialIcon(
                                      color: CustomColors.red,
                                      icon: Icons.g_mobiledata,
                                      onPressed: () async {
                                        if (viewModel.isLoading == false) {
                                          await viewModel.signInWithGoogle();
                                        }
                                      },
                                    ),
                              ),
                              SizedBoxConst.width16,
                              Observer(
                                builder:
                                    (_) => SocialIcon(
                                      color: Colors.blue,
                                      icon: Icons.facebook,
                                      onPressed: () async {
                                        if (viewModel.isLoading == false) {
                                          await viewModel.signInWithFacebook();
                                        }
                                      },
                                    ),
                              ),
                            ],
                          ),

                          SizedBoxConst.height32,
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  context.s.dontHaveAccountText,
                                  style: TextStyleConst.instance
                                      .onboardSubtitle()
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                                SizedBoxConst.height4,
                                GestureDetector(
                                  onTap: viewModel.navigateToCreateAccount,
                                  child: Text(
                                    context.s.createAccountButton,
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
