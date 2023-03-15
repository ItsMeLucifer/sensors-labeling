import 'package:flutter/material.dart';
import 'package:sensors_labeling/view/widgets/sensors_info_display.dart';
import 'package:sensors_labeling/view/widgets/side_menu.dart';

class SensorsPage extends StatelessWidget {
  const SensorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: const [
              Expanded(child: SensorsInfoDisplay()),
              VerticalDivider(),
              Expanded(child: SideMenu())
            ],
          ),
        ),
      ),
    );
  }
}
