import 'package:flutter/cupertino.dart';

import '../../../q_overlay.dart';

class QFadeAnimation extends QAnimation {
  final double begin;
  final double end;
  const QFadeAnimation({
    int? durationMilliseconds = 200,
    int? reverseDurationMilliseconds = 200,
    Curve? curve = Curves.linear,
    Curve? reverseCurve = Curves.linear,
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
