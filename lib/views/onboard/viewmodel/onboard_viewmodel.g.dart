// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboard_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardViewModel on OnboardViewModelBase, Store {
  late final _$currentPageAtom = Atom(
    name: 'OnboardViewModelBase.currentPage',
    context: context,
  );

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
    });
  }

  late final _$OnboardViewModelBaseActionController = ActionController(
    name: 'OnboardViewModelBase',
    context: context,
  );

  @override
  void onPageChanged(int index) {
    final _$actionInfo = _$OnboardViewModelBaseActionController.startAction(
      name: 'OnboardViewModelBase.onPageChanged',
    );
    try {
      return super.onPageChanged(index);
    } finally {
      _$OnboardViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void skipToLastPage() {
    final _$actionInfo = _$OnboardViewModelBaseActionController.startAction(
      name: 'OnboardViewModelBase.skipToLastPage',
    );
    try {
      return super.skipToLastPage();
    } finally {
      _$OnboardViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPage: ${currentPage}
    ''';
  }
}
