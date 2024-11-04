import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../profile/profile_page.dart';

class DailyStatusPage extends StatefulWidget {
  const DailyStatusPage({super.key});

  @override
  State<DailyStatusPage> createState() => _DailyStatusPageState();
}

class _DailyStatusPageState extends State<DailyStatusPage> {
  final CommunicatorApiService apiService = CommunicatorApiService();

  @override
  void initState() {
    super.initState();
    getAllDailyStatus();
  }

  List<Map<String, dynamic>> entries = [
    {
      "name": "Muhammad",
      "status1": "Casual Leave",
      "status2": "Other",
      "time": "10:00 AM",
      "image": AppAssets.profileIcon,
      "width": 85.0
    },
    {
      "name": "John.H",
      "status1": "Work From Home",
      "status2": "Check in",
      "time": "10:05 AM",
      "image": AppAssets.profileIcon,
      "width": 120.0
    },
    {
      "name": "Rohan",
      "status1": "Work From Home",
      "status2": "Check in",
      "time": "10:05 AM",
      "image": AppAssets.profileIcon,
      "width": 120.0
    },
    {
      "name": "Krishna",
      "status1": "Sick Leave",
      "status2": "Not Well",
      "time": "07:00 AM",
      "image": AppAssets.profileIcon,
      "width": 80.0
    },
    {
      "name": "John.H",
      "status1": "Work From Home",
      "status2": "Check out",
      "time": "07:05 PM",
      "image": AppAssets.profileIcon,
      "width": 120.0
    },
  ];

  List<dynamic> statusList = [];
   String userName="";
   bool isLoading = false;



  Future getAllDailyStatus() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
     userName = prefs.getString('username') ?? '';

  Map<String, dynamic> postData = {
    "EMPNAME": "",
    "FILTER": "ALL"
  };
  var result = await apiService.getAllDailyStatus(postData);
  print(result);
  var response = result;
  if (response['status'].toString() == 'Success') {
    setState(() {
      List<dynamic> data = response['dynamicData'][0];
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      statusList = data.where((entry) {
        String? checkInTime = entry['CHECK_IN_TIME'];
        if (checkInTime != null) {
          String entryDate = checkInTime.split('T')[0];
          print(entryDate);
          return entryDate == todayDate;
        }
        return false;
      }).toList();
      print('statusList $statusList');
      isLoading = false;
    });
  } else {
     setState(() {
        isLoading = false;
      });
    showInSnackBar(context, response['message'].toString());
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
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
                            color: AppColors.lightGrey2,
                            width: 1.0,
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.notifications,
                                color: AppColors.dark,
                              ),
                              onPressed: () {
                                // Handle the notification icon press
                              },
                            ),
                            Positioned(
                              right: 10,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 6,
                                  minHeight: 6,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfilePage()),
                          );
                        },
                        child: Image.asset(
                          AppAssets.profileIcon,
                          width: 43.0,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HeadingWidget(
                    title: userName.toString(),
                    vMargin: 1.0,
                    color: AppColors.dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  )
                ],
              ),
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeadingWidget(
                    title: 'Daily Status',
                    vMargin: 1.0,
                    color: AppColors.darkBlue3,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                  SubHeadingWidget(
                    title: 'Today',
                    fontSize: 13.0,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                children: statusList.map((entry) {
               String checkInTime = 'N/A';

                  if (entry['CHECK_IN_TIME'] != null) {
                    String timeParts = entry['CHECK_IN_TIME'].split('T')[1];
                    
                      checkInTime = timeParts;
                  
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15.0),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HeadingWidget(
                                title: entry['EMP_NAME'],
                                vMargin: 2.0,
                                color: AppColors.darkBlue3,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                              ),
                              Image.asset(
                                AppAssets.profileIcon,
                                width: 33.0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    // width: 120.0,
                                    // height: 37.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: SubHeadingWidget(
                                        title: entry['TYPE'],
                                        color: AppColors.grey1,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 7.0),
                                  Container(
                                     width: 135.0,
                                    // height: 37.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: SubHeadingWidget(
                                        title: entry['REASON'],
                                        color: AppColors.grey1,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SubHeadingWidget(
                                title: checkInTime.toString(),
                                fontSize: 13.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
