import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiting_list/models/puppy.dart';
import 'package:waiting_list/services/theme_services.dart';
import 'package:waiting_list/ui/add_puppy.dart';
import 'package:waiting_list/ui/theme.dart';
import 'package:waiting_list/ui/widgets/button.dart';
import 'package:waiting_list/ui/widgets/puppyTile.dart';
import '../controllers/puppy_controller.dart';
import '../services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _puppyController = Get.put(PuppyController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _puppyController.getPuppies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      // backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addPuppyBar(),
          _addDateBar(),
          const SizedBox(
            height: 15,
          ),
          _showPuppies(),
        ],
      ),
    );
  }

  _showPuppies() {
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: _puppyController.puppyList.length,
        itemBuilder: (_, index) {
          var puppy = _puppyController.puppyList[index];

          if(puppy.date==DateFormat.yMd().format(_selectedDate)){
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, puppy);
                          },
                          child: PuppyTile(puppy),
                        )
                      ],
                    ),
                  ),
                ));
          } else {
            return Container();
          }
        },
      );
    }));
  }

  _addPuppyBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(_selectedDate),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
              label: "+ Add Puppy",
              onTap: () async {
                await Get.to(AddPuppyPage());
                _addNotification();
                _puppyController.getPuppies();
              })
        ],
      ),
    );
  }

  void _addNotification() {
    NotifyHelper().displayNotification(
        title: "New Puppy ",
        body: "is added to the list");
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.indigo,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        onDateChange: (date) {
          setState((){
            _selectedDate = date;
          });
        },
      ),

    );
  }

  _showBottomSheet(BuildContext context, Puppy puppy) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: puppy.isServiced == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? Colors.black87 : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            Spacer(),
            puppy.isServiced == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Mark as Serviced",
                    onTap: () {
                      _puppyController.markAsServiced(puppy.id!);
                      Get.back();
                    },
                    clr: Colors.blueAccent,
                    context: context),
            _bottomSheetButton(
                label: "Delete Puppy",
                onTap: () {
                  _puppyController.deletePuppy(puppy);
                  Get.back();
                },
                clr: Colors.red[300]!,
                context: context),
            SizedBox(
              height: 20,
            ),
            _bottomSheetButton(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Colors.white,
                isClose: true,
                context: context),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true ? Colors.grey[400]! : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

_appBar() {
  return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          _changeThemeNotification();
        },
        child: const Icon(
          Icons.nightlight_round,
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

void _changeThemeNotification() {
  NotifyHelper().displayNotification(
      title: "Theme Changed",
      body: Get.isDarkMode
          ? "Activated Light Theme"
          : "Activate Dark Theme");
}
