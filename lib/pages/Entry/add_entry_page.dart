import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../models/add_entry_client_visit_model.dart';
import '../../models/add_entry_leave_model.dart';
import '../../models/add_entry_model.dart';
import '../../models/add_entry_permission_model.dart';
import '../../models/add_entry_working_extra_model.dart';
import '../../models/client_team_list_model.dart';
import '../../models/client_visit_edit_model.dart';
import '../../models/client_visit_list_model.dart';
import '../../models/client_visit_purpose_model.dart';
import '../../models/leave_approval_list_model.dart';
import '../../models/leave_edit_model.dart';
import '../../models/leave_list_model.dart';
import '../../models/permission_edit_model.dart';
import '../../models/permission_list_model.dart';
import '../../models/remarks_list_model.dart';
import '../../models/support_customer_model.dart';
import '../../models/work_type_list_model.dart';
import '../../models/workfrom_home_edit_model.dart';
import '../../models/workfrom_home_list_model.dart';
import '../../models/working_extra_edit_model.dart';
import '../../models/working_extra_list_model.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../../widgets/button1_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/custom_dropdown_widget1.dart';
import '../../widgets/custom_ml_dropdown.dart';
import '../../widgets/custom_rounded_ml_dropdown.dart';
import '../../widgets/custom_rounded_textfield.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/group_chip_widget.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/multi_dropdown_alert.dart';
import '../../widgets/rounded_button_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../profile/profile_page.dart';
import 'entry_list_page.dart';

class AddEntryPage extends StatefulWidget {
  dynamic id;
  String? type;
  AddEntryPage({super.key, this.id, this.type});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final CommunicatorApiService apiService = CommunicatorApiService();

  TextEditingController dobCtrl = TextEditingController();
  TextEditingController workDuringCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController startTimeCtrl = TextEditingController();
  TextEditingController remarksCtrl = TextEditingController();
  TextEditingController clientLocationCtrl = TextEditingController();
  TextEditingController clientContactCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime? _selectedDate;
  DateTime _focusedDate = DateTime.now();

  @override
  void initState() {
    setState(() {
      String checkInTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
      dobCtrl.text = checkInTime;
      workDuringCtrl.text = "Normal Working Day";

      String currentTime = DateFormat('hh:mm')
          .format(DateTime.now()); // Formats time in 12-hour format with AM/PM
      startTimeCtrl.text = currentTime;
    });
    if (widget.id == null) {
      getAllWorkFromHome();
      getAllRemarksList();
      getAllWorkType();
      getAllSupportCustomer();
      getAllClientTeam();
    }

    getAllLeaveApproval();

    //selectedStatusArray();
    if (widget.id != null && widget.type == "Work From Home") {
      getWorkFromHomeById();
    }
    if (widget.id != null && widget.type == "Permission") {
      getPermissionById();
    }

    if (widget.id != null && widget.type == "Leave") {
      getLeaveById();
    }

    if (widget.id != null && widget.type == "Working Extra") {
      getWorkingExtraById();
    }

    if (widget.id != null && widget.type == "Client Visit (Support)") {
      getClientVisitById();
    }

    super.initState();
  }

  // List<String>? selectedWorkedOnLeave;

String selectedWorkedOnLeave = "";


  bool compensatory = false;

  List<RemarksList>? remarksList;
  List<WorkTypeListData>? workTypeList;
  var selectedWorkTypeArr;
  String selectedWorkType = "";

  String name = "";
  String location = "";
  String department = "";
  String assignedBy = "";
  String role = "";
  String remarks = "";
  Future getAllRemarksList() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('username') ?? '';
      location = prefs.getString('location') ?? '';
      department = prefs.getString('department') ?? '';
      assignedBy = prefs.getString('approved_by') ?? '';
      role = prefs.getString('role') ?? '';
    });

    String apiUrl = "";

    apiUrl = 'Com_Remarks';

    var result = await apiService.get(apiUrl);
    var response = remarksListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        remarksList = response.response;
        print('remarksList ${remarksList}');

        if (widget.id == null) {
          selectedStatusArray();
        }

        if (widget.id != null && widget.type == "Work From Home") {
          selectedStatusArray1();
        }
        if (widget.id != null && widget.type == "Permission") {
          selectedStatusArray2();
        }

        if (widget.id != null && widget.type == "Leave") {
          selectedLeaveStatusArray();
        }
      });
    } else {
      setState(() {
        remarksList = [];
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  Future getAllWorkType() async {
    final prefs = await SharedPreferences.getInstance();

    String apiUrl = "ComTypeofwork";

    var result = await apiService.get(apiUrl);
    var response = workTypeListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        workTypeList = response.response;
        print('workTypeList ${workTypeList}');
        if (widget.id != null && widget.type == "Working Extra") {
          selectedWorkTypeArray();
        }
      });
    } else {
      setState(() {
        workTypeList = [];
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<SupportCustomer>? customerList;
  var selectedSupCustomerArr;
  String selectedSupportCustomer = "";

//   Future<void> getAllSupportCustomer() async {
//   String apiUrl = 'SupportCustomer';

//   try {
//     var result = await apiService.get(apiUrl);
//     print('Result: $result');

//     if (result == null || result.isEmpty) {
//       print("Received null or empty response");
//       setState(() {
//         customerList = [];
//       });
//       showInSnackBar(context, "No data available");
//       return;
//     }

//     var response = supportCustomerModelFromJson(result);

//     if (response.message.toString() == 'Success') {
//       setState(() {
//         print('customer response: ${response}');
//         customerList = response.supportCustomers;
//         print('Customer List: $customerList');

//         // Ensure `customerList` is not null before processing
//         for (var item in customerList!) {
//           item.accountHead = "${item.accode} ${item.accountHead}";
//         }
//       });
//     } else {
//       setState(() {
//         customerList = [];
//       });
//       showInSnackBar(context, response.message.toString());
//     }
//   } catch (e) {
//     print("Error during API call or processing: $e");
//     setState(() {
//       customerList = [];
//     });
//     showInSnackBar(context, "An error occurred: $e");
//   }

//   setState(() {});
// }

  Future getAllSupportCustomer() async {
    String apiUrl = "";

    apiUrl = 'SupportCustomer';

    var result = await apiService.get(apiUrl);

    var response = supportCustomerModelFromJson(result);
    if (response.message.toString() == 'Success') {
      setState(() {
        customerList = response.supportCustomers;
        print('customerList ${customerList}');

        for (var item in customerList!) {
          item.accountHeads = "${item.accode}-${item.accountHead}";
        }

        if (widget.id != null && widget.type == "Client Visit (Support)") {
          selectedClientNameArray();
        }
      });
    } else {
      setState(() {
        customerList = [];
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<ClientTeamList>? clientTeamList;
  var selectedClientTeamArr;
  String selectedClientTeam = "";

  Future getAllClientTeam() async {
    String apiUrl = "";

    apiUrl = 'ComTeamType';

    var result = await apiService.get(apiUrl);
    var response = clientTeamListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        clientTeamList = response.response;
        print('clientTeamList ${clientTeamList}');

        if (widget.id != null && widget.type == "Client Visit (Support)") {
          selectedClientTeamArray();
        }
      });
    } else {
      setState(() {
        clientTeamList = [];
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<VisitPurposeList>? visitPurposeList;
  var selectedVisitPurposeArr;
  String selectedVisitPurpose = "";

  Future getAllClientVisit() async {
    String apiUrl =
        'SupportPortalCommunicatorClientLocation?TEAM=${selectedClientTeam.toString()}';

    var result = await apiService.get(apiUrl);
    var response = clientVisitPurposeModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        visitPurposeList = response.response;
        print('visitPurposeList ${visitPurposeList}');
        if (widget.id != null && widget.type == "Client Visit (Support)") {
          selectedVisitPurposeArray();
        }
      });
    } else {
      setState(() {
        visitPurposeList = [];
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  WorkfromHomeEditData? workFromHomeData;

  Future getWorkFromHomeById() async {
    var id = (widget.id is double)
        ? widget.id.toInt()
        : int.parse(widget.id.toString());

    String apiUrl = 'EmployeeComWorkfromhome?MID=$id';

    var result = await apiService.get(apiUrl);
    var response = workfromHomeEditModelFromJson(result);
    if (response.status.toString() == 'Success') {
      getAllRemarksList();
      setState(() {
        workFromHomeData = response.response;

        selectedType = 0;

        dobCtrl.text =
            DateFormat('dd-MM-yyyy').format(workFromHomeData!.workedOn);

        workDuringCtrl.text = workFromHomeData!.workingDuring.toString();
        remarks = workFromHomeData!.reason;

        if (workFromHomeData!.halfFullDay == "Full Day") {
          selectedDay = 0;
        } else if (workFromHomeData!.halfFullDay == "Half Day-FN") {
          selectedDay = 1;
        } else {
          selectedDay = 2;
        }
        //selectedStatusArray1();
        print('workFromHomeData ${workFromHomeData}');
      });
    } else {
      setState(() {
        workFromHomeData = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  PermissionEditData? permissionData;

  Future getPermissionById() async {
    var id = (widget.id is double)
        ? widget.id.toInt()
        : int.parse(widget.id.toString());

    String apiUrl = 'EmployeeComPermission?MID=$id';

    var result = await apiService.get(apiUrl);
    var response = permissionEditModelFromJson(result);
    if (response.status.toString() == 'Success') {
      getAllRemarksList();
      setState(() {
        permissionData = response.response;
        selectedType = 1;

        dobCtrl.text = DateFormat('dd-MM-yyyy').format(permissionData!.date);

        String currentTime = DateFormat('hh:mm').format(permissionData!
            .preTime); // Formats time in 12-hour format with AM/PM
        startTimeCtrl.text = currentTime;
        selectedPermissionType = permissionData!.permissionType;
        if (selectedPermissionType == "WILL BE LATE" ||
            selectedPermissionType == "TAKING BREAK") {
          remarks = permissionData!.preRemark1;
        } else {
          remarks = permissionData!.remark!;
        }

        selectedPermissionType = permissionData!.permissionType;

        selectedPermissionTypeArray();

        print('permissionData ${permissionData}');
      });
    } else {
      setState(() {
        permissionData = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  LeaveEditData? leaveEditData;

  Future getLeaveById() async {
    var id = (widget.id is double)
        ? widget.id.toInt()
        : int.parse(widget.id.toString());

    String apiUrl = 'EmployeeComLeave?MID=$id';

    var result = await apiService.get(apiUrl);
    var response = leaveEditModelFromJson(result);
    if (response.status.toString() == 'Success') {
      getAllRemarksList();
      setState(() {
        leaveEditData = response.response;
        selectedType = 3;

        if (leaveEditData!.halfFullDay == "Full Day") {
          selectedDay = 0;
        } else if (leaveEditData!.halfFullDay == "Half Day-FN") {
          selectedDay = 1;
        } else {
          selectedDay = 2;
        }

        dobCtrl.text =
            DateFormat('dd-MM-yyyy').format(leaveEditData!.leaveAppliedOn);

        remarks = leaveEditData!.remarks;
        selectedLeaveType = leaveEditData!.leaveType;

        startDateCtrl.text =
            DateFormat('dd-MM-yyyy').format(leaveEditData!.startDate);
        endDateCtrl.text =
            DateFormat('dd-MM-yyyy').format(leaveEditData!.endDate);

        selectedLeaveTypeArray();

        if(leaveEditData!.leaveType == "Compensatory Leave"){

            compensatory = true;
            getAllWorkingExtraList(4);
            selectedWorkedOnLeave = leaveEditData!.workedOnDate.toString();
        }

        print('leaveEditData ${leaveEditData}');
      });
    } else {
      setState(() {
        leaveEditData = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  WorkingExtraEditData? workingExtraEditData;

  Future getWorkingExtraById() async {
    var id = (widget.id is double)
        ? widget.id.toInt()
        : int.parse(widget.id.toString());

    String apiUrl = 'EmployeeComWorkingExtra?MID=$id';

    var result = await apiService.get(apiUrl);
    var response = workingExtraEditModelFromJson(result);
    if (response.status.toString() == 'Success') {
      getAllWorkType();
      setState(() {
        workingExtraEditData = response.response;
        selectedType = 2;

        if (workingExtraEditData!.halfFullDay == "Full Day") {
          selectedDay = 0;
        } else if (workingExtraEditData!.halfFullDay == "Half Day-FN") {
          selectedDay = 1;
        } else {
          selectedDay = 2;
        }

        dobCtrl.text =
            DateFormat('dd-MM-yyyy').format(workingExtraEditData!.workedOn);

        remarksCtrl.text = workingExtraEditData!.remarks;

        selectedDuring = workingExtraEditData!.workingDuring;

        selectedWorkingDuringArray();

        selectedCompensation = workingExtraEditData!.compensation;

        selectedCompensationArray();

        selectedLocation = workingExtraEditData!.workingLocation;

        selectedWorkingLocationArray();

        selectedWorkType = workingExtraEditData!.typeOfWork;

        print('workingExtraEditData ${workingExtraEditData}');
      });
    } else {
      setState(() {
        workingExtraEditData = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  ClientVisitEditData? clientVisitEditData;

  Future getClientVisitById() async {
    var id = (widget.id is double)
        ? widget.id.toInt()
        : int.parse(widget.id.toString());

    String apiUrl = 'EmployeeComClientLocation?MID=$id';

    var result = await apiService.get(apiUrl);
    var response = clientVisitEditModelFromJson(result);
    if (response.status.toString() == 'Success') {
      getAllSupportCustomer();
      getAllClientTeam();
      setState(() {
        clientVisitEditData = response.response;
        selectedType = 4;

        dobCtrl.text =
            DateFormat('dd-MM-yyyy').format(clientVisitEditData!.date);

        selectedSupportCustomer = clientVisitEditData!.clientName;

        selectedClientTeam = clientVisitEditData!.team;

        selectedVisitPurpose = clientVisitEditData!.visitPurpose;

        clientLocationCtrl.text = clientVisitEditData!.clientLocation;

        clientContactCtrl.text = clientVisitEditData!.clientPoc;

        String currentTime = DateFormat('hh:mm').format(clientVisitEditData!
            .startTime); // Formats time in 12-hour format with AM/PM
        startTimeCtrl.text = currentTime;
        getAllClientVisit();

        print('clientVisitEditData ${clientVisitEditData}');
      });
    } else {
      setState(() {
        clientVisitEditData = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  void _showCalendarDialog(BuildContext context, String type) {
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
                        if (type == "WorkedOn") {
                          dobCtrl.text =
                              '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}';
                        } else if (type == "StartDate") {
                          startDateCtrl.text =
                              '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}';
                        } else {
                          endDateCtrl.text =
                              '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}';
                        }
                        getAllEntryList();
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

  List selectType = [
    {
      'name': 'Work From Home',
      'val': 1,
    },
    {
      'name': 'Permission',
      'val': 2,
    },
    {
      'name': 'Working Extra',
      'val': 3,
    },
    {
      'name': 'Leave',
      'val': 4,
    },
    {
      'name': 'Client visit ( support )',
      'val': 5,
    },
  ];
  int selectedType = 0;
  int selectedDay = 0;

  List daysType = [
    {
      'name': 'Full Day',
      'val': 1,
    },
    {
      'name': 'Half Day - FN',
      'val': 2,
    },
    {
      'name': 'Half Day - AN',
      'val': 3,
    },
  ];

  var selectedStatusArr;
  List statusList = [
    {'name': "Daily Login", 'id': 1},
    {'name': "Due to Emergency Work", 'id': 2},
    {'name': "For Personal Reason", 'id': 3},
    {'name': "For Hospital Purpose", 'id': 4},
    {'name': "Bank Related", 'id': 5},
  ];

  var selectedLeaveArr;
  String selectedLeaveType = "";
  List leaveList = [
    {'name': "Annual Leave", 'id': 1},
    {'name': "Sick Leave", 'id': 2},
    {'name': "Unpaid Leave", 'id': 3},
    {'name': "Compensatory Leave", 'id': 4},
  ];

  var selectedDuringArr;
  String selectedDuring = "";
  List workingDuringList = [
    {'name': "Weekend", 'id': 1},
    {'name': "Annual Vacation", 'id': 2},
    {'name': "Public Holiday", 'id': 3},
  ];

  var selectedCompensationArr;
  String selectedCompensation = "";
  List compensationList = [
    {'name': "COMPENSATORY OFF", 'id': 1},
    {'name': "EXTRA PAID", 'id': 2},
    {'name': "FOR LEAVE ALREADY TAKEN", 'id': 3},
  ];

  var selectedLocationArr;
  String selectedLocation = "";
  List locationList = [
    {'name': "WORK FROM OFFICE", 'id': 1},
    {'name': "WORK FROM HOME", 'id': 2},
    {'name': "FOR CLIENT", 'id': 3},
  ];

  var selectedPermissionArr;
  String selectedPermissionType = "";
  List permissionList = [
    {'name': "WILL BE LATE", 'id': 1},
    {'name': "TAKING BREAK", 'id': 2},
    {'name': "LEAVING EARLY", 'id': 3},
  ];

  selectedStatusArray() {
    String remarks = "Daily Login";

    List result;

    if (remarksList!.isNotEmpty) {
      result =
          remarksList!.where((element) => element.remarks == remarks).toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedStatusArr = result[0];
        });
      } else {
        setState(() {
          selectedStatusArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedStatusArr empty');

        selectedStatusArr = null;
      });
    }
  }

  selectedStatusArray1() {
    String remarks = "Daily Login";

    List result;

    if (remarksList!.isNotEmpty) {
      result = remarksList!
          .where((element) => element.remarks == workFromHomeData!.reason)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedStatusArr = result[0];
        });
      } else {
        setState(() {
          selectedStatusArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedStatusArr empty');

        selectedStatusArr = null;
      });
    }
  }

  selectedStatusArray2() {
    String remarks = "Daily Login";

    List result;

    if (remarksList!.isNotEmpty) {
      result = remarksList!
          .where((element) =>
              element.remarks ==
              (permissionData!.permissionType == "WILL BE LATE" ||
                      permissionData!.permissionType == "TAKING BREAK"
                  ? permissionData!.preRemark1
                  : permissionData!.remark))
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedStatusArr = result[0];
        });
      } else {
        setState(() {
          selectedStatusArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedStatusArr empty');

        selectedStatusArr = null;
      });
    }
  }

  selectedLeaveStatusArray() {
    List result;

    if (remarksList!.isNotEmpty) {
      result = remarksList!
          .where((element) => element.remarks == leaveEditData!.remarks)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedStatusArr = result[0];
        });
      } else {
        setState(() {
          selectedStatusArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedStatusArr empty');

        selectedStatusArr = null;
      });
    }
  }

  selectedPermissionTypeArray() {
    List result;

    if (permissionList!.isNotEmpty) {
      result = permissionList!
          .where((element) => element["name"] == permissionData!.permissionType)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedPermissionArr = result[0];
        });
      } else {
        setState(() {
          selectedPermissionArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedStatusArr empty');

        selectedPermissionArr = null;
      });
    }
  }

  selectedLeaveTypeArray() {
    List result;

    if (leaveList.isNotEmpty) {
      result = leaveList
          .where((element) => element["name"] == leaveEditData!.leaveType)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedLeaveArr = result[0];
        });
      } else {
        setState(() {
          selectedLeaveArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedLeaveArr empty');

        selectedLeaveArr = null;
      });
    }
  }

  selectedWorkingDuringArray() {
    List result;

    if (workingDuringList.isNotEmpty) {
      result = workingDuringList
          .where((element) =>
              element["name"] == workingExtraEditData!.workingDuring)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedDuringArr = result[0];
        });
      } else {
        setState(() {
          selectedDuringArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedDuringArr empty');

        selectedDuringArr = null;
      });
    }
  }

  selectedCompensationArray() {
    List result;

    if (compensationList.isNotEmpty) {
      result = compensationList
          .where((element) =>
              element["name"] == workingExtraEditData!.compensation)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedCompensationArr = result[0];
        });
      } else {
        setState(() {
          selectedCompensationArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedCompensationArr empty');

        selectedCompensationArr = null;
      });
    }
  }

  selectedWorkingLocationArray() {
    List result;

    if (locationList.isNotEmpty) {
      result = locationList
          .where((element) =>
              element["name"] == workingExtraEditData!.workingLocation.trim())
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedLocationArr = result[0];
        });
      } else {
        setState(() {
          selectedLocationArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedLocationArr empty');

        selectedLocationArr = null;
      });
    }
  }

  selectedWorkTypeArray() {
    List result;

    if (workTypeList!.isNotEmpty) {
      result = workTypeList!
          .where((element) => element.type == workingExtraEditData!.typeOfWork)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedWorkTypeArr = result[0];
        });
      } else {
        setState(() {
          selectedWorkTypeArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedWorkTypeArr empty');

        selectedWorkTypeArr = null;
      });
    }
  }

  selectedClientNameArray() {
    List result;

    if (customerList!.isNotEmpty) {
      result = customerList!
          .where((element) =>
              element.accountHead == clientVisitEditData!.clientName)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedSupCustomerArr = result[0];
        });
      } else {
        setState(() {
          selectedSupCustomerArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedSupCustomerArr empty');

        selectedSupCustomerArr = null;
      });
    }
  }

  selectedClientTeamArray() {
    List result;

    if (clientTeamList!.isNotEmpty) {
      result = clientTeamList!
          .where((element) => element.team == clientVisitEditData!.team)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedClientTeamArr = result[0];
        });
      } else {
        setState(() {
          selectedClientTeamArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedClientTeamArr empty');

        selectedClientTeamArr = null;
      });
    }
  }

  selectedVisitPurposeArray() {
    List result;

    if (visitPurposeList!.isNotEmpty) {
      result = visitPurposeList!
          .where((element) =>
              element.supportType == clientVisitEditData!.visitPurpose)
          .toList();

      if (result.isNotEmpty) {
        setState(() {
          selectedVisitPurposeArr = result[0];
        });
      } else {
        setState(() {
          selectedVisitPurposeArr = null;
        });
      }
    } else {
      setState(() {
        print('selectedVisitPurposeArr empty');

        selectedVisitPurposeArr = null;
      });
    }
  }

  errValidateDuring(String? value) {
    return (value) {
      if (value.isEmpty) {
        return 'Working During is required';
      }
      return null;
    };
  }

  errValidateClienttLocation(String? value) {
    return (value) {
      if (value.isEmpty) {
        return 'Client Location is required';
      }
      return null;
    };
  }

  errValidateClientContact(String? value) {
    return (value) {
      if (value.isEmpty) {
        return 'Client Point of Contact is required';
      }
      return null;
    };
  }

  errValidateRemarks(String? value) {
    return (value) {
      if (value.isEmpty) {
        return 'Remarks is required';
      }
      return null;
    };
  }

  errValidateStartTime(String? value) {
    return (value) {
      if (value.isEmpty) {
        return 'Start Time is required';
      }
      return null;
    };
  }

  String formatDate(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future saveEntryWorkFromHome() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      String checkInTime =
          DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());

      String day = "";

      if (selectedDay == 0) {
        day = "Full Day";
      } else if (selectedDay == 1) {
        day = "Half Day - FN";
      } else {
        day = "Half Day - AN";
      }

      if (remarks == "") {
        remarks = "Daily Login";
      }

      Map<String, dynamic> postData = {
        "MID": "",
        "EMP_NAME": userName.toString(),
        "EMP_LOCATION": location.toString(),
        "WORKED_ON": formattedDate,
        "EMP_DEPT": department.toString(),
        "APPROVED_BY": approvedBy.toString(),
        "REASON": remarks.toString(),
        "WORKING_DURING": workDuringCtrl.text,
        "CHECK_IN_TIME": checkInTime,
        "CHECK_OUT_TIME": "",
        "HALF_FULL_DAY": day.toString()
      };

      var result = await apiService.saveEntryWorkFromHome(postData);

      AddEntryModel response = addEntryModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future updateEntryWorkFromHome() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      String checkInTime =
          DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

      String checkOutTime =
          DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

      String day = "";

      if (selectedDay == 0) {
        day = "Full Day";
      } else if (selectedDay == 1) {
        day = "Half Day - FN";
      } else {
        day = "Half Day - AN";
      }

      if (remarks == "") {
        remarks = "Daily Login";
      }

      var id = (widget.id is double)
          ? widget.id.toInt()
          : int.parse(widget.id.toString());

      Map<String, dynamic> postData = {
        "MID": id,
        "EMP_NAME": userName.toString(),
        "EMP_LOCATION": location.toString(),
        "WORKED_ON": formattedDate,
        "EMP_DEPT": department.toString(),
        "APPROVED_BY": approvedBy.toString(),
        "REASON": remarks.toString(),
        "WORKING_DURING": workDuringCtrl.text,
        "CHECK_IN_TIME": workFromHomeData!.checkInTime.toString(),
        "CHECK_OUT_TIME": checkOutTime,
        "HALF_FULL_DAY": day.toString()
      };

      var result = await apiService.updateEntryWorkFromHome(id, postData);

      AddEntryModel response = addEntryModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  int calculateDaysBetween(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays;
  }

  Future saveEntryLeave() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(startDateCtrl.text);

      // Format the date to yyyy-MM-dd
      String startDate1 = DateFormat('yyyy-MM-dd').format(parsedDate1);

      DateTime parsedDate2 = DateFormat('dd-MM-yyyy').parse(endDateCtrl.text);

      // Format the date to yyyy-MM-dd
      String endDate1 = DateFormat('yyyy-MM-dd').format(parsedDate2);

      DateTime startDate = DateFormat('dd-MM-yyyy').parse(startDateCtrl.text);
      DateTime endDate = DateFormat('dd-MM-yyyy').parse(endDateCtrl.text);

      int noOfDays = calculateDaysBetween(startDate, endDate);

      String day = "";

      if (selectedDay == 0) {
        day = "Full Day";
      } else if (selectedDay == 1) {
        day = "Half Day - FN";
      } else {
        day = "Half Day - AN";
      }

      if (remarks == "") {
        remarks = "Daily Login";
      }

      Map<String, dynamic> postData = {
        "MID": "",
        "EMP_NAME": userName.toString(),
        "EMP_LOCATION": location.toString(),
        "LEAVE_APPLIED_ON": formattedDate.toString(),
        "EMP_DEPT": department.toString(),
        "APPROVED_BY": approvedBy.toString(),
        "REMARKS": remarks.toString(),
        "LEAVE_TYPE": selectedLeaveType.toString(),
        "HALF_FULL_DAY": day.toString(),
        "START_DATE": startDate1.toString(),
        "END_DATE": endDate1.toString(),
        "NO_OF_DAYS": noOfDays,
        "APPROVAL_STATUS": "P",
        "REJECTION_REMARKS": "",
        "WORKED_ON_DATE": selectedWorkedOnLeave.toString()
      };

      var result = await apiService.saveEntryLeave(postData);

      AddEntryLeaveModel response = addEntryLeaveModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future updateEntryLeave() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(startDateCtrl.text);

      // Format the date to yyyy-MM-dd
      String startDate1 = DateFormat('yyyy-MM-dd').format(parsedDate1);

      DateTime parsedDate2 = DateFormat('dd-MM-yyyy').parse(endDateCtrl.text);

      // Format the date to yyyy-MM-dd
      String endDate1 = DateFormat('yyyy-MM-dd').format(parsedDate2);

      DateTime startDate = DateFormat('dd-MM-yyyy').parse(startDateCtrl.text);
      DateTime endDate = DateFormat('dd-MM-yyyy').parse(endDateCtrl.text);

      int noOfDays = calculateDaysBetween(startDate, endDate);

      String day = "";

      if (selectedDay == 0) {
        day = "Full Day";
      } else if (selectedDay == 1) {
        day = "Half Day - FN";
      } else {
        day = "Half Day - AN";
      }

      if (remarks == "") {
        remarks = "Daily Login";
      }

      var id = (widget.id is double)
          ? widget.id.toInt()
          : int.parse(widget.id.toString());

      Map<String, dynamic> postData = {
        "MID": id,
        "EMP_NAME": userName.toString(),
        "EMP_LOCATION": location.toString(),
        "LEAVE_APPLIED_ON": formattedDate.toString(),
        "EMP_DEPT": department.toString(),
        "APPROVED_BY": approvedBy.toString(),
        "REMARKS": remarks.toString(),
        "LEAVE_TYPE": selectedLeaveType.toString(),
        "HALF_FULL_DAY": day.toString(),
        "START_DATE": startDate1.toString(),
        "END_DATE": endDate1.toString(),
        "NO_OF_DAYS": noOfDays,
        "APPROVAL_STATUS": "P",
        "REJECTION_REMARKS": "",
        "WORKED_ON_DATE": selectedWorkedOnLeave.toString()
      };

      var result = await apiService.updateEntryLeave(id, postData);

      AddEntryLeaveModel response = addEntryLeaveModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future saveEntryPermission() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      // DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(startDateCtrl.text);

      // // Format the date to yyyy-MM-dd
      // String startDate1 = DateFormat('yyyy-MM-dd').format(parsedDate1);

      //  DateTime parsedDate2 = DateFormat('dd-MM-yyyy').parse(endDateCtrl.text);

      // // Format the date to yyyy-MM-dd
      // String endDate1 = DateFormat('yyyy-MM-dd').format(parsedDate2);

      if (remarks == "") {
        remarks = "Daily Login";
      }
      Map<String, dynamic> postData = {};

      if (selectedPermissionType == "WILL BE LATE" ||
          selectedPermissionType == "TAKING BREAK") {
        postData = {
          "MID": "",
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "DATE": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARK": "",
          "PERMISSION_TYPE": selectedPermissionType.toString(),
          "TIME": "",
          "PRE_TIME": startTimeCtrl.text,
          "POST_TIME": " ",
          "PRE_REMARK1": remarks.toString(),
          "POST_REMARK2": ""
        };
      } else {
        postData = {
          "MID": "",
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "DATE": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARK": remarks.toString(),
          "PERMISSION_TYPE": selectedPermissionType.toString(),
          "TIME": startTimeCtrl.text,
          "PRE_TIME": "",
          "POST_TIME": " ",
          "PRE_REMARK1": "",
          "POST_REMARK2": ""
        };
      }

      var result = await apiService.saveEntryPermission(postData);

      AddEntryPermissionModel response =
          addEntryPermissionModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future updateEntryPermission() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      // DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(startDateCtrl.text);

      // // Format the date to yyyy-MM-dd
      // String startDate1 = DateFormat('yyyy-MM-dd').format(parsedDate1);

      //  DateTime parsedDate2 = DateFormat('dd-MM-yyyy').parse(endDateCtrl.text);

      // // Format the date to yyyy-MM-dd
      // String endDate1 = DateFormat('yyyy-MM-dd').format(parsedDate2);

      var id = (widget.id is double)
          ? widget.id.toInt()
          : int.parse(widget.id.toString());
      Map<String, dynamic> postData = {};

      if (selectedPermissionType == "WILL BE LATE" ||
          selectedPermissionType == "TAKING BREAK") {
        postData = {
          "MID": id,
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "DATE": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARK": "",
          "PERMISSION_TYPE": selectedPermissionType.toString(),
          "TIME": "",
          "PRE_TIME": startTimeCtrl.text,
          "POST_TIME": " ",
          "PRE_REMARK1": remarks.toString(),
          "POST_REMARK2": ""
        };
      } else {
        postData = {
          "MID": id,
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "DATE": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARK": remarks.toString(),
          "PERMISSION_TYPE": selectedPermissionType.toString(),
          "TIME": startTimeCtrl.text,
          "PRE_TIME": "",
          "POST_TIME": " ",
          "PRE_REMARK1": "",
          "POST_REMARK2": ""
        };
      }

      var result = await apiService.updateEntryPermission(id, postData);

      AddEntryPermissionModel response =
          addEntryPermissionModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future saveEntryWorkingExtra() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      DateTime parsedDate1 = DateFormat('dd-MM-yyyy').parse(selectedLeaveTaken);

      // Format the date to yyyy-MM-dd
      String formattedLeaveDate = DateFormat('yyyy-MM-dd').format(parsedDate1);

      String day = "";

      if (selectedDay == 0) {
        day = "Full Day";
      } else if (selectedDay == 1) {
        day = "Half Day - FN";
      } else {
        day = "Half Day - AN";
      }

      if (remarks != null) {
        remarks = "Daily Login";
      }

      DateTime now = DateTime.now();

      // Define the format you want (24-hour format without AM/PM)
      String checkIn = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      Map<String, dynamic> postData = {};

      if (selectedCompensation == "COMPENSATORY OFF" ||
          selectedCompensation == "EXTRA PAID") {
        postData = {
          "MID": "",
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "WORKED_ON": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARKS": remarksCtrl.text,
          "HALF_FULL_DAY": day.toString(),
          "WORKING_DURING": selectedDuring.toString(),
          "COMPENSATION": selectedCompensation.toString(),
          "WORKING_LOCATION": selectedLocation.toString(),
          "TYPE_OF_WORK": selectedWorkType.toString(),
          "CHECK_IN_TIME": checkIn.toString(),
          "CHECK_OUT_TIME": "",
          "LEAVE_TAKEN_DATES": "",
          "LEAVE_ON_MID": ""
        };
      } else {
        postData = {
          "MID": "",
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "WORKED_ON": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARKS": remarksCtrl.text,
          "HALF_FULL_DAY": day.toString(),
          "WORKING_DURING": selectedDuring.toString(),
          "COMPENSATION": selectedCompensation.toString(),
          "WORKING_LOCATION": selectedLocation.toString(),
          "TYPE_OF_WORK": selectedWorkType.toString(),
          "CHECK_IN_TIME": checkIn.toString(),
          "CHECK_OUT_TIME": "",
          "LEAVE_TAKEN_DATES": formattedLeaveDate.toString(),
          "LEAVE_ON_MID": ""
        };
      }

      var result = await apiService.saveEntryWorkingExtra(postData);

      AddEntryWorkingExtraModel response =
          addEntryWorkingExtraModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future updateEntryWorkingExtra() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      String formattedLeaveDate = "";

      if (selectedCompensation == "FOR LEAVE ALREADY TAKEN") {
        DateTime parsedDate1 = DateFormat('dd-MM-yyyy')
            .parse(workingExtraEditData!.leaveTakenDates);

        // Format the date to yyyy-MM-dd
        formattedLeaveDate = DateFormat('yyyy-MM-dd').format(parsedDate1);
      }

      String day = "";

      if (selectedDay == 0) {
        day = "Full Day";
      } else if (selectedDay == 1) {
        day = "Half Day - FN";
      } else {
        day = "Half Day - AN";
      }

      DateTime now = DateTime.now();

      // Define the format you want (24-hour format without AM/PM)
      String checkOut = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      String checkin = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(workingExtraEditData!.checkInTime);

      var id = (widget.id is double)
          ? widget.id.toInt()
          : int.parse(widget.id.toString());
      Map<String, dynamic> postData = {};

      print('selectedCompensation ${selectedCompensation}');

      if (selectedCompensation == "COMPENSATORY OFF" ||
          selectedCompensation == "EXTRA PAID") {
        postData = {
          "MID": id,
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "WORKED_ON": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARKS": remarksCtrl.text,
          "HALF_FULL_DAY": day.toString(),
          "WORKING_DURING": selectedDuring.toString(),
          "COMPENSATION": selectedCompensation.toString(),
          "WORKING_LOCATION": selectedLocation.toString(),
          "TYPE_OF_WORK": selectedWorkType.toString(),
          "CHECK_IN_TIME": checkin.toString(),
          "CHECK_OUT_TIME": checkOut.toString(),
          "LEAVE_TAKEN_DATES": "",
          "LEAVE_ON_MID": ""
        };
      } else {
        postData = {
          "MID": id,
          "EMP_NAME": userName.toString(),
          "EMP_LOCATION": location.toString(),
          "WORKED_ON": formattedDate.toString(),
          "EMP_DEPT": department.toString(),
          "APPROVED_BY": approvedBy.toString(),
          "REMARKS": remarksCtrl.text,
          "HALF_FULL_DAY": day.toString(),
          "WORKING_DURING": selectedDuring.toString(),
          "COMPENSATION": selectedCompensation.toString(),
          "WORKING_LOCATION": selectedLocation.toString(),
          "TYPE_OF_WORK": selectedWorkType.toString(),
          "CHECK_IN_TIME": checkin.toString(),
          "CHECK_OUT_TIME": checkOut.toString(),
          "LEAVE_TAKEN_DATES": formattedLeaveDate.toString(),
          "LEAVE_ON_MID": ""
        };
      }

      var result = await apiService.updateEntryWorkingExtra(id, postData);

      AddEntryWorkingExtraModel response =
          addEntryWorkingExtraModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future saveEntryClientVisit() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

// DateTime now = DateTime.now();

//   // Define the format you want (24-hour format without AM/PM)
//   String checkIn = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      Map<String, dynamic> postData = {
        "MID": "",
        "EMP_NAME": userName.toString(),
        "EMP_DEPT": department.toString(),
        "APPROVED_BY": approvedBy.toString(),
        "EMP_LOCATION": location.toString(),
        "CLIENT_NAME": selectedSupportCustomer.toString(),
        "CLIENT_LOCATION": clientLocationCtrl.text,
        "CLIENT_POC": clientContactCtrl.text,
        "DATE": formattedDate.toString(),
        "VISIT_PURPOSE": selectedVisitPurpose.toString(),
        "START_TIME": startTimeCtrl.text,
        "END_TIME": startTimeCtrl.text,
        "TEAM": selectedClientTeam.toString()
      };

      var result = await apiService.saveEntryClientVisit(postData);

      AddEntryClientVisitModel response =
          addEntryClientVisitModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  Future updateEntryClientVisit() async {
    if (dobCtrl.text != "") {
      final prefs = await SharedPreferences.getInstance();

      String userName = prefs.getString('username') ?? '';
      String location = prefs.getString('location') ?? '';
      String department = prefs.getString('department') ?? '';
      String approvedBy = prefs.getString('approved_by') ?? '';

      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);

      // Format the date to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      // Format the date to yyyy-MM-dd
      String startTime =
          DateFormat('hh:mm').format(clientVisitEditData!.startTime);

// DateTime now = DateTime.now();

//   // Define the format you want (24-hour format without AM/PM)
//   String checkIn = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      var id = (widget.id is double)
          ? widget.id.toInt()
          : int.parse(widget.id.toString());

      Map<String, dynamic> postData = {
        "MID": id,
        "EMP_NAME": userName.toString(),
        "EMP_DEPT": department.toString(),
        "APPROVED_BY": approvedBy.toString(),
        "EMP_LOCATION": location.toString(),
        "CLIENT_NAME": selectedSupportCustomer.toString(),
        "CLIENT_LOCATION": clientLocationCtrl.text,
        "CLIENT_POC": clientContactCtrl.text,
        "DATE": formattedDate.toString(),
        "VISIT_PURPOSE": selectedVisitPurpose.toString(),
        "START_TIME": startTime.toString(),
        "END_TIME": startTimeCtrl.text,
        "TEAM": selectedClientTeam.toString()
      };

      var result = await apiService.updateEntryClientVisit(id, postData);

      AddEntryClientVisitModel response =
          addEntryClientVisitModelFromJson(result);

      if (response.status.toString() == 'Success') {
        showInSnackBar(context, response.message.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => EntryListPage()));
        //  Navigator.pop(context, {'add': true});
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }

  List<LeaveApprovalData>? approvalList;
  List<LeaveApprovalData>? approvalList1;

  List<LeaveApprovalData>? approvalListAll;
  var selectedLeaveTakenArr;
  String selectedLeaveTaken = '';

  String userName = "";
  List? leaveTakenList = [];

  Future getAllLeaveApproval() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username') ?? '';

    var result = await apiService.getAllLeaveApproval();
    var response = leaveApprovalListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        approvalListAll = response.response;

        approvalList = approvalListAll!.where((entry) {
          String? employeeName = entry.empName;
          String? status = entry.approvalStatus;
          //  DateTime? startDate = entry.startDate;
          //  String formattedDate = DateFormat('dd-MM-yyyy').format(startDate);
          //  entry.startDateStr = formattedDate;
          if (employeeName != null) {
            print(employeeName);
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

        for (var item in approvalList!) {
          // Parse the startdate using the input format
          DateTime? startDate = item.startDate;

          // Format the date to dd-MM-yyyy

          String formattedDate = DateFormat('dd-MM-yyyy').format(startDate);

          leaveTakenList!.add({'date': formattedDate.toString()});
          // Update the startdate in the approvalList
          //item.startDate = formattedDate
        }

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

  List<WorkfromHomeListData>? workFromHomeList = [];
  List<WorkfromHomeListData>? workFromHomeListAll;

  bool buttonDisable = false;
  Future getAllWorkFromHome() async {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComWorkfromhome';

    var result = await apiService.get(apiUrl);
    var response = workfromHomeListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        print('workFromHomeList ${workFromHomeList}');

        workFromHomeListAll = response.response;

        DateTime workedOnDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
        String workedOnDate1 = DateFormat('dd-MM-yyyy').format(workedOnDate);

        workFromHomeList = workFromHomeListAll!.where((entry) {
          String formattedWorkedOnDate =
              DateFormat('dd-MM-yyyy').format(entry.workedOn);
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase() &&
                workedOnDate1 == formattedWorkedOnDate;
          }
          return false;
        }).toList();
        print('workFromHomeList ${workFromHomeList}');
        if (workFromHomeList!.isEmpty) {
          print("buttonDisable");
          buttonDisable = false;
        } else {
          print("buttonDisable1");
          buttonDisable = true;
        }
      });
    } else {
      setState(() {
        workFromHomeList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<PermissionListData>? permissionList1;
  List<PermissionListData>? permissionListAll;

  Future getAllPermissionList() async {
    setState(() {
      buttonDisable = false;
    });

    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComPermission';

    var result = await apiService.get(apiUrl);
    var response = permissionListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        permissionListAll = response.response;

        DateTime workedOnDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
        String workedOnDate1 = DateFormat('dd-MM-yyyy').format(workedOnDate);

        permissionList1 = permissionListAll!.where((entry) {
          String formattedWorkedOnDate =
              DateFormat('dd-MM-yyyy').format(entry.date);
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase() &&
                workedOnDate1 == formattedWorkedOnDate;
          }
          return false;
        }).toList();

        if (permissionList1!.isEmpty) {
          print("buttonDisable");
          buttonDisable = false;
        } else {
          print("buttonDisable1");
          buttonDisable = true;
        }
      });
    } else {
      setState(() {
        permissionList1 = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<WorkingExtraListData>? workinExtraList;
  List<WorkingExtraListData>? workinExtraListAll;

  Future getAllWorkingExtraList(int id) async {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

    String apiUrl = 'EmployeeComWorkingExtra';

    var result = await apiService.get(apiUrl);
    var response = workingExtraListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        workinExtraListAll = response.response;
        print('workinExtraListAll ${workinExtraListAll}');

        DateTime workedOnDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
        String workedOnDate1 = DateFormat('dd-MM-yyyy').format(workedOnDate);

      if(id == 0){
         workinExtraList = workinExtraListAll!.where((entry) {
          String formattedWorkedOnDate =
              DateFormat('dd-MM-yyyy').format(entry.workedOn);
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase() &&
                workedOnDate1 == formattedWorkedOnDate;
          }
          return false;
        }).toList();
      }
      else if(id == 4){

        workinExtraList = workinExtraListAll!.where((entry) {
            String formattedWorkedOnDate = DateFormat('dd-MM-yyyy').format(entry.workedOn);
            String? employeeName = entry.empName;

            // Get current date and extract the year and month
            DateTime now = DateTime.now();
            int currentYear = now.year;
            int currentMonth = now.month;

            // Extract the year and month from the workedOn date
            DateTime workedOnDate = entry.workedOn;
            int workedOnYear = workedOnDate.year;
            int workedOnMonth = workedOnDate.month;

            // Check if the workedOn date is in the current month and year
            bool isCurrentMonth = (workedOnYear == currentYear && workedOnMonth == currentMonth);
           

            if (employeeName != null) {
              print(employeeName);
              return employeeName.toLowerCase() == userName.toLowerCase() &&
                    entry.compensation == "COMPENSATORY OFF" &&
                    isCurrentMonth;
            }
            return false;
          }).toList();

          print('CompansationWorkedonlist:$workinExtraList');



      }
       
       if(id == 0){
        if (workinExtraList!.isEmpty) {
          print("buttonDisable");
          buttonDisable = false;
        } else {
          print("buttonDisable1");
          buttonDisable = true;
        }
       }
      });
    } else {
      setState(() {
        workinExtraList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List<LeaveListData>? leaveList1;
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
        print('LeaveList ${leaveListAll}');

        DateTime workedOnDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
        String workedOnDate1 = DateFormat('dd-MM-yyyy').format(workedOnDate);

        leaveList1 = leaveListAll!.where((entry) {
          String formattedWorkedOnDate =
              DateFormat('dd-MM-yyyy').format(entry.leaveAppliedOn);
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase() &&
                workedOnDate1 == formattedWorkedOnDate;
          }
          return false;
        }).toList();

        if (leaveList1!.isEmpty) {
          print("buttonDisable");
          buttonDisable = false;
        } else {
          print("buttonDisable1");
          buttonDisable = true;
        }
      });
    } else {
      setState(() {
        leaveList1 = null;
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

        DateTime workedOnDate = DateFormat('dd-MM-yyyy').parse(dobCtrl.text);
        String workedOnDate1 = DateFormat('dd-MM-yyyy').format(workedOnDate);

        clientVisitList = clientVisitListAll!.where((entry) {
          String formattedWorkedOnDate =
              DateFormat('dd-MM-yyyy').format(entry.date);
          String? employeeName = entry.empName;
          if (employeeName != null) {
            print(employeeName);
            return employeeName.toLowerCase() == userName.toLowerCase() &&
                workedOnDate1 == formattedWorkedOnDate;
          }
          return false;
        }).toList();

        if (clientVisitList!.isEmpty) {
          print("buttonDisable");
          buttonDisable = false;
        } else {
          print("buttonDisable1");
          buttonDisable = true;
        }
      });
    } else {
      setState(() {
        clientVisitList = null;
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
  }

  List? entryList;

  Future getAllEntryList() async {
    // if (dobCtrl.text != "") {
    final prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('username') ?? '';

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

        if (startDateCtrl.text != "") {
          DateTime startDate =
              DateFormat('dd-MM-yyyy').parse(startDateCtrl.text);

          String starDate1 = DateFormat('dd-MM-yyyy').format(startDate);
          print('startDate $starDate1');

          entryList = entryList!.where((entry) {
            String formattedWorkedOnDate = "";
            if (entry["WORKED_ON"] != null) {
              DateTime parsedDate = DateTime.parse(entry["WORKED_ON"]);
              formattedWorkedOnDate =
                  DateFormat('dd-MM-yyyy').format(parsedDate);
              print('workedon $formattedWorkedOnDate');
            } else {
              DateTime parsedDate = DateTime.parse(entry["DATE"]);
              formattedWorkedOnDate =
                  DateFormat('dd-MM-yyyy').format(parsedDate);
              print(formattedWorkedOnDate);
            }
            String? employeeName = entry["EMP_NAME"];
            if (employeeName != null) {
              print(employeeName);
              return employeeName.toLowerCase() == userName.toLowerCase() &&
                  starDate1 == formattedWorkedOnDate;
            }
            return false;
          }).toList();
        }

        if (endDateCtrl.text != "") {
          DateTime endDate = DateFormat('dd-MM-yyyy').parse(endDateCtrl.text);
          String endDate2 = DateFormat('dd-MM-yyyy').format(endDate);
          entryList = entryList!.where((entry) {
            String formattedWorkedOnDate = "";
            if (entry["WORKED_ON"] != null) {
              DateTime parsedDate = DateTime.parse(entry["WORKED_ON"]);
              formattedWorkedOnDate =
                  DateFormat('dd-MM-yyyy').format(parsedDate);
            } else {
              DateTime parsedDate = DateTime.parse(entry["DATE"]);
              formattedWorkedOnDate =
                  DateFormat('dd-MM-yyyy').format(parsedDate);
              print(formattedWorkedOnDate);
            }
            String? employeeName = entry["EMP_NAME"];
            if (employeeName != null) {
              print(employeeName);
              return employeeName.toLowerCase() == userName.toLowerCase() &&
                  endDate2 == formattedWorkedOnDate;
            }
            return false;
          }).toList();
        }

        if (entryList!.isNotEmpty) {
          startDateCtrl.text = "";
          endDateCtrl.text = "";
          showDateExistsPopup(context, startDateCtrl.text);
        }

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

  void showDateExistsPopup(BuildContext context, String startDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: HeadingWidget(
              title: 'An entry already exists for the selected date'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  String getLabel(int selectedType) {
    switch (selectedType) {
      case 3:
        return 'Applied on :';
      case 1:
        return 'Date :';
      case 2:
        return 'Date :';
      case 4:
        return 'Date :';
      default:
        return 'Worked on :';
    }
  }

  void saveEntry(int selectedType) {
    switch (selectedType) {
      case 0:
        saveEntryWorkFromHome();
        break;
      case 1:
        saveEntryPermission();
        break;
      case 2:
        saveEntryWorkingExtra();
        break;
      case 3:
        saveEntryLeave();
        break;
      case 4:
        saveEntryClientVisit();
        break;
      // Add more cases as needed
      default:
        print('Invalid selection');
    }
  }

  void updateEntry(int selectedType) {
    switch (selectedType) {
      case 0:
        updateEntryWorkFromHome();
        break;
      case 1:
        updateEntryPermission();
        break;
      case 2:
        updateEntryWorkingExtra();
        break;
      case 3:
        updateEntryLeave();
        break;
      case 4:
        updateEntryClientVisit();
        break;
      // Add more cases as needed
      default:
        print('Invalid selection');
    }
  }

  void timePicker(String selectedPermissionType) {
    switch (selectedPermissionType) {
      case "WILL BE LATE":
        null;
        break;
      case "TAKING BREAK":
        null;
        break;
      case "LEAVING EARLY":
        _selectTime(context);
        break;
      // Add more cases as needed
      default:
        print('Invalid selection');
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Header background color
            hintColor: Colors.blue, // Selected color
            colorScheme: ColorScheme.light(primary: Colors.blue),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Convert TimeOfDay to DateTime to format it
        final now = DateTime.now();
        final DateTime selectedTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        startTimeCtrl.text = DateFormat('hh:mm').format(selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('')),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  //SizedBox(height: 27.0),
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
                                      color: AppColors.lightGrey2, width: 1.0)),
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
                              ])),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProfilePage()));
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HeadingWidget(
                        title: 'Entry',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
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
                                  title: 'Employee Name: ',
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                HeadingWidget(
                                  title: name.toString(),
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
                                  fontSize: 12.0,
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
                                  fontSize: 12.0,
                                )
                              ],
                            )
                          ],
                        ),
                      ])),

                  SizedBox(
                    height: 18.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HeadingWidget(
                        title: getLabel(selectedType),
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      CustomRoundedTextField(
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
                          width: 158.0,
                          readOnly: true, // when true user cannot edit text

                          onTap: () async {
                            _showCalendarDialog(context, 'WorkedOn');
                          }),
                    ],
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    HeadingWidget(
                      title: 'Select Type :',
                      vMargin: 1.0,
                      color: AppColors.darkBlue3,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    )
                  ]),

                  SizedBox(
                    height: 8.0,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 3.0,
                      children: selectType.map((choice) {
                        int index = selectType.indexOf(choice);
                        return GroupChipWidget(
                          showCheckmark: false,
                          items: choice['name'],
                          selectedChip: selectedType,
                          index: index,
                          selectedColor: AppColors.darkBlue3,
                          // backgroundColor: AppColors.light,
                          nonSeletedColor: AppColors.dark,
                          fontSize: 12.0,
                          onTap: (bool selected) {
                            setState(() {
                              selectedType = selected ? index : 0;
                              selectedPermissionType = "LEAVING EARLY";
                              buttonDisable = false;
                              if (selectedType == 0) {
                                getAllWorkFromHome();
                              } else if (selectedType == 1) {
                                getAllPermissionList();
                              } else if (selectedType == 2) {
                                getAllWorkingExtraList(0);
                              } else if (selectedType == 3) {
                                getAllLeaveList();
                              } else if (selectedType == 4) {
                                getAllClientVisitList();
                              }
                              print(selectedType);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(
                    height: 15.0,
                  ),

                  Divider(
                    height: 1,
                    thickness: 0.0,
                    color: AppColors.grey,
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  if (selectedType != 4 && selectedType != 1)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: 'Half / Full day',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      )
                    ]),

                  if (selectedType != 4 && selectedType != 1)
                    SizedBox(
                      height: 8.0,
                    ),

                  if (selectedType != 4 && selectedType != 1)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 3.0,
                        children: daysType.map((choice) {
                          int index = daysType.indexOf(choice);
                          return GroupChipWidget(
                            showCheckmark: false,
                            items: choice['name'],
                            selectedChip: selectedDay,
                            index: index,
                            selectedColor: AppColors.darkBlue3,
                            // backgroundColor: AppColors.light,
                            nonSeletedColor: AppColors.dark,
                            fontSize: 12.0,
                            onTap: (bool selected) {
                              setState(() {
                                selectedDay = selected ? index : 0;
                                print(selectedDay);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                  if (selectedType != 4 && selectedType != 1)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 4)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Client Name :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        if (customerList != null)
                          CustomDropdownWidget1(
                            //labelText: 'Payment Mode',
                            selectedItem: selectedSupCustomerArr,
                            height: 36.0,
                            // width: 135.0,
                            width: 200.0,
                            valArr: customerList,
                            itemAsString: (p0) =>
                                p0?.accountHeads.toString() ?? '',
                            onChanged: (value) {
                              print('value ${value.accountHead}');
                              setState(() {
                                selectedSupportCustomer =
                                    value.accountHead.toString();
                              });
                              //selectedPaymentMode = value;
                              // selectedPaymentMode = value['id'];
                            },
                          ),
                      ],
                    ),

                  if (selectedType == 4)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 4)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: 'Client Location:',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      CustomeTextField(
                        height: 40.0,
                        control: clientLocationCtrl,
                        validator:
                            errValidateClienttLocation(clientLocationCtrl.text),

                        labelText: '',
                        width: MediaQuery.of(context).size.width - 180,
                        //lines: 4,
                      ),
                    ]),

                  if (selectedType == 4)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 4)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: 'Client Point of\n Contact:',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      CustomeTextField(
                        height: 40.0,
                        control: clientContactCtrl,
                        validator:
                            errValidateClientContact(clientContactCtrl.text),

                        labelText: '',
                        width: MediaQuery.of(context).size.width - 180,
                        //lines: 4,
                      ),
                    ]),

                  if (selectedType == 4)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 4)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Team :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        if (clientTeamList != null)
                          CustomDropdownWidget1(
                            //labelText: 'Payment Mode',
                            selectedItem: selectedClientTeamArr,
                            height: 36.0,
                            // width: 135.0,
                            width: 200.0,
                            valArr: clientTeamList,
                            itemAsString: (p0) => p0?.team.toString() ?? '',
                            onChanged: (value) {
                              print('value ${value.team}');
                              setState(() {
                                selectedClientTeam = value.team.toString();
                                getAllClientVisit();
                              });
                              //selectedPaymentMode = value;
                              // selectedPaymentMode = value['id'];
                            },
                          ),
                      ],
                    ),

                  if (selectedType == 4)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 4 && visitPurposeList != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Visit Purpose :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        if (visitPurposeList != null)
                          CustomDropdownWidget1(
                            //labelText: 'Payment Mode',
                            selectedItem: selectedVisitPurposeArr,
                            height: 36.0,
                            // width: 135.0,
                            width: 200.0,
                            valArr: visitPurposeList,
                            itemAsString: (p0) =>
                                p0?.supportType.toString() ?? '',
                            onChanged: (value) {
                              print('value ${value.supportType}');
                              setState(() {
                                selectedVisitPurpose =
                                    value.supportType.toString();
                              });
                              //selectedPaymentMode = value;
                              // selectedPaymentMode = value['id'];
                            },
                          ),
                      ],
                    ),

                  if (selectedType == 4 && visitPurposeList != null)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 0)
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     HeadingWidget(
                    //     title: 'Working During:',
                    //     vMargin: 1.0,
                    //     color: AppColors.darkBlue3,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 15.0,
                    //   ),

                    //   SizedBox(width: 12.0,),
                    //  CustomeTextField(
                    //     height: 40.0,
                    //     control: workDuringCtrl,
                    //     validator: errValidateDuring(workDuringCtrl.text),

                    //     labelText: '',
                    //     width: MediaQuery.of(context).size.width - 180,
                    //     readOnly: true,
                    //     borderRadius: 20.0,
                    //     //lines: 4,
                    //   ),
                    //   ]),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2, // Adjust flex for label width
                          child: HeadingWidget(
                            title: 'Working During:',
                            vMargin: 1.0,
                            color: AppColors.darkBlue3,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                            width: 12.0), // Space between label and text field
                        Expanded(
                          flex: 3, // Adjust flex for text field width
                          child: CustomeTextField(
                            height: 40.0,
                            control: workDuringCtrl,
                            validator: errValidateDuring(workDuringCtrl.text),
                            labelText:
                                '', // Empty label text as per your requirement
                            readOnly: true,
                            borderRadius: 20.0,
                            //lines: 4, // Uncomment if you need multiline
                          ),
                        ),
                      ],
                    ),

                  if (selectedType == 2)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 2)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: 'Working During:',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      CustomDropdownWidget1(
                        //labelText: 'Payment Mode',
                        selectedItem: selectedDuringArr,
                        height: 36.0,
                        // width: 135.0,
                        width: 200.0,
                        valArr: workingDuringList,
                        itemAsString: (p0) => p0?['name']?.toString() ?? '',
                        onChanged: (value) {
                          print('value ${value['name']}');
                          setState(() {
                            selectedDuring = value['name'].toString();
                          });
                          //selectedPaymentMode = value;
                          // selectedPaymentMode = value['id'];
                        },
                      ),
                    ]),

                  if (selectedType == 2)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 2)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: 'Compensation:',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      CustomDropdownWidget1(
                        //labelText: 'Payment Mode',
                        selectedItem: selectedCompensationArr,
                        height: 36.0,
                        // width: 135.0,
                        width: 200.0,
                        valArr: compensationList,
                        itemAsString: (p0) => p0?['name']?.toString() ?? '',
                        onChanged: (value) {
                          print('value ${value['name']}');
                          setState(() {
                            selectedCompensation = value['name'].toString();
                          });
                          //selectedPaymentMode = value;
                          // selectedPaymentMode = value['id'];
                        },
                      ),
                    ]),

                  if (selectedType == 2)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 2 &&
                      selectedCompensation == "FOR LEAVE ALREADY TAKEN")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Leave Date :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        if (leaveTakenList != null)
                          CustomDropdownWidget1(
                            //labelText: 'Payment Mode',
                            selectedItem: selectedLeaveTakenArr,
                            height: 36.0,
                            // width: 135.0,
                            width: 200.0,
                            valArr: leaveTakenList,
                            itemAsString: (p0) => p0?['date'].toString() ?? '',
                            onChanged: (value) {
                              print('value ${value['date']}');
                              setState(() {
                                selectedLeaveTaken = value['date'].toString();
                              });
                              //selectedPaymentMode = value;
                              // selectedPaymentMode = value['id'];
                            },
                          ),
                      ],
                    ),

                  if (selectedType == 2 &&
                      selectedCompensation == "FOR LEAVE ALREADY TAKEN")
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 2)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: 'Working Location:',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      if (locationList != null)
                        CustomDropdownWidget1(
                          //labelText: 'Payment Mode',
                          selectedItem: selectedLocationArr,
                          height: 36.0,
                          // width: 135.0,
                          width: 200.0,
                          valArr: locationList,
                          itemAsString: (p0) => p0?['name']?.toString() ?? '',
                          onChanged: (value) {
                            print('value ${value['name']}');
                            setState(() {
                              selectedLocation = value['name'].toString();
                            });
                            //selectedPaymentMode = value;
                            // selectedPaymentMode = value['id'];
                          },
                        ),
                    ]),

                  if (selectedType == 2)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Work Type :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        if (workTypeList != null)
                          CustomDropdownWidget1(
                            //labelText: 'Payment Mode',
                            selectedItem: selectedWorkTypeArr,
                            height: 36.0,
                            // width: 135.0,
                            width: 200.0,
                            valArr: workTypeList,
                            itemAsString: (p0) => p0?.type.toString() ?? '',
                            onChanged: (value) {
                              print('value ${value.type}');
                              setState(() {
                                selectedWorkType = value.type.toString();
                              });
                              //selectedPaymentMode = value;
                              // selectedPaymentMode = value['id'];
                            },
                          ),
                      ],
                    ),

                  if (selectedType == 2)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 0)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Permission Type :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        CustomDropdownWidget1(
                          //labelText: 'Payment Mode',
                          selectedItem: selectedPermissionArr,
                          height: 36.0,
                          // width: 135.0,
                          width: 180.0,
                          valArr: permissionList,
                          itemAsString: (p0) => p0?['name']?.toString() ?? '',
                          onChanged: (value) {
                            print('value ${value['name']}');
                            setState(() {
                              selectedPermissionType = value['name'].toString();
                            });
                            //selectedPaymentMode = value;
                            // selectedPaymentMode = value['id'];
                          },
                        ),
                      ],
                    ),

                  if (selectedType == 1)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 1 || selectedType == 4)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: selectedPermissionType == "LEAVING EARLY"
                            ? 'Time :'
                            : 'Start Time :',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      CustomeTextField(
                          height: 40.0,
                          control: startTimeCtrl,
                          validator: errValidateStartTime(startTimeCtrl.text),
                          labelText: '',
                          width: MediaQuery.of(context).size.width - 180,
                          onTap: () => timePicker(selectedPermissionType),
                          readOnly: true,
                          suffixIcon: Icon(
                            Icons.access_time,
                            size: 18.0,
                          )
                          //lines: 4,
                          ),
                    ]),

                  if (selectedType == 1)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Leave Type :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                        CustomDropdownWidget1(
                          //labelText: 'Payment Mode',
                          selectedItem: selectedLeaveArr,
                          height: 36.0,
                          // width: 135.0,
                          width: 200.0,
                          valArr: leaveList,
                          itemAsString: (p0) => p0?['name']?.toString() ?? '',
                          onChanged: (value) {
                            print('value ${value['name']}');
                            setState(() {
                              selectedLeaveType = value['name'].toString();
                              compensatory = false;
                              if(value['id'] == 4){

                                getAllWorkingExtraList(value['id']);
                                 compensatory = true;
                              }
                            });
                            //selectedPaymentMode = value;
                            // selectedPaymentMode = value['id'];
                          },
                        ),
                      ],
                    ),

                   if (selectedType == 3 && compensatory == true)
                    SizedBox(
                      height: 25.0,
                    ),

                     if (workinExtraList != null && selectedType == 3 && compensatory == true)
                       Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Worked On :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 12.0,
                        ),
                  //      CustomRoundedMultiDropDown(
                  //          height: 36.0,
                  //         // // width: 135.0,
                  //          width: 215.0,
                  //   labelText: '',
                  //   labelField: (WorkingExtraListData item) => DateFormat('dd-MM-yyyy').format(item.workedOn),
                  //   onChanged: (value) {
                  //     setState(() {
                  //        print('start');
                  //        selectedWorkedOnLeave =
                  //         value!.map((e) => e.workedOn).toList().join(',');
                  //         print('selectedWorkedOnLeave $selectedWorkedOnLeave');
                        
                  //     });
                     
                  //   },
                  //   //validator: errValidateCategory(selectedCategory),
                  //   valArr: workinExtraList,
                  // ),

                          Expanded(
              child: MultiDropdownAlert(
                items: workinExtraList!.map((item) => MultiSelectItem<String>(
                  DateFormat('dd-MM-yyyy').format(item.workedOn).toString(),
                  DateFormat('dd-MM-yyyy').format(item.workedOn).toString(),
                )).toList(),
                title: '',
                selectedColor: Colors.blue,
                onConfirm: (values) {
                  setState(() {
                    selectedWorkedOnLeave = values.join(',');
                    print('selectedWorkedOnLeave $selectedWorkedOnLeave');
                  });
                },
                maxSelection: 3,
                 initialSelectedValues: selectedWorkedOnLeave.isNotEmpty
                ? selectedWorkedOnLeave.split(',')
                : [],
              ),
            ),


                  

                   ]),

                  if (selectedType == 3)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'Start Date :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        CustomRoundedTextField(
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
                            control: startDateCtrl,
                            //validator: errValidateDob(dobCtrl.text),
                            width: 158.0,
                            readOnly: true, // when true user cannot edit text

                            onTap: () async {
                              _showCalendarDialog(context, "StartDate");
                            }),
                      ],
                    ),

                  if (selectedType == 3)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType == 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeadingWidget(
                          title: 'End Date :',
                          vMargin: 1.0,
                          color: AppColors.darkBlue3,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        CustomRoundedTextField(
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
                            control: endDateCtrl,
                            //validator: errValidateDob(dobCtrl.text),
                            width: 158.0,
                            readOnly: true, // when true user cannot edit text

                            onTap: () async {
                              _showCalendarDialog(context, 'EndDate');
                            }),
                      ],
                    ),

                  if (selectedType == 3)
                    SizedBox(
                      height: 22.0,
                    ),

                  if (selectedType != 2 && selectedType != 4)
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [

                    //       HeadingWidget(
                    //     title: 'Remarks :',
                    //     vMargin: 1.0,
                    //     color: AppColors.darkBlue3,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 15.0,
                    //   ),

                    //   SizedBox(width: 12.0,),

                    //   if(remarksList != null)
                    //   CustomDropdownWidget1(
                    //   //labelText: 'Payment Mode',
                    //   selectedItem: selectedStatusArr,
                    //   height: 36.0,
                    //  // width: 135.0,
                    //   width: 200.0,
                    //   valArr: remarksList,
                    //   itemAsString: (p0) => p0.remarks.toString(),
                    //   onChanged: (value) {
                    //     print('value ${value.remarks}');
                    //     setState(() {
                    //       remarks = value.remarks.toString();
                    //     });
                    //     //selectedPaymentMode = value;
                    //     // selectedPaymentMode = value['id'];
                    //   },
                    // ),

                    //   ],
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex:
                              2, // Adjust this value to control the space ratio for the heading
                          child: HeadingWidget(
                            title: 'Remarks :',
                            vMargin: 1.0,
                            color: AppColors.darkBlue3,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(
                            width:
                                12.0), // Spacing between the title and dropdown
                        if (remarksList != null)
                          Expanded(
                            flex:
                                3, // Adjust this value to control the space for the dropdown
                            child: CustomDropdownWidget1(
                              selectedItem: selectedStatusArr,
                              height: 36.0,
                              width: double
                                  .infinity, // Ensures it uses all the available space in Expanded
                              valArr: remarksList,
                              itemAsString: (p0) => p0.remarks.toString(),
                              onChanged: (value) {
                                print('value ${value.remarks}');
                                setState(() {
                                  remarks = value.remarks.toString();
                                });
                              },
                            ),
                          ),
                      ],
                    ),

                  if (selectedType == 2)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      HeadingWidget(
                        title: 'Remarks:',
                        vMargin: 1.0,
                        color: AppColors.darkBlue3,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      CustomeTextField(
                        height: 40.0,
                        control: remarksCtrl,
                        validator: errValidateRemarks(remarksCtrl.text),

                        labelText: '',
                        width: MediaQuery.of(context).size.width - 180,
                        //readOnly: true,
                        //lines: 4,
                      ),
                    ]),

                  SizedBox(
                    height: 25.0,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // RoundedButtonWidget(
                          //         title: "Cancel",
                          //         width: MediaQuery.of(context).size.width * (20/100),
                          //         height: MediaQuery.of(context).size.height * (6/100),
                          //         fontSize: 16.0,
                          //         titleColor: AppColors.grey,
                          //         borderColor: AppColors.grey ,
                          //         onTap: () {

                          //         },
                          //       ),

                          Button1Widget(
                              title: 'Cancel',
                              width: MediaQuery.of(context).size.width *
                                  (20 / 100),
                              color: AppColors.light,
                              titleColor: AppColors.darkGrey,
                              borderRadius: 12.0,
                              borderColor: AppColors.shadowGrey,
                              fontWeight: FontWeight.bold,
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              }),

                          SizedBox(
                            width: 12.0,
                          ),

                          if (widget.id == null && buttonDisable == false)
                            ButtonWidget(
                                title: 'Apply',
                                width: MediaQuery.of(context).size.width *
                                    (20 / 100),
                                height: 38.0,
                                color: AppColors.darkBlue3,
                                borderRadius: 12.0,
                                onTap: () {
                                  saveEntry(selectedType);
                                })
                          else if (buttonDisable == false)
                            ButtonWidget(
                                title: 'Check Out',
                                width: MediaQuery.of(context).size.width *
                                    (25 / 100),
                                height: 38.0,
                                color: AppColors.darkBlue3,
                                borderRadius: 12.0,
                                onTap: () {
                                  updateEntry(selectedType);
                                }),
                        ],
                      )
                    ],
                  )
                ]))));
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
}
