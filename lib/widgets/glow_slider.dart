import 'package:custom_painters/painters/slider_thumbs/glow_slider_thumb_shape.dart';
import 'package:custom_painters/painters/slider_tracks/glow_slider_track_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class GlowSlider extends StatefulWidget {
  @Preview(name: 'GlowSlider')
  const GlowSlider({super.key, this.maxGlowAtCenter = true}) : segments = null, divideOnSegments = false;

  @Preview(name: 'Segmented GlowSlider')
  const GlowSlider.segmented({
    super.key,
    this.segments = 10,
    this.maxGlowAtCenter = false,
    this.divideOnSegments = true,
  });

  final int? segments;
  final bool maxGlowAtCenter;
  final bool divideOnSegments;

  @override
  State<GlowSlider> createState() => _GlowSliderState();
}

class _GlowSliderState extends State<GlowSlider> {
  double _value = 0.5;

  void _setValue(double value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        sliderTheme: Theme.of(context).sliderTheme.copyWith(
          thumbShape: GlowSliderThumbShape(maxAtCenter: widget.maxGlowAtCenter),
          thumbColor: Theme.of(context).scaffoldBackgroundColor,
          trackShape: GlowSliderTrackShape(segments: widget.segments),
          activeTrackColor: const Color(0xFFA7F5FB),
          inactiveTrackColor: const Color(0xFF1D766E),
          overlayColor: const Color(0xFFA7F5FB).withValues(alpha: 0.05),
          inactiveTickMarkColor: Colors.transparent,
          activeTickMarkColor: Colors.transparent,
        ),
      ),
      child: Slider(
        onChanged: _setValue,
        value: _value,
        divisions: widget.divideOnSegments ? widget.segments : null,
      ),
    );
  }
}
