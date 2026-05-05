import 'package:flutter/material.dart';

class GlowSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const GlowSliderTrackShape({
    this.segments,
  });

  final int? segments;

  @override
  bool get isRounded => true;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final (Paint leftTrackPaint, Paint rightTrackPaint) = switch (textDirection) {
      TextDirection.ltr => (activePaint, inactivePaint),
      TextDirection.rtl => (inactivePaint, activePaint),
    };

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);
    final isLTR = textDirection == TextDirection.ltr;
    final isRTL = textDirection == TextDirection.rtl;

    final layerRect = trackRect.inflate(additionalActiveTrackHeight);
    context.canvas.saveLayer(layerRect, Paint());
    try {
      final bool drawInactiveTrack = thumbCenter.dx < (trackRect.right - (sliderTheme.trackHeight! / 2));
      if (drawInactiveTrack) {
        // Draw the inactive track segment.
        context.canvas.drawRRect(
          RRect.fromLTRBR(
            thumbCenter.dx - (sliderTheme.trackHeight! / 2),
            isRTL ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
            trackRect.right,
            isRTL ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
            isLTR ? trackRadius : activeTrackRadius,
          ),
          rightTrackPaint,
        );
      }

      final bool drawActiveTrack = thumbCenter.dx > (trackRect.left + (sliderTheme.trackHeight! / 2));
      if (drawActiveTrack) {
        // Draw the active track segment.
        context.canvas.drawRRect(
          RRect.fromLTRBR(
            trackRect.left,
            isLTR ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
            thumbCenter.dx + (sliderTheme.trackHeight! / 2),
            isLTR ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
            isLTR ? activeTrackRadius : trackRadius,
          ),
          leftTrackPaint,
        );
      }

      if (segments != null) {
        final gapPaint = Paint()..blendMode = BlendMode.clear;
        for (var i = 1; i < segments!; i++) {
          final x = trackRect.left + trackRect.width * (i / segments!);
          context.canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, trackRect.center.dy),
              width: sliderTheme.trackGap ?? 6,
              height: layerRect.height,
            ),
            gapPaint,
          );
        }
      }
    } finally {
      context.canvas.restore();
    }

    final bool showSecondaryTrack =
        (secondaryOffset != null) &&
        (isLTR ? (secondaryOffset.dx > thumbCenter.dx) : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final secondaryTrackColorTween = ColorTween(
        begin: sliderTheme.disabledSecondaryActiveTrackColor,
        end: sliderTheme.secondaryActiveTrackColor,
      );
      final secondaryTrackPaint = Paint()..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (isLTR) {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            secondaryOffset.dx,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          secondaryTrackPaint,
        );
      }
    }
  }
}
