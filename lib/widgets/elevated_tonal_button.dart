import 'package:flutter/material.dart';

class ElevatedTonalButton extends StatelessWidget {
  final MaterialStateProperty<Color?>? backgroundColor;
  final MaterialStateProperty<Color?>? foregroundColor;
  final MaterialStateProperty<double?>? elevation;
  final MaterialStateProperty<Color?>? shadowColor;
  final VoidCallback onPressed;
  final String text;
  final Icon icon;

  const ElevatedTonalButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      style: ButtonStyle(
        backgroundColor:
            backgroundColor ?? MaterialStateProperty.all(Colors.blue[50]),
        foregroundColor:
            foregroundColor ?? MaterialStateProperty.all(Colors.blue[900]),
        elevation: elevation ?? MaterialStateProperty.all(1.5),
        shadowColor: shadowColor ?? MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onPressed: onPressed,
      icon: icon,
      label: Text(text),
    );
  }
}
