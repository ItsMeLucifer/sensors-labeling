import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_labeling/viewmodel/sensors_view_model.dart';
import 'package:sensors_labeling/view/sensors_page.dart';
import 'package:sensors_plus/sensors_plus.dart';

final ChangeNotifierProvider<SensorsViewModel> sensorsProvider =
    ChangeNotifierProvider((_) => SensorsViewModel());

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(
            color: Colors.blueGrey,
          ),
          headlineMedium: TextStyle(
            color: Colors.indigo,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: Colors.teal,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        dividerColor: Colors.black,
      ),
      home: HomePage(ref: ref),
    );
  }
}

class HomePage extends StatefulWidget {
  final WidgetRef ref;
  const HomePage({required this.ref, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final sensorsVM = widget.ref.read(sensorsProvider);
    debugPrint('INIT STATE');
    accelerometerEvents.listen((AccelerometerEvent event) {
      sensorsVM.addAccelerometerValue(<double>[event.x, event.y, event.z]);
    });
    gyroscopeEvents.listen((GyroscopeEvent event) {
      sensorsVM.addGyroValue(<double>[event.x, event.y, event.z]);
    });
    magnetometerEvents.listen((MagnetometerEvent event) {
      sensorsVM.addMagnetometerValue(<double>[event.x, event.y, event.z]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SensorsPage();
  }
}
