import 'dart:ui';

import 'package:flutter/material.dart';

import '../../q_overlay.dart';
import '../types/qoverlay.dart';

class FilterWidget extends StatelessWidget {
  final QOverlayBase overlay;
  final BackgroundFilterSettings settings;
  final QAnimation animation;
  const FilterWidget(this.overlay, this.settings, this.animation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => settings.dissmiseOnClick ? QOverlay.dismiss(overlay) : () {},
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: settings.blurX, sigmaY: settings.blurY),
        child: FutureBuilder(
          future: Future.microtask(() => null),
          builder: (_, s) => AnimatedContainer(
            duration: Duration(milliseconds: animation.durationMilliseconds),
            constraints: const BoxConstraints.expand(),
            color: s.connectionState == ConnectionState.done
                ? settings.color ?? Colors.grey.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
