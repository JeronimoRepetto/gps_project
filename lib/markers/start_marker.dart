import 'package:flutter/material.dart';

class StartMarker extends CustomPainter {
  final int minutes;
  final String destination;

  StartMarker({required this.minutes, required this.destination});
  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;
    final withePaint = Paint()..color = Colors.white;
    const double circleBlackRadius = 20;
    const double circleWhiteRadius = 7;
    canvas.drawCircle(
        Offset(circleBlackRadius, size.height - circleBlackRadius),
        circleBlackRadius,
        blackPaint);
    canvas.drawCircle(
        Offset(circleBlackRadius, size.height - circleBlackRadius),
        circleWhiteRadius,
        withePaint);

    //White box
    final path = Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    //shadow
    canvas.drawShadow(path, Colors.black, 10, false);
    //drawing box
    canvas.drawPath(path, withePaint);

    const blackBoxRect = Rect.fromLTWH(40, 20, 70, 80);
    //BlackBox
    canvas.drawRect(blackBoxRect, blackPaint);

    //Texts
    //Minutes

    final textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
        text: "$minutes");

    final minutesPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);

    minutesPainter.paint(canvas, const Offset(40, 35));

    const minuteTextSpan = TextSpan(
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
        text: "Min");

    final minutesMinPainter = TextPainter(
      text: minuteTextSpan,
      maxLines: 1,
      ellipsis: "...",
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);
    minutesMinPainter.paint(canvas, const Offset(40, 68));

    //DESCRIPTION
    final locationTextSpan = TextSpan(
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
        text: destination);

    final locationPainter = TextPainter(
      text: locationTextSpan,
      maxLines: 3,
      ellipsis: '...',
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: size.width - 135, minWidth: size.width - 135);
    final double offsetY = (destination.length > 20) ? 35 : 48;
    locationPainter.paint(canvas, Offset(120, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
