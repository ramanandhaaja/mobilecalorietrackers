import 'package:flutter/material.dart';

/// A custom clipper that creates a single curved wave shape.
/// Often used for decorative backgrounds or header elements.
class CurvedWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8); // Start the curve below the top left

    // First control point and end point for the curve
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    // Second control point and end point for the curve
    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height * 0.8); // Line to the top right start
    path.lineTo(size.width, 0); // Line back to the top right
    path.close(); // Close the path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false; // No need to reclip unless parameters change
}

/// An alternative wave clipper with a slightly different curve.
class AltCurvedWaveClipper extends CustomClipper<Path> {
 @override
 Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75); // Start lower

    // Define control points for a smoother, wider wave
    var controlPoint1 = Offset(size.width * 0.25, size.height * 0.9);
    var endPoint1 = Offset(size.width * 0.5, size.height * 0.7);
    var controlPoint2 = Offset(size.width * 0.75, size.height * 0.5);
    var endPoint2 = Offset(size.width, size.height * 0.65);

    // Create a cubic bezier curve for a more complex wave shape
    path.cubicTo(controlPoint1.dx, controlPoint1.dy,
                 controlPoint2.dx, controlPoint2.dy,
                 endPoint1.dx, endPoint1.dy);

     // Adding another segment for variation, could use quadratic or cubic
     var controlPoint3 = Offset(size.width * 0.75, size.height * 0.9); // Adjust as needed
     var endPoint3 = Offset(size.width, size.height * 0.8); // End near the right edge

     path.quadraticBezierTo(controlPoint3.dx, controlPoint3.dy, endPoint3.dx, endPoint3.dy);


    path.lineTo(size.width, 0); // Line to top-right
    path.close(); // Close the path
    return path;
 }

 @override
 bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
