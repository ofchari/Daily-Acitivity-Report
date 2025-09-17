import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/count_get_controller.dart';

class CountScreen extends StatefulWidget {
  const CountScreen({super.key});

  @override
  State<CountScreen> createState() => _CountScreenState();
}

class _CountScreenState extends State<CountScreen> {
  final CountController controller = Get.put(CountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                "Count: ${controller.Count}", // ✅ lowercase, reactive
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.increment,
              child: const Text("Increment"),
            ),
            ElevatedButton(
              onPressed: controller.decrement,
              child: const Text("Decrement"),
            ),
          ],
        ),
      ),
    );
  }
}
