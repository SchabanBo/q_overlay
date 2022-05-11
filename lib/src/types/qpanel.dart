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
  /// The Position where the panel should displayed
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

  QPanel({
    required this.child,
    this.alignment = Alignment.bottomCenter,
    this.offset = Offset.zero,
    this.actions = const OverlayActions(),
    QAnimation? animation,
    this.margin,
    this.height,
    this.backgroundDecoration,
    this.backgroundFilter = const BackgroundFilterSettings(),
    this.width,
    this.duration,
    this.color,
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
          builder: (context) => FilterWidget(
            this,
            backgroundFilter!,
            animation,
          ),
        ),
      OverlayEntry(
        builder: (context) => OverlayWidget(
          overlay: this,
          height: () => _getHeight(MediaQuery.of(context).size),
          width: () => _getWidth(MediaQuery.of(context).size),
          alignment: alignment,
          position: (s, _) => Offset.zero,
        ),
      )
    ];
  }

  double? _getWidth(Size screen) {
    if (width != null) return width;
    if (alignment.x != 0) return screen.width * 0.3;
    if (alignment.x == 0 && alignment.y == 0) return screen.width * 0.4;
    if (alignment.x == 0 && alignment.y != 0) return screen.width;
    return null;
  }

  double? _getHeight(Size screen) {
    if (height != null) return height;
    if (alignment.x != 0 && alignment.y == 0) return screen.height;
    return null;
  }

  Offset getBegin() {
    if (alignment.x != 0.0) return Offset(alignment.x, 0.0);

    if (alignment.y == 0.0 && alignment.y == 0.0) {
      return const Offset(0.0, 5);
    }

    return Offset(0.0, alignment.y);
  }
}
