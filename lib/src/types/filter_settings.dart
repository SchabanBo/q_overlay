import 'package:flutter/material.dart';

class FilterSettings {
  /// The background filter color.
  final Color? color;
  final double blurX;
  final double blurY;

  /// close the overlay if the user taps outside of it
  final bool dissmiseOnClick;

  const FilterSettings({
    this.color,
    this.blurX = 5.0,
    this.blurY = 5.0,
    this.dissmiseOnClick = true,
  });
}
