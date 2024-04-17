import 'package:get/get.dart';
import 'package:msa_app/getx/expense_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ExpenseController>(ExpenseController());
  }
}