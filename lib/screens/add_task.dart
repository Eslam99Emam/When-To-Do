import 'dart:developer';

import 'package:When_to_do/providers.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:When_to_do/Items/Date_picker.dart';
import 'package:When_to_do/main.dart';
import 'package:provider/provider.dart';

class Add_Task extends StatefulWidget {
  Add_Task({super.key});

  @override
  State<Add_Task> createState() => _Add_TaskState();
}

class _Add_TaskState extends State<Add_Task> {
  GlobalKey<FormState> formstate = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Consumer<Our_TaskTime>(builder: (context, tasktime, widget) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formstate,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "Add a task",
                  style: Theme.of(context).textTheme.displayMedium!.apply(
                        fontSizeDelta: 3,
                        fontWeightDelta: 3,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Task 1",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                      border: GradientOutlineInputBorder(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      label: Text(
                        "Title *",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelAlignment: FloatingLabelAlignment.start),
                  validator: (String? title) => (title ?? "").length > 0
                      ? null
                      : "Task name can't be empty",
                  onSaved: (t) => title = t,
                ),
                SizedBox(
                  height: 24,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Task 1 Description...",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                    border: GradientOutlineInputBorder(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    label: Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                  ),
                  onSaved: (d) => description = d,
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Date_Picker(
                      title: "year",
                      value: context.watch<Our_TaskTime>().year,
                      func: (year) {
                        tasktime.year = year;
                      },
                      min: DateTime.now().year,
                      max: 2030,
                    ),
                    Date_Picker(
                      title: "month",
                      value: context.watch<Our_TaskTime>().month,
                      func: (month) {
                        tasktime.month = month;
                      },
                      min: 1,
                      max: 12,
                    ),
                    Date_Picker(
                      title: "day",
                      value: context.watch<Our_TaskTime>().day,
                      func: (day) {
                        tasktime.day = day;
                      },
                      min: 1,
                      max: 31,
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Date_Picker(
                      title: "hour",
                      value: context.watch<Our_TaskTime>().hour,
                      func: (hour) {
                        tasktime.hour = hour;
                      },
                      min: 1,
                      max: 24,
                    ),
                    Date_Picker(
                      title: "minute",
                      value: context.watch<Our_TaskTime>().minute,
                      func: (minute) {
                        tasktime.minute = minute;
                      },
                      min: 0,
                      max: 59,
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    if (formstate.currentState!.validate()) {
                      formstate.currentState!.save();
                      DateTime date = DateTime(tasktime.year, tasktime.month,
                          tasktime.day, tasktime.hour, tasktime.minute);
                      String formattedDate =
                          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      String formattedTime =
                          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
                      Map our_json = {
                        'title': title,
                        'description': description,
                        'task_date': formattedDate,
                        'end_time': formattedTime,
                        'task_user': supabase.auth.currentUser!.id
                      };
                      await supabase
                          .from('tasks')
                          .insert(
                            our_json,
                          )
                          .then((v) {
                        var snackBar = SnackBar(
                          content: Text("Task Added"),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        context.read<Tasks>().get_AllTasks;
                        formstate.currentState!.reset();
                        tasktime.year = DateTime.now().year;
                        tasktime.month = DateTime.now().month;
                        tasktime.day = DateTime.now().day;
                        tasktime.hour = DateTime.now().hour;
                        tasktime.minute = DateTime.now().minute;
                      }, onError: (e) {
                        log(e.toString());
                        var snackBar = SnackBar(
                          content: Text("Error Adding Task, try again later"),
                          backgroundColor: Colors.red,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      "Add Task",
                      style: Theme.of(context).textTheme.headlineSmall!.apply(
                          fontSizeDelta: 2,
                          fontWeightDelta: 1,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
