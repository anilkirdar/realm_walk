import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/components/icons/svg_icon.dart';
import '../../core/constants/assets/svg_const.dart';
import '../../core/constants/utils/ui_constants/radius_const.dart';
import '../../core/constants/utils/ui_constants/sized_box_const.dart';
import '../../core/constants/utils/ui_constants/text_style_const.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/init/notifier/custom_theme.dart';
import '../../core/init/notifier/theme_notifier.dart';
import '../../core/init/system_init.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late final bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = Provider.of<ThemeNotifier>(context, listen: false).isDark;

    SystemInit.instance.setSystemUIOverlayStyleWelcomeView();

    WidgetsBinding.instance.addPostFrameCallback((_) => checkAndNavigate());
  }

  @override
  void dispose() {
    SystemInit.instance.setSystemUIOverlayStyle(isDark);
    super.dispose();
  }

  Future<void> checkAndNavigate() async {
    if (!kIsWeb) FlutterNativeSplash.remove();

    await Future.delayed(const Duration(milliseconds: 2000));

    final hasInternet = await hasConnection();

    if (!mounted) return;

    if (hasInternet) {
      context.go('/onboarding');
    } else {
      _showNoInternetDialog(context, () => checkAndNavigate());
    }
  }

  Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showNoInternetDialog(BuildContext context, VoidCallback onRetry) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: RadiusConst.circular20),
            title: Text(
              context.s.noInternetConnection,
              style: TextStyleConst.instance.generalTextStyle1(),
            ),
            content: Text(
              context.s.checkYourInternet,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  context.s.closeText,
                  style: TextStyleConst.instance.generalTextStyle1().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  onRetry();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: RadiusConst.circular10,
                  ),
                ),
                child: Text(
                  context.s.retryText,
                  style: TextStyleConst.instance.generalTextStyle1().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: SafeArea(
        child: SizedBox(
          height: context.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  SvgPictureAsset(
                    asset: SVGConst.instance.logo,
                    color: CustomColors.white,
                    width: context.width * 0.24,
                  ),
                  SizedBoxConst.height16,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'GAAMETIIME',
                        style: TextStyleConst.instance.splashTitle(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBoxConst.height8,
                      Text(
                        'CONNECT WITH YOUR REALITY',
                        style: TextStyleConst.instance.splashSubtitle(),
                      ),
                    ],
                  ),
                ],
              ),
              SvgPictureAsset(
                asset: SVGConst.instance.splash,
                color: CustomColors.white,
                width: context.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
