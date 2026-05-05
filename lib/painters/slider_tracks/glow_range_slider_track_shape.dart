import 'package:flutter/material.dart';

class GlowRangeSliderTrackShape extends RangeSliderTrackShape with BaseSliderTrackShape {
  const GlowRangeSliderTrackShape({
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
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    final Canvas canvas = context.canvas;
    final activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final inactivePaint = Paint()..color = sliderTheme.inactiveTrackColor!;

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

    // Resolve left/right thumb positions so RTL is handled correctly.
    final leftThumbCenter = textDirection == TextDirection.ltr ? startThumbCenter : endThumbCenter;
    final rightThumbCenter = textDirection == TextDirection.ltr ? endThumbCenter : startThumbCenter;

    final layerRect = trackRect.inflate(additionalActiveTrackHeight);
    canvas.saveLayer(layerRect, Paint());
    try {
      // Left inactive segment (track start → left thumb).
      if (leftThumbCenter.dx > trackRect.left + (trackGap / 2)) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            trackRect.left,
            trackRect.top,
            leftThumbCenter.dx + (trackHeight / 2),
            trackRect.bottom,
            trackRadius,
          ),
          inactivePaint,
        );
      }

      // Right inactive segment (right thumb → track end).
      if (rightThumbCenter.dx < trackRect.right - (trackGap / 2)) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            rightThumbCenter.dx - (trackHeight / 2),
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
            trackRadius,
          ),
          inactivePaint,
        );
      }

      // Active segment (between thumbs, drawn on top and taller for the glow).
      if (rightThumbCenter.dx - leftThumbCenter.dx > trackGap) {
        canvas.drawRRect(
          RRect.fromLTRBR(
            leftThumbCenter.dx - (trackHeight / 2),
            trackRect.top - (additionalActiveTrackHeight / 2),
            rightThumbCenter.dx + (trackHeight / 2),
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
