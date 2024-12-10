import 'package:flutter/material.dart';
import 'package:When_to_do/Items/GradientText.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      backgroundColor: const Color(0xFF000000),
      elevation: 6,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientText(
            "When ",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
            gradient:
                LinearGradient(colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)]),
          ),
          Text(
            "To-Do",
            style: TextStyle(
              color: const Color.fromARGB(255, 224, 224, 224),
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
