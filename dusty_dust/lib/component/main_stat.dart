import 'package:flutter/material.dart';

class MainStat extends StatelessWidget {
  final String category;
  final String imgPath;
  final String level;
  final String stat;
  final double width;

  const MainStat({
    required this.category,
    required this.imgPath,
    required this.level,
    required this.stat,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(
      color: Colors.black,
    );

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: ts,
          ),
          const SizedBox(
            height: 8,
          ),
          Image.asset(
            imgPath,
            width: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            level,
            style: ts,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            stat,
            style: ts,
          ),
        ],
      ),
    );
  }
}
