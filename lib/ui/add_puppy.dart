import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiting_list/controllers/puppy_controller.dart';
import 'package:waiting_list/models/puppy.dart';
import 'package:waiting_list/ui/theme.dart';
import 'package:waiting_list/ui/widgets/button.dart';
import 'package:waiting_list/ui/widgets/input_field.dart';

class AddPuppyPage extends StatefulWidget {
  AddPuppyPage({Key? key}) : super(key: key);

  @override
  State<AddPuppyPage> createState() => _AddPuppyPageState();
}

class _AddPuppyPageState extends State<AddPuppyPage> {
  final PuppyController _puppyController = Get.put(PuppyController());
  var _arrivalTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serviceDetailsController =
      TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Create new Puppy", style: headingStyle),
              MyInputField(
                title: "Name",
                hint: "Enter name/owner of the puppy",
                controller: _nameController,
              ),
              MyInputField(
                  title: "Service",
                  hint: "Please provide service details ",
                  controller: _serviceDetailsController),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.grey,
                    )),
              ),
              MyInputField(
                title: "Arrival Time",
                hint: _arrivalTime,
                controller: _arrivalTimeController,
                widget: IconButton(
                  icon: const Icon(
                    Icons.timelapse_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getTimeFromUser();
                  },
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  MyButton(label: "Add Puppy", onTap: () => _validateData()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _addPuppy() async {
    await _puppyController.addPuppy(
        puppy: Puppy(
            name: _nameController.text,
            serviceDetails: _serviceDetailsController.text,
            date: DateFormat.yMd().format(_selectedDate),
            arrivalTime: _arrivalTime,
            isServiced: 0));
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser() async {
    var pickerTime = await _getTime();
    String formatedTime =  pickerTime.format(context);

    setState(() {
      _arrivalTime = formatedTime;
    });
  }

  _getTime() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_arrivalTime.split(":")[0]),
          minute: int.parse(_arrivalTime.split(":")[1].split(" ")[0])),
    );
  }

  _validateData() {
    if (_nameController.text.isNotEmpty &&
        _serviceDetailsController.text.isNotEmpty) {
      _addPuppy();
      Get.back();
    } else if (_nameController.text.isEmpty ||
        _serviceDetailsController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pinkAccent,
          icon: const Icon(Icons.warning_amber_rounded));
    }
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage("images/profile_image.png"),
          ),
          SizedBox(
            width: 20,
          )
        ]);
  }
}
