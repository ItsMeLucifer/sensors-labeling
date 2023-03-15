import 'dart:async';

import 'package:flutter/material.dart';

class DelayTimer extends StatefulWidget {
  final int seconds;
  const DelayTimer({required this.seconds, super.key});

  @override
  State<DelayTimer> createState() => _DelayTimerState();
}

class _DelayTimerState extends State<DelayTimer> {
  Timer? timer;
  int seconds = 0;
  @override
  void initState() {
    seconds = widget.seconds;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        timer?.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$seconds',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}
