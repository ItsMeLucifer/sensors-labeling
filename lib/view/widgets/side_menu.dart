import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sensors_labeling/main.dart';
import 'package:sensors_labeling/view/widgets/delay_timer.dart';
import 'package:sensors_labeling/viewmodel/sensors_view_model.dart';

class SideMenu extends ConsumerWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorsVM = ref.watch(sensorsProvider);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          ..._buildSection(
            context,
            'Display options',
            ElevatedButton(
              onPressed: sensorsVM.toggleSlowMode,
              child: Text(
                'Slow Mode: ${sensorsVM.slowMode}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (sensorsVM.recordingState == RecordingState.stagnation)
            ..._buildSection(
              context,
              'Recording options',
              _buildRecordingOptions(context, ref),
            ),
          if (sensorsVM.recordingState != RecordingState.stagnation)
            ..._buildRecordingStatus(context, ref),
        ],
      ),
    );
  }

  List<Widget> _buildSection(BuildContext context, String name, Widget child) {
    return [
      Text(
        name,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.left,
      ),
      const Divider(),
      child,
      const Divider(),
    ];
  }

  Widget _buildRecordingOptions(BuildContext context, WidgetRef ref) {
    final sensorsVM = ref.watch(sensorsProvider);
    return Column(
      children: [
        ..._buildNumberPicker(
          context,
          name: 'Delay in the start of sensors data recording (from now)',
          value: sensorsVM.recordingStartDelay,
          onChanged: sensorsVM.setRecordingStartDelay,
          min: 0,
          max: 15,
        ),
        ..._buildNumberPicker(
          context,
          name: 'Delay in terminating sensors data recording (from now)',
          value: sensorsVM.recordingStopDelay,
          onChanged: sensorsVM.setRecordingStopDelay,
          min: 1,
        ),
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: sensorsVM.startDataRecording,
            child: const Text(
              'START RECORDING',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildNumberPicker(
    BuildContext context, {
    required String name,
    required int value,
    required void Function(int) onChanged,
    int min = 0,
    int max = 100,
  }) {
    return [
      Text(
        name,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
      NumberPicker(
        value: value,
        minValue: min,
        maxValue: max,
        onChanged: onChanged,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.teal),
            bottom: BorderSide(color: Colors.teal),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildRecordingStatus(BuildContext context, WidgetRef ref) {
    final sensorsVM = ref.watch(sensorsProvider);
    return [
      Text(
        sensorsVM.recordingState.name.toUpperCase(),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      _buildDelayTimer(context, ref),
      if (sensorsVM.recordingState == RecordingState.saved) ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(sensorsVM.savedDataInfo),
        ),
        ElevatedButton(
          onPressed: sensorsVM.restart,
          child: const Text('OK'),
        )
      ],
    ];
  }

  Widget _buildDelayTimer(BuildContext context, WidgetRef ref) {
    final sensorsVM = ref.watch(sensorsProvider);
    switch (sensorsVM.recordingState) {
      case RecordingState.awaiting:
        return DelayTimer(
            key: const Key("start"), seconds: sensorsVM.recordingStartDelay);
      case RecordingState.recording:
        return DelayTimer(
            key: const Key("stop"),
            seconds:
                sensorsVM.recordingStopDelay - sensorsVM.recordingStartDelay);
      default:
        return Container();
    }
  }
}
