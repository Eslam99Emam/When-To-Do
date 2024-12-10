import 'dart:async';

import 'package:When_to_do/pages/sign.dart';
import 'package:When_to_do/providers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:When_to_do/Items/GradientText.dart';
import 'package:When_to_do/functions.dart';
import 'package:When_to_do/main.dart';

class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page>
    with SingleTickerProviderStateMixin {
  var img_loaded = true;
  var name = (supabase.auth.currentUser!.userMetadata!["name"] as String);
  int? tasks_num;

  Future<Map> fetchdata() async {
    PostgrestResponse<List<Map<String, dynamic>>> tasks = await supabase
        .from("tasks")
        .select("title")
        .eq("task_user", supabase.auth.currentUser!.id)
        .count();

    String date = DateTime.now().toIso8601String().split("T")[0];

    List next_task = await supabase
        .from("tasks")
        .select("*")
        .eq("task_user", supabase.auth.currentUser!.id)
        .gte("task_date", date)
        .order("task_date", ascending: true)
        .order("end_time", ascending: true)
        .limit(1);

    if (next_task.length == 0) {
      return {
        "count": 0,
        "next_task": false,
      };
    } else {
      return {
        "count": tasks.count,
        "next_task": true,
        "next_task_title": next_task[0]["title"],
        "next_task_date": next_task[0]["task_date"],
        "next_task_time": timeconvert(next_task[0]["end_time"]),
      };
    }
  }

  next_task(item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 12,
        ),
        Text(
          "Next task",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(fontWeightDelta: 3),
        ),
        SizedBox(
          height: 4,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            "\"${item["title"]}\" due to \n\t${item["task_date"]} on ${item["end_time"]}",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .apply(fontWeightDelta: 2, fontSizeDelta: 1),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<My_User>(builder: (context, value, widget) {
        return SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black87,
                radius: 45,
                child: GradientText(
                  "${value.get_user.userMetadata!["name"][0]}",
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  style: Theme.of(context).textTheme.displaySmall!.apply(
                        fontWeightDelta: 10,
                      ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Name",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(fontWeightDelta: 3),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    // GestureDetector
                    // onTap: () {
                    //     GlobalKey<FormState> formkey = GlobalKey();
                    //     TextEditingController NameUpdateController =
                    //         TextEditingController();
                    //     AwesomeDialog(
                    //       context: context,
                    //       dialogType: DialogType.question,
                    //       headerAnimationLoop: false,
                    //       autoDismiss: false,
                    //       onDismissCallback: (type) {
                    //         log(type.toString());
                    //       },
                    //       title: "Update your username",
                    //       body: Form(
                    //         key: formkey,
                    //         child: Padding(
                    //           padding:
                    //               const EdgeInsets.symmetric(horizontal: 16.0),
                    //           child: TextFormField(
                    //             controller: NameUpdateController,
                    //             decoration: InputDecoration(
                    //               label: Text("Name Update"),
                    //               hintText: "New name",
                    //               border: GradientOutlineInputBorder(
                    //                 gradient: LinearGradient(
                    //                   colors: [
                    //                     Color(0xFF6A82FB),
                    //                     Color(0xFFFC5C7D)
                    //                   ],
                    //                   begin: Alignment.topLeft,
                    //                   end: Alignment.bottomRight,
                    //                 ),
                    //               ),
                    //             ),
                    //             validator: (value) {
                    //               if ((value ?? "") == "") {
                    //                 return "New name can't be Empty";
                    //               }
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //       btnCancelText: "Quit",
                    //       btnCancelColor: Colors.black87,
                    //       btnOkText: "Update",
                    //       btnOkColor: Colors.red.shade900,
                    //       btnOkOnPress: () {
                    //         if (formkey.currentState!.validate()) {
                    //           supabase.auth.updateUser(
                    //             UserAttributes(
                    //               data: {
                    //                 "name": NameUpdateController.text,
                    //               },
                    //             ),
                    //           );
                    //           var snackbar = SnackBar(
                    //             content: Text("Name Updated"),
                    //           );
                    //           ScaffoldMessenger.of(context)
                    //               .showSnackBar(snackbar);
                    //           context.read<My_User>().get_user;
                    //           Navigator.pop(context);
                    //         }
                    //       },
                    //     )..show();
                    //   },
                    // Row
                    Text(
                      "${value.get_user.userMetadata!["name"]}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(fontWeightDelta: 2, fontSizeDelta: 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Email",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(fontWeightDelta: 3),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${value.get_user.email}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(fontWeightDelta: 2, fontSizeDelta: 1),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Tasks Left",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(fontWeightDelta: 3),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        "${(context.read<Tasks>().get_AllTasks ?? []).length}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(fontWeightDelta: 2, fontSizeDelta: 1),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    (context.read<Tasks>().get_AllTasks ?? []).length > 0
                        ? next_task(
                            (context.read<Tasks>().get_AllTasks ?? [])[0])
                        : SizedBox()
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 14,
                        spreadRadius: -10,
                        blurStyle: BlurStyle.solid),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      headerAnimationLoop: false,
                      title: "Do you really want to log out ?",
                      btnCancelText: "No",
                      btnCancelColor: Colors.black87,
                      btnOkText: "Log Out",
                      btnOkColor: Colors.red.shade900,
                      btnOkOnPress: () async {
                        Navigator.pushReplacement(
                          context,
                          SlideTTBPageRouting(
                            SignPage(),
                          ),
                        );
                      },
                    )..show();
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(48.0, 12.0, 48.0, 12.0),
                    child: Text(
                      "Log Out",
                      style: Theme.of(context).textTheme.headlineSmall!.apply(
                            color: Colors.white,
                            fontWeightDelta: 4,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
