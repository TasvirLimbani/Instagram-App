import 'package:flutter/material.dart';

class Heartanimating extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final bool alwaysAnimated;
  final Duration duration;
  final VoidCallback? onEnd;
  Heartanimating(
      {Key? key,
      required this.child,
      required this.isAnimating,
      this.alwaysAnimated = false,
      this.duration = const Duration(milliseconds: 150),
      this.onEnd})
      : super(key: key);

  @override
  State<Heartanimating> createState() => _HeartanimatingState();
}

class _HeartanimatingState extends State<Heartanimating>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: halfDuration));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant Heartanimating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  Future doAnimation() async {
    if (widget.isAnimating || widget.alwaysAnimated) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(Duration(milliseconds: 400));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
        scale: scale,
        child: widget.child,
      );
}