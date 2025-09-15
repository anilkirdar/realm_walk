import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/base/model/base_view_model.dart';
import '../../../core/constants/enums/view/view_status_enum.dart';
import '../../_product/_utility/web_view_manager.dart';
import '../service/i_web_service.dart';
import '../service/web_service.dart';

part 'web_viewmodel.g.dart';

class WebViewModel = WebViewModelBase with _$WebViewModel;

abstract class WebViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => viewModelContext = context;

  void setUrl(String value) => url = value;

  late IWebService webService;

  late final WebViewController _controller;

  final WebViewManager webViewManager = WebViewManager.instance;

  String url = '';

  WebViewController get controller => _controller;

  @observable
  ViewStatusEnum viewStatus = ViewStatusEnum.loading;

  @action
  void setViewStatus(ViewStatusEnum status) {
    viewStatus = status;
  }

  @override
  void init() async {
    if (url == '') {
      throw Error();
    }
    webService = WebService(vexanaManager.networkManager);
    _controller = webViewManager.initController(viewModelContext, url);
    loadScreen();
  }

  @action
  Future<void> loadScreen() async {
    controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (value) {
        setViewStatus(ViewStatusEnum.loaded);
      },
      onWebResourceError: (value) {
        setViewStatus(ViewStatusEnum.error);
      },
    ));
  }

  void dispose() {
    _controller.clearCache();
  }
}
