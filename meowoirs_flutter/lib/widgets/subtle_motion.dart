import 'package:flutter/material.dart';

/// Provides a calm, page-turn like entrance animation:
/// - Fades from 0.0 to 1.0
/// - Translates vertically from 14dp to 0dp
/// - Runs for 300ms using Curves.fastOutSlowIn
/// - Respects system reduced motion setting
///
/// Direct parity with SubtleMotion.kt.
class SubtleContentEntrance extends StatefulWidget {
  const SubtleContentEntrance({
    super.key,
    required this.child,
    this.initialOffsetY = 14.0,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final double initialOffsetY;
  final Duration duration;

  @override
  State<SubtleContentEntrance> createState() => _SubtleContentEntranceState();
}

class _SubtleContentEntranceState extends State<SubtleContentEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.initialOffsetY),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));

    // Automatically trigger entrance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final disableAnimations =
            MediaQuery.of(context).disableAnimations;
        if (disableAnimations) {
          _controller.value = 1.0;
        } else {
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
