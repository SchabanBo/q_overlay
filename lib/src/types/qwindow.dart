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
  final Offset? position;

  final Alignment? alignment;

  @override
  final Widget child;

  @override
  final Duration? duration;

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

  final BackgroundFilterSettings? backgroundFilter;

  final bool canMove;

  @override
  final OverlayActions actions;

  @override
  late final OverlayAnimation overlayAnimation;

  QWindow({
    required this.child,
    this.position,
    this.alignment,
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
  })  : assert(alignment != null || position != null,
            'Alignment or position must be provieded'),
        name = name ?? 'Window${child.hashCode}';

  factory QWindow.confirmation({
    required String message,
    String? yesMessage,
    String? noMessage,
    bool canCancel = true,
    bool canMove = false,
    String? cancelMessage,
  }) {
    final name = 'Confirmation${message.hashCode}';
    return QWindow(
        name: name,
        alignment: Alignment.center,
        backgroundFilter: const BackgroundFilterSettings(),
        canMove: canMove,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(message),
            const Divider(),
            Row(
              children: [
                OutlinedButton(
                  child: Text(yesMessage ?? 'Yes'),
                  onPressed: () => QOverlay.dismissName(name, result: true),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  child: Text(noMessage ?? 'No'),
                  onPressed: () => QOverlay.dismissName(name, result: false),
                ),
                if (canCancel) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    child: Text(cancelMessage ?? 'Cancel'),
                    onPressed: () => QOverlay.dismissName(name, result: null),
                  ),
                ],
              ],
            ),
          ]),
        ));
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
    if (moveDelta != null) {
      return moveDelta;
    }

    if (position != null) {
      if (size == null) return position!;

      var xPercent = position!.dx / screen.width;
      var yPercent = position!.dy / screen.height;
      return Offset(
        position!.dx - size.width * xPercent,
        position!.dy - size.height * yPercent,
      );
    }

    size = size ?? const Size(0, 0);
    final x = (screen.width / 2 + screen.width / 2 * alignment!.x) -
        (size.width * 0.5 + size.width * 0.5 * alignment!.x);
    final y = (screen.height / 2 + screen.height / 2 * alignment!.y) -
        (size.height * 0.5 + size.height * 0.5 * alignment!.y);
    return Offset(x, y);
  }
}
