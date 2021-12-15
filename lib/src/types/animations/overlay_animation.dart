import 'package:flutter/material.dart';

import '../../../q_overlay.dart';
import 'fade_animation.dart';
import 'scale_animation.dart';
import 'slide_animation.dart';

class OverlayAnimation {
  final AnimationController controller;
  final QAnimationBuilder animationBuilder;
  OverlayAnimation? child;
  OverlayAnimation({
    required this.controller,
    required this.animationBuilder,
    this.child,
  });

  factory OverlayAnimation.of({
    required QAnimation animation,
    required TickerProvider tickerProvider,
  }) {
    final controller = AnimationController(
      duration: Duration(milliseconds: animation.durationMilliseconds),
      reverseDuration:
          Duration(milliseconds: animation.reverseDurationMilliseconds),
      debugLabel: '${animation.runtimeType}',
      vsync: tickerProvider,
    );
    final curvedAnimation = CurvedAnimation(
        parent: controller,
        curve: animation.curve,
        reverseCurve: animation.reverseCurve);
    OverlayAnimation? result;
    if (animation is QSlideAnimation) {
      result = OverlayAnimation.slide(
          curvedAnimation: curvedAnimation,
          controller: controller,
          begin: animation.getBegin(),
          end: animation.end);
    }
    if (animation is QFadeAnimation) {
      result = OverlayAnimation.fade(
          curvedAnimation: curvedAnimation,
          controller: controller,
          begin: animation.begin,
          end: animation.end);
    }
    if (animation is QScaleAnimation) {
      result = OverlayAnimation.scale(
          curvedAnimation: curvedAnimation,
          controller: controller,
          begin: animation.begin,
          end: animation.end);
    }
    if (result == null) {
      controller.dispose();
      throw Exception('Unknown animation type: ${animation.runtimeType}');
    }

    if (animation.childAnimation != null) {
      result.child = OverlayAnimation.of(
        animation: animation.childAnimation!,
        tickerProvider: tickerProvider,
      );
    }

    return result;
  }

  factory OverlayAnimation.slide({
    required CurvedAnimation curvedAnimation,
    required AnimationController controller,
    required Offset begin,
    required Offset end,
  }) {
    final animation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(curvedAnimation);

    return OverlayAnimation(
        controller: controller,
        animationBuilder: (child) => SlideTransition(
              position: animation,
              child: child,
            ));
  }

  factory OverlayAnimation.fade({
    required CurvedAnimation curvedAnimation,
    required AnimationController controller,
    required double begin,
    required double end,
  }) {
    final animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(curvedAnimation);

    return OverlayAnimation(
        controller: controller,
        animationBuilder: (child) => FadeTransition(
              opacity: animation,
              child: child,
            ));
  }

  factory OverlayAnimation.scale({
    required AnimationController controller,
    required CurvedAnimation curvedAnimation,
    required double begin,
    required double end,
  }) {
    final animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(curvedAnimation);
    return OverlayAnimation(
        controller: controller,
        animationBuilder: (child) => ScaleTransition(
              scale: animation,
              child: child,
            ));
  }

  List<AnimationController> get controllers {
    final result = <AnimationController>[controller];
    if (child != null) {
      result.addAll(child!.controllers);
    }
    return result;
  }

  Future<void> reverse() =>
      Future.wait(controllers.map((controller) => controller.reverse()));

  Future<void> forward() =>
      Future.wait(controllers.map((controller) => controller.forward()));

  Widget build(Widget childWidget) {
    final result = animationBuilder(childWidget);
    return child == null ? result : child!.build(result);
  }

  void dispose() {
    controller.dispose();
    child?.dispose();
  }
}
