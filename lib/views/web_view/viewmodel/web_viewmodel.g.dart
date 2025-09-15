// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WebViewModel on WebViewModelBase, Store {
  late final _$viewStatusAtom = Atom(
    name: 'WebViewModelBase.viewStatus',
    context: context,
  );

  @override
  ViewStatusEnum get viewStatus {
    _$viewStatusAtom.reportRead();
    return super.viewStatus;
  }

  @override
  set viewStatus(ViewStatusEnum value) {
    _$viewStatusAtom.reportWrite(value, super.viewStatus, () {
      super.viewStatus = value;
    });
  }

  late final _$loadScreenAsyncAction = AsyncAction(
    'WebViewModelBase.loadScreen',
    context: context,
  );

  @override
  Future<void> loadScreen() {
    return _$loadScreenAsyncAction.run(() => super.loadScreen());
  }

  late final _$WebViewModelBaseActionController = ActionController(
    name: 'WebViewModelBase',
    context: context,
  );

  @override
  void setViewStatus(ViewStatusEnum status) {
    final _$actionInfo = _$WebViewModelBaseActionController.startAction(
      name: 'WebViewModelBase.setViewStatus',
    );
    try {
      return super.setViewStatus(status);
    } finally {
      _$WebViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
viewStatus: ${viewStatus}
    ''';
  }
}
