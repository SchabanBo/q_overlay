import 'package:flutter/material.dart';

import '../../q_overlay.dart';
import '../widgets/overlay_widget.dart';
import 'animations/overlay_animation.dart';
import 'animations/slide_animation.dart';
import 'qoverlay.dart';

/// Show a notification in any router you have in your project
class QNotification with QOverlayBase {
  /// The Position where the notification should displayed
  final Alignment alignment;

  /// The offset from the Notification position With this offset, you can move
  /// the notification position for example for up or down left or right
  final Offset offset;

  /// The Notification width
  final double? width;

  /// The notification height
  final double? height;

  /// The content of your notification
  @override
  final Widget child;

  /// The notification color
  @override
  final Color? color;

  @override
  final Duration? duration;

  @override
  final String name;

  @override
  final OverlayActions actions;

  @override
  late final QAnimation animation;

  @override
  final BoxDecoration? backgroundDecoration;

  @override
  final EdgeInsets? margin;

  @override
  late final OverlayAnimation overlayAnimation;

  QNotification({
    required this.child,
    this.offset = Offset.zero,
    this.alignment = Alignment.bottomRight,
    QAnimation? animation,
    this.actions = const OverlayActions(),
    this.duration = const Duration(seconds: 2),
    this.height,
    this.backgroundDecoration,
    this.margin,
    this.width,
    this.color,
    String? name,
  }) : name = name ?? 'Notification${child.hashCode}' {
    this.animation = animation ?? QSlideAnimation(begin: getBegin());
  }

  @override
  List<OverlayEntry> buildEntries() {
    return [
      OverlayEntry(
          builder: (context) => OverlayWidget(
                overlay: this,
                height: () => height,
                width: () => width,
                position: (s, _) =>
                    _calcPosition(MediaQuery.of(context).size, s),
              ))
    ];
  }

  @override
  Future<T?> show<T>({BuildContext? context}) =>
      QOverlay.show(this, context: context);

  Offset _calcPosition(Size screen, Size? size) {
    size = size ?? const Size(0, 0);
    final x = (screen.width / 2 + screen.width / 2 * alignment.x) -
        (size.width * 0.5 + size.width * 0.5 * alignment.x) +
        offset.dx;
    final y = (screen.height / 2 + screen.height / 2 * alignment.y) -
        (size.height * 0.5 + size.height * 0.5 * alignment.y) +
        offset.dy;
    return Offset(x, y);
  }

  Offset getBegin() {
    if (alignment.x != 0.0) return Offset(alignment.x, 0.0);

    if (alignment.y == 0.0 && alignment.y == 0.0) {
      return Offset(0.0, 5);
    }

    return Offset(0.0, alignment.y);
  }
}
