import 'dart:ui';

import 'package:flutter/material.dart';

class DrawPage extends StatefulWidget {
  //const DrawPage({ Key? key }) : super(key: key);

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final _offsets = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Draw Something'),
      // ),
      body: GestureDetector(
        onPanDown: (details) {
          // final renderObject = context.findRenderObject();
          // final renderBox = RenderBox(renderObject);
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          print(details.globalPosition);
          setState(() {
            _offsets.add(localPosition);
          });
        },
        onPanUpdate: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            _offsets.add(localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _offsets.add(null);
          });
        },
        child: Center(
          child: CustomPaint(
            painter: DrawBookPainter(_offsets),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //color: Colors.blue[50],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawBookPainter extends CustomPainter {
  final offsets;

  DrawBookPainter(this.offsets) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepOrange
      ..isAntiAlias = true
      ..strokeWidth = 3.0;
    print('hi');
    for (var i = 0; i < offsets.length; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(
          offsets[i],
          offsets[i + 1],
          paint,
        );
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(
          PointMode.points,
          [offsets[i]],
          paint,
        );
      }
    }
    // for (var offset in offsets) {
    //   print(offset);
    //   canvas.drawPoints(PointMode.points, [offset], paint);
    // }
  }

  // @override
  // SemanticsBuilderCallback get semanticsBuilder {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
