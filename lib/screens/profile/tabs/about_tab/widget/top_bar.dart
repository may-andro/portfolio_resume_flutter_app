import 'package:flutter/material.dart';

class AboutPageTopBar extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Positioned(
			top: 0,
			left: 0,
			right: 0,
			child: CustomPaint(
				child: Container(
					height: MediaQuery.of(context).size.height * 0.5,
				),
				painter: CurvesPainter(),
			),
		);
	}
}

class CurvesPainter extends CustomPainter {
	Color firstColor = Color(0xFF000000);
	Color secondColor = Color(0xFF000000).withOpacity(0.5);
	Color thirdColor = Color(0xFF000000).withOpacity(0.2);

	@override
	void paint(Canvas canvas, Size size) {
		Path path = Path();
		Paint paint = Paint();

		path.lineTo(0, size.height * 0.5);
		path.quadraticBezierTo(size.width * 0.10, size.height * 0.80, size.width * 0.15, size.height * 0.60);
		path.quadraticBezierTo(size.width * 0.20, size.height * 0.45, size.width * 0.27, size.height * 0.60);
		path.quadraticBezierTo(size.width * 0.45, size.height, size.width * 0.50, size.height * 0.80);
		path.quadraticBezierTo(size.width * 0.55, size.height * 0.45, size.width * 0.75, size.height * 0.75);
		path.quadraticBezierTo(size.width * 0.9, size.height * 0.93, size.width, size.height * 0.75);
		path.lineTo(size.width, 0);
		path.close();

		paint.color = firstColor;
		canvas.drawPath(path, paint);
	}

	@override
	bool shouldRepaint(CustomPainter oldDelegate) {
		return oldDelegate != this;
	}
}