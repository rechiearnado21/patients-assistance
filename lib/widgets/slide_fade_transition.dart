import 'dart:async';

import 'package:flutter/material.dart';

class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset? begin;
  final Offset? end;
  const SlideFadeTransition(
      {super.key,
      required this.child,
      required this.duration,
      this.begin,
      this.end});

  @override
  State<SlideFadeTransition> createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    Timer(const Duration(milliseconds: 200),
        () => _animationController!.forward());
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
              begin: widget.begin ?? const Offset(-1, 0),
              end: widget.end ?? Offset.zero)
          .animate(_animationController!),
      child:
          FadeTransition(opacity: _animationController!, child: widget.child),
    );
  }
}
