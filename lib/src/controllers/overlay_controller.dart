import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../types/qoverlay.dart';

class OverlaysController {
  final _requests = <_OverlayRequest>[];

  Future<T?> add<T>(OverlayState overlayState, QOverlayBase overlay) async {
    final request = _OverlayRequest<T>(overlay);
    _requests.add(request);
    overlayState.insertAll(request.overlayEntries());
    if (overlay.duration != null) {
      request.timer = Timer(overlay.duration!, () {
        _dismiss(request);
      });
    }
    return request.completer.future;
  }

  Future<T?> _dismiss<T>(_OverlayRequest<T?> request, {T? result}) async {
    if (await request.cleanup(result: result)) {
      _requests.remove(request);
    }

    return request.completer.future;
  }

  Future<T?> dismiss<T>(QOverlayBase overlay, {T? result}) => _dismiss<T>(
      _requests.firstWhere((element) => element.overlay == overlay)
          as _OverlayRequest<T?>,
      result: result);

  Future<T?> dismissName<T>(String name, {T? result}) => _dismiss<T>(
      _requests.firstWhere((element) => element.overlay.name == name)
          as _OverlayRequest<T?>,
      result: result);

  Future<T?> dismissLast<T>({T? result}) =>
      _dismiss<T>(_requests.last as _OverlayRequest<T?>, result: result);

  Future<void> dismissAll<T>({T? result, bool atSmaeTime = false}) async {
    for (var item in _requests.reversed.toList()) {
      if (atSmaeTime) {
        _dismiss(item, result: result);
      } else {
        await _dismiss(item, result: result);
      }
    }
  }
}

class _OverlayRequest<T> {
  final QOverlayBase overlay;
  final completer = Completer<T?>();
  bool mounted = true;
  Timer? timer;
  _OverlayRequest(this.overlay);

  final _overlayEntries = <OverlayEntry>[];

  List<OverlayEntry> overlayEntries() {
    _overlayEntries.clear();
    _overlayEntries.addAll(overlay.buildEntries());
    return _overlayEntries;
  }

  Future<bool> cleanup({T? result}) async {
    if (!mounted) {
      return true;
    }
    mounted = false;
    timer?.cancel();
    timer = null;
    if (overlay.actions.canClose != null) {
      final canClose = await overlay.actions.canClose!(result);
      if (!canClose) {
        return false;
      }
    }
    await overlay.overlayAnimation.reverse();
    if (overlay.actions.onClose != null) {
      result = await overlay.actions.onClose!(result);
    }

    for (var item in _overlayEntries) {
      item.remove();
    }
    _overlayEntries.clear();
    overlay.overlayAnimation.dispose();
    completer.complete(result);
    return true;
  }
}
