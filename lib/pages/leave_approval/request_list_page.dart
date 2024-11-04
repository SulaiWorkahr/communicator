import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/leave_approval_list_model.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../../widgets/button1_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_dropdown_widget1.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../profile/profile_page.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  
  final CommunicatorApiService apiService = CommunicatorApiService();


   @override
  void initState() {
    getAllLeaveApproval();
    selectedStatusArray();
    
    
    super.initState();
  }

  selectedStatusArray() {
  
 List result;
  
       if(statusList.isNotEmpty){
         setState(() {
          selectedStatusArr = statusList[0];
        });

       }
       else{

         selectedStatusArr = null;

       }
  
    }

    String formatDate(String dateStr) {
  final DateTime date = DateTime.parse(dateStr);
  return DateFormat('dd-MM-yyyy').format(date);
}


   String formatDate1(String dateStr) {
  final DateTime date = DateTime.parse(dateStr);
  return DateFormat('yyyy-MM-dd').format(date);
}


   var selectedStatusArr;
  List statusList = [
    {'name': "All", 'id': 1},
  ];

  int _currentPage = 1;
  final int _totalPages = 10;


  
  Future requestAction(String type, LeaveApprovalData? data) async {
   
  // DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(data!.leaveAppliedOn.toString());

  // // Format the date to yyyy-MM-dd
  // String leaveAppliedon = DateFormat('yyyy-MM-dd').format(parsedDate);

      
    Map<String, dynamic> postData = {
    "MID": data!.mid,
    "EMP_NAME": data.empName,
    "EMP_DEPT": data.empDept,
    "EMP_LOCATION": data.empLocation,
    "LEAVE_TYPE": data.leaveType,
    "LEAVE_APPLIED_ON": formatDate1(data.leaveAppliedOn.toString()),
    "HALF_FULL_DAY": data.halfFullDay,
    "APPROVED_BY": data.approvedBy,
    "REMARKS": data.remarks,
    "START_DATE": formatDate1(data.startDate.toString()),
    "END_DATE": formatDate1(data.endDate.toString()),
    "NO_OF_DAYS": data.noOfDays,
    "APPROVAL_STATUS": type.toString(),
    "REJECTION_REMARKS": ""

    };

    var result = await apiService.requestAction(postData);
   

    if (result["Status"].toString() == 'Success') {
      showInSnackBar(context, result["message"].toString());
       Navigator.pop(context, {'update': true});
       getAllLeaveApproval();
    } else {
      print(result["message"].toString());
      showInSnackBar(context, result["message"].toString());
    }
    //}
    //  else {
    //   showInSnackBar(context, "Please fill all fields");
    // }
  }



void _showActionDialog(BuildContext context, LeaveApprovalData? requestList) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
       double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define the base widths and heights
    double baseRoundedButtonWidth = 90.0;
    double baseRoundedButtonHeight = 45.0;
    double baseButtonWidth = 100.0;
    double baseButtonHeight = 35.0;

    // Calculate the new dimensions based on screen size
    double roundedButtonWidth = screenWidth * (baseRoundedButtonWidth / 375); // Assuming base screen width is 375
    double roundedButtonHeight = screenHeight * (baseRoundedButtonHeight / 805); // Assuming base screen height is 667
    double buttonWidth = screenWidth * (baseButtonWidth / 375); // Assuming base screen width is 375
    double buttonHeight = screenHeight * (baseButtonHeight / 667);
      return AlertDialog(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        surfaceTintColor:Colors.white ,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Center(
          child: HeadingWidget(
            title: 'Please Choose One',
            color: AppColors.darkBlue3,
            fontSize: 18.0,
          )
        ),
        actions: <Widget>[
            Padding(padding: EdgeInsets.all(8.0),
          child: 
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

          //       RoundedButtonWidget(
          //   title: "Cancel",
          //   width: roundedButtonWidth,
          //   height: roundedButtonHeight,
          //   fontSize: 16.0,
          //   titleColor: AppColors.grey,
          //   borderColor: AppColors.grey ,
          //   onTap: () {
          //     Navigator.of(context).pop();
              
          //   },
          // ),

            Button1Widget(
                          title: 'Rejected',
                          width: MediaQuery.of(context).size.width * (20/80),
                          height: MediaQuery.of(context).size.height * (20/370),
                          color: AppColors.darkRed,
                          titleColor:  AppColors.light,
                          borderRadius: 12.0,
                          borderColor: AppColors.darkRed,
                          fontWeight: FontWeight.bold,
                          onTap: (){
                            requestAction("R",requestList);
                            Navigator.of(context).pop();
                          }
                          ),
          ButtonWidget(
              title: 'Approved',
              width: buttonWidth,
              height: buttonHeight,
              color: AppColors.green,
              borderRadius: 10.0,
              onTap: (){

                 requestAction("A",requestList);

                  // checkOut = true;
                  Navigator.of(context).pop();
                  
          
              }
              ),
              ]
            )
          )
            )
          

        ],
      );
    },
  );
}


 List<LeaveApprovalData>? requestList;
  List<LeaveApprovalData>? requestListAll;

  String userName = "";

  Future getAllLeaveApproval() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username') ?? '';

    var result = await apiService.getAllLeaveApproval();
    var response = leaveApprovalListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        requestListAll = response.response;

        requestList = requestListAll!.where((entry) {
          String? employeeName = entry.approvedBy;
          String? status = entry.approvalStatus;
          if (employeeName != null) {
            print(employeeName);
            return employeeName == userName && status == "P";
          }
          return false;
        }).toList();

        print('requestList ${requestList}');
      });
    } else {
      setState(() {
        requestList = [];
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('')),
    body: requestList == null
        ? Center(child: CircularProgressIndicator())
        : requestList!.isEmpty
            ? Center(child: Text('No requests found.'))
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
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingWidget(
                            title: 'Request List',
                            vMargin: 1.0,
                            color: AppColors.darkBlue3,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          // CustomDropdownWidget1(
                          //   //labelText: 'Payment Mode',
                          //   selectedItem: selectedStatusArr,
                          //   borderColor: AppColors.lightGrey2,
                          //   height: 35.0,
                          //   width: 125.0,
                          //   valArr: statusList,
                          //   itemAsString: (p0) => p0['name'],
                          //   onChanged: (value) {
                          //     print('value $value');
                          //     //selectedPaymentMode = value;
                          //     // selectedPaymentMode = value['id'];
                          //   },
                          // ),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: requestList!.length,
                        itemBuilder: (context, index) {
                          var request = requestList![index];
                          return Container(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      HeadingWidget(
                                        title: request.empName,
                                        vMargin: 1.0,
                                        color: AppColors.darkBlue3,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                      ButtonWidget(
                                        title: 'Action',
                                        width: 90.0,
                                        height: 35.0,
                                        color: AppColors.darkBlue3,
                                        borderRadius: 10.0,
                                        titleFS: 14.0,
                                        onTap: () {
                                          _showActionDialog(context,request);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        // width: 90.0,
                                        // height: 25.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: SubHeadingWidget(
                                            title: request.leaveType,
                                            color: AppColors.grey1,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      Container(
                                        // width: 125.0,
                                        // height: 25.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: SubHeadingWidget(
                                            title: request.remarks ?? 'No Remarks',
                                            color: AppColors.grey1,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          HeadingWidget(
                                            title: formatDate(request.startDate.toString()) ,
                                            vMargin: 1.0,
                                            color: AppColors.darkBlue3,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                          ),
                                          SizedBox(width: 5.0),
                                          SubHeadingWidget(title: "To", fontSize: 12.0),
                                          SizedBox(width: 5.0),
                                          HeadingWidget(
                                            title: formatDate(request.endDate.toString()),
                                            vMargin: 1.0,
                                            color: AppColors.darkBlue3,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SubHeadingWidget(
                                            title: "No Of Days:",
                                            fontSize: 12.0,
                                          ),
                                          SizedBox(width: 3.0),
                                          HeadingWidget(
                                            title: request.noOfDays.toString(),
                                            vMargin: 1.0,
                                            color: AppColors.darkBlue3,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                          ),
                                        ],
                                      ),
                                      HeadingWidget(
                                        title: formatDate(request.leaveAppliedOn.toString()),
                                        vMargin: 1.0,
                                        color: AppColors.darkBlue3,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                      ),
                                    ],
                                  ),
                                ],
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
  shadowColor: AppColors.light,
  surfaceTintColor: AppColors.light,
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
                  if (i == 1 ||
                      i == _totalPages ||
                      (i >= _currentPage - 1 && i <= _currentPage + 1))
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
          value: _currentPage,
          items: List.generate(_totalPages, (index) {
            int pageNumber = index + 1;
            return DropdownMenuItem(
              value: pageNumber,
              child: Text(pageNumber.toString()),
            );
          }),
          onChanged: (value) {
            setState(() {
              _currentPage = value!;
            });
          },
        ),
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
      });
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: _currentPage == page ? AppColors.darkBlue3 : Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        page.toString(),
        style: TextStyle(
          color: _currentPage == page ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}
}