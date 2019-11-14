import 'package:flutter/material.dart';

class FluidTopBar extends StatelessWidget {
  final Widget child;

  FluidTopBar({this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      painter: CurvesPainter(),
    );
  }
}

class CurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.35, size.width * 0.20, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.33, size.height * 0.90, size.width * 0.38, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.44, size.height * 0.5, size.width * 0.5, size.height * 0.58);
    path.quadraticBezierTo(size.width * 0.53, size.height * 0.62, size.width * 0.58, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.86, size.width * 0.66, size.height * 0.78);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width * 0.88, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.93, size.height * 1.0, size.width, size.height * 1.0);
    path.lineTo(size.width, 0);
    path.close();

    var gradient = LinearGradient(
      colors: [Colors.black, Colors.black87],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    paint
      ..shader = gradient.createShader(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
