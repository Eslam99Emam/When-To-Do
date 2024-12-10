import 'package:When_to_do/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:When_to_do/Items/My_appbar.dart';
import 'package:When_to_do/Items/My_bottom_navbar.dart';
import 'package:When_to_do/screens/All.dart';
import 'package:When_to_do/screens/add_task.dart';
import 'package:When_to_do/screens/calendar.dart';
import 'package:When_to_do/screens/profile.dart';
import 'package:When_to_do/screens/weekly.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color theme = Colors.white;

  @override
  Widget build(BuildContext context) {
    try {
      return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Our_Date(),
          ),
          ChangeNotifierProvider(
            create: (context) => PageControl(),
          ),
          ChangeNotifierProvider(
            create: (context) => Our_TaskTime(),
          ),
          ChangeNotifierProvider(
            create: (context) => Tasks(),
          ),
          ChangeNotifierProvider(
            create: (context) => My_User(),
          ),
        ],
        child: Consumer<Tasks>(
          builder: (context, value, child) {
            return Consumer<PageControl>(
              builder: (context, value, child) {
                return Scaffold(
                  backgroundColor: theme,
                  extendBody: true,
                  appBar: CustomAppBar().build(context),
                  body: PageView(
                    controller: context.watch<PageControl>().get_pageController,
                    onPageChanged: (i) {
                      value.set_index(i);
                    },
                    children: [
                      All_Tasks(),
                      Calendar_Page(),
                      Add_Task(),
                      Weekly_page(),
                      Profile_Page()
                    ],
                  ),
                  bottomNavigationBar: My_Bottom_navbar(
                      index: context.watch<PageControl>().get_current),
                );
              },
            );
          },
        ),
      ),
    );
    } catch (e) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
