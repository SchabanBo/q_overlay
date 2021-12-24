import 'dart:math';

import 'package:flutter/material.dart';

import '../types/animations/overlay_animation.dart';
import '../types/qoverlay.dart';

class OverlayWidget extends StatefulWidget {
  final QOverlayBase overlay;
  final double? Function() height;
  final double? Function() width;
  final Offset Function(Size?, Offset?) position;
  final Alignment? alignment;
  final bool canMoved;

  const OverlayWidget({
    required this.overlay,
    required this.position,
    required this.height,
    required this.width,
    this.canMoved = false,
    this.alignment,
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

    if (widget.overlay.actions.onReady != null) {
      widget.overlay.actions.onReady!();
    }

    widget.overlay.overlayAnimation.forward().then((value) {
      if (widget.overlay.actions.onReady != null) {
        widget.overlay.actions.onReady!();
      }
    });
  }

  void _updateSize() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (containerKey.currentContext != null) {
        final containerSize = containerKey.currentContext!.size;
        if (_size == null) {
          _size = containerSize;
          setState(() {});
        } else {
          _size = containerSize;
        }
      }
    });
  }

  Offset? _moveingPosition;

  @override
  Widget build(BuildContext context) {
    _updateSize();
    final _position = widget.position(_size, _moveingPosition);
    final _child = widget.overlay.overlayAnimation.build(widget.canMoved
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
        : child);
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment!,
            child: SizedBox(
              width: width,
              height: height,
              child: _child,
            ),
          )
        : Positioned(
            left: _position.dx,
            top: _position.dy,
            width: width,
            height: height,
            child: _child,
          );
  }

  double? get width {
    final w = widget.width();
    if (w == null || _size == null) {
      return w;
    }
    return max(w, _size!.width);
  }

  double? get height {
    final h = widget.height();
    if (h == null || _size == null) {
      return h;
    }
    return max(h, _size!.height);
  }

  Widget get child => SafeArea(
      child: Material(
          color: Colors.transparent,
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
