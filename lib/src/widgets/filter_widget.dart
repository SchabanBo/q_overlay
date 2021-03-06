import 'dart:ui';

import 'package:flutter/material.dart';

import '../../q_overlay.dart';

class FilterWidget extends StatelessWidget {
  final QOverlayBase overlay;
  final BackgroundFilterSettings settings;
  final QAnimation animation;
  const FilterWidget(this.overlay, this.settings, this.animation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!settings.dismissOnClick &&
        settings.blurX == null &&
        settings.blurY == null) {
      return Container();
    }

    Widget child = FutureBuilder(
      future: Future.microtask(() {}),
      builder: (_, s) => AnimatedContainer(
        duration: Duration(milliseconds: animation.durationMilliseconds),
        constraints: const BoxConstraints.expand(),
        color: s.connectionState == ConnectionState.done
            ? settings.color ?? Colors.black.withOpacity(0.1)
            : Colors.transparent,
      ),
    );
    if (settings.blurX != null && settings.blurY != null) {
      child = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: settings.blurX!,
          sigmaY: settings.blurY!,
        ),
        child: child,
      );
    }
    if (settings.dismissOnClick) {
      child = GestureDetector(
        onTap: () => QOverlay.dismiss(overlay),
        child: child,
      );
    }
    return child;
  }
}
