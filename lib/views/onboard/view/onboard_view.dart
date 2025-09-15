import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/components/button/adaptive_gradient_button.dart';
import '../../../core/components/media/image/base_asset_image.dart';
import '../../../core/constants/assets/image_const.dart';
import '../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../core/constants/utils/ui_constants/radius_const.dart';
import '../../../core/constants/utils/ui_constants/sized_box_const.dart';
import '../../../core/constants/utils/ui_constants/text_style_const.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/init/theme/app_color_scheme.dart';
import '../viewmodel/onboard_viewmodel.dart';

part '../modules/onboard_page.dart';

class OnboardView extends StatelessWidget {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<OnboardViewModel>(
      viewName: 'OnboardView',
      viewModel: OnboardViewModel(),
      onModelReady: (viewModel) {
        viewModel.setContext(context);
        viewModel.init();
      },
      onDispose: (viewModel) {
        viewModel.dispose();
      },
      onPageBuilder: (BuildContext context, OnboardViewModel viewModel) {
        List<OnboardingPage> onboardingData = [
          OnboardingPage(
            illustration: ImageConst.instance.onboard1,
            title: context.s.onboardTitle1,
            subtitle: context.s.onboardSubtitle1,
          ),
          OnboardingPage(
            illustration: ImageConst.instance.onboard2,
            title: context.s.onboardTitle2,
            subtitle: context.s.onboardSubtitle2,
          ),
          OnboardingPage(
            illustration: ImageConst.instance.onboard3,
            title: context.s.onboardTitle3,
            subtitle: context.s.onboardSubtitle3,
          ),
        ];

        return Scaffold(
          backgroundColor: Colors.white,
          body: PageView.builder(
            controller: viewModel.pageController,
            onPageChanged: viewModel.onPageChanged,
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              final page = onboardingData[index];
              final isLastPage = index == onboardingData.length - 1;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight,
                  top: context.height * (isLastPage ? 0.1 : 0.2),
                ),
                child: Column(
                  children: [
                    SizedBoxConst.height20,

                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: context.width * 0.9,
                        child: BaseAssetImage(
                          page.illustration,
                          fit: BoxFit.contain,
                          // shouldSetColor: false,
                          // width: context.width * 0.85,
                        ),
                      ),
                    ),

                    SizedBoxConst.height64,

                    Padding(
                      padding: PaddingConst.horizontal32,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            page.title,
                            style: TextStyleConst.instance.onboardTitle(),
                            textAlign: TextAlign.center,
                          ),

                          SizedBoxConst.height32,

                          Text(
                            page.subtitle,
                            style: TextStyleConst.instance.onboardSubtitle(),
                            textAlign: TextAlign.center,
                          ),

                          SizedBoxConst.height48,

                          if (!isLastPage) ...[
                            Padding(
                              padding: PaddingConst.top8,
                              child: TextButton(
                                onPressed: () => viewModel.skipToLastPage(),
                                style: TextButton.styleFrom(
                                  padding:
                                      PaddingConst.horizontal24 +
                                      PaddingConst.vertical12,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size.zero,
                                  visualDensity: VisualDensity.compact,
                                ),
                                child: Text(
                                  context.s.buttonSkip,
                                  style: TextStyleConst.instance
                                      .onboardSubtitle()
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColorScheme.instance.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ),
                          ],

                          if (isLastPage) ...[
                            Center(
                              child: AdaptiveGradientButton(
                                onPressed:
                                    () => viewModel.navigateToUserChoice(),
                                child: Text(
                                  context.s.letsPlay,
                                  style: TextStyleConst.instance
                                      .generalTextStyle1()
                                      .copyWith(
                                        letterSpacing: 0.3,
                                        color: AppColorScheme.instance.white,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    Observer(
                      builder: (_) {
                        return Padding(
                          padding: PaddingConst.horizontal32,
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                onboardingData.length,
                                (dotIndex) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: PaddingConst.horizontal4,
                                  height: 8,
                                  width:
                                      viewModel.currentPage == dotIndex
                                          ? 24
                                          : 8,
                                  decoration: BoxDecoration(
                                    color:
                                        viewModel.currentPage == dotIndex
                                            ? AppColorScheme.instance.primary
                                            : AppColorScheme.instance.grey1,
                                    borderRadius: RadiusConst.circular4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
