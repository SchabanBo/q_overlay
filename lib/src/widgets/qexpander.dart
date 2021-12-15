import 'dart:math';

import 'package:flutter/material.dart';

import '../../q_overlay.dart';
import '../types/animations/fade_animation.dart';
import '../types/animations/overlay_animation.dart';
import '../types/animations/scale_animation.dart';
import '../types/animations/slide_animation.dart';
import '../types/qoverlay.dart';
import 'filter_widget.dart';
import 'overlay_widget.dart';

class QExpander<T> extends StatefulWidget {
  /// the overlay alignment what will be matched with the parent alignment
  /// default is the center
  final Alignment alignment;

  /// The overlay position relative to the screen
  ///if this alignment is set the [alignment] will be ignored
  final Alignment? globalAlignment;

  /// The child widget which will be clicked to expand the overlay
  final Widget child;

  final Duration? duration;

  final Color? color;

  final String name;

  final QAnimation? animation;

  final BoxDecoration? backgroundDecoration;

  final EdgeInsets? margin;

  final FilterSettings? backgroundFilter;

  final OverlayActions actions;

  final Widget expandChild;

  final bool expanded;

  final Offset offset;

  final Function(T?)? onSelect;

  QExpander({
    required this.child,
    required this.expandChild,
    this.alignment = Alignment.center,
    this.globalAlignment,
    this.actions = const OverlayActions(),
    this.margin,
    this.color,
    this.backgroundFilter =
        const FilterSettings(blurX: 0, blurY: 0, dissmiseOnClick: true),
    this.animation,
    this.backgroundDecoration,
    this.duration,
    String? name,
    this.onSelect,
    this.expanded = false,
    this.offset = Offset.zero,
    Key? key,
  })  : name = name ?? 'Expander${child.hashCode}',
        super(key: key);

  @override
  _QExpanderState<T> createState() => _QExpanderState<T>();
}

class _QExpanderState<T> extends State<QExpander<T>> {
  final containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.expanded) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _onTap();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      key: containerKey,
      child: widget.child,
    );
  }

// Offset(offset.dx + size.width * 0.5, offset.dy + size.height * 0.5)
  void _onTap() {
    final renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero,
        ancestor: Navigator.of(context).context.findRenderObject());
    final size = renderBox.size;
    _QExpander(
      widget: widget,
      parentPosition: offset,
      parentSize: size,
      screenSize: MediaQuery.of(context).size,
    ).show<T>(context: containerKey.currentContext).then((value) {
      if (widget.onSelect != null) {
        widget.onSelect!(value);
      }
    });
  }
}

/// Show a window at any position on the screen.
class _QExpander with QOverlayBase {
  final QExpander widget;
  final Size parentSize;
  final Size screenSize;
  final Offset parentPosition;

  @override
  late final QAnimation animation;

  @override
  late final OverlayAnimation overlayAnimation;

  _QExpander({
    required this.widget,
    required this.parentSize,
    required this.parentPosition,
    required this.screenSize,
  });

  @override
  Future<T?> show<T>({BuildContext? context}) =>
      QOverlay.show(this, context: context);

  @override
  List<OverlayEntry> buildEntries() {
    animation = widget.animation ??
        QFadeAnimation(
          child: QScaleAnimation(
            child: QSlideAnimation(begin: _getBegin()),
          ),
        );

    return [
      if (widget.backgroundFilter != null)
        OverlayEntry(
          builder: (context) =>
              FilterWidget(this, widget.backgroundFilter!, animation),
          maintainState: false,
          opaque: false,
        ),
      OverlayEntry(
          builder: (context) => OverlayWidget(
                overlay: this,
                height: () => null,
                width: () => null,
                position: (s, _) =>
                    _calcPosition(MediaQuery.of(context).size, s),
              ))
    ];
  }

  Offset _calcPosition(Size screen, Size? size) {
    if (widget.globalAlignment != null) {
      return _getGlobalPosition(screen, size);
    }

    final alignment = widget.globalAlignment ?? widget.alignment;
    final position = alignment.withinRect(Rect.fromLTRB(
        parentPosition.dx,
        parentPosition.dy,
        parentPosition.dx + parentSize.width,
        parentPosition.dy + parentSize.height));

    size = size ?? Size(0, 0);
    final x = position.dx + (size.width * 0.5 * alignment.x - size.width * 0.5);
    final y =
        position.dy + (size.height * 0.5 * alignment.y - size.height * 0.5);

    final maxXPoint = screen.width - size.width * alignment.x;
    final maxYPoint = screen.height - size.height * alignment.x;
    return Offset(max(0, min(x, maxXPoint)), max(0, min(y, maxYPoint)));
  }

  Offset _getGlobalPosition(Size screen, Size? size) {
    size = size ?? Size(0, 0);
    final x =
        (screen.width / 2 + screen.width / 2 * widget.globalAlignment!.x) -
            (size.width * 0.5 + size.width * 0.5 * widget.globalAlignment!.x);
    final y =
        (screen.height / 2 + screen.height / 2 * widget.globalAlignment!.y) -
            (size.height * 0.5 + size.height * 0.5 * widget.globalAlignment!.y);
    return Offset(x, y);
  }

  Offset _getBegin() {
    final alignment = widget.globalAlignment ?? widget.alignment;
    var x = -alignment.x;
    var y = -alignment.y;

    return Offset(x, y);
  }

  @override
  OverlayActions get actions => widget.actions;

  @override
  BoxDecoration? get backgroundDecoration => widget.backgroundDecoration;

  @override
  Widget get child => widget.expandChild;

  @override
  Color? get color => widget.color;

  @override
  Duration? get duration => widget.duration;

  @override
  EdgeInsets? get margin => widget.margin;

  @override
  String get name => widget.name;
}
