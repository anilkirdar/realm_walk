// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overlay_state_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OverlayStateStore on OverlayStateStoreBase, Store {
  Computed<bool>? _$hasOverlayStateComputed;

  @override
  bool get hasOverlayState =>
      (_$hasOverlayStateComputed ??= Computed<bool>(
            () => super.hasOverlayState,
            name: 'OverlayStateStoreBase.hasOverlayState',
          ))
          .value;

  late final _$overlayStateAtom = Atom(
    name: 'OverlayStateStoreBase.overlayState',
    context: context,
  );

  @override
  OverlayState? get overlayState {
    _$overlayStateAtom.reportRead();
    return super.overlayState;
  }

  @override
  set overlayState(OverlayState? value) {
    _$overlayStateAtom.reportWrite(value, super.overlayState, () {
      super.overlayState = value;
    });
  }

  late final _$OverlayStateStoreBaseActionController = ActionController(
    name: 'OverlayStateStoreBase',
    context: context,
  );

  @override
  void setOverlayState(OverlayState state) {
    final _$actionInfo = _$OverlayStateStoreBaseActionController.startAction(
      name: 'OverlayStateStoreBase.setOverlayState',
    );
    try {
      return super.setOverlayState(state);
    } finally {
      _$OverlayStateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearOverlayState() {
    final _$actionInfo = _$OverlayStateStoreBaseActionController.startAction(
      name: 'OverlayStateStoreBase.clearOverlayState',
    );
    try {
      return super.clearOverlayState();
    } finally {
      _$OverlayStateStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
overlayState: ${overlayState},
hasOverlayState: ${hasOverlayState}
    ''';
  }
}
