// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$WebsocketStore on WebsocketStoreBase, Store {
  late final _$isSocketConnectedAtom = Atom(
    name: 'WebsocketStoreBase.isSocketConnected',
    context: context,
  );

  @override
  bool get isSocketConnected {
    _$isSocketConnectedAtom.reportRead();
    return super.isSocketConnected;
  }

  @override
  set isSocketConnected(bool value) {
    _$isSocketConnectedAtom.reportWrite(value, super.isSocketConnected, () {
      super.isSocketConnected = value;
    });
  }

  late final _$isUserInCallAtom = Atom(
    name: 'WebsocketStoreBase.isUserInCall',
    context: context,
  );

  @override
  bool get isUserInCall {
    _$isUserInCallAtom.reportRead();
    return super.isUserInCall;
  }

  @override
  set isUserInCall(bool value) {
    _$isUserInCallAtom.reportWrite(value, super.isUserInCall, () {
      super.isUserInCall = value;
    });
  }

  late final _$isAppResumedAtom = Atom(
    name: 'WebsocketStoreBase.isAppResumed',
    context: context,
  );

  @override
  bool get isAppResumed {
    _$isAppResumedAtom.reportRead();
    return super.isAppResumed;
  }

  @override
  set isAppResumed(bool value) {
    _$isAppResumedAtom.reportWrite(value, super.isAppResumed, () {
      super.isAppResumed = value;
    });
  }

  late final _$connectAsyncAction = AsyncAction(
    'WebsocketStoreBase.connect',
    context: context,
  );

  @override
  Future<bool> connect(String token) {
    return _$connectAsyncAction.run(() => super.connect(token));
  }

  late final _$WebsocketStoreBaseActionController = ActionController(
    name: 'WebsocketStoreBase',
    context: context,
  );

  @override
  void setSocketConnected(bool value) {
    final _$actionInfo = _$WebsocketStoreBaseActionController.startAction(
      name: 'WebsocketStoreBase.setSocketConnected',
    );
    try {
      return super.setSocketConnected(value);
    } finally {
      _$WebsocketStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSocketConnected: ${isSocketConnected},
isUserInCall: ${isUserInCall},
isAppResumed: ${isAppResumed}
    ''';
  }
}
