import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../services/comFuncService.dart';
import '../../services/communicator_api_service.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/sub_heading_widget.dart';
import '../profile/profile_page.dart';
import 'holiday_list_model.dart';

class HolidayListPage extends StatefulWidget {
  const HolidayListPage({super.key});

  @override
  State<HolidayListPage> createState() => _HolidayListPageState();
}

class _HolidayListPageState extends State<HolidayListPage> {

  final CommunicatorApiService apiService = CommunicatorApiService();


@override
  void initState() {
    
    getAllHolidayList();
    
    super.initState();
  }


   List<HolidayListData>? holidayList;
  
   String location="";
   String userName="";
   bool isLoading = false;



  Future getAllHolidayList() async {
     setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();

     String role = prefs.getString('role') ?? '';
      location = prefs.getString('location') ?? '';
     userName = prefs.getString('username') ?? '';

     String apiUrl = "";

       if(userName == "VIDYA MURALEEDHARAN"){
        apiUrl = 'ComHolidayList';
       }
       else{
        apiUrl = 'ComHolidayList?LOCATION='+location;
       }
    var result = await apiService.get(apiUrl);
    var response = holidayListModelFromJson(result);
    if (response.status.toString() == 'Success') {
      setState(() {
        holidayList = response.response;

        print('holidayList ${holidayList}');
        isLoading = false;
       
      });
    } else {
      setState(() {
        holidayList = [];
        isLoading = false;
       
      });
      showInSnackBar(context, response.message.toString());
    }
    setState(() {});
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      HeadingWidget(
                    title: 'Holidays',
                    vMargin: 1.0,
                    color: AppColors.darkBlue3,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),

                  SubHeadingWidget(title: 'This Year',fontSize: 13.0),

                    ],
                  ),
                  

                  Row(
                    children: [
                      SubHeadingWidget(title: 'Location: ',fontSize: 13.0),

                      SizedBox(width: 4.0,),

                      HeadingWidget(title: location.toString(),color: AppColors.darkBlue3,fontSize: 13.0,)

                    ],
                  )
                ],
              ),
              SizedBox(height: 18.0),

              isLoading
                  ? Center(child: CircularProgressIndicator())
                  :  SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AppColors.lightGrey2, width: 1.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Table(
                      border: TableBorder.all(color: AppColors.lightGrey2, width: 1.0),
                      defaultColumnWidth: FixedColumnWidth(120.0),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: AppColors.darkBlue3),
                          children: [
                            _buildVerticalHeaderCell('Holiday'),
                            _buildVerticalHeaderCell('Date'),
                            _buildVerticalHeaderCell('Day'),
                          ],
                        ),
                        if(holidayList != null)
                       ...holidayList!.map((e) => _buildTableRow(e.holiday, e.displayDate, e.day)),
                        // _buildTableRow('Shivaratri', 'Mar 8', 'Friday'),
                        // _buildTableRow('Good Friday', 'Mar 29', 'Friday'),
                        // _buildTableRow('Vishu', 'Apr 14', 'Sunday'),
                        // _buildTableRow('Eid-ul-Fitr (Ramadan)', 'Apr 11', 'Thursday'),
                        // _buildTableRow('May Day', 'May 1', 'Wednesday'),
                        // _buildTableRow('Bakrid', 'Jun 17', 'Monday'),
                        // _buildTableRow('Independence Day', 'Aug 15', 'Thursday'),
                        // _buildTableRow('Onam', 'Sep 16', 'Monday'),
                      ],
                    ),
                  ),
                ),
              ),


            ]
          )
        )
      )
    );
  }


  TableRow _buildTableRow(String holiday, String date, String day) {
    return TableRow(
      children: [
        _buildTableCell(holiday),
        _buildTableCell(date),
        _buildTableCell(day),
      ],
    );
  }

  Widget _buildVerticalHeaderCell(String text) {
    return RotatedBox(
      quarterTurns: 0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    alignment: Alignment.center, // Ensure the text is centered
    child: Text(
      text,
      textAlign: TextAlign.center, // Center the text within the cell
    ),
  );
}

}