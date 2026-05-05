import 'package:flutter/material.dart';

class GlowSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const GlowSliderTrackShape({
    this.divisions,
  });

  final int? divisions;

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
    final Canvas canvas = context.canvas;
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

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular(
      (trackRect.height + additionalActiveTrackHeight) / 2,
    );

    final trackHeight = sliderTheme.trackHeight ?? 1;
    final trackGap = sliderTheme.trackGap ?? 6;

    final layerRect = trackRect.inflate(additionalActiveTrackHeight);
    canvas.saveLayer(layerRect, Paint());
    try {
      final bool drawInactiveTrack = thumbCenter.dx < (trackRect.right - (trackGap / 2));
      if (drawInactiveTrack) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            thumbCenter.dx - (trackHeight / 2),
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
            trackRadius,
          ),
          inactivePaint,
        );
      }

      final bool drawActiveTrack = thumbCenter.dx > (trackRect.left + (trackGap / 2));
      if (drawActiveTrack) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            trackRect.left,
            trackRect.top - (additionalActiveTrackHeight / 2),
            thumbCenter.dx + (trackHeight / 2),
            trackRect.bottom + (additionalActiveTrackHeight / 2),
            activeTrackRadius,
          ),
          activePaint,
        );
      }

      if (isDiscrete && divisions != null) {
        final gapPaint = Paint()..blendMode = BlendMode.clear;
        for (var i = 1; i < divisions!; i++) {
          final x = trackRect.left + trackRect.width * (i / divisions!);
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset(x, trackRect.center.dy),
              width: trackGap,
              height: layerRect.height,
            ),
            gapPaint,
          );
        }
      }
    } finally {
      canvas.restore();
    }
  }
}
