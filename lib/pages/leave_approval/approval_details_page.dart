import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/leave_approval_list_model.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../profile/profile_page.dart';

class ApprovalDetailsPage extends StatefulWidget {
 final String? type;
 final LeaveApprovalData? approvalData;
   ApprovalDetailsPage({super.key,this.type,this.approvalData});

  @override
  State<ApprovalDetailsPage> createState() => _ApprovalDetailsPageState();
}

class _ApprovalDetailsPageState extends State<ApprovalDetailsPage> {

  @override
  void initState() {
    employeeDetails();
    super.initState();
     
  }
 String role = "";
  String location = "";
  String department = "";

  Future employeeDetails() async {
  print('start');
  
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    role = prefs.getString('role') ?? '';
    location = prefs.getString('location') ?? '';
    department = prefs.getString('department') ?? '';
  });
  
  print('start1 $role');
  print('start2 $location');
  print('start3 $department');
}


  String formatDate(String dateStr) {
  final DateTime date = DateTime.parse(dateStr);
  return DateFormat('dd-MM-yyyy').format(date);
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        child: Stack(children: <Widget>[
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
                        ]),
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
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeadingWidget(
                    title: 'Details Of Approval',
                    vMargin: 1.0,
                    color: AppColors.darkBlue3,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ]
                ),
                SizedBox(height: 20.0),


                Container(
                          margin: EdgeInsets.only(bottom: 15.0),
          //width: MediaQuery.of(context).size.width * 0.43,
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

                if(widget.type == 'A')
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                             SubHeadingWidget(title: "Approved By: ${widget.approvalData!.approvedBy.toString()}", fontSize: 13.0, color: AppColors.success,),

                           SizedBox(width: 3.0,),

                       Image.asset(
                        AppAssets.approvedIcon,
                        width: 21.0,
                        // height: 50.0,
                      ),

                          ],
                        ),

                        if(widget.type == 'R')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                             SubHeadingWidget(title: "Rejected By: ${widget.approvalData!.approvedBy.toString()}", fontSize: 13.0, color: AppColors.darkRed,),

                           SizedBox(width: 3.0,),

                       Image.asset(
                        AppAssets.rejectedIcon,
                        width: 21.0,
                        // height: 50.0,
                      ),

                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          HeadingWidget(
                      title: widget.approvalData!.empName.toString(),
                      vMargin: 2.0,
                      color: AppColors.darkBlue3,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                          ]),

                          SizedBox(height: 10.0,),


                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                HeadingWidget(
                                  title: 'Role: ',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                   color: AppColors.darkGrey,
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: role.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                              ],
                            ),

                            SizedBox(width: 55.0),
                            Row(
                              children: [
                                HeadingWidget(
                                  title: 'Department: ',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: department.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 7.0,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            HeadingWidget(
                                  title: 'Location: ',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: location.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                          ],
                        ),

                         SizedBox(height: 20.0,),

               Divider(
                        height: 1,
                        thickness: 0.0,
                        color: AppColors.grey,
                      ),
                       SizedBox(height: 20.0,),

                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             Expanded(
                                    flex: 2,
                                    child:
                            HeadingWidget(
                                  title: 'Leave Type',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                             ),
                                // SizedBox(
                                //   width: 5.0,
                                // ),

                                Expanded(
                                    flex: 1,
                                    child: HeadingWidget(
                                      title: ":",
                                      vMargin: 3.0,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                 Expanded(
                                    flex: 5,
                                    child:
                                HeadingWidget(
                                  title: widget.approvalData!.leaveType.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                                 )
                          ],
                        ),

                        SizedBox(height: 10.0,),

                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Expanded(
                                    flex: 2,
                                    child:
                            HeadingWidget(
                                  title: 'Applied Date',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                                // SizedBox(
                                //   width: 5.0,
                                // ),

                                 Expanded(
                                    flex: 1,
                                    child: HeadingWidget(
                                      title: ":",
                                      vMargin: 3.0,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                   Expanded(
                                    flex: 5,
                                    child:
                                HeadingWidget(
                                  title: formatDate(widget.approvalData!.leaveAppliedOn.toString()),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                                   )
                          ],
                        ),

                         SizedBox(height: 10.0,),

                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                    flex: 2,
                                    child:
                            HeadingWidget(
                                  title: 'Remarks',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                            ),
                                // SizedBox(
                                //   width: 5.0,
                                // ),

                                   Expanded(
                                    flex: 1,
                                    child: HeadingWidget(
                                      title: ":",
                                      vMargin: 3.0,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                   Expanded(
                                    flex: 5,
                                    child:
                                HeadingWidget(
                                  title: widget.approvalData!.remarks.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                                   )
                          ],
                        ),

                          SizedBox(height: 10.0,),

                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Expanded(
                                    flex: 2,
                                    child:
                            HeadingWidget(
                                  title: 'Start Date',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                                // SizedBox(
                                //   width: 5.0,
                                // ),

                                  Expanded(
                                    flex: 1,
                                    child: HeadingWidget(
                                      title: ":",
                                      vMargin: 3.0,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                   Expanded(
                                    flex: 5,
                                    child:
                                HeadingWidget(
                                  title: formatDate(widget.approvalData!.startDate.toString()),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                                   )
                          ],
                        ),

                         SizedBox(height: 10.0,),

                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Expanded(
                                    flex: 2,
                                    child:
                            HeadingWidget(
                                  title: 'End Date',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                                // SizedBox(
                                //   width: 5.0,
                                // ),
                                  Expanded(
                                    flex: 1,
                                    child: HeadingWidget(
                                      title: ":",
                                      vMargin: 3.0,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                   Expanded(
                                    flex: 5,
                                    child:
                                HeadingWidget(
                                  title: formatDate(widget.approvalData!.endDate.toString()),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                                   )
                          ],
                        ),

                        SizedBox(height: 10.0,),

                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Expanded(
                                    flex: 2,
                                    child:
                            HeadingWidget(
                                  title: 'No of Days',
                                  fontSize: 12.0,
                                  vMargin: 1.0,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                                // SizedBox(
                                //   width: 5.0,
                                // ),
                                 Expanded(
                                    flex: 1,
                                    child: HeadingWidget(
                                      title: ":",
                                      vMargin: 3.0,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                   Expanded(
                                    flex: 5,
                                    child:
                                HeadingWidget(
                                  title: widget.approvalData!.noOfDays.toString(),
                                  color: AppColors.darkBlue3,
                                  fontSize: 13.0,
                                  vMargin: 1.0,
                                )
                                   )
                          ],
                        ),




                

              ]
            )
          )
                )

            ]
          )
        )
      )
    );
  }
}