import 'dart:convert';

import 'package:communicator/widgets/heading_widget.dart';
import 'package:communicator/widgets/sub_heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../../widgets/button1_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/rounded_button_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

 final CommunicatorApiService apiService = CommunicatorApiService();

 


@override
  void initState() {
    super.initState();
     employeeDetails();
  }

  List<Map<String, dynamic>>? employeeList;
  String name = "";
  String location = "";
  String department = "";
  String designation = "";
  String assignedBy = "";
  String role = "";
  String dateOfJoining = "";
  String dob = "";
DateTime? dob1;
DateTime? dateOfJoinings;

Future<void> employeeDetails() async {
  if (!mounted) return;

  try {
    final prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');

    if (userName == null) {
      if (mounted) showInSnackBar(context, 'Username not found');
      return;
    }

    var result = await apiService.employeeDetails(userName);

    var parsedResult = jsonDecode(result);

    if (parsedResult != null && parsedResult.containsKey('status')) {
      String status = parsedResult['status'].toString();

      if (status == 'Success') {
        if (!mounted) return;

        setState(() {
          var dynamicData = parsedResult['dynamicData'] as List<dynamic>;
          if (dynamicData.isNotEmpty) {
            employeeList = List<Map<String, dynamic>>.from(dynamicData[0]);
            name = employeeList![0]['EMPMST_NAME'];
            location = employeeList![0]['EMPMST_LOCATION'];
            department = employeeList![0]['PORTAL_DETARTMENT'];
            assignedBy = employeeList![0]['EMPMST_REPORTING_MANAGER'];
            role = employeeList![0]['PORTAL_ROLE'];
            designation = employeeList![0]['DESIGNATION'];
            dob = employeeList![0]['DOB'];
            dateOfJoining = employeeList![0]['DOJ'];
             dob1 = DateTime.parse(dob);
             dateOfJoinings = DateTime.parse(dateOfJoining);
          } else {
            employeeList = null;
          }
        });

        // Save to SharedPreferences only if the widget is still mounted
        if (mounted && employeeList != null) {
          await prefs.setString('username', employeeList![0]['EMPMST_NAME'] ?? '');
          await prefs.setString('role', employeeList![0]['PORTAL_ROLE'] ?? '');
          await prefs.setString('location', employeeList![0]['EMPMST_LOCATION'] ?? '');
          await prefs.setString('department', employeeList![0]['PORTAL_DETARTMENT'] ?? '');
          await prefs.setString('approved_by', employeeList![0]['EMPMST_REPORTING_MANAGER'] ?? '');
        }

      } else {
        if (mounted) {
          setState(() {
            employeeList = null;
          });
          showInSnackBar(context, status);
        }
      }
    } else {
      if (mounted) showInSnackBar(context, 'Unexpected response structure');
    }
  } catch (e) {
    if (mounted) {
      print('Error fetching employee details: $e');
      showInSnackBar(context, 'Error fetching employee details: $e');
    }
  }
}

  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: HeadingWidget(title: "Logout", fontSize: 18.0,),
        content: HeadingWidget(title: "Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel", style: TextStyle(fontSize: 15.0)),
          ),
          TextButton(
            onPressed: () async {
              final pref = await SharedPreferences.getInstance();
              await pref.clear();
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                ModalRoute.withName('/login'),
              );
            },
            child: const Text("Logout", style: TextStyle(fontSize: 15.0)),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
  

// Parse the String to DateTime


    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  AppAssets.profileBackgroundIcon1,
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 130.0, 
                  left: MediaQuery.of(context).size.width / 2 - 60, 
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage(AppAssets.profileNewIcon),
                  ),
                ),
                Positioned(
                  top: 210.0, 
                  left: MediaQuery.of(context).size.width / 2 + 33, 
                  child: 
                  // CircleAvatar(
                  //   radius: 20,
                  //   backgroundColor: const Color.fromRGBO(111, 135, 160, 1),
                  //   child:  
                    IconButton(
                  icon: Image.asset(
                    AppAssets.cameraIcon, // Your custom asset image
                    width: 38.0,
                    height: 38.0,
                  ),
                  onPressed: () {
                    // Edit button action
                  },
                ),
                  ),
                //),
                Positioned(
                  top: 10.0, 
                  right: 10.0, 
                  child: Row(
                    children: [
                      IconButton(
                    icon: Icon(Icons.logout),
                    color: Colors.white,
                    onPressed: () async{
                      // Add your logout functionality here
                     _showLogoutDialog(context);
                    },
                  ),
                  //SizedBox(width: 2.0,),
                  GestureDetector(
                    onTap: () async {
                     
                        _showLogoutDialog(context);
                      
                    },
                    child: HeadingWidget(title: 'Logout', color: AppColors.light,)
                  )

                  

                    ],
                  )
                  
                ),
              ],
            ),
            SizedBox(height: 70), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 //SizedBox(width: 155), 
                HeadingWidget(
                  title: name.toString(),
                  color: AppColors.dark,
                  fontSize: 20.0,
                ),
                //SizedBox(width: 8),
                // IconButton(
                //   icon: Image.asset(
                //     AppAssets.editIcon, // Your custom asset image
                //     width: 25.0,
                //     height: 25.0,
                //   ),
                //   onPressed: () {
                //     // Edit button action
                //   },
                // ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HeadingWidget(
                        title: "Details",
                        color: AppColors.dark,
                        fontSize: 20.0,
                        vMargin: 1.0,
                      ),
                //       SizedBox(width: 4.0),
                //       IconButton(
                //       icon: Image.asset(
                //         AppAssets.editIcon, // Your custom asset image
                //         width: 25.0,
                //         height: 25.0,
                //       ),
                //       onPressed: () {
                //         // Edit button action
                //       },
                // ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.0,
                    color: AppColors.grey,
                  ),
                  SizedBox(height: 10.0),
                  HeadingWidget(
                    title: "Designation:",
                    color: AppColors.dark,
                    fontSize: 17.0,
                    vMargin: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  SubHeadingWidget(
                    title: designation.toString(),
                    color: AppColors.darkBlue,
                    fontSize: 16.0,
                    vMargin: 1.0,
                  ),
                  SizedBox(height: 10.0),
                  HeadingWidget(
                    title: "Branch:",
                    color: AppColors.dark,
                    fontSize: 17.0,
                    vMargin: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  SubHeadingWidget(
                    title: location.toString(),
                    color: AppColors.darkBlue,
                    fontSize: 16.0,
                    vMargin: 1.0,
                  ),
                  SizedBox(height: 10.0),
                  // HeadingWidget(
                  //   title: "Email id:",
                  //   color: AppColors.dark,
                  //   fontSize: 17.0,
                  //   vMargin: 1.0,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  // SubHeadingWidget(
                  //   title: 'example@gmail.com',
                  //   color: AppColors.darkBlue,
                  //   fontSize: 16.0,
                  //   vMargin: 1.0,
                  // ),
                  // SizedBox(height: 10.0),
                  HeadingWidget(
                    title: "Reporting Head:",
                    color: AppColors.dark,
                    fontSize: 17.0,
                    vMargin: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  SubHeadingWidget(
                    title: assignedBy.toString(),
                    color: AppColors.darkBlue,
                    fontSize: 16.0,
                    vMargin: 1.0,
                  ),
                  SizedBox(height: 10.0),
                  HeadingWidget(
                    title: "DOB:",
                    color: AppColors.dark,
                    fontSize: 17.0,
                    vMargin: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  if(dob1 != null)
                  SubHeadingWidget(
                    title: DateFormat('dd-MM-yyyy').format(dob1!).toString(),
                    color: AppColors.darkBlue,
                    fontSize: 16.0,
                    vMargin: 1.0,
                  ),
                  SizedBox(height: 10.0),
                  HeadingWidget(
                    title: "Joining Date:",
                    color: AppColors.dark,
                    fontSize: 17.0,
                    vMargin: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  if(dateOfJoinings != null)
                  SubHeadingWidget(
                    title: DateFormat('dd-MM-yyyy').format(dateOfJoinings!).toString(),
                    color: AppColors.darkBlue,
                    fontSize: 16.0,
                    vMargin: 1.0,
                  ),
                  SizedBox(height: 15.0)
                  // SizedBox(height: 30.0),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Button1Widget(
                  //       title: 'Cancel',
                  //       width: 110.0,
                  //       height: 34.0,
                  //       color: AppColors.light,
                  //       titleColor: AppColors.darkBlue3,
                  //       borderRadius: 20.0,
                  //       borderColor: AppColors.darkBlue3,
                  //       fontWeight: FontWeight.bold,
                  //       onTap: () {},
                  //     ),
                  //     SizedBox(width: 12.0),
                  //     ButtonWidget(
                  //       title: 'Save',
                  //       width: 110.0,
                  //       color: AppColors.darkBlue3,
                  //       borderRadius: 20.0,
                  //       height: 35.0,
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
