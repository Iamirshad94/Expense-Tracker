import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msa_app/config/app_theme.dart';
import 'package:msa_app/utils/app_images.dart';
import 'package:msa_app/utils/app_text_styles.dart';
import 'package:msa_app/utils/custom_button.dart';
import '../data/models/expense_model.dart';
import '../getx/expense_controller.dart';

enum ExpenseBody { All, Weekly, Monthly }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  ExpenseType _selectedExpenseType = ExpenseType.Entertainment;
  DateTime _selectedDate = DateTime.now();
  final expenseController = Get.find<ExpenseController>();
  TabController? tabController;

  @override
  initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  // Select date function
  Future<DateTime> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      return pickedDate;
    }
    return _selectedDate;
  }

  // this function is used to manage the type of Expense so that it can render the right Tile
  String _handleExpenseTitle(String expenseType) {
    if (expenseType == ExpenseType.Fuel.toString()) {
      return 'Fuel';
    } else if (expenseType == ExpenseType.Groceries.toString()) {
      return 'Grocery';
    } else if (expenseType == ExpenseType.Entertainment.toString()) {
      return 'Entertainment';
    } else if (expenseType == ExpenseType.Rent.toString()) {
      return 'Rent';
    } else if (expenseType == ExpenseType.MedicalExpenses.toString()) {
      return 'Medical Expenses';
    } else {
      return 'Utilities';
    }
  }

  // Checking ExpenseType from this
  ExpenseType _checkExpenseType(String expenseType) {
    if (expenseType == ExpenseType.Fuel.toString()) {
      return ExpenseType.Fuel;
    } else if (expenseType == ExpenseType.Groceries.toString()) {
      return ExpenseType.Groceries;
    } else if (expenseType == ExpenseType.Entertainment.toString()) {
      return ExpenseType.Entertainment;
    } else if (expenseType == ExpenseType.Rent.toString()) {
      return ExpenseType.Rent;
    } else if (expenseType == ExpenseType.MedicalExpenses.toString()) {
      return ExpenseType.MedicalExpenses;
    } else {
      return ExpenseType.Utilities;
    }
    // Implement logic to show a dialog for adding an expense
    // You can use showDialog or showBottomSheet
  }

  // Checking type of Expense and get right Expense Icon
  Image _handleExpenseIcon(String expenseType) {
    if (expenseType == ExpenseType.Fuel.toString()) {
      return Image.asset(AppImages.fuelIcon);
    } else if (expenseType == ExpenseType.Groceries.toString()) {
      return Image.asset(AppImages.groceryIcon);
    } else if (expenseType == ExpenseType.Entertainment.toString()) {
      return Image.asset(AppImages.entertainmentIcon);
    } else if (expenseType == ExpenseType.Rent.toString()) {
      return Image.asset(AppImages.rentIcon);
    } else if (expenseType == ExpenseType.MedicalExpenses.toString()) {
      return Image.asset(AppImages.fuelIcon);
    } else {
      return Image.asset(AppImages.fuelIcon);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GetBuilder<ExpenseController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyTheme.colorWhite,
        appBar: AppBar(
          backgroundColor: MyTheme.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "Expense Tracker",
            style: AppTextStyles.textWhiteBodyRegular,
          ),
          bottom: TabBar(controller: tabController,
              labelColor: MyTheme.colorWhite,
              indicatorColor: MyTheme.colorWhite,
              tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ]),
        ),
        body: controller.expenses.isEmpty && controller.isLoading == false
            ? Center(
                child: Text(
                  'No expense data to show!',
                  style: AppTextStyles.textGreyBodySmall,
                ),
              )
            : controller.isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: MyTheme.primaryColor,
                    ),
                  )
                : TabBarView(
            controller: tabController,
            children: [
              _allExpenseView(
                  controller, ExpenseBody.All),
              _allExpenseView(
                  controller, ExpenseBody.Weekly),
              _allExpenseView(
                  controller, ExpenseBody.Monthly),
            ]),
        floatingActionButton: _addExpenseButton(),
      );
    });
  }

  // Common Tab view only filtering the list by week or month type
  Widget _allExpenseView(
      ExpenseController controller, ExpenseBody expenseBody) {
    List<Expense> filteredExpenses = controller.expenses;
    final today = DateTime.now(); // Initialize with all expenses
    if (expenseBody == ExpenseBody.Weekly) {
      filteredExpenses = filteredExpenses.where((expense) {
        final delta = today.difference(DateTime.parse(expense.date));
        return delta.inDays <= 7;
      }).toList();
    } else if (expenseBody == ExpenseBody.Monthly) {
      // Filter for expenses within the last month
      final thisMonth = DateTime(today.year, today.month, 1);
      filteredExpenses = filteredExpenses.where((expense) {
        return DateTime.parse(expense.date)
            .isAfter(thisMonth.subtract(const Duration(days: 1)));
      }).toList();
    }
    return SizedBox(
      height: 400,
      child: ListView.builder(
          itemCount: filteredExpenses.length,
          itemBuilder: (BuildContext context, int index) {
            return _expenseTile(index, filteredExpenses, controller);
          }),
    );
  }

// common expense tile
  Widget _expenseTile(
      int index, List<Expense> expenseList, ExpenseController controller) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: MyTheme.colorGrey)),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
                child: _handleExpenseIcon(expenseList[index].expenseType)),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _handleExpenseTitle(expenseList[index].expenseType),
                  style: AppTextStyles.textBlackBodyRegular,
                ),
                Text(
                  expenseList[index].description.toString(),
                  style: AppTextStyles.textGreyBodySmall,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            _amountController.text =
                                expenseList[index].amount.toString();
                            _descriptionController.text =
                                expenseList[index].description.toString();
                            _selectedDate =
                                DateTime.parse(expenseList[index].date);
                            _selectedExpenseType = _checkExpenseType(
                                expenseList[index].expenseType);
                            _addExpenseBottomSheet(
                                value: true, id: expenseList[index].id);
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () async {
                            await controller
                                .deleteExpense(controller.expenses[index].id);
                            // setState(() {});
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 30,
                          )),
                    ],
                  ),
                  Text(
                    '${controller.expenses[index].amount.toString()} INR',
                    style: AppTextStyles.textPrimaryColorHeading,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  // Floating button for adding expense
  Widget _addExpenseButton() => FloatingActionButton(
      backgroundColor: MyTheme.primaryColor,
      child: const Icon(
        Icons.add,
        color: MyTheme.colorWhite,
      ),
      onPressed: () {
        _addExpenseBottomSheet(value: false);
      });

  // Bottom sheet having a form for adding expense
  Future _addExpenseBottomSheet({required bool value, int? id}) {
    return Get.bottomSheet(
      _addExpenseForm(isUpdating: value, id: id),
      backgroundColor: MyTheme.colorWhite,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      enableDrag: false,
    );
  }

  // Add Expense form
  Widget _addExpenseForm({required bool isUpdating, int? id}) {
    return StatefulBuilder(builder:
        (BuildContext context, StateSetter setState /*You can rename this!*/) {
      debugPrint('Selected Date-->> $_selectedDate');
      debugPrint('Today Date-->> ${DateTime.now()}');
      final today = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      return SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListView(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      onPressed: () {
                        _amountController.clear();
                        _descriptionController.clear();
                        _selectedDate = DateTime.now();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: MyTheme.primaryColor,
                      ))
                ],
                title: AppButton(
                  text: isUpdating ? 'UPDATE' : 'ADD',
                  onPressed: () async {
                    debugPrint('${_descriptionController.isBlank}');
                    debugPrint('${_descriptionController.text.isEmpty}');
                    debugPrint('Description ${_descriptionController.text}');

                    if (_amountController.text.isEmpty ||
                        _descriptionController.text.isEmpty) {
                      Get.snackbar('Fill Required Details',
                          'All the fields are mandatory, please fill all the details',
                          backgroundColor: MyTheme.primaryColor,
                          duration: const Duration(seconds: 2),
                          colorText: MyTheme.colorWhite);
                    } else {
                      final amount = int.parse(_amountController.text);
                      isUpdating
                          ? expenseController.updateExpense(
                              id: id!,
                              amount: amount,
                              date: _selectedDate,
                              description: _descriptionController.text,
                              expenseType: _selectedExpenseType,
                            )
                          : expenseController.addNewExpense(
                              amount: amount,
                              date: _selectedDate,
                              description: _descriptionController.text,
                              expenseType: _selectedExpenseType);

                      // setState(() {});
                      Get.back();
                    }
                  },
                  width: 120,
                  height: 50,
                ),
              ),
              const Divider(
                color: MyTheme.colorGrey,
                thickness: 0.5,
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    label: Text(
                      'Add Amount',
                      style: AppTextStyles.textGreyBodySmall,
                    ),
                    suffixText: 'INR',
                    suffixStyle: AppTextStyles.textBlackBodyRegular,
                    hintText: '',
                    hintStyle: AppTextStyles.textBlackBodyRegular,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    today == _selectedDate
                        ? Text(
                            'Today',
                            style: AppTextStyles.textBlackBodyRegular,
                          )
                        : Text(
                            DateFormat('dd-MM-yy').format(_selectedDate),
                            style: AppTextStyles.textBlackBodyRegular,
                          ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: MyTheme.primaryColor,
                      ),
                      onPressed: () async {
                        final pickedDate = await _selectDate(context);
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    label: Text(
                      'Description',
                      style: AppTextStyles.textGreyBodySmall,
                    ),
                    hintText: '',
                    hintStyle: AppTextStyles.textBlackBodyRegular,
                    alignLabelWithHint:
                        true, // Align label with top of the field
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<ExpenseType>(
                  value: _selectedExpenseType,
                  iconEnabledColor: MyTheme.primaryColor,
                  items: ExpenseType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type.toString().split('.').last,
                              style: AppTextStyles.textBlackBodySmall,
                            ),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedExpenseType = value!),
                  decoration: InputDecoration(
                    labelText: 'Expense Type',
                    labelStyle: AppTextStyles.textGreyBodySmall,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

