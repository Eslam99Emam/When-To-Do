import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:When_to_do/Items/TaskTile.dart';
import 'package:When_to_do/functions.dart';
import 'package:When_to_do/providers.dart';

class All_Tasks extends StatefulWidget {
  const All_Tasks({super.key});

  @override
  State<All_Tasks> createState() => _All_TasksState();
}

class _All_TasksState extends State<All_Tasks> {
  @override
  Widget build(BuildContext context) {
    if ((context.read<Tasks>().get_AllTasks ?? []).isEmpty) {
      // log(context.read<Tasks>().get_AllTasks.toString());
      return Center(
        child: Text(
          "Finally, you don't have any tasks left. 🎉",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .apply(fontSizeDelta: 6, fontWeightDelta: 6),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: (context.watch<Tasks>().get_dates() ?? []).length,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 15,
          );
        },
        itemBuilder: (context, index) {
          List w = (context.read<Tasks>().get_dates() ?? []);
          String date = w[index];
          List items = [];
          (context.read<Tasks>().get_AllTasks ?? []).forEach(
            (element) {
              if (element["task_date"] == date) {
                items.add(element);
              }
            },
          );
          var datetime = (date.split("-")).map((e) => int.parse(e)).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${DateFormat.yMMMMd().format(DateTime(datetime[0], datetime[1], datetime[2]))}",
                // "${snapshot.data![index]["task_date"]}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: 15,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  return TaskTile(
                    title: items[i]["title"],
                    subtitle: items[i]["description"],
                    time: timeconvert(items[i]["end_time"]),
                  );
                },
                separatorBuilder: (context, i) {
                  if (items[i]["task_date"] == w[index] && items.length > 1) {
                    return SizedBox(
                      height: 15,
                    );
                  } else {
                    return SizedBox();
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
