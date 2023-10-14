import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  const PageHeading({
    Key? key,
    required this.heading,
  }) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading.split(' ').first,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        const SizedBox(width: 4),
        Text(
          heading.split(' ').last,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
