import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color color;
  final double elevation;
  final VoidCallback? onTap;
  final bool hasBorder;
  final Color borderColor;
  
  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16.0,
    this.color = Colors.white,
    this.elevation = 2.0,
    this.onTap,
    this.hasBorder = false,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final adjustedElevation = elevation / devicePixelRatio.clamp(1.0, 3.0);
    
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: adjustedElevation,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: hasBorder ? Border.all(
              color: borderColor,
              width: 1.5 / devicePixelRatio.clamp(1.0, 2.0),
            ) : null,
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
} 