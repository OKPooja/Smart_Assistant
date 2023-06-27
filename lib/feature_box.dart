import 'package:flutter/material.dart';
import 'package:voice_assistant_app/pallet.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String description;
  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
        decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular((5)).copyWith(
              // topLeft: Radius.zero,
              // bottomRight: Radius.zero,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: const TextStyle(
                  color: Pallete.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 13,),
          Padding(padding: const EdgeInsets.only(right: 15),
          child: Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Pallete.blackColor,
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
