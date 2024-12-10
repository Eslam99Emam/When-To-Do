import 'package:When_to_do/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Our_Date extends ChangeNotifier {
  DateTime date = DateTime.now();

  DateTime get get_date => date;

  bool is_disposed = false;

  @override
  void dispose() {
    is_disposed = true;
    super.dispose();
  }

  Our_Date() {
    print("Our Date is ${this.date}");
  }

  void set_date(DateTime datetime) {
    if (date != datetime && !is_disposed) {
      date = datetime;
      notifyListeners();
    }
  }
}

class PageControl extends ChangeNotifier {
  PageController pageController = PageController(initialPage: 2);
  int current = 2;

  bool is_disposed = false;

  @override
  void dispose() {
    is_disposed = true;
    super.dispose();
  }

  PageController get get_pageController => pageController;
  int get get_current => current;

  void set_index(int i) {
    if (current != i && !is_disposed) {
      current = i;
      notifyListeners();
    }
  }

  void set_pageController(int i) {
    if (current != i && !is_disposed) {
      current = i;
      pageController.animateToPage(i,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      notifyListeners();
    }
  }
}

class Our_TaskTime extends ChangeNotifier {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  int _day = DateTime.now().day;
  int _hour = DateTime.now().hour;
  int _minute = DateTime.now().minute;

  bool is_disposed = false;

  @override
  void dispose() {
    is_disposed = true;
    super.dispose();
  }

  // Getter and Setter for Year
  int get year => _year;
  set year(int value) {
    if (value >= 0) {
      if (value != _year && !is_disposed) {
        _year = value;
        notifyListeners();
      }
    } else {
      throw ArgumentError('Year cannot be negative');
    }
  }

  // Getter and Setter for Month
  int get month => _month;
  set month(int value) {
    if ((value >= 1 && value <= 12) && !is_disposed) {
      if (value != _month) {
        _month = value;
        notifyListeners();
      }
    } else {
      throw ArgumentError('Month must be between 1 and 12');
    }
  }

  // Getter and Setter for Day
  int get day => _day;
  set day(int value) {
    if ((value >= 1 && value <= 31) && !is_disposed) {
      if (value != _day) {
        _day = value;
        notifyListeners();
      }
    } else {
      throw ArgumentError('Day must be between 1 and 31');
    }
  }

  // Getter and Setter for Hour
  int get hour => _hour;
  set hour(int value) {
    if (value >= 1 && value <= 24) {
      if (value != _hour && !is_disposed) {
        _hour = value;
        notifyListeners();
      }
    } else {
      throw ArgumentError('Hour must be between 0 and 23');
    }
  }

  // Getter and Setter for Minute
  int get minute => _minute;
  set minute(int value) {
    if ((value >= 0 && value < 60) && !is_disposed) {
      if (value != _minute) {
        _minute = value;
        notifyListeners();
      }
    } else {
      throw ArgumentError('Minute must be between 0 and 59');
    }
  }
}

class Tasks extends ChangeNotifier {
  List<Map>? _AllTasks;

  List<Map>? daytasks;

  bool is_disposed = false;

  @override
  void dispose() {
    is_disposed = true;
    super.dispose();
  }

  Tasks() {
    this.set_AllTasks();
  }

  void set_AllTasks() async {
    var new_tasks;
    try {
      new_tasks = await supabase
          .from("tasks")
          .select("*")
          .eq(
              "task_user",
              (supabase.auth.currentUser ??
                      User(
                          id: "",
                          appMetadata: {},
                          userMetadata: {},
                          aud: "",
                          createdAt: "",
                          email: ""))
                  .id)
          .order("end_time")
          .order("task_date")
          .select("*");
    } catch (e) {}

    if (_AllTasks != new_tasks &&
        new_tasks.runtimeType != Null &&
        !is_disposed) {
      _AllTasks = new_tasks;
      notifyListeners();
    }
  }

  List<Map>? get get_AllTasks {
    this.set_AllTasks();
    return this._AllTasks;
  }

  // to be used in both calendar.dart and weekly.dart for filtering date
  void set_daytasks(day) {
    daytasks = (this._AllTasks ?? []).where((task) {
      return task.containsValue(day);
    }).toList();
  }

  // to be used in both calendar.dart and weekly.dart for getting filtered date
  List<Map>? get_daytasks(day) {
    this.set_daytasks(day);
    return this.daytasks;
  }

  // to filter only unique dates and sort them " to be used in All.dart "
  List? get_dates() {
    dynamic dates = Set();
    (this.get_AllTasks ?? []).forEach(
      (x) {
        if (x.containsKey("task_date")) {
          // print(x["task_date"]);
          (dates as Set).add(x["task_date"]);
        }
      },
    );
    dates = dates.toList();
    dates.sort((x, y) {
      var xl = (x as String).split("-").map((s) => int.parse((s))).toList();
      var yl = (y as String).split("-").map((s) => int.parse((s))).toList();
      var xd = DateTime(xl[0], xl[1], xl[2]);
      var yd = DateTime(yl[0], yl[1], yl[2]);
      return xd.compareTo(yd);
    });
    return dates;
  }
}

class My_User extends ChangeNotifier {
  User user = supabase.auth.currentUser ??
      User(
          id: "",
          appMetadata: {},
          userMetadata: {"name": ""},
          aud: "",
          createdAt: "",
          email: "");

  bool is_disposed = false;

  @override
  void dispose() {
    is_disposed = true;
    super.dispose();
  }

  void set_user() async {
    var new_user;
    try {
      new_user = (await supabase.auth.getUser()).user;
    } catch (e) {}
    if (new_user != user && new_user.runtimeType != Null && !is_disposed) {
      user = new_user;
      notifyListeners();
    }
  }

  User get get_user {
    this.set_user();
    return this.user;
  }
}
