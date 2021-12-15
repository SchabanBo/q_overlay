import 'package:flutter/material.dart';

import '../../../q_overlay.dart';

class QSlideAnimation extends QAnimation {
  final Offset? begin;
  final Offset end;
  final Alignment? beginAlignment;
  const QSlideAnimation({
    int? durationMilliseconds,
    int? reverseDurationMilliseconds,
    Curve? curve,
    Curve? reverseCurve,
    this.begin,
    this.beginAlignment,
    this.end = Offset.zero,
    QAnimation? child,
  })  : assert(begin != null || beginAlignment != null),
        super(
          durationMilliseconds: durationMilliseconds,
          reverseDurationMilliseconds: reverseDurationMilliseconds,
          curve: curve,
          reverseCurve: reverseCurve,
          childAnimation: child,
        );

  Offset getBegin() => begin ?? Offset(beginAlignment!.x, beginAlignment!.y);
}
