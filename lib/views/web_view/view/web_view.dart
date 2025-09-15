import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/components/adaptive_widgets/adaptive_circular_indicator.dart';
import '../../../core/components/adaptive_widgets/app_bar_widget.dart';
import '../../../core/constants/enums/view/view_status_enum.dart';
import '../viewmodel/web_viewmodel.dart';

class WebView extends StatelessWidget {
  const WebView({Key? key, required this.url, required this.appBarText})
      : assert(url != '', 'Url must not be empty'),
        super(key: key);
  final String url, appBarText;

  @override
  Widget build(BuildContext context) {
    return BaseView<WebViewModel>(
        viewModel: WebViewModel(),
        viewName: 'WebView//${url.split('://').last.replaceAll('//', '/')}',
        onModelReady: (model) {
          model.setContext(context);
          model.setUrl(url);
          model.init();
        },
        onPageBuilder: (BuildContext context, WebViewModel viewModel) => Scaffold(
              appBar: AppBarConst(
                centerTitle: true,
                title: appBarText,
                implyExitButton: false,
              ),
              body: Observer(builder: (context) {
                /// TODO: create a widget that handles view status and error for all views
                if (viewModel.viewStatus == ViewStatusEnum.error) {
                  return const Center(child: Text('Error'));
                }

                return viewModel.viewStatus == ViewStatusEnum.loading
                    ? const Center(child: AdaptiveCPI())
                    : WebViewWidget(controller: viewModel.controller);
              }),
            ));
  }
}
