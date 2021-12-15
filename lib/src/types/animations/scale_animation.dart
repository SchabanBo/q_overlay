import 'package:flutter/cupertino.dart';

import '../../../q_overlay.dart';

class QScaleAnimation extends QAnimation {
  final double begin;
  final double end;
  const QScaleAnimation({
    int? durationMilliseconds = 300,
    int? reverseDurationMilliseconds = 300,
    Curve? curve = Curves.fastOutSlowIn,
    Curve? reverseCurve = Curves.fastOutSlowIn,
    this.begin = 0,
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
