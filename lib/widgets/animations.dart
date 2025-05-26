import 'package:flutter/material.dart';
import 'dart:math' show pi, min;
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

/// Animation utilities for the app.
/// Contains wrapper widgets and animation presets

/// Wrap any widget with this to add a fade-in animation
class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder<double>(
      delay: delay,
      duration: duration,
      tween: 0.0.tweenTo(1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Wrap any widget with this to add a slide animation from a direction
class SlideAnimation extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;
  final Curve curve;

  const SlideAnimation({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.beginOffset = const Offset(0.0, 50.0),
    this.curve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem đã chạy animation xong chưa để truyền sự kiện nhấp chuột
    if (delay == Duration.zero) {
      return Transform.translate(
        offset: Offset.zero,
        child: child,
      );
    }
    
    return PlayAnimationBuilder<Offset>(
      delay: delay,
      duration: duration,
      tween: beginOffset.tweenTo(Offset.zero),
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: FadeInAnimation(
        delay: delay,
        duration: duration,
        child: child,
      ),
    );
  }
}

/// Wrap a ListView with this for staggered animations
class AnimatedListView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final Axis scrollDirection;
  final int? staggerDelayMs;

  const AnimatedListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.staggerDelayMs = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      controller: controller,
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return SlideAnimation(
          delay: Duration(milliseconds: (staggerDelayMs ?? 50) * index),
          beginOffset: const Offset(0, 50),
          child: FadeInAnimation(
            delay: Duration(milliseconds: (staggerDelayMs ?? 50) * index),
            child: itemBuilder(context, index),
          ),
        );
      },
    );
  }
}

/// Pulse animation for buttons or attention-grabbing elements
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool infinite;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.infinite = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _animation = Tween<double>(begin: 1.0, end: 1.1)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    if (widget.infinite) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Flip animation for card-like elements
class FlipAnimation extends StatelessWidget {
  final Widget front;
  final Widget back;
  final bool showFront;
  final Duration duration;
  final Axis direction;

  const FlipAnimation({
    super.key,
    required this.front,
    required this.back,
    required this.showFront,
    this.duration = const Duration(milliseconds: 500),
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final rotateAnimation = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotateAnimation,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(showFront) != child?.key);
            var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
            tilt *= isUnder ? -1.0 : 1.0;
            final value = isUnder ? min(rotateAnimation.value, pi/2) : rotateAnimation.value;
            return Transform(
              transform: direction == Axis.horizontal
                ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
                : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      switchInCurve: Curves.easeInBack,
      switchOutCurve: Curves.easeOutBack.flipped,
      child: showFront 
        ? KeyedSubtree(key: const ValueKey(true), child: front)
        : KeyedSubtree(key: const ValueKey(false), child: back),
    );
  }
} 