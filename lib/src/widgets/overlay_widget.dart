import 'package:flutter/material.dart';

import '../types/animations/overlay_animation.dart';
import '../types/qoverlay.dart';

class OverlayWidget extends StatefulWidget {
  final QOverlayBase overlay;
  final double? Function() height;
  final double? Function() width;
  final Offset Function(Size?, Offset?) position;
  final bool canMoved;

  const OverlayWidget({
    required this.overlay,
    required this.position,
    required this.height,
    required this.width,
    this.canMoved = false,
    Key? key,
  }) : super(key: key);

  @override
  _OverlayWidgetState createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget>
    with TickerProviderStateMixin {
  final containerKey = GlobalKey();
  Size? _size;
  @override
  void initState() {
    widget.overlay.overlayAnimation = OverlayAnimation.of(
        animation: widget.overlay.animation, tickerProvider: this);
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (containerKey.currentContext != null) {
        final containerSize = containerKey.currentContext!.size;
        _size = containerSize;
        setState(() {});
      }
    });

    if (widget.overlay.actions.onReady != null) {
      widget.overlay.actions.onReady!();
    }

    widget.overlay.overlayAnimation.forward().then((value) {
      if (widget.overlay.actions.onReady != null) {
        widget.overlay.actions.onReady!();
      }
    });
  }

  Offset? _moveingPosition;

  @override
  Widget build(BuildContext context) {
    final _position = widget.position(_size, _moveingPosition);
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      width: widget.width(),
      height: widget.height(),
      child: widget.overlay.overlayAnimation.build(
        widget.canMoved
            ? GestureDetector(
                onPanUpdate: (details) {
                  final size = containerKey.currentContext!.size!;
                  _moveingPosition = Offset(
                      details.globalPosition.dx - size.width / 2,
                      details.globalPosition.dy - size.height * 0.2);
                  setState(() {});
                },
                child: child,
              )
            : child,
      ),
    );
  }

  Widget get child => SafeArea(
      child: Material(
          key: containerKey,
          child: Container(
              margin: widget.overlay.margin,
              decoration: widget.overlay.backgroundDecoration ??
                  BoxDecoration(
                    color: widget.overlay.color ??
                        Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
              child: widget.overlay.child)));
}