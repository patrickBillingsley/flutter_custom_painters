import 'dart:ui';

import 'package:flutter/material.dart';

class GlowRangeSliderThumbShape extends RangeSliderThumbShape {
  const GlowRangeSliderThumbShape({
    this.radius = 12,
    this.minGlowSigma = 2,
    this.maxGlowSigma = 10,
    this.glowColor = const Color(0xFFA7F5FB),
    this.strokeWidth = 2.0,
    this.strokeColor = const Color(0xFFA7F5FB),
  });

  /// Radius of the solid knob, in logical pixels.
  final double radius;

  /// Blur sigma applied to the glow when the thumb is at either edge.
  final double minGlowSigma;

  /// Blur sigma applied to the glow when the thumb is at the midpoint.
  final double maxGlowSigma;

  /// Color of the blur glow behind the knob.
  final Color glowColor;

  /// Width of the stroke drawn around the knob circumference.
  final double strokeWidth;

  /// Color of the stroke drawn around the knob circumference.
  final Color strokeColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius + maxGlowSigma * 2.75);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final canvas = context.canvas;

    // 0.0 at edges, 1.0 at center
    // final double glowFactor = 1.0 - (value - 0.5).abs() * 2;
    final double glowFactor = 1.0;
    final double sigma = lerpDouble(minGlowSigma, maxGlowSigma, glowFactor)!;

    canvas.drawCircle(
      center,
      radius + sigma * 0.5,
      Paint()
        ..color = glowColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma),
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = sliderTheme.thumbColor!
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }
}
