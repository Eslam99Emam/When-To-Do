import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import 'package:When_to_do/Items/TaskTile.dart';
import 'package:When_to_do/functions.dart';
import 'package:When_to_do/providers.dart';

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({super.key});

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<Our_Date>(
              builder: (context, value, child) {
                return CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    firstDate: DateTime.now(),
                    dayBuilder: (
                        {required date,
                        decoration,
                        isDisabled,
                        isSelected,
                        isToday,
                        textStyle}) {
                      // Custom day widget
                      return Container(
                        decoration: BoxDecoration(
                          gradient: isSelected ?? false
                              ? LinearGradient(
                                  colors: [Colors.blue, Colors.purple],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          border: isToday ?? false
                              ? GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                )
                              : null,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected ?? false
                                ? Colors.white
                                : isDisabled ?? false
                                    ? Colors.grey
                                    : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  displayedMonthDate: value.get_date,
                  value: [value.get_date],
                  onValueChanged: (v) {
                    value.set_date(v[0]);
                  },
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 32.0),
              child: SizedBox(
                height: 1,
                width: 32,
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
            Consumer<Tasks>(builder: (context, value, child) {
              return Consumer<Our_Date>(builder: (context, v, child) {
                if ((value.get_daytasks(v.get_date.toString().split(" ")[0]) ??
                        [])
                    .isEmpty) {
                  return Center(
                    child: Text(
                      "You don't have tasks ${v.get_date.toString().split(" ")[0] == DateTime.now().toString().split(" ")[0] ? "today." : "that day."}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(fontSizeDelta: 6, fontWeightDelta: 6),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: (value.get_daytasks(
                                v.get_date.toString().split(" ")[0]) ??
                            [])
                        .length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                    itemBuilder: (context, i) {
                      return TaskTile(
                        title: (value.get_daytasks(
                                v.get_date.toString().split(" ")[0]) ??
                            [])[i]["title"],
                        subtitle: (value.get_daytasks(
                                v.get_date.toString().split(" ")[0]) ??
                            [])[i]["description"],
                        time: timeconvert((value.get_daytasks(
                                v.get_date.toString().split(" ")[0]) ??
                            [])[i]["end_time"]),
                      );
                    },
                  );
                }
              });
            })
          ],
        ),
      ),
    );
  }
}
