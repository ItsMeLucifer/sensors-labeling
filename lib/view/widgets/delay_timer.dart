import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_labeling/main.dart';
import 'package:sensors_labeling/viewmodel/sensors_view_model.dart';

class DelayTimer extends StatefulWidget {
  final int seconds;
  final WidgetRef? ref;
  const DelayTimer({required this.seconds, this.ref, super.key});

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
      if (widget.ref != null && seconds < 5 && seconds > 0) {
        final sensorsVM = widget.ref!.read(sensorsProvider);
        sensorsVM.player.play(AssetSource(SensorsViewModel.tickSoundPath));
      }
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
