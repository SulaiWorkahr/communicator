import 'package:communicator/pages/leave_approval/approval_details_page.dart';
import 'package:communicator/pages/leave_approval/request_list_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/leave_approval_list_model.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../../widgets/custom_dropdown_widget1.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../profile/profile_page.dart';

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({super.key});

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  final CommunicatorApiService apiService = CommunicatorApiService();

  @override
  void initState() {
    getAllLeaveApproval();
    selectedStatusArray();
    super.initState();
  }

  selectedStatusArray() {
    if (statusList.isNotEmpty) {
      setState(() {
        selectedStatusArr = statusList[0];
      });
    } else {
      selectedStatusArr = null;
    }
  }

  var selectedStatusArr;
  List statusList = [
    {'name': "All", 'id': 1},
     {'name': "Work From Home", 'id': 2},
     {'name': "Permission", 'id': 3},
     {'name': "Working Extra", 'id': 4},
     {'name': "Leave", 'id': 5},
     {'name': "Client Visit (Support)", 'id': 6},

  ];

  // int _currentPage = 1;
  // final int _totalPages = 10;

  List<LeaveApprovalData>? approvalList;
  List<LeaveApprovalData>? approvalList1;

  List<LeaveApprovalData>? approvalListAll;

  String userName = "";
  String role ="";

  Future getAllLeaveApproval() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username') ?? '';
    role = prefs.getString('role') ?? '';

    var result = await apiService.getAllLeaveApproval();
    var response = leaveApprovalListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        approvalListAll = response.response;

        approvalList = approvalListAll!.where((entry) {
          // String? employeeName = entry.approvedBy;
          String? employeeName = entry.empName;
            String? status = entry.approvalStatus;
          if (employeeName != null) {
            print(employeeName);
            // return employeeName == userName && status != "P";
            return employeeName == userName;
          }
          return false;
        }).toList();

          approvalList1 = approvalListAll!.where((entry) {
          String? employeeName = entry.approvedBy;
            String? status = entry.approvalStatus;
          if (employeeName != null) {
            print(employeeName);
            return employeeName == userName && status == "P";
          }
          return false;
        }).toList();

        print('approvalList ${approvalList}');
      });
    } else {
      setState(() {
        approvalList = [];
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }


  int _currentPage = 1;
int _itemsPerPage = 10; // Show 10 records per page

//Calculate the total number of pages
int get _totalPages => approvalList != null && approvalList!.isNotEmpty
    ? (approvalList!.length / _itemsPerPage).ceil()
    : 1;

// Function to get the items for the current page
  List<dynamic> _getPaginatedEntries() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return approvalList!.sublist(
      startIndex,
      endIndex > approvalList!.length ? approvalList!.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: approvalList == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    title: 'Leave Approval',
                    vMargin: 1.0,
                    color: AppColors.darkBlue3,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                  CustomDropdownWidget1(
                    //labelText: 'Payment Mode',
                    selectedItem: selectedStatusArr,
                    borderColor: AppColors.lightGrey2,
                    height: 35.0,
                    width: 145.0,
                    valArr: statusList,
                    itemAsString: (p0) => p0['name'],
                    onChanged: (value) {
                      print('value $value');
                      //selectedPaymentMode = value;
                      // selectedPaymentMode = value['id'];
                    },
                  ),
                ],
              ),

              SizedBox(height: 30.0,),

              if(role == "Manager")
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                RequestListPage()));
                    
                  },
              child: Stack(
          clipBehavior: Clip.none,
          children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: HeadingWidget(
                    title: 'Request',
                    vMargin: 1.0,
                    color: AppColors.darkBlue3,
                    //fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
        ),
        Positioned(
          top: -10,
          right: -10,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: 
          
            HeadingWidget(title: approvalList1!.length.toString(), color: AppColors.light, fontSize: 12.0,fontWeight: FontWeight.bold,)
            
          ),
        ),
      ],
    )
        )

                  

                ]
              ),
              if(role == "Manager")
               SizedBox(height: 30.0,),

               Divider(
                        height: 1,
                        thickness: 0.0,
                        color: AppColors.grey,
                      ),
                       SizedBox(height: 30.0,),

                    approvalList!.isEmpty
                        ? Center(child: Text('No leave approvals found.'))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            //itemCount: approvalList!.length,
                            itemCount: _getPaginatedEntries().length,
                            itemBuilder: (context, index) {
                              //final approval = approvalList![index];
                              final approval = _getPaginatedEntries()[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ApprovalDetailsPage(type: approval.approvalStatus,approvalData: approval),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15.0),
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
                                    child: 
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            HeadingWidget(
                                              title: approval.empName ?? '',
                                              vMargin: 2.0,
                                              color: AppColors.darkBlue3,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                SubHeadingWidget(
                                                  title: approval.approvalStatus == 'A'
                                                      ? "Approved By: ${approval.approvedBy ?? ''}"
                                                      : "Rejected By: ${approval.approvedBy ?? ''}",
                                                  fontSize: 13.0,
                                                  color: approval.approvalStatus == 'A'
                                                      ? AppColors.success
                                                      : AppColors.darkRed,
                                                ),
                                                SizedBox(width: 3.0),
                                                Image.asset(
                                                  approval.approvalStatus == 'A'
                                                      ? AppAssets.approvedIcon
                                                      : AppAssets.rejectedIcon,
                                                  width: 21.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              // width: 80.0,
                                              // height: 26.0,
                                              padding: EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                color: AppColors.background,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Center(
                                                child: SubHeadingWidget(
                                                  title: approval.leaveType ?? '',
                                                  color: AppColors.grey1,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                            HeadingWidget(
                                              title: DateFormat('dd-MM-yyyy').format(approval.leaveAppliedOn),
                                              vMargin: 2.0,
                                              color: AppColors.darkBlue3,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
     bottomNavigationBar: BottomAppBar(
      elevation: 0,
      color: AppColors.light,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 15.0),
              onPressed: _currentPage > 1
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= _totalPages; i++)
                      if (i == 1 || i == _totalPages || (i >= _currentPage - 1 && i <= _currentPage + 1))
                        _pageButton(i)
                      else if (i == 2 || i == _totalPages - 1)
                        Text('...')
                      else
                        Container(),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 15.0),
              onPressed: _currentPage < _totalPages
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
            ),
            SizedBox(width: 10),
            Text('Page'),
            SizedBox(width: 5),
            DropdownButton<int>(
              value: _currentPage != null ? _currentPage : 1, // Fallback to page 1 if null
              items: List.generate(_totalPages, (index) {
                int pageNumber = index + 1;
                return DropdownMenuItem(
                  value: pageNumber,
                  child: Text(pageNumber.toString()),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _currentPage = value ?? 1; // Fallback to page 1 if value is null
                });
              },
            )

          ],
        ),
      ),
    ),
    );
  }

  Widget _pageButton(int page) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPage = page;
          getAllLeaveApproval(); // Fetch the new page data
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: _currentPage == page ? AppColors.darkBlue : AppColors.light,
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            color: _currentPage == page ? AppColors.light : AppColors.darkBlue3,
          ),
        ),
      ),
    );
  }
}
