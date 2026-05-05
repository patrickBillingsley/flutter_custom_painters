import 'package:flutter/material.dart';

class GlowRangeSliderTrackShape extends RangeSliderTrackShape with BaseRangeSliderTrackShape {
  const GlowRangeSliderTrackShape({
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
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
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

    final (Offset leftThumbOffset, Offset rightThumbOffset) = switch (textDirection) {
      TextDirection.ltr => (startThumbCenter, endThumbCenter),
      TextDirection.rtl => (endThumbCenter, startThumbCenter),
    };
    final Size thumbSize = sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete);
    final double thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final trackRadius = Radius.circular(trackRect.height / 2);

    final layerRect = trackRect.inflate(additionalActiveTrackHeight);
    context.canvas.saveLayer(layerRect, Paint());
    try {
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          trackRect.left,
          trackRect.top,
          leftThumbOffset.dx,
          trackRect.bottom,
          topLeft: trackRadius,
          bottomLeft: trackRadius,
        ),
        inactivePaint,
      );
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          rightThumbOffset.dx,
          trackRect.top,
          trackRect.right,
          trackRect.bottom,
          topRight: trackRadius,
          bottomRight: trackRadius,
        ),
        inactivePaint,
      );
      context.canvas.drawRRect(
        RRect.fromLTRBR(
          leftThumbOffset.dx - (sliderTheme.trackHeight! / 2),
          trackRect.top - (additionalActiveTrackHeight / 2),
          rightThumbOffset.dx + (sliderTheme.trackHeight! / 2),
          trackRect.bottom + (additionalActiveTrackHeight / 2),
          trackRadius,
        ),
        activePaint,
      );

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
  }
}
