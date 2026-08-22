import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double? width;
  final double? height;

  const AnimatedButton({
    required this.onPressed,
    required this.child,
    this.color,
    this.width,
    this.height,
    super.key,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.durationFast,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool isSecondary = widget.color != null && 
        (widget.color == Colors.grey || 
         widget.color!.a < 1.0 || 
         widget.color == Colors.white10 || 
         widget.color == Colors.black12);
        
    final bool isDanger = widget.color != null && 
        (widget.color == Colors.redAccent || 
         widget.color == Colors.red);

    BoxDecoration decoration;
    TextStyle textStyle;

    if (isSecondary) {
      decoration = BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        ),
      );
      textStyle = TextStyle(
        color: isDark ? Colors.redAccent.shade100 : Colors.red.shade700,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
    } else if (isDanger) {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF43F5E), // rose-500
            Color(0xFFE11D48), // rose-600
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF43F5E).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );
      textStyle = const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
    } else {
      decoration = BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D9488), // teal-600
            Color(0xFF14B8A6), // teal-500
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14B8A6).withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      );
      textStyle = const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height ?? 52,
          alignment: Alignment.center,
          decoration: decoration,
          child: DefaultTextStyle(
            style: textStyle,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
