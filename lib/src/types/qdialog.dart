import 'dart:async';

import 'package:flutter/material.dart';

import '../../q_overlay.dart';
import '../widgets/filter_widget.dart';
import '../widgets/overlay_widget.dart';
import 'animations/fade_animation.dart';
import 'animations/overlay_animation.dart';
import 'animations/slide_animation.dart';
import 'qoverlay.dart';

/// Show a dialog in any router you have in your project
class QDialog with QOverlayBase {
  /// The offset from the Notification position With this offset, you can move
  /// the notification position for example for up or down left or right
  final Offset offset;

  /// The Notification width
  final double? width;

  /// The notification height
  final double? height;

  @override
  final Widget child;

  @override
  final Duration? duration;

  /// The notification color
  @override
  final Color? color;

  final BackgroundFilterSettings? backgroundFilter;

  @override
  final String name;

  @override
  late final QAnimation animation;

  @override
  final BoxDecoration? backgroundDecoration;

  @override
  final EdgeInsets? margin;

  @override
  late final OverlayAnimation overlayAnimation;

  @override
  final OverlayActions actions;

  QDialog({
    required this.child,
    this.offset = Offset.zero,
    this.actions = const OverlayActions(),
    QAnimation? animation,
    this.margin,
    this.height,
    this.backgroundDecoration,
    this.backgroundFilter = const BackgroundFilterSettings(blurX: 1, blurY: 1),
    this.width,
    this.duration,
    this.color,
    String? name,
    Key? key,
  }) : name = name ?? 'Panel${child.hashCode}' {
    this.animation =
        animation ?? const QFadeAnimation(reverseDurationMilliseconds: 100);
  }

  @override
  Future<T?> show<T>({BuildContext? context}) =>
      QOverlay.show(this, context: context);

  @override
  List<OverlayEntry> buildEntries() {
    return [
      if (backgroundFilter != null)
        OverlayEntry(
            builder: (context) =>
                FilterWidget(this, backgroundFilter!, animation)),
      OverlayEntry(
          builder: (context) => OverlayWidget(
                overlay: this,
                height: () => height,
                width: () => width,
                alignment: Alignment.center,
                position: (s, _) => Offset.zero,
              ))
    ];
  }
}
