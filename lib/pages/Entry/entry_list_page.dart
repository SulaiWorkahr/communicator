import 'package:communicator/pages/Entry/add_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/client_visit_list_model.dart';
import '../../models/leave_list_model.dart';
import '../../models/permission_list_model.dart';
import '../../models/workfrom_home_delete_model.dart';
import '../../models/workfrom_home_list_model.dart';
import '../../models/working_extra_list_model.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../../widgets/button1_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_dropdown_widget.dart';
import '../../widgets/custom_dropdown_widget1.dart';
import '../../widgets/custom_rounded_textfield.dart';
import '../../widgets/group_chip_widget.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/rounded_button_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../profile/profile_page.dart';

class EntryListPage extends StatefulWidget {
  const EntryListPage({super.key});

  @override
  State<EntryListPage> createState() => _EntryListPageState();
}

class _EntryListPageState extends State<EntryListPage> {
  final CommunicatorApiService apiService = CommunicatorApiService();

  TextEditingController dobCtrl = TextEditingController();
  TextEditingController dob1Ctrl = TextEditingController();

//  int _currentPage = 1;
  //final int _totalPages = 10;

  DateTime selectedDate = DateTime.now();
  DateTime? _selectedDate;
  DateTime _focusedDate = DateTime.now();
  var selectedStatusArr;
  var selectedStatusArr1;

  List statusList = [
    {'name': "All", 'id': 1},
    {'name': "Work From Home", 'id': 2},
    {'name': "Permission", 'id': 3},
    {'name': "Working Extra", 'id': 4},
    {'name': "Leave", 'id': 5},
    {'name': "Client Visit (Support)", 'id': 6},
  ];

  var selectedFilterStatusArr;
  List filterStatusList = [
    {'name': "All", 'id': 1},
    {'name': "Work From Home", 'id': 2},
    {'name': "Permission", 'id': 3},
    {'name': "Working Extra", 'id': 4},
    {'name': "Leave", 'id': 5},
    {'name': "Client Visit (Support)", 'id': 6},
  ];

  String selectedMonth = "";

  List status1List = [
  {'name': "January", 'id': 1},
  {'name': "February", 'id': 2},
  {'name': "March", 'id': 3},
  {'name': "April", 'id': 4},
  {'name': "May", 'id': 5},
  {'name': "June", 'id': 6},
  {'name': "July", 'id': 7},
  {'name': "August", 'id': 8},
  {'name': "September", 'id': 9},
  {'name': "October", 'id': 10},
  {'name': "November", 'id': 11},
  {'name': "December", 'id': 12},
];


  @override
  void initState() {
    //updateMonthName();
    selectedStatusArray();
    selectedFilterStatusArray();
    getAllEntryList();

    super.initState();
  }

  void updateMonthName() {
    // Get current month name using DateTime and DateFormat
    String currentMonth = DateFormat.MMMM().format(DateTime.now());

    // Update the 'name' field in the list
    setState(() {
      status1List[0]['name'] = currentMonth;
    });
  }

  void filterEntriesByMonth(String selectedMonthName) {
    // Define a map to convert month names to their corresponding month numbers
    const monthMap = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    // Get the month number from the month name
    int selectedMonth = monthMap[selectedMonthName] ??
        DateTime.now().month; // Default to current month
    int selectedYear =
        DateTime.now().year; // Assuming you want to filter for the current year

    // Filter the entry list based on the selected month and year
    entryList = entryList!.where((entry) {
      // Check if DATE is null
      if (entry["DATE"] == null) {
        return false; // Skip this entry if DATE is null
      }

      // Parse DATE string to DateTime
      DateTime entryDate = DateTime.parse(entry["DATE"]);

      // Check if the entry's month and year match the selected month and year
      return entryDate.month == selectedMonth;
    }).toList();

    // Optionally sort the filtered entries by DATE in descending order
    entryList!.sort((a, b) {
      return b["DATE"].compareTo(a["DATE"]); // For descending order
    });

    print("Filtered EntryList: $entryList");
  }

  List? entryList;

  Future getAllEntryList() async {
    // if (dobCtrl.text != "") {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    //   DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

    // // Format the date to yyyy-MM-dd
    // String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    Map<String, dynamic> postData = {
      "EMPNAME": userName.toString(),
      "FILTER": "ALL"
    };

    var result = await apiService.getAllEntryList(postData);

    //AddEntryLeaveModel response = addEntryLeaveModelFromJson(result);
    var response = result;
    if (response['status'].toString() == 'Success') {
      //showInSnackBar(context, response['message'].toString());
      setState(() {
        entryList = response['dynamicData'][0];
        workFromHomeList = null;
        leaveList = null;
        permissionList = null;
        workinExtraList = null;
        clientVisitList = null;

        if (selectedMonth != "") {
          filterEntriesByMonth(selectedMonth);
        }

        if (selectedFilterId == 1) {
          print('selectedFilterid: $selectedFilterId');
          DateTime startDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(dob1Ctrl.text);

          entryList = entryList!.where((entry) {
            // Check if WORKED_ON is null
            if (entry["WORKED_ON"] == null) {
              return false; // Skip this entry if WORKED_ON is null
            }

            DateTime workedOnDate = DateTime.parse(
                entry["WORKED_ON"]); // Parse WORKED_ON string to DateTime

            // Optionally, format it to dd-MM-yyyy if you need to display it in this format
            String formattedWorkedOnDate =
                DateFormat('dd-MM-yyyy').format(workedOnDate);

            return (workedOnDate.isAfter(startDate) &&
                    workedOnDate.isBefore(endDate)) ||
                workedOnDate.isAtSameMomentAs(startDate) ||
                workedOnDate.isAtSameMomentAs(endDate);
          }).toList();
        }
        _totalPages = (entryList!.length / _itemsPerPage).ceil();
        entryList!.sort((a, b) {
          return b["DATE"].compareTo(
              a["DATE"]); // For ascending order, use a.date.compareTo(b.date)
        });
        print("EntryList ${entryList}");
      });
    } else {
      print(response['message'].toString());
      showInSnackBar(context, response['message'].toString());
    }
    // }
    //  else {
    //   showInSnackBar(context, "Please fill all fields");
    // }
  }

  List<WorkfromHomeListData>? workFromHomeList;
  List<WorkfromHomeListData>? workFromHomeListAll;

  Future getAllWorkFromHome(String? type) async {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComWorkfromhome';

    var result = await apiService.get(apiUrl);
    var response = workfromHomeListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        print('workFromHomeList ${workFromHomeList}');

        workFromHomeListAll = response.response;
        entryList = null;
        leaveList = null;
        permissionList = null;
        workinExtraList = null;
        clientVisitList = null;

        workFromHomeList = workFromHomeListAll!.where((entry) {
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase();
          }
          return false;
        }).toList();

        if (type == "WorkFromHome") {
          DateTime startDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(dob1Ctrl.text);

          workFromHomeList = workFromHomeList!.where((entry) {
            String formattedWorkedOnDate =
                DateFormat('dd-MM-yyyy').format(entry.workedOn);
            DateTime workedOnDate =
                DateFormat('dd-MM-yyyy').parse(formattedWorkedOnDate);

            return (workedOnDate.isAfter(startDate) &&
                    workedOnDate.isBefore(endDate)) ||
                workedOnDate.isAtSameMomentAs(startDate) ||
                workedOnDate.isAtSameMomentAs(endDate);
          }).toList();
        }
        workFromHomeList!.sort((a, b) {
          return b.workedOn.compareTo(
              a.workedOn); // For ascending order, use a.date.compareTo(b.date)
        });
        _totalPagesWorkFromHome =
            (workFromHomeList!.length / _itemsPerPage).ceil();
      });
    } else {
      setState(() {
        workFromHomeList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<LeaveListData>? leaveList;
  List<LeaveListData>? leaveListAll;

  Future getAllLeaveList() async {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComLeave';

    var result = await apiService.get(apiUrl);
    var response = leaveListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        leaveListAll = response.response;
        print('LeaveList ${leaveList}');
        entryList = null;
        workFromHomeList = null;
        permissionList = null;
        workinExtraList = null;
        clientVisitList = null;

        leaveList = leaveListAll!.where((entry) {
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase();
          }
          return false;
        }).toList();

        if (selectedFilterId == 5) {
          DateTime startDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(dob1Ctrl.text);

          leaveList = leaveList!.where((entry) {
            String formattedWorkedOnDate =
                DateFormat('dd-MM-yyyy').format(entry.leaveAppliedOn);
            DateTime workedOnDate =
                DateFormat('dd-MM-yyyy').parse(formattedWorkedOnDate);

            return (workedOnDate.isAfter(startDate) &&
                    workedOnDate.isBefore(endDate)) ||
                workedOnDate.isAtSameMomentAs(startDate) ||
                workedOnDate.isAtSameMomentAs(endDate);
          }).toList();
        }

        _totalPagesLeave = (leaveList!.length / _itemsPerPage).ceil();

        leaveList!.sort((a, b) {
          return b.leaveAppliedOn.compareTo(a
              .leaveAppliedOn); // For ascending order, use a.date.compareTo(b.date)
        });
      });
    } else {
      setState(() {
        leaveList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<PermissionListData>? permissionList;
  List<PermissionListData>? permissionListAll;

  Future getAllPermissionList() async {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComPermission';

    var result = await apiService.get(apiUrl);
    var response = permissionListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        permissionListAll = response.response;
        print('permissionList ${permissionList}');
        entryList = null;
        workFromHomeList = null;
        leaveList = null;
        workinExtraList = null;
        clientVisitList = null;

        permissionList = permissionListAll!.where((entry) {
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase();
          }
          return false;
        }).toList();

        if (selectedFilterId == 3) {
          DateTime startDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(dob1Ctrl.text);

          permissionList = permissionList!.where((entry) {
            String formattedWorkedOnDate =
                DateFormat('dd-MM-yyyy').format(entry.date);
            DateTime workedOnDate =
                DateFormat('dd-MM-yyyy').parse(formattedWorkedOnDate);

            return (workedOnDate.isAfter(startDate) &&
                    workedOnDate.isBefore(endDate)) ||
                workedOnDate.isAtSameMomentAs(startDate) ||
                workedOnDate.isAtSameMomentAs(endDate);
          }).toList();
        }

        _totalPagesPermission = (permissionList!.length / _itemsPerPage).ceil();

        permissionList!.sort((a, b) {
          return b.date.compareTo(
              a.date); // For ascending order, use a.date.compareTo(b.date)
        });
      });
    } else {
      setState(() {
        permissionList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<WorkingExtraListData>? workinExtraList;
  List<WorkingExtraListData>? workinExtraListAll;

  Future getAllWorkingExtraList() async {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComWorkingExtra';

    var result = await apiService.get(apiUrl);
    var response = workingExtraListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        workinExtraListAll = response.response;
        print('workinExtraListAll ${workinExtraListAll}');
        entryList = null;
        workFromHomeList = null;
        permissionList = null;
        leaveList = null;
        clientVisitList = null;

        workinExtraList = workinExtraListAll!.where((entry) {
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase();
          }
          return false;
        }).toList();

        if (selectedFilterId == 4) {
          DateTime startDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(dob1Ctrl.text);

          workinExtraList = workinExtraList!.where((entry) {
            String formattedWorkedOnDate =
                DateFormat('dd-MM-yyyy').format(entry.workedOn);
            DateTime workedOnDate =
                DateFormat('dd-MM-yyyy').parse(formattedWorkedOnDate);

            return (workedOnDate.isAfter(startDate) &&
                    workedOnDate.isBefore(endDate)) ||
                workedOnDate.isAtSameMomentAs(startDate) ||
                workedOnDate.isAtSameMomentAs(endDate);
          }).toList();
        }

        _totalPagesWorkingExtra =
            (workinExtraList!.length / _itemsPerPage).ceil();

        workinExtraList!.sort((a, b) {
          return b.workedOn.compareTo(
              a.workedOn); // For ascending order, use a.date.compareTo(b.date)
        });
      });
    } else {
      setState(() {
        workinExtraList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<ClientVisitListData>? clientVisitList;
  List<ClientVisitListData>? clientVisitListAll;

  Future getAllClientVisitList() async {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComClientLocation';

    var result = await apiService.get(apiUrl);
    var response = clientVisitListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        clientVisitListAll = response.response;
        print('clientVisitListAll ${clientVisitListAll}');
        entryList = null;
        workFromHomeList = null;
        permissionList = null;
        leaveList = null;
        workinExtraList = null;

        clientVisitList = clientVisitListAll!.where((entry) {
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase();
          }
          return false;
        }).toList();

        if (selectedFilterId == 6) {
          DateTime startDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(dob1Ctrl.text);

          clientVisitList = clientVisitList!.where((entry) {
            String formattedWorkedOnDate =
                DateFormat('dd-MM-yyyy').format(entry.date);
            DateTime workedOnDate =
                DateFormat('dd-MM-yyyy').parse(formattedWorkedOnDate);

            return (workedOnDate.isAfter(startDate) &&
                    workedOnDate.isBefore(endDate)) ||
                workedOnDate.isAtSameMomentAs(startDate) ||
                workedOnDate.isAtSameMomentAs(endDate);
          }).toList();
        }

        _totalPagesClientVisit =
            (clientVisitList!.length / _itemsPerPage).ceil();

        clientVisitList!.sort((a, b) {
          return b.date.compareTo(
              a.date); // For ascending order, use a.date.compareTo(b.date)
        });
      });
    } else {
      setState(() {
        clientVisitList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  selectedStatusArray() {
    List result;

    if (statusList.isNotEmpty) {
      setState(() {
        selectedStatusArr = statusList[0];
      });
    } else {
      selectedStatusArr = null;
    }
  }

  selectedFilterStatusArray() {
    List result;

    if (filterStatusList.isNotEmpty) {
      setState(() {
        selectedFilterStatusArr = filterStatusList[0];
      });
    } else {
      selectedFilterStatusArr = null;
    }
  }

  selectedfilterDropdownArray() {
    List result;

    if (filterStatusList.isNotEmpty) {
      result = filterStatusList
          .where((element) => element["id"] == selectedFilterId)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedFilterStatusArr = result[0];
        });
      } else {
        setState(() {
          selectedFilterStatusArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedFilterStatusArr empty');

        selectedFilterStatusArr = null;
      });
    }
  }

  List selectType = [
    {
      'name': 'Work From Home',
      'val': 1,
    },
    {
      'name': 'Daily Login',
      'val': 2,
    },
    {
      'name': 'Full Day',
      'val': 3,
    },
    {
      'name': 'Normal working Day',
      'val': 4,
    },
  ];
  int selectedType = 0;

  final List<Map<String, dynamic>> leaveEntries = [
    {
      'date': '05-07-2024',
      'leaveType': 'Work From Home',
      'reason': 'Daily Login',
      'duration': 'Full Day',
      'time': '10:00 AM To 07:00 PM',
      'status': 'Normal working Day',
      'approvedBy': 'Chinnu',
      'approvalStatus': 'Approved',
      'icon': Icons.check,
      'iconColor': Colors.green,
    },
    {
      'date': '04-07-2024',
      'leaveType': 'Casual Leave',
      'reason': 'For Personal Reason',
      'duration': '04-07-2024 To 04-07-2024',
      'status': 'Pending',
      'approvedBy': '',
      'approvalStatus': 'Pending',
      'icon': Icons.hourglass_empty,
      'iconColor': Colors.orange,
    },
    {
      'date': '03-07-2024',
      'leaveType': 'Sick Leave',
      'reason': 'Not Well',
      'duration': '05-07-2024 To 05-07-2024',
      'status': 'Approved',
      'approvedBy': 'Chinnu',
      'approvalStatus': 'Approved',
      'icon': Icons.check,
      'iconColor': Colors.green,
    },
    {
      'date': '02-07-2024',
      'leaveType': 'Work From Home',
      'reason': 'Daily Login',
      'duration': 'Full Day',
      'time': '10:00 AM To 07:00 PM',
      'status': 'Normal working Day',
      'approvedBy': 'Chinnu',
      'approvalStatus': 'Approved',
      'icon': Icons.check,
      'iconColor': Colors.green,
    },
    {
      'date': '01-07-2024',
      'leaveType': 'Casual Leave',
      'reason': 'Other',
      'duration': '01-07-2024 To 01-07-2024',
      'status': 'Rejected',
      'approvedBy': 'Chinnu',
      'approvalStatus': 'Rejected',
      'icon': Icons.clear,
      'iconColor': Colors.red,
    },
  ];

  bool checkOut = false;
  int selectedPage = 1;

  void _showCheckOutDialog(BuildContext context) {
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
        double roundedButtonWidth = screenWidth *
            (baseRoundedButtonWidth / 375); // Assuming base screen width is 375
        double roundedButtonHeight = screenHeight *
            (baseRoundedButtonHeight /
                805); // Assuming base screen height is 667
        double buttonWidth = screenWidth *
            (baseButtonWidth / 375); // Assuming base screen width is 375
        double buttonHeight = screenHeight * (baseButtonHeight / 667);
        return AlertDialog(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
              child: HeadingWidget(
            title: 'Are you sure?',
            color: AppColors.darkBlue3,
            fontSize: 18.0,
          )),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
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
                          title: 'Cancel',
                          width: MediaQuery.of(context).size.width * (20 / 80),
                          height:
                              MediaQuery.of(context).size.height * (20 / 370),
                          color: AppColors.light,
                          titleColor: AppColors.darkGrey,
                          borderRadius: 12.0,
                          borderColor: AppColors.shadowGrey,
                          fontWeight: FontWeight.bold,
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                      ButtonWidget(
                          title: 'Check Out',
                          width: buttonWidth,
                          height: buttonHeight,
                          color: AppColors.darkBlue3,
                          borderRadius: 10.0,
                          onTap: () {
                            setState(() {
                              checkOut = true;
                              Navigator.of(context).pop();
                            });
                          }),
                    ])))
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, dynamic id, dynamic type) {
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
        double roundedButtonWidth = screenWidth *
            (baseRoundedButtonWidth / 375); // Assuming base screen width is 375
        double roundedButtonHeight = screenHeight *
            (baseRoundedButtonHeight /
                805); // Assuming base screen height is 667
        double buttonWidth = screenWidth *
            (baseButtonWidth / 375); // Assuming base screen width is 375
        double buttonHeight = screenHeight * (baseButtonHeight / 667);

        return AlertDialog(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Center(
              child: HeadingWidget(
            title: 'Are you sure?',
            color: AppColors.darkBlue3,
            fontSize: 18.0,
          )),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
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
                        title: 'Cancel',
                        width: MediaQuery.of(context).size.width * (20 / 80),
                        height: MediaQuery.of(context).size.height * (20 / 370),
                        color: AppColors.light,
                        titleColor: AppColors.darkGrey,
                        borderRadius: 12.0,
                        borderColor: AppColors.shadowGrey,
                        fontWeight: FontWeight.bold,
                        onTap: () {
                          Navigator.of(context).pop();
                        }),

                    ButtonWidget(
                        title: 'Delete',
                        width: buttonWidth,
                        height: buttonHeight,
                        color: AppColors.darkRed,
                        borderRadius: 10.0,
                        onTap: () {
                          setState(() {
                            var deleteId = (id is double)
                                ? id.toInt()
                                : int.parse(id.toString());
                            deleteWorkFromHomeById(deleteId, type);
                          });
                        }),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future deleteWorkFromHomeById(int id, String type) async {
    String apiUrl = "";
    if (type == "Work From Home") {
      apiUrl = 'EmployeeComWorkfromhome?MID=$id';
    } else if (type == "Permission") {
      apiUrl = 'EmployeeComPermission?MID=$id';
    } else if (type == "Leave") {
      apiUrl = 'EmployeeComLeave?MID=$id';
    } else if (type == "Working Extra") {
      apiUrl = 'EmployeeComWorkingExtra?MID=$id';
    } else {
      apiUrl = 'EmployeeComClientLocation?MID=$id';
    }

    var result = await apiService.delete(apiUrl);
    WorkfromHomeDeleteModel response = workfromHomeDeleteModelFromJson(result);

    if (response.status.toString() == 'Success') {
      showInSnackBar(context, response.message.toString());
      Navigator.of(context).pop();
      setState(() {
        getAllEntryList();
      });
    } else {
      print(response.message.toString());
      showInSnackBar(context, response.message.toString());
    }
  }

  void _showCalendarDialog(BuildContext context, String? type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdowns(setState),
                // SizedBox(height: 5.0),
                TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focusedDate,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {CalendarFormat.month: ''},
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDate, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _focusedDate = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDate = focusedDay;
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextFormatter: (date, locale) => '',
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    TextButton(
                      onPressed: () {
                        if (type == "StartDate") {
                          dobCtrl.text =
                              '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}';
                        } else {
                          dob1Ctrl.text =
                              '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}';
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),

                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  int selectedFilterId = 0;

  void _showFilterDialog(BuildContext context) {
    setState(() {
      if (selectedFilterId != 0) {
        selectedfilterDropdownArray();
      }
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Center(
                child: HeadingWidget(
              title: 'Please Choose',
              color: AppColors.darkBlue3,
              fontSize: 18.0,
            )),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: HeadingWidget(
                      title: 'Type',
                      color: AppColors.darkBlue3,
                      fontSize: 16.0,
                    ),
                  ),
                  // SizedBox(
                  //   width: 5.0,
                  // ),

                  Expanded(
                    flex: 1,
                    child: HeadingWidget(
                      title: ':',
                      color: AppColors.darkBlue3,
                      vMargin: 3.0,
                      fontSize: 16.0,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                    flex: 5,
                    child: CustomDropdownWidget1(
                      //labelText: 'Payment Mode',
                      selectedItem: selectedFilterStatusArr,
                      height: 33.0,
                      width: 120.0,
                      borderColor: AppColors.lightGrey2,
                      valArr: filterStatusList,
                      itemAsString: (p0) => p0['name'],
                      onChanged: (value) {
                        print('value $value');
                        //selectedPaymentMode = value;
                        // selectedPaymentMode = value['id'];
                        print('value $value');
                        selectedFilterId = value['id'];
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: HeadingWidget(
                      title: 'Start Date',
                      color: AppColors.darkBlue3,
                      fontSize: 16.0,
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
                      color: AppColors.darkBlue3,
                      fontSize: 16.0,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Expanded(
                      flex: 5,
                      child: CustomRoundedTextField(
                          height: 32.0,
                          verticalMargin: 2.0,
                          labelStyleFs: 14.0,
                          labelText: 'dd/mm/yy',
                          // title: 'dd/mm/yy',
                          labelColor: AppColors.dark,
                          borderSideColor: AppColors.lightGrey2,
                          enableBorderColor: AppColors.lightGrey2,
                          focusBorderColor: AppColors.lightGrey2,
                          suffixIcon: const Icon(
                            Icons.date_range,
                          ),
                          control: dobCtrl,
                          //validator: errValidateDob(dobCtrl.text),
                          width: 120.0,
                          readOnly: true, // when true user cannot edit text

                          onTap: () async {
                            _showCalendarDialog(context, "StartDate");
                          }))
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: HeadingWidget(
                      title: 'End Date',
                      color: AppColors.darkBlue3,
                      fontSize: 16.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: HeadingWidget(
                      title: ":",
                      vMargin: 3.0,
                      color: AppColors.darkBlue3,
                      fontSize: 16.0,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: CustomRoundedTextField(
                          height: 32.0,
                          verticalMargin: 2.0,
                          labelStyleFs: 14.0,
                          labelText: 'dd/mm/yy',
                          // title: 'dd/mm/yy',
                          labelColor: AppColors.dark,
                          borderSideColor: AppColors.lightGrey2,
                          enableBorderColor: AppColors.lightGrey2,
                          focusBorderColor: AppColors.lightGrey2,
                          suffixIcon: const Icon(
                            Icons.date_range,
                          ),
                          control: dob1Ctrl,
                          //validator: errValidateDob(dobCtrl.text),
                          width: 120.0,
                          readOnly: true, // when true user cannot edit text

                          onTap: () async {
                            _showCalendarDialog(context, "EndDate");
                          }))
                ],
              )
            ]),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWidget(
                      title: 'Apply',
                      width: 80.0,
                      height: 35.0,
                      color: AppColors.darkBlue3,
                      borderRadius: 10.0,
                      onTap: () {
                        setState(() {
                          if(selectedFilterId == 0){
                            selectedFilterId =1;
                          }
                          if (selectedFilterId == 2) {
                            getAllWorkFromHome("WorkFromHome");
                          } else if (selectedFilterId == 1) {
                            getAllEntryList();
                          } else if (selectedFilterId == 3) {
                            getAllPermissionList();
                          } else if (selectedFilterId == 4) {
                            getAllWorkingExtraList();
                          } else if (selectedFilterId == 5) {
                            getAllLeaveList();
                          } else if (selectedFilterId == 6) {
                            getAllClientVisitList();
                          }
                          Navigator.of(context).pop();
                        });
                      }),
                ],
              )
            ],
          );
        });
  }

  int _totalPages = 1;
  int _totalPagesWorkFromHome = 1;
  int _totalPagesLeave = 1;
  int _totalPagesPermission = 1;
  int _totalPagesWorkingExtra = 1;
  int _totalPagesClientVisit = 1;

  int _currentPage = 1;
  int _itemsPerPage = 10; // Show 10 records per page

  int get totalPagesForCurrentList {
    if (selectedDropdownId == 1) return _totalPages;
    if (selectedDropdownId == 2) return _totalPagesWorkFromHome;
    if (selectedDropdownId == 3) return _totalPagesPermission;
    if (selectedDropdownId == 4) return _totalPagesWorkingExtra;
    if (selectedDropdownId == 5) return _totalPagesLeave;
    if (selectedDropdownId == 6) return _totalPagesClientVisit;
    return 1; // Default if no list is selected
  }

// Calculate the total number of pages
// int get _totalPages => entryList != null && entryList!.isNotEmpty
//     ? (entryList!.length / _itemsPerPage).ceil()
//     : 1;

// Function to get the items for the current page
  List<dynamic> _getPaginatedEntries() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return entryList!.sublist(
      startIndex,
      endIndex > entryList!.length ? entryList!.length : endIndex,
    );
  }

// int get totalPagesWorkFromHome => workFromHomeList != null && workFromHomeList!.isNotEmpty
//   ? (workFromHomeList!.length / _itemsPerPage).ceil()
//   : 1;

  List<dynamic> getPaginatedWorkFromHomeEntries() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return workFromHomeList!.sublist(
      startIndex,
      endIndex > workFromHomeList!.length ? workFromHomeList!.length : endIndex,
    );
  }

  List<dynamic> getPaginatedLeaveEntries() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return leaveList!.sublist(
      startIndex,
      endIndex > leaveList!.length ? leaveList!.length : endIndex,
    );
  }

  List<dynamic> getPaginatedPermissionEntries() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return permissionList!.sublist(
      startIndex,
      endIndex > permissionList!.length ? permissionList!.length : endIndex,
    );
  }

  List<dynamic> getPaginatedWorkingExtraEntries() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return workinExtraList!.sublist(
      startIndex,
      endIndex > workinExtraList!.length ? workinExtraList!.length : endIndex,
    );
  }

  List<dynamic> getPaginatedClientVisitEntries() {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return clientVisitList!.sublist(
      startIndex,
      endIndex > clientVisitList!.length ? clientVisitList!.length : endIndex,
    );
  }

  int selectedDropdownId = 1;

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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ProfilePage()));
                        },
                        child: Image.asset(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeadingWidget(
                        title: 'Entry List',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      CustomDropdownWidget1(
                        //labelText: 'Payment Mode',
                        selectedItem: selectedStatusArr,
                        borderColor: AppColors.lightGrey2,
                        selectedTextColor: AppColors.darkGrey,
                        height: 35.0,
                        //width: 125.0,
                        //  height: 48.0,
                        width: 163.0,
                        valArr: statusList,
                        itemAsString: (p0) => p0['name'],
                        onChanged: (value) {
                          print('value $value');
                          //selectedPaymentMode = value;
                          // selectedPaymentMode = value['id'];
                          setState(() {
                            selectedFilterId = 0;
                            _currentPage = 1;
                            selectedDropdownId = value['id'];

                            print('value $value');
                            if (value['id'] == 1) {
                              getAllEntryList();
                            } else if (value['id'] == 2) {
                              getAllWorkFromHome("");
                            } else if (value['id'] == 5) {
                              getAllLeaveList();
                            } else if (value['id'] == 3) {
                              getAllPermissionList();
                            } else if (value['id'] == 4) {
                              getAllWorkingExtraList();
                            } else if (value['id'] == 6) {
                              getAllClientVisitList();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width /
                            3.90, // Adjust the width based on your design
                        decoration: BoxDecoration(
                          color: AppColors.light,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomDropdownWidget(
                                selectedItem: selectedStatusArr1,
                                labelText: 'This Month',
                                labelColor: AppColors.darkGrey,
                                labelField: (item) => item['name'],
                                labelStyleFs: 10.0,
                                onChanged: (value) {
                                  setState(() {
                                    // selectedMonthArr = value;
                                    selectedMonth = value['name'];
                                    // print(selectedMonth);
                                    getAllEntryList();
                                  });
                                },
                                valArr: status1List,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (entryList != null && entryList!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //itemCount: entryList!.length,
                  itemCount: _getPaginatedEntries().length,
                  itemBuilder: (context, index) {
                    // final leaveEntry = entryList![index];
                    final leaveEntry = _getPaginatedEntries()[index];
                    DateTime dateTime = DateTime.parse(leaveEntry['DATE']);

                    // Format the DateTime object into a readable string
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(dateTime);

                    String formattedTime = "";
                    if (leaveEntry['CHECK_IN_TIME'] != null) {
                      DateTime dateTime1 =
                          DateTime.parse(leaveEntry['CHECK_IN_TIME']);

                      // Format the DateTime object to extract and format the time part
                      formattedTime = DateFormat('hh:mm a').format(dateTime1);
                    }

                    String checkoutTime = "";
                    if (leaveEntry['CHECK_OUT_TIME'] != null) {
                      DateTime dateTime1 =
                          DateTime.parse(leaveEntry['CHECK_OUT_TIME']);

                      // Format the DateTime object to extract and format the time part
                      checkoutTime = DateFormat('hh:mm a').format(dateTime1);
                      // print('checkoutTime${checkoutTime}');
                    }
                    return Container(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  HeadingWidget(
                                    title: formattedDate.toString(),
                                    vMargin: 1.0,
                                    color: AppColors.darkBlue3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),

                                  //   if(!checkOut)
                                  //  ButtonWidget(
                                  //       title: 'Check Out',
                                  //       width: 100.0,
                                  //       height: 35.0,
                                  //       color: AppColors.darkBlue3,
                                  //       borderRadius: 10.0,
                                  //       titleFS: 14.0,
                                  //       onTap: (){
                                  //         _showCheckOutDialog(context);
                                  //       }
                                  //       ),
                                ],
                              ),

                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // width: 120.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                      title:
                                          leaveEntry['TYPE']?.toString() ?? '',
                                      color: AppColors.grey1,
                                      fontSize: 12.0,
                                    )),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    // width: 110.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                            title: leaveEntry['REASON']
                                                    ?.toString() ??
                                                '',
                                            color: AppColors.grey1,
                                            fontSize: 12.0)),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 60.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                          title: leaveEntry['HALF_FULL_DAY']
                                                  ?.toString() ??
                                              '',
                                          color: AppColors.grey1,
                                          fontSize: 12.0,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        // width: 123.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title:
                                                    leaveEntry['WORKING_DURING']
                                                            ?.toString() ??
                                                        '',
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.light,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey2,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            MdiIcons.squareEditOutline,
                                            color: AppColors.darkBlue3,
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (leaveEntry['TYPE'] ==
                                                  "Work From Home") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddEntryPage(
                                                                id: leaveEntry[
                                                                    'MID'],
                                                                type: leaveEntry[
                                                                        'TYPE']
                                                                    .toString())));
                                              }
                                              if (leaveEntry['TYPE'] ==
                                                  "Permission") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddEntryPage(
                                                                id: leaveEntry[
                                                                    'MID'],
                                                                type: leaveEntry[
                                                                        'TYPE']
                                                                    .toString())));
                                              }

                                              if (leaveEntry['TYPE'] ==
                                                  "Leave") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddEntryPage(
                                                                id: leaveEntry[
                                                                    'MID'],
                                                                type: leaveEntry[
                                                                        'TYPE']
                                                                    .toString())));
                                              }

                                              if (leaveEntry['TYPE'] ==
                                                  "Working Extra") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddEntryPage(
                                                                id: leaveEntry[
                                                                    'MID'],
                                                                type: leaveEntry[
                                                                        'TYPE']
                                                                    .toString())));
                                              }

                                              if (leaveEntry['TYPE'] ==
                                                  "Client Visit (Support)") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddEntryPage(
                                                                id: leaveEntry[
                                                                    'MID'],
                                                                type: leaveEntry[
                                                                        'TYPE']
                                                                    .toString())));
                                              }
                                            });
                                          },
                                        )),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.light,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.lightGrey2,
                                          width: 1.0,
                                        ),
                                      ),
                                      child:
                                          //  IconButton(
                                          //     icon: Icon(Icons.delete, color: AppColors.danger),
                                          //     onPressed: () {
                                          //       _showDeleteDialog(context);
                                          //     },
                                          //   ),

                                          IconButton(
                                        icon: Image.asset(
                                          AppAssets
                                              .deleteIcon, // Your custom asset image
                                          width: 23.0,
                                          height: 23.0,
                                        ),
                                        onPressed: () {
                                          _showDeleteDialog(
                                              context,
                                              leaveEntry['MID'],
                                              leaveEntry['TYPE'].toString());
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 70.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreen,
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: formattedTime,
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      SubHeadingWidget(
                                        title: "To",
                                      ),
                                      if (checkoutTime != "")
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                      if (checkoutTime != "")
                                        Container(
                                          // width: 70.0,
                                          // height: 28.0,
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightRed,
                                            borderRadius: BorderRadius.circular(
                                                16), // Rounded corners
                                          ),
                                          child: Center(
                                              child: SubHeadingWidget(
                                                  title:
                                                      checkoutTime.toString(),
                                                  color: AppColors.grey1,
                                                  fontSize: 12.0)),
                                        ),
                                    ],
                                  ),
                                  SubHeadingWidget(
                                    title:
                                        leaveEntry['APPROVED_BY']?.toString() ??
                                            '',
                                    fontSize: 12.0,
                                  )
                                ],
                              )

                              //   ],
                              // )
                            ],
                          ),
                          // ));
                          //     }).toList(),
                        ));
                  },
                ),
              if (permissionList != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //itemCount: permissionList!.length,
                  itemCount: getPaginatedPermissionEntries().length,
                  itemBuilder: (context, index) {
                    //final leaveEntry = permissionList![index];
                    final leaveEntry = getPaginatedPermissionEntries()[index];
                    //DateTime dateTime = DateTime.parse(leaveEntry.date);

                    // Format the DateTime object into a readable string
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(leaveEntry.date);

                    String formattedTime = "";
                    if (leaveEntry.preTime != null) {
                      //DateTime dateTime1 = DateTime.parse(leaveEntry.preTime);

                      // Format the DateTime object to extract and format the time part
                      formattedTime =
                          DateFormat('hh:mm a').format(leaveEntry.preTime);
                    }

                    String checkoutTime = "";
                    if (leaveEntry.postTime != null) {
                      //DateTime dateTime1 = DateTime.parse(leaveEntry['CHECK_OUT_TIME']);

                      // Format the DateTime object to extract and format the time part
                      checkoutTime =
                          DateFormat('hh:mm a').format(leaveEntry.postTime);
                      // print('checkoutTime${checkoutTime}');
                    }
                    return Container(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  HeadingWidget(
                                    title: formattedDate.toString(),
                                    vMargin: 1.0,
                                    color: AppColors.darkBlue3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),

                                  //   if(!checkOut)
                                  //  ButtonWidget(
                                  //       title: 'Check Out',
                                  //       width: 100.0,
                                  //       height: 35.0,
                                  //       color: AppColors.darkBlue3,
                                  //       borderRadius: 10.0,
                                  //       titleFS: 14.0,
                                  //       onTap: (){
                                  //         _showCheckOutDialog(context);
                                  //       }
                                  //       ),
                                ],
                              ),

                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // width: 120.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                      title: leaveEntry.permissionType
                                              .toString() ??
                                          '',
                                      color: AppColors.grey1,
                                      fontSize: 12.0,
                                    )),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    // width: 110.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                            title:
                                                leaveEntry.remark.toString() ??
                                                    '',
                                            color: AppColors.grey1,
                                            fontSize: 12.0)),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 60.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                          title: leaveEntry.preRemark1
                                                  .toString() ??
                                              '',
                                          color: AppColors.grey1,
                                          fontSize: 12.0,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        // width: 123.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: leaveEntry.remark
                                                        .toString() ??
                                                    '',
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.light,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey2,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            MdiIcons.squareEditOutline,
                                            color: AppColors.darkBlue3,
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          AddEntryPage(
                                                              id: leaveEntry
                                                                  .mid,
                                                              type:
                                                                  "Permission")));
                                            });
                                          },
                                        )),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.light,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.lightGrey2,
                                          width: 1.0,
                                        ),
                                      ),
                                      child:
                                          //  IconButton(
                                          //     icon: Icon(Icons.delete, color: AppColors.danger),
                                          //     onPressed: () {
                                          //       _showDeleteDialog(context);
                                          //     },
                                          //   ),

                                          IconButton(
                                        icon: Image.asset(
                                          AppAssets
                                              .deleteIcon, // Your custom asset image
                                          width: 23.0,
                                          height: 23.0,
                                        ),
                                        onPressed: () {
                                          _showDeleteDialog(context,
                                              leaveEntry.mid, "Permission");
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 70.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreen,
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: formattedTime,
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      SubHeadingWidget(
                                        title: "To",
                                      ),
                                      if (checkoutTime != "")
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                      if (checkoutTime != "")
                                        Container(
                                          // width: 70.0,
                                          // height: 28.0,
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightRed,
                                            borderRadius: BorderRadius.circular(
                                                16), // Rounded corners
                                          ),
                                          child: Center(
                                              child: SubHeadingWidget(
                                                  title:
                                                      checkoutTime.toString(),
                                                  color: AppColors.grey1,
                                                  fontSize: 12.0)),
                                        ),
                                    ],
                                  ),
                                  SubHeadingWidget(
                                    title:
                                        leaveEntry.approvedBy.toString() ?? '',
                                    fontSize: 12.0,
                                  )
                                ],
                              )

                              //   ],
                              // )
                            ],
                          ),
                          // ));
                          //     }).toList(),
                        ));
                  },
                ),
              if (workFromHomeList != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //itemCount: workFromHomeList!.length,
                  itemCount: getPaginatedWorkFromHomeEntries().length,
                  itemBuilder: (context, index) {
                    //final leaveEntry = workFromHomeList![index];
                    final leaveEntry = getPaginatedWorkFromHomeEntries()[index];
                    // DateTime dateTime = DateTime.parse(leaveEntry.workedOn);

                    // Format the DateTime object into a readable string
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(leaveEntry.workedOn);

                    String formattedTime = "";
                    if (leaveEntry.checkInTime != null) {
                      //DateTime dateTime1 = DateTime.parse(leaveEntry.checkInTime);

                      // Format the DateTime object to extract and format the time part
                      formattedTime =
                          DateFormat('hh:mm a').format(leaveEntry.checkInTime);
                    }

                    String checkoutTime = "";
                    if (leaveEntry.checkOutTime != null) {
                      //DateTime dateTime1 = DateTime.parse(leaveEntry['CHECK_OUT_TIME']);

                      // Format the DateTime object to extract and format the time part
                      checkoutTime =
                          DateFormat('hh:mm a').format(leaveEntry.checkOutTime);
                      // print('checkoutTime${checkoutTime}');
                    }
                    return Container(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  HeadingWidget(
                                    title: formattedDate.toString(),
                                    vMargin: 1.0,
                                    color: AppColors.darkBlue3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),

                                  //   if(!checkOut)
                                  //  ButtonWidget(
                                  //       title: 'Check Out',
                                  //       width: 100.0,
                                  //       height: 35.0,
                                  //       color: AppColors.darkBlue3,
                                  //       borderRadius: 10.0,
                                  //       titleFS: 14.0,
                                  //       onTap: (){
                                  //         _showCheckOutDialog(context);
                                  //       }
                                  //       ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //             Container(
                                  //   // width: 120.0,
                                  //   // height: 28.0,
                                  //    padding: EdgeInsets.all(6.0),
                                  //   decoration: BoxDecoration(
                                  //     color: AppColors.background, // Grey background color
                                  //     borderRadius: BorderRadius.circular(16), // Rounded corners
                                  //   ),
                                  //   child: Center(
                                  //     child: SubHeadingWidget(title: leaveEntry.halfFullDay.toString() ?? '', color: AppColors.grey1, fontSize: 12.0,)
                                  //   ),
                                  // ),

                                  SizedBox(
                                    width: 5.0,
                                  ),

                                  Container(
                                    // width: 110.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                            title:
                                                leaveEntry.reason.toString() ??
                                                    '',
                                            color: AppColors.grey1,
                                            fontSize: 12.0)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 60.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                          title: leaveEntry.halfFullDay
                                                  .toString() ??
                                              '',
                                          color: AppColors.grey1,
                                          fontSize: 12.0,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        // width: 123.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: leaveEntry.workingDuring
                                                        .toString() ??
                                                    '',
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.light,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey2,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            MdiIcons.squareEditOutline,
                                            color: AppColors.darkBlue3,
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => AddEntryPage(
                                                          id: leaveEntry.mid,
                                                          type:
                                                              "Work From Home")));
                                            });
                                          },
                                        )),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.light,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.lightGrey2,
                                          width: 1.0,
                                        ),
                                      ),
                                      child:
                                          //  IconButton(
                                          //     icon: Icon(Icons.delete, color: AppColors.danger),
                                          //     onPressed: () {
                                          //       _showDeleteDialog(context);
                                          //     },
                                          //   ),

                                          IconButton(
                                        icon: Image.asset(
                                          AppAssets
                                              .deleteIcon, // Your custom asset image
                                          width: 23.0,
                                          height: 23.0,
                                        ),
                                        onPressed: () {
                                          _showDeleteDialog(context,
                                              leaveEntry.mid, "Work From Home");
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 70.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreen,
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: formattedTime,
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      SubHeadingWidget(
                                        title: "To",
                                      ),
                                      if (checkoutTime != "")
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                      if (checkoutTime != "")
                                        Container(
                                          // width: 70.0,
                                          // height: 28.0,
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightRed,
                                            borderRadius: BorderRadius.circular(
                                                16), // Rounded corners
                                          ),
                                          child: Center(
                                              child: SubHeadingWidget(
                                                  title:
                                                      checkoutTime.toString(),
                                                  color: AppColors.grey1,
                                                  fontSize: 12.0)),
                                        ),
                                    ],
                                  ),
                                  SubHeadingWidget(
                                    title:
                                        leaveEntry.approvedBy.toString() ?? '',
                                    fontSize: 12.0,
                                  )
                                ],
                              )
                            ],
                          ),
                          // ));
                          //     }).toList(),
                        ));
                  },
                ),
              if (workinExtraList != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  // itemCount: workinExtraList!.length,
                  itemCount: getPaginatedWorkingExtraEntries().length,
                  itemBuilder: (context, index) {
                    //final leaveEntry = workinExtraList![index];
                    final leaveEntry = getPaginatedWorkingExtraEntries()[index];
                    // DateTime dateTime = DateTime.parse(leaveEntry.workedOn);

                    // Format the DateTime object into a readable string
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(leaveEntry.workedOn);

                    String formattedTime = "";
                    if (leaveEntry.checkInTime != null) {
                      //DateTime dateTime1 = DateTime.parse(leaveEntry.checkInTime);

                      // Format the DateTime object to extract and format the time part
                      formattedTime =
                          DateFormat('hh:mm a').format(leaveEntry.checkInTime);
                    }

                    String checkoutTime = "";
                    if (leaveEntry.checkOutTime != null) {
                      //DateTime dateTime1 = DateTime.parse(leaveEntry['CHECK_OUT_TIME']);

                      // Format the DateTime object to extract and format the time part
                      checkoutTime =
                          DateFormat('hh:mm a').format(leaveEntry.checkOutTime);
                      // print('checkoutTime${checkoutTime}');
                    }
                    return Container(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  HeadingWidget(
                                    title: formattedDate.toString(),
                                    vMargin: 1.0,
                                    color: AppColors.darkBlue3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),

                                  //   if(!checkOut)
                                  //  ButtonWidget(
                                  //       title: 'Check Out',
                                  //       width: 100.0,
                                  //       height: 35.0,
                                  //       color: AppColors.darkBlue3,
                                  //       borderRadius: 10.0,
                                  //       titleFS: 14.0,
                                  //       onTap: (){
                                  //         _showCheckOutDialog(context);
                                  //       }
                                  //       ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // width: 120.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                      title:
                                          leaveEntry.compensation.toString() ??
                                              '',
                                      color: AppColors.grey1,
                                      fontSize: 12.0,
                                    )),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    // width: 110.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                            title: leaveEntry.typeOfWork
                                                    .toString() ??
                                                '',
                                            color: AppColors.grey1,
                                            fontSize: 12.0)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 60.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                          title: leaveEntry.halfFullDay
                                                  .toString() ??
                                              '',
                                          color: AppColors.grey1,
                                          fontSize: 12.0,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        // width: 123.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: leaveEntry.workingDuring
                                                        .toString() ??
                                                    '',
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.light,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey2,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            MdiIcons.squareEditOutline,
                                            color: AppColors.darkBlue3,
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => AddEntryPage(
                                                          id: leaveEntry.mid,
                                                          type:
                                                              "Working Extra")));
                                            });
                                          },
                                        )),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.light,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.lightGrey2,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: Image.asset(
                                          AppAssets
                                              .deleteIcon, // Your custom asset image
                                          width: 23.0,
                                          height: 23.0,
                                        ),
                                        onPressed: () {
                                          _showDeleteDialog(context,
                                              leaveEntry.mid, "Working Extra");
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 70.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreen,
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: formattedTime,
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      SubHeadingWidget(
                                        title: "To",
                                      ),
                                      if (checkoutTime != "")
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                      if (checkoutTime != "")
                                        Container(
                                          // width: 70.0,
                                          // height: 28.0,
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightRed,
                                            borderRadius: BorderRadius.circular(
                                                16), // Rounded corners
                                          ),
                                          child: Center(
                                              child: SubHeadingWidget(
                                                  title:
                                                      checkoutTime.toString(),
                                                  color: AppColors.grey1,
                                                  fontSize: 12.0)),
                                        ),
                                    ],
                                  ),
                                  SubHeadingWidget(
                                    title:
                                        leaveEntry.approvedBy.toString() ?? '',
                                    fontSize: 12.0,
                                  )
                                ],
                              )
                            ],
                          ),
                        ));
                  },
                ),
              if (clientVisitList != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //itemCount: clientVisitList!.length,
                  itemCount: getPaginatedClientVisitEntries().length,
                  itemBuilder: (context, index) {
                    //final leaveEntry = clientVisitList![index];
                    final leaveEntry = getPaginatedClientVisitEntries()[index];

                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(leaveEntry.date);

                    String formattedTime = "";
                    if (leaveEntry.startTime != null) {
                      formattedTime =
                          DateFormat('hh:mm a').format(leaveEntry.startTime);
                    }

                    String checkoutTime = "";
                    if (leaveEntry.endTime != null) {
                      checkoutTime =
                          DateFormat('hh:mm a').format(leaveEntry.endTime);
                    }
                    return Container(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  HeadingWidget(
                                    title: formattedDate.toString(),
                                    vMargin: 1.0,
                                    color: AppColors.darkBlue3,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // width: 120.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                      title: leaveEntry.clientName.toString() ??
                                          '',
                                      color: AppColors.grey1,
                                      fontSize: 12.0,
                                    )),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // width: 110.0,
                                    // height: 28.0,
                                    padding: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: AppColors
                                          .background, // Grey background color
                                      borderRadius: BorderRadius.circular(
                                          16), // Rounded corners
                                    ),
                                    child: Center(
                                        child: SubHeadingWidget(
                                            title: leaveEntry.clientLocation
                                                    .toString() ??
                                                '',
                                            color: AppColors.grey1,
                                            fontSize: 12.0)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 60.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                          title:
                                              leaveEntry.clientPoc.toString() ??
                                                  '',
                                          color: AppColors.grey1,
                                          fontSize: 12.0,
                                        )),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        width: 185.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: leaveEntry.visitPurpose
                                                        .toString() ??
                                                    '',
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.light,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey2,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            MdiIcons.squareEditOutline,
                                            color: AppColors.darkBlue3,
                                            size: 24.0,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => AddEntryPage(
                                                          id: leaveEntry.mid,
                                                          type:
                                                              "Client Visit (Support)")));
                                            });
                                          },
                                        )),
                                    SizedBox(
                                      width: 4.0,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.light,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.lightGrey2,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: Image.asset(
                                          AppAssets
                                              .deleteIcon, // Your custom asset image
                                          width: 23.0,
                                          height: 23.0,
                                        ),
                                        onPressed: () {
                                          _showDeleteDialog(
                                              context,
                                              leaveEntry.mid,
                                              "Client Visit (Support)");
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // width: 70.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreen,
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: formattedTime,
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      SubHeadingWidget(
                                        title: "To",
                                      ),
                                      if (checkoutTime != "")
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                      if (checkoutTime != "")
                                        Container(
                                          // width: 70.0,
                                          // height: 28.0,
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightRed,
                                            borderRadius: BorderRadius.circular(
                                                16), // Rounded corners
                                          ),
                                          child: Center(
                                              child: SubHeadingWidget(
                                                  title:
                                                      checkoutTime.toString(),
                                                  color: AppColors.grey1,
                                                  fontSize: 12.0)),
                                        ),
                                    ],
                                  ),
                                  SubHeadingWidget(
                                    title:
                                        leaveEntry.approvedBy.toString() ?? '',
                                    fontSize: 12.0,
                                  )
                                ],
                              )
                            ],
                          ),
                          // ));
                          //     }).toList(),
                        ));
                  },
                ),
              if (leaveList != null)
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    //itemCount: leaveList!.length,
                    itemCount: getPaginatedLeaveEntries().length,
                    itemBuilder: (context, index) {
                      //final leaveEntry = leaveList![index];
                      final leaveEntry = getPaginatedLeaveEntries()[index];
                      // DateTime dateTime = DateTime.parse(leaveEntry.workedOn);

                      // Format the DateTime object into a readable string
                      String formattedDate = DateFormat('dd-MM-yyyy')
                          .format(leaveEntry.leaveAppliedOn);

                      String startDate =
                          DateFormat('dd-MM-yyyy').format(leaveEntry.startDate);

                      String endDate =
                          DateFormat('dd-MM-yyyy').format(leaveEntry.endDate);

                      return Container(
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    HeadingWidget(
                                      title: formattedDate.toString(),
                                      vMargin: 1.0,
                                      color: AppColors.darkBlue3,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      // width: 80.0,
                                      // height: 28.0,
                                      padding: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .background, // Grey background color
                                        borderRadius: BorderRadius.circular(
                                            16), // Rounded corners
                                      ),
                                      child: Center(
                                          child: SubHeadingWidget(
                                        title: leaveEntry.leaveType.toString(),
                                        color: AppColors.grey1,
                                        fontSize: 12.0,
                                      )),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      // width: 80.0,
                                      // height: 28.0,
                                      padding: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .background, // Grey background color
                                        borderRadius: BorderRadius.circular(
                                            16), // Rounded corners
                                      ),
                                      child: Center(
                                          child: SubHeadingWidget(
                                        title:
                                            leaveEntry.halfFullDay.toString(),
                                        color: AppColors.grey1,
                                        fontSize: 12.0,
                                      )),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      // width: 70.0,
                                      // height: 28.0,
                                      padding: EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: AppColors
                                            .background, // Grey background color
                                        borderRadius: BorderRadius.circular(
                                            16), // Rounded corners
                                      ),
                                      child: Center(
                                          child: SubHeadingWidget(
                                              title: leaveEntry.approvalStatus
                                                  .toString(),
                                              color: AppColors.grey1,
                                              fontSize: 12.0)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        // width: 70.0,
                                        // height: 28.0,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .background, // Grey background color
                                          borderRadius: BorderRadius.circular(
                                              16), // Rounded corners
                                        ),
                                        child: Center(
                                            child: SubHeadingWidget(
                                                title: leaveEntry.remarks
                                                    .toString(),
                                                color: AppColors.grey1,
                                                fontSize: 12.0)),
                                      ),
                                    ]),
                                SizedBox(
                                  height: 3.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        HeadingWidget(
                                          title: startDate.toString(),
                                          vMargin: 1.0,
                                          color: AppColors.darkBlue3,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        SubHeadingWidget(
                                          title: "To",
                                          fontSize: 12.0,
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        HeadingWidget(
                                          title: endDate.toString(),
                                          vMargin: 1.0,
                                          color: AppColors.darkBlue3,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.light,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.lightGrey2,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              MdiIcons.squareEditOutline,
                                              color: AppColors.darkBlue3,
                                              size: 24.0,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddEntryPage(
                                                                id: leaveEntry
                                                                    .mid,
                                                                type:
                                                                    "Leave")));
                                              });
                                            },
                                          )),
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.light,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.lightGrey2,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Image.asset(
                                            AppAssets
                                                .deleteIcon, // Your custom asset image
                                            width: 23.0,
                                            height: 23.0,
                                          ),
                                          onPressed: () {
                                            _showDeleteDialog(context,
                                                leaveEntry.mid, "Leave");
                                          },
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SubHeadingWidget(
                                          title: "No of Days:",
                                          fontSize: 12.0,
                                        ),
                                        SizedBox(
                                          width: 3.0,
                                        ),
                                        HeadingWidget(
                                          title: leaveEntry.noOfDays.toString(),
                                          vMargin: 1.0,
                                          color: AppColors.darkBlue3,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SubHeadingWidget(
                                          title:
                                              "Approved By: ${leaveEntry.approvedBy.toString()}",
                                          fontSize: 13.0,
                                          color: AppColors.success,
                                        ),
                                        SizedBox(
                                          width: 3.0,
                                        ),
                                        Image.asset(
                                          AppAssets.approvedIcon,
                                          width: 21.0,
                                          // height: 50.0,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ));
                    })
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
              // Backward Button
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
              // Page number buttons
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= totalPagesForCurrentList; i++)
                        if (i == 1 ||
                            i == totalPagesForCurrentList ||
                            (i >= _currentPage - 1 && i <= _currentPage + 1))
                          _pageButton(i)
                        else if (i == 2 || i == totalPagesForCurrentList - 1)
                          Text('...')
                        else
                          Container(),
                    ],
                  ),
                ),
              ),
              // Forward Button
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 15.0),
                onPressed: _currentPage < totalPagesForCurrentList
                    ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                    : null,
              ),
              SizedBox(width: 10),
              // Page Label
              Text('Page'),
              SizedBox(width: 5),
              // Dropdown for selecting pages
              DropdownButton<int>(
                value: _currentPage,
                items: List.generate(totalPagesForCurrentList, (index) {
                  int pageNumber = index + 1;
                  return DropdownMenuItem(
                    value: pageNumber,
                    child: Text(pageNumber.toString()),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _currentPage =
                        value ?? 1; // Fallback to page 1 if value is null
                  });
                },
              ),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: BottomAppBar(
      //   elevation: 0,
      //   color: AppColors.light,
      //   child: Padding(
      //     padding: EdgeInsets.all(4.0),
      //     child: Row(
      //       children: [
      //         IconButton(
      //           icon: Icon(Icons.arrow_back_ios, size: 15.0),
      //           onPressed: _currentPage > 1
      //               ? () {
      //                   setState(() {
      //                     _currentPage--;
      //                   });
      //                 }
      //               : null,
      //         ),
      //         Expanded(
      //           child: SingleChildScrollView(
      //             scrollDirection: Axis.horizontal,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 for (int i = 1; i <= _totalPages; i++)
      //                   if (i == 1 || i == _totalPages || (i >= _currentPage - 1 && i <= _currentPage + 1))
      //                     _pageButton(i)
      //                   else if (i == 2 || i == _totalPages - 1)
      //                     Text('...')
      //                   else
      //                     Container(),
      //               ],
      //             ),
      //           ),
      //         ),
      //         IconButton(
      //           icon: Icon(Icons.arrow_forward_ios, size: 15.0),
      //           onPressed: _currentPage < _totalPages
      //               ? () {
      //                   setState(() {
      //                     _currentPage++;
      //                   });
      //                 }
      //               : null,
      //         ),
      //         SizedBox(width: 10),
      //         Text('Page'),
      //         SizedBox(width: 5),
      //        DropdownButton<int>(
      //         value: _currentPage != null ? _currentPage : 1, // Fallback to page 1 if null
      //         items: List.generate(_totalPages, (index) {
      //           int pageNumber = index + 1;
      //           return DropdownMenuItem(
      //             value: pageNumber,
      //             child: Text(pageNumber.toString()),
      //           );
      //         }),
      //         onChanged: (value) {
      //           setState(() {
      //             _currentPage = value ?? 1; // Fallback to page 1 if value is null
      //           });
      //         },
      //       )
      //       ],
      //     ),
      //   ),
      // ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 43.0,
            //padding: EdgeInsets.all(11.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkBlue3,
            ),
            child: Center(
                child: IconButton(
              icon: Icon(
                MdiIcons.tune,
                color: AppColors.light,
                size: 20.0,
              ),
              onPressed: () {
                _showFilterDialog(context);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget buildLeaveCard(Map<String, dynamic> leaveEntry) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      padding: EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeadingWidget(
                title: leaveEntry['date'],
                vMargin: 1.0,
                color: AppColors.darkBlue3,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
              ButtonWidget(
                  title: 'Check Out',
                  width: 100.0,
                  height: 40.0,
                  color: AppColors.darkBlue3,
                  borderRadius: 10.0,
                  titleFS: 14.0,
                  onTap: () {}),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leaveEntry['leaveType']),
                  Text(leaveEntry['reason']),
                  Text(leaveEntry['duration']),
                  if (leaveEntry['time'] != null) Text(leaveEntry['time']),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(leaveEntry['icon'], color: leaveEntry['iconColor']),
                      SizedBox(width: 4),
                      Text(
                        leaveEntry['approvalStatus'],
                        style: TextStyle(
                          color: leaveEntry['iconColor'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (leaveEntry['approvedBy'].isNotEmpty)
                    Text('Approved by: ${leaveEntry['approvedBy']}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdowns(StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          value: _focusedDate.month,
          items: List.generate(12, (index) => index + 1)
              .map((month) => DropdownMenuItem(
                    value: month,
                    child: Text(_monthName(month)),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _focusedDate =
                    DateTime(_focusedDate.year, value, _focusedDate.day);
              });
            }
          },
        ),
        SizedBox(width: 20),
        DropdownButton<int>(
          value: _focusedDate.year,
          items: List.generate(101, (index) => index + 2000)
              .map((year) => DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _focusedDate =
                    DateTime(value, _focusedDate.month, _focusedDate.day);
              });
            }
          },
        ),
      ],
    );
  }

  String _monthName(int month) {
    List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
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
