import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  bool isoutline = false;
  final Color col;
  final Color textcolor;
  final String text;
  Color? bordercolor;
  final double? texsize;
  double? height;
  double? width;

  MyButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.col,
      required this.textcolor,
      required this.isoutline,
      this.bordercolor,
      required this.height,
      required this.width,
      required this.texsize});

  @override
  Widget build(BuildContext context) {
    return isoutline
        ? GestureDetector(
            onTap: onPressed,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  boxShadow: isoutline
                      ? const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 0,
                            spreadRadius: 0,
                            offset: Offset(0, 2), // vertical shadow
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 5,
                            spreadRadius: 3,
                            offset: Offset(0, 2), // vertical shadow
                          ),
                        ],
                  borderRadius: BorderRadius.circular(10),
                  color: col),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textcolor,
                    fontFamily: "ansaf",
                    fontSize: texsize,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      isoutline
                          ? Shadow(
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 0.0,
                              color: Colors.black.withOpacity(0.5),
                            )
                          : Shadow(
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: onPressed,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(0, 2), // vertical shadow
                    ),
                  ],
                  border: Border.all(width: 1, color: bordercolor!),
                  borderRadius: BorderRadius.circular(10),
                  color: col),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textcolor,
                    fontFamily: "ansaf",
                    fontSize: texsize,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 1.0,
                          color: isoutline
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
