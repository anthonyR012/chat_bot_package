import 'package:flutter/material.dart';

/// A widget that displays a typing indicator.
/// Please provide a [customTypeIndicator] if you want to display a custom indicator.
class TypingIndicator extends StatefulWidget {
  /// You do not require a [styleTypeIndicator], but you can provide one to customize the indicator.
  const TypingIndicator({super.key, this.styleTypeIndicator});

  ///provide a [styleTypeIndicator] to customize the indicator
  final StyleTypeIndicator? styleTypeIndicator;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late final StyleTypeIndicator _styleTypeIndicator;

  @override
  void initState() {
    super.initState();
    _styleTypeIndicator = widget.styleTypeIndicator ?? StyleTypeIndicator();
    _animationController = AnimationController(
      vsync: this,
      duration: _styleTypeIndicator.animateDuration,
    )..repeat(reverse: _styleTypeIndicator.reverse);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: _styleTypeIndicator.curveDots,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: _styleTypeIndicator.paddingTyping,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: _styleTypeIndicator.backgroundColorIndicator ??
                Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dot(animation: _animation, delay: 0),
              const SizedBox(width: 4),
              Dot(animation: _animation, delay: 0.2),
              const SizedBox(width: 4),
              Dot(animation: _animation, delay: 0.4),
            ],
          ),
        ),
      ),
    );
  }
}

///Dot used in the indicator
class Dot extends StatelessWidget {
  ///Animate according to the delay
  final Animation<double> animation;

  ///Delay in the animation
  final double delay;

  ///Color of the dot
  final Color? dotColor;

  const Dot(
      {super.key, required this.animation, required this.delay, this.dotColor});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(delay, 1.0),
        ),
      ),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: dotColor ?? Colors.grey[800],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

///Modify the style of the indicator
class StyleTypeIndicator {
  ///The background color of the indicator
  final Color? backgroundColorIndicator;
  final Color? dotColor;

  ///The duration of the animation
  final Duration animateDuration;
  final bool reverse;
  final EdgeInsets paddingTyping;
  final Curve curveDots;

  /// Style of the indicator
  StyleTypeIndicator(
      {this.backgroundColorIndicator,
      this.dotColor,
      this.curveDots = Curves.easeInOut,
      this.animateDuration = const Duration(milliseconds: 1000),
      this.paddingTyping = const EdgeInsets.symmetric(vertical: 4.0),
      this.reverse = true});
}
