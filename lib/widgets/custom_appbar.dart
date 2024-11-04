import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../controllers/base_controller.dart';
import 'heading_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool? isDarkModeEnabled = false;
  final Function()? onPressed;
  Widget? leading;
  CustomAppBar(
      {super.key, required this.title, this.isDarkModeEnabled, this.onPressed, this.leading});
  BaseController baseCtrl = Get.put(BaseController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      // foregroundColor: AppColors.light,
      // backgroundColor: AppColors.lightGrey1,
      centerTitle: true,
      leading: leading,
      title: HeadingWidget(
        title: title.toString(),
        color: AppColors.dark,
        fontSize: 18.0,
      ),
      actions: <Widget>[
        // IconButton(
        //     icon: Icon(isDarkModeEnabled == true
        //         ? Icons.wb_sunny
        //         : Icons.nightlight_round),
        //     // onPressed: () {
        //     //   baseCtrl.isDarkModeEnabled.value =
        //     //       !baseCtrl.isDarkModeEnabled.value;
        //     //   print(
        //     //       'baseCtrl isDarkModeEnabled ${baseCtrl.isDarkModeEnabled.value}');
        //     // }),
        // onPressed: onPressed),
        // IconButton(
        //     onPressed: () async {
        //       final pref = await SharedPreferences.getInstance();
        //       await pref.clear();
        //       Navigator.pushNamed(context, '/login');
        //     },
        //     icon: Icon(Icons.logout_rounded)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
