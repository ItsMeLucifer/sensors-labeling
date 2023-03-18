import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum RecordingState { stagnation, awaiting, recording, recorded }

class SensorsViewModel extends ChangeNotifier {
  ScrollController accelerometerScrollController = ScrollController();
  ScrollController gyroScrollController = ScrollController();
  ScrollController magnetometerScrollController = ScrollController();

  List<List<double>> _accelerometerValues = [];
  List<List<double>> get accelerometerValues => _accelerometerValues;
  set accelerometerValues(List<List<double>> list) {
    _accelerometerValues = list;
    notifyListeners();
  }

  void addAccelerometerValue(List<double> values) {
    _accelerometerValues.add(values);
    if (recordingState == RecordingState.recording) {
      _acceleratorSavedValues.add(values);
    }
    _animateControllerToBottom(accelerometerScrollController);
    notifyListeners();
  }

  List<List<double>> _gyroValues = [];
  List<List<double>> get gyroValues => _gyroValues;
  set gyroValues(List<List<double>> list) {
    _gyroValues = list;
    notifyListeners();
  }

  void addGyroValue(List<double> values) {
    _gyroValues.add(values);
    if (recordingState == RecordingState.recording) {
      _gyroSavedValues.add(values);
    }
    _animateControllerToBottom(gyroScrollController);
    notifyListeners();
  }

  List<List<double>> _magnetometerValues = [];
  List<List<double>> get magnetometerValues => _magnetometerValues;
  set magnetometerValues(List<List<double>> list) {
    _magnetometerValues = list;
    notifyListeners();
  }

  void addMagnetometerValue(List<double> values) {
    _magnetometerValues.add(values);
    if (recordingState == RecordingState.recording) {
      _magnetometerSavedValues.add(values);
    }
    _animateControllerToBottom(magnetometerScrollController);
    notifyListeners();
  }

  bool slowMode = false;
  void toggleSlowMode() {
    slowMode = !slowMode;
    notifyListeners();
  }

  void _animateControllerToBottom(ScrollController controller) {
    try {
      if (slowMode) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(seconds: 3),
          curve: Curves.fastLinearToSlowEaseIn,
        );
        return;
      }
      controller.jumpTo(controller.position.maxScrollExtent);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // =================
  // RECORDING
  // =================

  int _recordingStartDelay = 5;
  int get recordingStartDelay => _recordingStartDelay;

  void setRecordingStartDelay(int value) {
    _recordingStartDelay = value;
    if (value > recordingStopDelay) {
      _recordingStopDelay = value + 1;
    }
    notifyListeners();
  }

  int _recordingStopDelay = 10;
  int get recordingStopDelay => _recordingStopDelay;

  void setRecordingStopDelay(int value) {
    _recordingStopDelay = value;
    if (value < recordingStartDelay) {
      _recordingStartDelay = value - 1;
    }
    notifyListeners();
  }

  int timerValue = 0;

  RecordingState _recordingState = RecordingState.stagnation;
  RecordingState get recordingState => _recordingState;
  set recordingState(RecordingState state) {
    _recordingState = state;
    notifyListeners();
  }

  Future<void> startDataRecording() async {
    debugPrint(
        'start delay : $recordingStartDelay\nstop delay: $recordingStopDelay');
    recordingState = RecordingState.awaiting;
    setFilePath();
    Future.delayed(
      Duration(seconds: recordingStartDelay),
      () {
        recordingState = RecordingState.recording;
        stopDataRecording();
      },
    );
  }

  Future<void> stopDataRecording() async {
    Future.delayed(
      Duration(seconds: recordingStopDelay - recordingStartDelay),
      saveData,
    );
  }

  List<List<double>> _acceleratorSavedValues = [];
  List<List<double>> _gyroSavedValues = [];
  List<List<double>> _magnetometerSavedValues = [];

  String get savedDataInfo {
    return "${_acceleratorSavedValues.length} values from accelerometer\n${_gyroSavedValues.length} values from gyro\n${_magnetometerSavedValues.length} values from magnetometer";
  }

  String filePath = '';

  Future setFilePath() async {
    // final directory = await getExternalStorageDirectory();
    Directory(
            '/storage/emulated/0/Download/sensors_labeling_data/${labels[labelIndex]}')
        .createSync(recursive: true);
    filePath =
        '/storage/emulated/0/Download/sensors_labeling_data/${labels[labelIndex]}/${DateTime.now().microsecondsSinceEpoch}.txt';
  }

  List<String> labels = ['FALLING', 'CLIMBING', 'WALKING'];

  int labelIndex = 0;

  void saveData() async {
    final File file = File(filePath);
    await file.writeAsString(
        '$_acceleratorSavedValues;$_gyroSavedValues;$_magnetometerSavedValues;${_recordingStopDelay - _recordingStartDelay}');
    recordingState = RecordingState.recorded;
    getStringFromFile();
  }

  String fileContent = '';

  void getStringFromFile() async {
    final File file = File(filePath);
    fileContent = await file.readAsString();
    notifyListeners();
  }

  void restart() {
    _acceleratorSavedValues.clear();
    _gyroSavedValues.clear();
    _magnetometerSavedValues.clear();
    recordingState = RecordingState.stagnation;
  }
}
