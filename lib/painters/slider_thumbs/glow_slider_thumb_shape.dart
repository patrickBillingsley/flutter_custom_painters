import 'dart:ui';

import 'package:flutter/material.dart';

/// A circular slider thumb that renders a Gaussian blur glow behind the knob.
///
/// The glow intensity varies with the thumb's position along the track: it is
/// weakest at both edges ([minGlowSigma]) and brightest at the midpoint
/// ([maxGlowSigma]). This creates a visual cue that draws the eye toward the
/// center of the range.
class GlowSliderThumbShape extends SliderComponentShape {
  const GlowSliderThumbShape({
    this.radius = 12,
    this.minGlowSigma = 2,
    this.maxGlowSigma = 10,
    this.maxAtCenter = true,
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

  final bool maxAtCenter;

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
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // 0.0 at edges, 1.0 at center
    final double glowFactor = 1.0 - (value - 0.5).abs() * 2;
    final double sigma = lerpDouble(
      minGlowSigma,
      maxGlowSigma,
      maxAtCenter ? glowFactor : value,
    )!;

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
