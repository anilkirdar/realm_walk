import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'overlay_state_store.g.dart';

class OverlayStateStore = OverlayStateStoreBase with _$OverlayStateStore;

abstract class OverlayStateStoreBase with Store {
  @observable
  OverlayState? overlayState;

  @action
  void setOverlayState(OverlayState state) {
    overlayState = state;
  }

  @computed
  bool get hasOverlayState => overlayState != null;

  /// Helper method to safely insert overlay entries
  void insertOverlay(OverlayEntry entry) {
    if (hasOverlayState) {
      overlayState!.insert(entry);
    }
  }

  /// Helper method to safely get overlay state
  OverlayState? getOverlayState() {
    return overlayState;
  }

  /// Clear the overlay state reference
  @action
  void clearOverlayState() {
    overlayState = null;
  }
}
