import 'dart:async';

import 'package:flutter/material.dart';

import '../../q_overlay.dart';
import '../widgets/filter_widget.dart';
import '../widgets/overlay_widget.dart';
import 'animations/overlay_animation.dart';
import 'animations/slide_animation.dart';
import 'qoverlay.dart';

/// Show a panel in any router you have in your project
class QPanel with QOverlayBase {
  /// The Position where the panal should displayed
  final Alignment alignment;

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

  final FilterSettings? backgroundFilter;

  @override
  final String name;

  @override
  late final QAnimation animation;

  final bool shrink;

  @override
  final BoxDecoration? backgroundDecoration;

  @override
  final EdgeInsets? margin;

  @override
  late final OverlayAnimation overlayAnimation;

  @override
  final OverlayActions actions;

  QPanel({
    required this.child,
    this.alignment = Alignment.bottomCenter,
    this.offset = Offset.zero,
    this.actions = const OverlayActions(),
    QAnimation? animation,
    this.margin,
    this.height,
    this.backgroundDecoration,
    this.backgroundFilter,
    this.width,
    this.duration,
    this.color,
    this.shrink = false,
    String? name,
    Key? key,
  }) : name = name ?? 'Panel${child.hashCode}' {
    this.animation = animation ?? QSlideAnimation(begin: getBegin());
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
                height: () => _getHeight(MediaQuery.of(context).size),
                width: () => _getWidth(MediaQuery.of(context).size),
                position: (s, _) =>
                    _calcPosition(MediaQuery.of(context).size, s),
              ))
    ];
  }

  Offset _calcPosition(Size screen, Size? size) {
    size = size ?? Size(0, 0);
    final x = (screen.width / 2 + screen.width / 2 * alignment.x) -
        (size.width * 0.5 + size.width * 0.5 * alignment.x) +
        offset.dx;
    final y = (screen.height / 2 + screen.height / 2 * alignment.y) -
        (size.height * 0.5 + size.height * 0.5 * alignment.y) +
        offset.dy;
    return Offset(x, y);
  }

  double? _getWidth(Size screen) {
    if (width != null) return width;
    if (shrink) return null;
    if (alignment.x == 0.0 && alignment.y != 0) return screen.width;
    return screen.width * 0.35;
  }

  double? _getHeight(Size screen) {
    if (height != null) {
      return height;
    }
    if (shrink) {
      return null;
    }
    if (alignment.x != 00 && alignment.y == 0.0) return screen.height;
    return screen.height * 0.35;
  }

  Offset getBegin() {
    if (alignment.x != 0.0) return Offset(alignment.x, 0.0);

    if (alignment.y == 0.0 && alignment.y == 0.0) {
      return Offset(0.0, 5);
    }

    return Offset(0.0, alignment.y);
  }
}
