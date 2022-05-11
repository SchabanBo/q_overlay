import 'package:flutter/material.dart';

import 'controllers/overlay_controller.dart';
import 'types/qoverlay.dart';

class QOContext {
  GlobalKey<NavigatorState>? navigationKey;

  final _controller = OverlaysController();

  int get overlayCount => _controller.length;

  /// Show an overlay
  Future<T?> show<T>(QOverlayBase overlay, {BuildContext? context}) async {
    assert(navigationKey != null || context != null,
        'Either navigationKey or context must be provided');
    final overlayState = context == null
        ? navigationKey!.currentState!.overlay
        : Navigator.of(context).overlay;
    return _controller.add<T?>(overlayState!, overlay);
  }

  /// Dismiss an overlay
  Future<T?> dismiss<T>(QOverlayBase overlay, {T? result}) async {
    return _controller.dismiss<T>(overlay, result: result);
  }

  /// Dismiss an overlay with [Name]
  Future<T?> dismissName<T>(String name, {T? result}) async {
    return _controller.dismissName<T>(name, result: result);
  }

  // Dismiss last open overlay
  Future<T?> dismissLast<T>({T? result}) async {
    return _controller.dismissLast<T>(result: result);
  }

  /// Dismiss all overlays
  Future<void> dismissAll<T>({T? result, bool atSameTime = false}) async {
    return _controller.dismissAll<T>(result: result, atSameTime: atSameTime);
  }

  Function(String) log = print;
}
