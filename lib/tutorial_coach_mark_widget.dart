import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/content_target.dart';
import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/target_position.dart';
import 'package:tutorial_coach_mark/util.dart';

import 'target_focus.dart';

class TutorialCoachMarkWidget extends StatefulWidget {
  const TutorialCoachMarkWidget({
    Key key,
    this.targets,
    this.finish,
    this.paddingFocus = 10,
    this.clickTarget,
    this.alignSkip = Alignment.bottomRight,
    this.textSkip = "SKIP",
    this.clickSkip,
    this.colorShadow = Colors.black,
    this.opacityShadow = 0.8,
    this.textStyleSkip = const TextStyle(color: Colors.white),
    this.hideSkip,

    this.clickClose,
    this.alignClose = Alignment.bottomLeft,
    this.textClose = "CLOSE",
    this.textStyleClose = const TextStyle(color: Colors.white),
    this.hideClose
  }) : super(key: key);

  final List<TargetFocus> targets;
  final Function(TargetFocus) clickTarget;
  final Function() finish;
  final Color colorShadow;
  final double opacityShadow;
  final double paddingFocus;
  final Function(TargetFocus) clickSkip;
  final AlignmentGeometry alignSkip;
  final String textSkip;
  final TextStyle textStyleSkip;
  final bool hideSkip;


  final Function() clickClose;
  final AlignmentGeometry alignClose;
  final String textClose;
  final TextStyle textStyleClose;
  final bool hideClose;

  @override
  TutorialCoachMarkWidgetState createState() => TutorialCoachMarkWidgetState();
}

class TutorialCoachMarkWidgetState extends State<TutorialCoachMarkWidget> {
  final GlobalKey<AnimatedFocusLightState> _focusLightKey = GlobalKey();
  bool showContent = false;
  TargetFocus currentTarget;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          AnimatedFocusLight(
            key: _focusLightKey,
            targets: widget.targets,
            finish: widget.finish,
            paddingFocus: widget.paddingFocus,
            colorShadow: widget.colorShadow,
            opacityShadow: widget.opacityShadow,
            clickTarget: (target) {
              if (widget.clickTarget != null) widget.clickTarget(target);
            },
            focus: (target) {
              setState(() {
                currentTarget = target;
                showContent = true;
              });
            },
            removeFocus: () {
              setState(() {
                showContent = false;
              });
            },
          ),
          AnimatedOpacity(
            opacity: showContent ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: _buildContents(),
          ),
          _buildSkip(),
          _buildClose()
        ],
      ),
    );
  }

  Widget _buildContents() {
    if (currentTarget == null) {
      return SizedBox.shrink();
    }

    List<Widget> children = List();

    TargetPosition target = getTargetCurrent(currentTarget);

    var positioned = Offset(
      target.offset.dx + target.size.width / 2,
      target.offset.dy + target.size.height / 2,
    );

    double haloWidth;
    double haloHeight;

    if (currentTarget.shape == ShapeLightFocus.Circle) {
      haloWidth = target.size.width > target.size.height
          ? target.size.width
          : target.size.height;
      haloHeight = haloWidth;
    } else {
      haloWidth = target.size.width;
      haloHeight = target.size.height;
    }

    haloWidth = haloWidth * 0.6 + widget.paddingFocus;
    haloHeight = haloHeight * 0.6 + widget.paddingFocus;

    double weight = 0.0;
    double top;
    double bottom;
    double left;

    children = currentTarget.contents.map<Widget>((i) {
      switch (i.align) {
        case AlignContent.bottom:
          {
            weight = MediaQuery.of(context).size.width;
            left = 0;
            top = positioned.dy + haloHeight;
            bottom = null;
          }
          break;
        case AlignContent.top:
          {
            weight = MediaQuery.of(context).size.width;
            left = 0;
            top = null;
            bottom = haloHeight +
                (MediaQuery.of(context).size.height - positioned.dy);
          }
          break;
        case AlignContent.left:
          {
            weight = positioned.dx - haloWidth;
            left = 0;
            top = positioned.dy - target.size.height / 2 - haloHeight;
            bottom = null;
          }
          break;
        case AlignContent.right:
          {
            left = positioned.dx + haloWidth;
            top = positioned.dy - target.size.height / 2 - haloHeight;
            bottom = null;
            weight = MediaQuery.of(context).size.width - left;
          }
          break;
        case AlignContent.custom:
          {
            left = i.customPosition.left;
            top = i.customPosition.top;
            bottom = i.customPosition.bottom;
            weight = MediaQuery.of(context).size.width;
          }
          break;
      }

      return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        child: Container(
          width: weight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: i.child,
          ),
        ),
      );
    }).toList();

    return Stack(
      children: children,
    );
  }

  Widget _buildSkip() {
    if (widget.hideSkip) {
      return SizedBox.shrink();
    }
    return Align(
      alignment: widget.alignSkip,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: showContent ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: InkWell(
            onTap: () {
              widget.clickSkip(currentTarget);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.textSkip,
                style: widget.textStyleSkip,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClose() {
    if (widget.hideClose) {
      return SizedBox.shrink();
    }
    return Align(
      alignment: widget.alignClose,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: showContent ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: InkWell(
            onTap: widget.clickClose,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.textClose,
                style: widget.textStyleClose,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void next() => _focusLightKey?.currentState?.next();
  void skip() => _focusLightKey?.currentState?.skip();
  void previous() => _focusLightKey?.currentState?.previous();
}
