import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../services/communicator_api_service.dart';
import '../widgets/heading_widget.dart';
import '../widgets/sub_heading_widget.dart';
import 'profile/profile_page.dart';

class LeaveBalancePage extends StatefulWidget {
  const LeaveBalancePage({super.key});

  @override
  State<LeaveBalancePage> createState() => _LeaveBalancePageState();
}

class _LeaveBalancePageState extends State<LeaveBalancePage> {

final CommunicatorApiService apiService = CommunicatorApiService();

 


@override
  void initState() {
    super.initState();
     getAllLeaveBalance();
  }

  List<dynamic>? leaveBalanceList;
  List<dynamic>? data;

 String? userName ="";

List<Map<String, dynamic>>? leaveBalances; 
   bool isLoading = false;


Future<void> getAllLeaveBalance() async {
    setState(() {
      isLoading = true;
    });
  try {
    final prefs = await SharedPreferences.getInstance();
     userName = prefs.getString('username');

    var result = await apiService.getAllLeaveBalance();

    // Parse the JSON string response
    var parsedResult = jsonDecode(result);

    // Check if parsedResult is valid and has expected structure
    if (parsedResult != null && parsedResult.containsKey('status')) {
      print(parsedResult);

      // Convert status to String for comparison
      String status = parsedResult['status'].toString();

      if (status == 'Success') {
        setState(() {
          // Safely access the nested structure
          var dynamicData = parsedResult['dynamicData'] as List<dynamic>;
          if (dynamicData.isNotEmpty) {
            data = List<dynamic>.from(dynamicData[0]);
           

            leaveBalanceList = data!.where((entry) {
              return entry['EMPMST_NAME'] == userName;
            }).toList();
             print('leaveBalanceList ${leaveBalanceList}');

            // Extract LEAVE_BALANCE for the matched entry
             if (leaveBalanceList!.isNotEmpty) {
              var leaveBalanceStr = leaveBalanceList![0]['LEAVE_BALANCE'];
              if (leaveBalanceStr != null) {
                leaveBalances = (jsonDecode(leaveBalanceStr) as List<dynamic>).map<Map<String, dynamic>>((item) {
                  return Map<String, dynamic>.from(item);
                }).toList();
              }
            }

            print('leaveBalanceList $leaveBalanceList');
            print('leaveBalances $leaveBalances');
          } else {
            data = null;
          }
          print(data);
      isLoading = false;

        });
      } else {
        setState(() {
          leaveBalanceList = null;
          isLoading = false;
        });
        showInSnackBar(context, status);
      }
    } else {
      isLoading = false;
      // Handle unexpected response structure
      showInSnackBar(context, 'Unexpected response structure');
    }
  } catch (e) {
    // Handle errors from the API call
    print('Error fetching employee details: $e');
    showInSnackBar(context, 'Error fetching employee details: $e');
  }
}

void showInSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
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
                          ],
                        ),
                      ),
                      SizedBox(width: 10.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfilePage(),
                            ),
                          );
                        },
                        child: Image.asset(
                          AppAssets.profileIcon,
                          width: 43.0,
                          // height: 50.0,
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
                    fontSize: 22.0,
                  )
                ],
              ),
              SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HeadingWidget(
                    title: 'Leave Balance',
                    vMargin: 1.0,
                    color: AppColors.darkBlue3,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ],
              ),
              SizedBox(height: 18.0),
             isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.lightGrey2, width: 1.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Table(
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: AppColors.lightGrey2, width: 1.0),
                      ),
                      defaultColumnWidth: FixedColumnWidth(120.0),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: AppColors.darkBlue3),
                          children: [
                            _buildTableHeader('Leave Type'),
                            _buildTableHeader('Allocated'),
                            _buildTableHeader('Leave Taken'),
                            _buildTableHeader('Leave Balance'),
                          ],
                        ),
                         if(leaveBalances != null)

                       // _buildTableRow('Casual Leave', '4', '4', '3'),
                        _buildTableRow('Sick Leave', leaveBalances![0]["sick_leave"]["sick_leave_total"], leaveBalances![0]["sick_leave"]["Leave_take"], leaveBalances![0]["sick_leave"]["balance_leave"]),
                        if(leaveBalances != null)
                        _buildTableRow('Compensatory', leaveBalances![0]["compensatory_leave"]["compensatory_leave_total"], leaveBalances![0]["compensatory_leave"]["Leave_take"], leaveBalances![0]["compensatory_leave"]["balance_leave"]),
                        if(leaveBalances != null)
                        _buildTableRow('Unpaid Leave', leaveBalances![0]["unpaid_leave"]["unpaid_leave_total"], leaveBalances![0]["unpaid_leave"]["Leave_take"], leaveBalances![0]["unpaid_leave"]["balance_leave"]),
                        if(leaveBalances != null && leaveBalances![0]["annual_leave"] != null)
                        _buildTableRow('Annual Leave', leaveBalances![0]["annual_leave"]["annual_leave_total"], leaveBalances![0]["annual_leave"]["Leave_take"], leaveBalances![0]["annual_leave"]["balance_leave"]),
                        if(leaveBalances != null)
                        _buildTableRow('Work From Home', leaveBalances![0]["work_from_home"]["work_from_home_total"], leaveBalances![0]["work_from_home"]["Leave_take"], leaveBalances![0]["work_from_home"]["balance_leave"]),



                        // _buildTableRow('Carry Forward', '12', '12', '1'),
                        // _buildTableRow('Unpaid', '11', '11', '4'),
                        // _buildTableRow('WFH', '1', '1', '5'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(dynamic leaveType, dynamic allocated, dynamic leaveTaken1, dynamic leaveBalance) {
    return TableRow(
      children: [
        _buildTableCell(leaveType),
        _buildTableCell(allocated),
        _buildTableCell(leaveTaken1),
        _buildTableCell(leaveBalance),
      ],
    );
  }

  Widget _buildTableHeader(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.light,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      alignment: Alignment.center,
      child: Text(text),
    );
  }
}
