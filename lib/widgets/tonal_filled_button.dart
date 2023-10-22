import 'package:flutter/material.dart';

class TonalFilledButton extends StatelessWidget {
  const TonalFilledButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.lightBlue[50]),
        foregroundColor: MaterialStateProperty.all(Colors.lightBlueAccent[700]),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}
