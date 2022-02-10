import 'package:flutter/material.dart';

class BackgroundFilterSettings {
  /// The background filter color.
  final Color? color;
  final double blurX;
  final double blurY;

  /// close the overlay if the user taps outside of it
  final bool dissmiseOnClick;

  const BackgroundFilterSettings({
    this.color,
    this.blurX = 5.0,
    this.blurY = 5.0,
    this.dissmiseOnClick = true,
  });

  factory BackgroundFilterSettings.transparent(
          {bool dissmiseOnClick = false}) =>
      BackgroundFilterSettings(
        color: Colors.transparent,
        blurX: 0.0001,
        blurY: 0.0001,
        dissmiseOnClick: dissmiseOnClick,
      );
}
