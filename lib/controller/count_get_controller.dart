import 'package:get/get.dart';

class CountController extends GetxController {
  var Count = 0.obs;

  void increment() {
    Count++;
  }

  void decrement() {
    Count--;
  }
}
