import 'package:custom_painters/painters/slider_thumbs/glow_range_slider_thumb_shape.dart';
import 'package:custom_painters/painters/slider_tracks/glow_range_slider_track_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class GlowRangeSlider extends StatefulWidget {
  @Preview(name: 'GlowRangeSlider')
  const GlowRangeSlider({super.key}) : divisions = null;

  @Preview(name: 'Segmented GlowRangeSlider')
  const GlowRangeSlider.segmented({super.key, this.divisions = 10});

  final int? divisions;

  @override
  State<GlowRangeSlider> createState() => _GlowRangeSliderState();
}

class _GlowRangeSliderState extends State<GlowRangeSlider> {
  RangeValues _range = RangeValues(0, 1);

  void _setRange(RangeValues range) {
    setState(() {
      _range = range;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        sliderTheme: Theme.of(context).sliderTheme.copyWith(
          rangeThumbShape: GlowRangeSliderThumbShape(),
          thumbColor: Theme.of(context).scaffoldBackgroundColor,
          rangeTrackShape: GlowRangeSliderTrackShape(divisions: widget.divisions),
          activeTrackColor: const Color(0xFFA7F5FB),
          inactiveTrackColor: const Color(0xFF1D766E),
          overlayColor: const Color(0xFFA7F5FB).withValues(alpha: 0.05),
          inactiveTickMarkColor: Colors.transparent,
          activeTickMarkColor: Colors.transparent,
        ),
      ),
      child: RangeSlider(
        onChanged: _setRange,
        values: _range,
        divisions: widget.divisions,
      ),
    );
  }
}
