import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_labeling/main.dart';

class SensorsInfoDisplay extends ConsumerWidget {
  const SensorsInfoDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorsVM = ref.watch(sensorsProvider);
    return Column(
      children: [
        ..._buildSection(
          context,
          'Accelerometer',
          sensorsVM.accelerometerScrollController,
          sensorsVM.accelerometerValues,
        ),
        ..._buildSection(
          context,
          'Gyroscope',
          sensorsVM.gyroScrollController,
          sensorsVM.gyroValues,
        ),
        ..._buildSection(
          context,
          'Magnetometer',
          sensorsVM.magnetometerScrollController,
          sensorsVM.magnetometerValues,
        ),
      ],
    );
  }

  List<Widget> _buildSection(BuildContext context, String title,
      ScrollController controller, List<List<double>> items) {
    return [
      Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.left,
      ),
      const Divider(),
      Expanded(
        child: _buildListView(
          context,
          controller,
          items,
        ),
      ),
      const Divider(),
    ];
  }

  Widget _buildListView(BuildContext context, ScrollController controller,
      List<List<double>> items) {
    return ListView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final values = items[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'X: ${values[0].toStringAsFixed(3)}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: const Color.fromARGB(255, 255, 0, 0),
                  ),
            ),
            Text(
              'Y: ${values[1].toStringAsFixed(3)}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: const Color.fromARGB(255, 0, 255, 17),
                  ),
            ),
            Text(
              'Z: ${values[2].toStringAsFixed(3)}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: const Color.fromARGB(255, 0, 30, 255),
                  ),
            ),
          ],
        );
      },
    );
  }
}
