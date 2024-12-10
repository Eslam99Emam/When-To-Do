import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import 'package:When_to_do/Items/TaskTile.dart';
import 'package:When_to_do/functions.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:When_to_do/providers.dart';

class Weekly_page extends StatefulWidget {
  const Weekly_page({super.key});

  @override
  State<Weekly_page> createState() => _Weekly_pageState();
}

class _Weekly_pageState extends State<Weekly_page> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<Our_Date>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                EasyDateTimeLinePicker.itemBuilder(
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  focusedDate: value.get_date,
                  currentDate: DateTime.now(),
                  itemExtent: 75,
                  daySeparatorPadding: 15,
                  itemBuilder:
                      (context, date, isSelected, isDisabled, isToday, onTap) {
                    return InkWell(
                      onTap: onTap,
                      radius: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isSelected && !isToday ? Colors.grey : null,
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [Colors.blue, Colors.purple],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          border: isToday
                              ? GradientBoxBorder(
                                  width: 2.0,
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.purple],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                )
                              : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              monthformatter(date),
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.apply(
                                        fontSizeDelta: 2,
                                        fontWeightDelta: 1,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                            ),
                            Text(
                              "${date.day}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .apply(
                                    fontSizeDelta: 3,
                                    fontWeightDelta: 1,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                            Text(
                              weekdayformatter(date),
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.apply(
                                        fontSizeDelta: 1,
                                        fontWeightDelta: 1,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  onDateChange: (date) {
                    value.set_date(date);
                  },
                  headerOptions: HeaderOptions(headerType: HeaderType.none),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    height: 1,
                    width: 32,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ),
                (context.read<Tasks>().get_daytasks(value.get_date
                                    .toIso8601String()
                                    .split("T")[0]) ??
                                [])
                            .length >
                        0
                    ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (context.read<Tasks>().get_daytasks(value
                                    .get_date
                                    .toIso8601String()
                                    .split("T")[0]) ??
                                [])
                            .length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 15,
                          );
                        },
                        itemBuilder: (context, i) {
                          return TaskTile(
                            title: (context.read<Tasks>().get_daytasks(value
                                    .get_date
                                    .toIso8601String()
                                    .split("T")[0]) ??
                                [])[i]["title"],
                            subtitle: (context.read<Tasks>().get_daytasks(value
                                    .get_date
                                    .toIso8601String()
                                    .split("T")[0]) ??
                                [])[i]["description"],
                            time: timeconvert((context
                                    .read<Tasks>()
                                    .get_daytasks(value.get_date
                                        .toIso8601String()
                                        .split("T")[0]) ??
                                [])[i]["end_time"]),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "You don't have tasks ${value.get_date == DateTime.now() ? "today." : "that day."}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .apply(fontSizeDelta: 6, fontWeightDelta: 6),
                          textAlign: TextAlign.center,
                        ),
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
