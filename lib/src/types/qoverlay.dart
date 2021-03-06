import 'package:flutter/material.dart';

import '../../q_overlay.dart';
import 'animations/overlay_animation.dart';

mixin QOverlayBase {
  /// a unique name for the overlay
  String get name;

  /// the overlay animation
  QAnimation get animation;

  /// the overlay background color
  Color? get color;

  /// the overlay margin
  EdgeInsets? get margin;

  /// the animation when the overlay is shown
  OverlayAnimation get overlayAnimation;
  set overlayAnimation(OverlayAnimation value);

  BoxDecoration? get backgroundDecoration;

  /// this widget to show in the overlay
  Widget get child;

  /// set you actions to the overlay events
  OverlayActions get actions;

  /// the time to keep the overlay open.
  /// When the time is over, the overlay will be closed automatically.
  /// If the value is null, the overlay will not be closed automatically.
  Duration? get duration;

  List<OverlayEntry> buildEntries();

  ///  show this overlay
  Future<T?> show<T>({BuildContext? context});
}

/// the overlay actions to handle the overlay events
class OverlayActions<T> {
  /// run an action right before an overlay is about to open
  final Future<void> Function()? onOpen;

  /// run an action after the overlay is opened
  final Future<void> Function()? onReady;

  /// run an action when the overlay is about to close
  /// return [False] to cancel the close action
  final Future<bool> Function(T?)? canClose;

  /// run an action when the overlay is closed
  /// you can here change the overlay result and return a new one
  final Future<T?> Function(T?)? onClose;

  const OverlayActions({
    this.onOpen,
    this.onReady,
    this.canClose,
    this.onClose,
  });
}
