import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/components/button/animated_button.dart';
import '../../../core/components/icons/dark_svg_icon.dart';
import '../../../core/components/icons/svg_icon.dart';
import '../../../core/constants/app/app_const.dart';
import '../../../core/constants/assets/svg_const.dart';
import '../../../core/constants/utils/ui_constants/font_size_const.dart';
import '../../../core/constants/utils/ui_constants/padding_const.dart';
import '../../../core/constants/utils/ui_constants/size_const.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/init/firebase/crashlytics/crashlytics_manager.dart';
import '../../../core/init/notifier/theme_notifier.dart';
import '../../../core/init/theme/app_color_scheme.dart';
import '../../_product/_widgets/text/header_text.dart';
import '../../auth/provider/auth_provider.dart';
import '../_wrapper/store/wrapper_store.dart';

void showMaintenanceBottomSheet(BuildContext context) {
  // final MainViewModel mainViewModel = context.read<MainViewModel>();

  try {
    // mainViewModel.websocketStore.disconnect();
  } catch (e) {
    print(e);
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    useRootNavigator: true,
    backgroundColor: context.theme.scaffoldBackgroundColor,
    constraints: BoxConstraints(
      maxHeight: context.height,
      minHeight: context.height,
    ),
    builder: (context) => const MaintenanceView(),
  );
}

class MaintenanceView extends StatefulWidget {
  const MaintenanceView({super.key});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  late StreamSubscription<DocumentSnapshot> _appStatusSubscription;

  @override
  void initState() {
    super.initState();
    _appStatusSubscription = FirebaseFirestore.instance
        .collection('app_status')
        .doc('app_status')
        .snapshots()
        .listen((value) {
          onAppStatusChanged(value);
        });
  }

  void onAppStatusChanged(DocumentSnapshot value) {
    final data = value.data() as Map<String, dynamic>;
    bool isAppAvailable = false;

    if (Platform.isAndroid) {
      if (data['isAndroidEnabled'] == true) {
        isAppAvailable = true;
      }
    } else {
      if (data['isIOSEnabled'] == true) {
        isAppAvailable = true;
      }
    }

    if (!isAppAvailable) {
      return;
    }

    _appStatusSubscription.cancel();

    // final MainViewModel mainViewModel = context.read<MainViewModel>();
    final WrapperStore wrapperStore = context.read<WrapperStore>();
    final AuthProvider auth = context.read<AuthProvider>();

    final bool isAuthenticated = auth.tryAutoLogin();

    context.pop();

    wrapperStore.init(isAuthenticated: isAuthenticated).then((value) {
      try {
        // mainViewModel.websocketStore.connect(auth.token);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: Padding(
          padding: context.paddingMainHorizontal,
          child: Column(
            children: [
              Expanded(flex: 9, child: buildHeaderText(context)),
              Expanded(flex: 17, child: buildPicture()),
              Expanded(flex: 12, child: buildContactButton(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderText(BuildContext context) {
    return Padding(
      padding: PaddingConst.top24,
      child: HeaderText(
        title: context.s.maintenanceTitle,
        subTitle: context.s.maintenanceSubtitle,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Widget buildPicture() {
    return DarkSvgPictureAsset(
      asset: SVGConst.instance.freshStarter,
      shouldSetColor: false,
    );
  }

  Widget buildContactButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseAnimatedButton(
          size: ButtonSize.large,
          backgroundColor: context.theme.colorScheme.secondaryContainer,
          shadowColor: context.theme.colorScheme.secondaryContainer.withOpacity(
            0.5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPictureAsset(
                asset: SVGConst.instance.instagram,
                color: AppColorScheme.instance.white,
              ),
              Padding(
                padding: PaddingConst.left8,
                child: Text(
                  context.s.buttonContactUs,
                  style: context.primaryTextTheme.labelLarge,
                ),
              ),
            ],
          ),
          onTap: () async {
            onContactPressed();
          },
        ),
        SizeConst.dynamicBoxHeight(16),
        buildVersionNumber(context),
        passionText(context),
      ],
    );
  }

  Text passionText(BuildContext context) {
    return Text(
      context.s.settingsCreatedWithPassion,
      style: context.textTheme.titleMedium!.copyWith(
        fontSize: FontSizeConst.small,
        color: Provider.of<ThemeNotifier>(
          context,
        ).getCustomTheme.darkPurpleToLightBlue,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget buildVersionNumber(BuildContext context) {
    return (Text(
      context.s.maintenanceVersionText(
        "${AppConst.majorVersion}.${AppConst.minorVersion}.${AppConst.subVersion}",
      ),
      style: TextStyle(
        color: Provider.of<ThemeNotifier>(
          context,
        ).getCustomTheme.darkPurpleToLightBlue,
        fontSize: FontSizeConst.medium,
        fontWeight: FontWeight.w600,
      ),
    ));
  }

  Future<void> onContactPressed() async {
    try {
      // final Uri url = Uri.parse(APIConst.whatsappContact);
      final Uri url = Uri.parse('');
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      await CrashlyticsManager.instance.sendACrash(
        error: e.toString(),
        stackTrace: StackTrace.current,
        reason: 'onContactPressed error',
      );
      return;
    }
  }
}
