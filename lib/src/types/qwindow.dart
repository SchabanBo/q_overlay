import 'package:flutter/material.dart';

import '../../q_overlay.dart';
import '../widgets/filter_widget.dart';
import '../widgets/overlay_widget.dart';
import 'animations/fade_animation.dart';
import 'animations/overlay_animation.dart';
import 'animations/scale_animation.dart';
import 'qoverlay.dart';

/// Show a window at any position on the screen.
class QWindow with QOverlayBase {
  /// The position of the overlay
  final Offset position;

  @override
  final Widget child;

  @override
  final Duration? duration;

  /// The notification color
  @override
  final Color? color;

  @override
  final String name;

  @override
  final QAnimation animation;

  @override
  final BoxDecoration? backgroundDecoration;

  @override
  final EdgeInsets? margin;

  final FilterSettings? backgroundFilter;

  final bool canMove;

  @override
  final OverlayActions actions;

  @override
  late final OverlayAnimation overlayAnimation;

  QWindow({
    required this.child,
    required this.position,
    this.actions = const OverlayActions(),
    this.margin,
    this.color,
    this.backgroundFilter,
    this.animation = const QFadeAnimation(child: QScaleAnimation()),
    this.backgroundDecoration,
    this.canMove = false,
    this.duration,
    String? name,
    Key? key,
  }) : name = name ?? 'Window${child.hashCode}';

  @override
  Future<T?> show<T>({BuildContext? context}) =>
      QOverlay.show(this, context: context);

  @override
  List<OverlayEntry> buildEntries() {
    return [
      if (backgroundFilter != null)
        OverlayEntry(
          builder: (context) =>
              FilterWidget(this, backgroundFilter!, animation),
          maintainState: false,
          opaque: false,
        ),
      OverlayEntry(
          builder: (context) => OverlayWidget(
                overlay: this,
                height: () => null,
                width: () => null,
                position: (s, m) =>
                    _calcPosition(MediaQuery.of(context).size, s, m),
                canMoved: canMove,
              ))
    ];
  }

  Offset _calcPosition(Size screen, Size? size, Offset? moveDelta) {
    if (size == null) {
      return position;
    }
    if (moveDelta != null) {
      return moveDelta;
    }

    var xPercent = position.dx / screen.width;
    var yPercent = position.dy / screen.height;
    return Offset(
      position.dx - size.width * xPercent,
      position.dy - size.height * yPercent,
    );
  }
}
