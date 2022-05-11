import 'package:flutter/material.dart';

import '../../../q_overlay.dart';

class QScaleAnimation extends QAnimation {
  final double begin;
  final double end;
  final Alignment alignment;
  const QScaleAnimation({
    int? durationMilliseconds = 300,
    int? reverseDurationMilliseconds = 300,
    Curve? curve = Curves.fastOutSlowIn,
    Curve? reverseCurve = Curves.fastOutSlowIn,
    this.begin = 0,
    this.alignment = Alignment.center,
    this.end = 1,
    QAnimation? child,
  }) : super(
          durationMilliseconds: durationMilliseconds,
          reverseDurationMilliseconds: reverseDurationMilliseconds,
          curve: curve,
          reverseCurve: reverseCurve,
          childAnimation: child,
        );
}
