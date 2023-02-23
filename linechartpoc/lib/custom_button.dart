import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

typedef voidFunction = void Function();

enum TabButton { click, unclick }

class CustomButton extends StatefulWidget {
  final String buttonTitle;
  final voidFunction ontap;
  final bool buttonStatus;

  const CustomButton(
      {super.key,
      required this.buttonStatus,
      required this.buttonTitle,
      required this.ontap});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor =
        widget.buttonStatus == true ? Colors.green : Colors.white;
    Color textColor = widget.buttonStatus == true
        ? Colors.white
        : const Color.fromARGB(255, 3, 31, 24);
    Color borderColor = widget.buttonStatus == true
        ? const Color.fromARGB(255, 10, 147, 112)
        : Colors.white;

    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(6.0),
          color: buttonColor,
        ),
        height: 50.0,
        width: 50,
        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
        child: Center(
          child: Text(
            widget.buttonTitle,
            style: TextStyle(color: textColor, fontSize: 13.0),
          ),
        ),
      ),
    );
  }
}
