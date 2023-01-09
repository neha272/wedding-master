import 'package:flutter/material.dart';

class MyCustomIndicator extends Decoration {
  final BoxPainter _painter;

  MyCustomIndicator({required Color color, required double height})
      : _painter = _IndicatorPainter(height, color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _IndicatorPainter extends BoxPainter {
  final Paint _paint;
  final double height;
  final Color color;

  _IndicatorPainter(this.height, this.color) : _paint = Paint()..shader;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect rect = (offset + Offset(0, cfg.size!.height - height) &
        Size(cfg.size!.width, height));

    canvas.drawRRect(
      RRect.fromRectAndCorners(rect),
      _paint
        ..shader = RadialGradient(
          radius: 12,
          colors: [color, Colors.transparent],
        ).createShader(rect),
    );
  }
}
