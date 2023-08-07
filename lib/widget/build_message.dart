import 'package:beat_jerky/widget/reusable_text.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../utils/color.dart';

class BuildMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  const BuildMessage({
    super.key, required this.message, required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            decoration: isMe ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:  const GradientBoxBorder(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                    indigoColor,
                    pinkColor,
                  ],
                ),
              ),
            ) : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: pinkColor,
            ),
            child: ReusableText(
              title: message,size: 18,color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}