import 'package:animated_mesh_gradient/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

class AnimatedBox extends StatefulWidget {
  const AnimatedBox({
    super.key,
    required this.width,
    required this.height,
    this.compute,
    this.isInitiallyVisible = false,
    this.child,
  });

  final double width;
  final double height;
  final Future Function()? compute;
  final bool isInitiallyVisible;
  final Widget? child;

  @override
  State<AnimatedBox> createState() => _AnimatedBoxState();
}

class _AnimatedBoxState extends State<AnimatedBox> {
  late double currentHeight;
  late double currentWidth;

  @override
  void initState() {
    currentHeight = widget.isInitiallyVisible ? widget.height : 0;
    currentWidth = widget.width;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.child != null ? currentHeight = widget.height : currentHeight = 0;
    return Material(
      color: Colors.transparent,
      child: AnimatedOpacity(
        duration: 600.millis,
        curve: Curves.easeOut,
        opacity: widget.child != null ? 1 : 0,
        child: AnimatedContainer(
          duration: 600.millis,
          curve: widget.child == null
              ? Curves.easeInOut
              : Sprung.custom(
                  damping: 30,
                  stiffness: 200,
                  mass: 1.0,
                  velocity: 0.2,
                ),
          height: currentHeight,
          width: currentWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
