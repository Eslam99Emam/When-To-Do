import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class Date_Picker extends StatefulWidget {
  Date_Picker({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.func,
  });

  String title;

  int value;

  int min;

  int max;

  void Function(int) func;

  @override
  State<Date_Picker> createState() => _Date_PickerState();
}

class _Date_PickerState extends State<Date_Picker> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .apply(fontWeightDelta: 2),
          ),
          Center(
              child: NumberPicker(
            itemWidth: 75,
            itemHeight: 30,
            zeroPad: true,
            minValue: widget.min,
            maxValue: widget.max,
            value: widget.value,
            onChanged: widget.func,
          )),
        ],
      ),
    );
  }
}
