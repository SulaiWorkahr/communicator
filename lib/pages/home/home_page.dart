import 'dart:convert';

import 'package:communicator/pages/Entry/add_entry_page.dart';
import 'package:communicator/pages/daily_status/daily_status_page.dart';
import 'package:communicator/pages/leave_approval/leave_approval_page.dart';
import 'package:communicator/pages/leave_balance_page.dart';
import 'package:communicator/pages/profile/profile_page.dart';
import 'package:communicator/widgets/heading_widget.dart';
import 'package:communicator/widgets/sub_heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../Entry/entry_list_page.dart';
import '../holidays/holiday_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
  String assignedBy = "";
  String role = "";

// Future<void> employeeDetails() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     String? userName = prefs.getString('username');
    
//     if (userName == null) {
//       showInSnackBar(context, 'Username not found');
//       return;
//     }
    
//     var result = await apiService.employeeDetails(userName);
    
//     // Parse the JSON string response
//     var parsedResult = jsonDecode(result);
    
//     // Check if parsedResult is valid and has expected structure
//     if (parsedResult != null && parsedResult.containsKey('status')) {
//       print(parsedResult);
      
//       // Convert status to String for comparison
//       String status = parsedResult['status'].toString();
      
//       if (status == 'Success') {
//         setState(()  {
//           // Safely access the nested structure
//           var dynamicData = parsedResult['dynamicData'] as List<dynamic>;
//           if (dynamicData.isNotEmpty) {
         
//             employeeList = List<Map<String, dynamic>>.from(dynamicData[0]);
//             name = employeeList![0]['EMPMST_NAME'];
//             location = employeeList![0]['EMPMST_LOCATION'];
//             department = employeeList![0]['PORTAL_DETARTMENT'];
//             assignedBy = employeeList![0]['EMPMST_REPORTING_MANAGER'];
//             role = employeeList![0]['PORTAL_ROLE'];

            

//           } else {
//             employeeList = null;
            
//           }
//           print(employeeList);
//         });
//           final prefs = await SharedPreferences.getInstance();
//             await prefs.setString('username', employeeList![0]['EMPMST_NAME'] ?? '');
//             await prefs.setString('role', employeeList![0]['PORTAL_ROLE'] ?? '');
//             await prefs.setString('location', employeeList![0]['EMPMST_LOCATION'] ?? '');
//             await prefs.setString('department', employeeList![0]['PORTAL_DETARTMENT'] ?? '');
//             await prefs.setString('approved_by', employeeList![0]['EMPMST_REPORTING_MANAGER'] ?? '');
//       } else {
//         setState(() {
//           employeeList = null;
//         });
//         showInSnackBar(context, status);
//       }
//     } else {
//       // Handle unexpected response structure
//       showInSnackBar(context, 'Unexpected response structure');
//     }
//   } catch (e) {
//     // Handle errors from the API call
//     print('Error fetching employee details: $e');
//     showInSnackBar(context, 'Error fetching employee details: $e');
//   }
// }


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


void showInSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: Text('Home')),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  SizedBox(height: 27.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubHeadingWidget(
                        title: 'Welcome',
                        vMargin: 1.0,
                        color: AppColors.dark,
                        fontSize: 17.0,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.light,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.lightGrey2, width: 1.0)),
                            child: Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.notifications, color: AppColors.dark,),
                  onPressed: () {
                    // Handle the notification icon press
                  },
                ),
                Positioned(
                  right: 10,
                  top: 4,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 6,
                      minHeight: 6,
                    ),
                    
                  ),
                )
              ])
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {

                              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProfilePage()));
                              
                            },
                            child: 
                            Image.asset(
                            AppAssets.profileIcon,
                            width: 43.0,
                            // height: 50.0,
                          ),
                          )
                          
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HeadingWidget(
                        title: name.toString(),
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      //margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                              color: AppColors.lightGrey2, width: 1)),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SubHeadingWidget(
                                  title: 'Role: ',
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: role.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 12.0,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SubHeadingWidget(
                                  title: 'Location: ',
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: location.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 11.0,
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SubHeadingWidget(
                                  title: 'Department: ',
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: department.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 12.0,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SubHeadingWidget(
                                  title: 'Assigned By: ',
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: assignedBy.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 11.0,
                                )
                              ],
                            )
                          ],
                        ),
                      ])),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    HeadingWidget(
                      title: 'Communicator',
                      vMargin: 1.0,
                      color: AppColors.darkBlue3,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    )
                  ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGridItem(() => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                DailyStatusPage())),
                          Image.asset(
                            AppAssets.dailyStatus,
                            width: 35.0,
                            // height: 50.0,
                          ),
                          'Daily\nStatus',
                          Icons.arrow_forward,
                        ),
                        _buildGridItem(() =>  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                LeaveBalancePage())),
                          Image.asset(
                            AppAssets.leaveCalender,
                            width: 35.0,
                            // height: 50.0,
                          ),
                          'Leave\nBalance',
                          Icons.arrow_forward,
                        ),
                      ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGridItem(() =>  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                HolidayListPage())),
                          Image.asset(
                            AppAssets.holidayList,
                            width: 35.0,
                            // height: 50.0,
                          ),
                          'Holiday\nList',
                          Icons.arrow_forward,
                        ),
                        _buildGridItem(() =>  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                EntryListPage())),
                          Image.asset(
                            AppAssets.viewEntry,
                            width: 35.0,
                            // height: 50.0,
                          ),
                          'View\nEntry',
                          Icons.arrow_forward,
                        )
                      ]),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildGridItem(() =>  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                LeaveApprovalPage())),
                          Image.asset(
                            AppAssets.leaveApproval,
                            width: 35.0,
                            // height: 50.0,
                          ),
                          'Leave\nApproval',
                          Icons.arrow_forward,
                        ),

                        

                        // _buildGridItem(  Image.asset(
                        //   AppAssets.addEntry,
                        //   width: 35.0,
                        //   // height: 50.0,
                        // ),'Add\nEntry',Icons.arrow_forward,)
                        GestureDetector(
                        onTap: () {
                           Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                AddEntryPage()));

                        },
                       child: Container(
                            width: MediaQuery.of(context).size.width * 0.43,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          AppAssets.addEntry,
                                          width: 35.0,
                                          // height: 50.0,
                                        )
                                      ]),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      HeadingWidget(
                                        title: 'Add\nEntry',
                                      ),

                                      // SizedBox(width: 40.0,),

                                      Container(
                                        height: 33.0,
                                        padding: EdgeInsets.all(4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.darkBlue3,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.light,
                                            size: 19.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))),
                      ])
                ]))));
  }

  Widget _buildGridItem(Function()? onTap,Widget image, String title, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [image]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeadingWidget(
                      title: title,
                    ),

                    // SizedBox(width: 40.0,),

                    IconButton(
                      icon: Icon(icon, color: AppColors.dark),
                      onPressed: onTap,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
