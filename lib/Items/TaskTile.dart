import 'dart:developer';

import 'package:When_to_do/main.dart';
import 'package:When_to_do/providers.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:When_to_do/Items/GradientText.dart';

class TaskTile extends StatefulWidget {
  dynamic title;

  dynamic subtitle;

  dynamic time;

  TaskTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.time});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: true,
          showCloseIcon: true,
          title: 'Do you want to delete this task ?',
          desc:
              'You will Delete the Task : ${widget.title} \nwhich due to ${widget.time}',
          titleTextStyle:
              Theme.of(context).textTheme.bodyLarge!.apply(fontWeightDelta: 10),
          btnOkColor: Colors.red,
          btnOkText: "Delete",
          btnOkOnPress: () async {
            await supabase.from("tasks").delete().eq("title", widget.title);
            Provider.of<Tasks>(context, listen: false).set_AllTasks();
          },
          btnCancelText: "Edit",
          btnCancelColor: Colors.amber.shade300,
          btnCancelOnPress: () {
            GlobalKey<FormState> formState = GlobalKey();
            TextEditingController titleEditingController =
                TextEditingController(text: "${widget.title}");
            TextEditingController descriptionEditingController =
                TextEditingController(text: "${widget.subtitle}");
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.bottomSlide,
              headerAnimationLoop: false,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: true,
              showCloseIcon: true,
              title: 'Update this task',
              desc:
                  'You will Update the Task title : ${widget.title} & Description "${widget.subtitle}" \n which due to ${widget.time}',
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .apply(fontWeightDelta: 10),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: formState,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleEditingController,
                        decoration: InputDecoration(
                          label: Text("Title"),
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Title",
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '') == '') {
                            return "Can't have an Empty title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: descriptionEditingController,
                        decoration: InputDecoration(
                          label: Text("Description"),
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: "Description",
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              btnOkColor: Colors.amber.shade300,
              btnOkText: "Update",
              btnOkOnPress: () async {
                if (formState.currentState!.validate()) {
                  log(descriptionEditingController.text);
                  var data = {
                    "title": titleEditingController.text,
                    "description": descriptionEditingController.text,
                  };
                  await supabase
                      .from("tasks")
                      .update(data)
                      .eq("title", widget.title);
                  Provider.of<Tasks>(context, listen: false).set_AllTasks();
                }
              },
              btnCancelText: "Cancel",
              btnCancelColor: Colors.black87,
              btnCancelOnPress: () {},
            ).show();
          },
        ).show();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          title: Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(fontSizeDelta: 0.75),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            widget.subtitle,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.grey.shade800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing:
              // Text(
              GradientText(
            gradient: LinearGradient(
              colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            widget.time.runtimeType == DateTime
                ? "${widget.time.hour.toString().padLeft(2, "0")}:${widget.time.minute.toString().padLeft(2, "0")}"
                : "${widget.time}",
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                color: Colors.black, fontWeightDelta: -1, fontSizeDelta: 0),
          ),
        ),
      ),
    );
  }
}
