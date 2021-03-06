library tutorial_coach_mark;

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark_widget.dart';

export 'package:tutorial_coach_mark/content_target.dart';
export 'package:tutorial_coach_mark/target_focus.dart';

class TutorialCoachMark {
  final BuildContext _context;
  final List<TargetFocus> targets;
  final Function(TargetFocus) onClickTarget;
  final Function() onFinish;
  final double paddingFocus;
  final Function(TargetFocus) onClickSkip;
  final AlignmentGeometry alignSkip;
  final String textSkip;
  final TextStyle textStyleSkip;
  final bool hideSkip;

  final Function() onClickClose;
  final AlignmentGeometry alignClose;
  final String textClose;
  final TextStyle textStyleClose;
  final bool hideClose;

  final Color colorShadow;
  final double opacityShadow;
  final GlobalKey<TutorialCoachMarkWidgetState> _widgetKey = GlobalKey();

  OverlayEntry _overlayEntry;

  TutorialCoachMark(
    this._context, {
    this.targets,
    this.colorShadow = Colors.black,
    this.onClickTarget,
    this.onFinish,
    this.paddingFocus = 10,
    this.onClickSkip,
    this.alignSkip = Alignment.bottomRight,
    this.textSkip = "SKIP",
    this.textStyleSkip = const TextStyle(color: Colors.white),
    this.hideSkip = false,
    this.opacityShadow = 0.8,
    this.onClickClose,
    this.alignClose = Alignment.bottomLeft,
    this.textClose = "CLOSE",
    this.textStyleClose = const TextStyle(color: Colors.white),
    this.hideClose = false,
  }) : assert(targets != null, opacityShadow >= 0 && opacityShadow <= 1);

  OverlayEntry _buildOverlay() {
    return OverlayEntry(builder: (context) {
      return TutorialCoachMarkWidget(
        key: _widgetKey,
        targets: targets,
        clickTarget: onClickTarget,
        paddingFocus: paddingFocus,
        clickSkip: skip,
        alignSkip: alignSkip,
        textSkip: textSkip,
        textStyleSkip: textStyleSkip,
        hideSkip: hideSkip,

        clickClose: close,
        alignClose: alignClose,
        textClose: textClose,
        textStyleClose: textStyleClose,
        hideClose: hideClose,

        colorShadow: colorShadow,
        opacityShadow: opacityShadow,
        finish: finish,
      );
    });
  }

  void show() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlay();
      Overlay.of(_context).insert(_overlayEntry);
    }
  }

  void finish() {
    if (onFinish != null) onFinish();
    _removeOverlay();
  }

  void skip(TargetFocus currentTargetFocus) {
    if (onClickSkip != null) onClickSkip(currentTargetFocus);
    _widgetKey?.currentState?.skip();
  }

  void close() {
    if (onClickClose != null) onClickClose();
    _removeOverlay();
  }

  void next() => _widgetKey?.currentState?.next();

  void previous() => _widgetKey?.currentState?.previous();

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
