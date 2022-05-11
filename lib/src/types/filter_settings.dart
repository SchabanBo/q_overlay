import 'package:flutter/material.dart';

class BackgroundFilterSettings {
  /// The background filter color.
  final Color? color;
  final double? blurX;
  final double? blurY;

  /// close the overlay if the user taps outside of it
  final bool dismissOnClick;

  const BackgroundFilterSettings({
    this.color,
    this.blurX,
    this.blurY,
    this.dismissOnClick = true,
  });

  factory BackgroundFilterSettings.transparent([bool dismissOnClick = true]) =>
      BackgroundFilterSettings(
        color: Colors.transparent,
        blurX: null,
        blurY: null,
        dismissOnClick: dismissOnClick,
      );
}
