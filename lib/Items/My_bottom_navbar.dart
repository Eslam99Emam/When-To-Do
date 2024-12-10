import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:When_to_do/providers.dart';

class My_Bottom_navbar extends StatefulWidget {
  int index;

  My_Bottom_navbar({super.key, required this.index});

  @override
  State<My_Bottom_navbar> createState() => _My_Bottom_navbarState();
}

class _My_Bottom_navbarState extends State<My_Bottom_navbar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PageControl>(
      builder: (context, value, child) {
        return CrystalNavigationBar(
          marginR: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          paddingR: EdgeInsets.fromLTRB(16, 10, 16, 10),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          backgroundColor: Colors.black.withOpacity(0.6),
          currentIndex: widget.index,
          onTap: (i) {
            if (i == widget.index) {
              return;
            } else {
              value.set_pageController(i);
              widget.index = i;
            }
          },
          items: [
            CrystalNavigationBarItem(
              icon: Icons.home,
              unselectedIcon: Icons.home_outlined,
              selectedColor: Colors.amber,
              unselectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: Icons.calendar_month_sharp,
              unselectedIcon: Icons.calendar_month_outlined,
              selectedColor: Colors.amber,
              unselectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: Icons.add_circle,
              selectedColor: Colors.blue.shade500,
              unselectedColor: Colors.purple.shade300,
            ),
            CrystalNavigationBarItem(
              icon: Icons.view_week,
              unselectedIcon: Icons.view_week_outlined,
              selectedColor: Colors.amber,
              unselectedColor: Colors.white,
            ),
            CrystalNavigationBarItem(
              icon: Icons.person,
              unselectedIcon: Icons.person_outline,
              selectedColor: Colors.amber,
              unselectedColor: Colors.white,
            ),
          ],
        );
      },
    );
  }
}
