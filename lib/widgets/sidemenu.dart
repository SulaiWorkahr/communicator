
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

import '../controllers/base_controller.dart';
import '../widgets/heading_widget.dart';
import '../widgets/sub_heading_widget.dart';

class SideMenu extends StatelessWidget {
  SideMenu({super.key});

  final BaseController filterController = Get.put(BaseController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 220.0,
      backgroundColor: AppColors.light,
      surfaceTintColor: AppColors.light,
      child: ListView(
        children: [
          // UserAccountsDrawerHeader(
          //   accountName: HeadingWidget(
          //     title: 'John',
          //     color: AppColors.light,
          //   ),
          //   accountEmail: SubHeadingWidget(
          //       title: 'john@example.com', color: AppColors.light),
          //   currentAccountPicture: CircleAvatar(
          //     backgroundImage: AssetImage('assets/images/avatar.jpeg'),
          //   ),
          // ),

          //SizedBox(height: 4.0,),

          Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                //width: 300.0, // Adjust the width based on your design
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.darkBlue, AppColors.lightBlue],
                  ),
                  //color:AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:
                    // Padding(
                    // padding: EdgeInsets.only(top: 2.0,bottom: 8.0,right: 5.0,left: 5.0),
                    //   child:
                    Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 2.0, bottom: 8.0, right: 5.0, left: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.profile1Icon,
                                width: 50.0,
                                // height: 50.0,
                              ),
                              SizedBox(width: 5.0),
                              HeadingWidget(
                                textAlign: TextAlign.center,
                                title: "Username",
                                color: AppColors.light,
                                vMargin: 1.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: -9,
                      right: -5,
                      child: Container(
                        // margin: EdgeInsets.only(top: 10.0),
                        alignment: Alignment.topRight,
                        child: IconButton(
                          //alignment: Alignment.topRight,
                          icon: Image.asset(
                            AppAssets.editIcon,
                            // alignment: Alignment.topRight,
                            width: 25.0,
                            // height: 50.0,
                          ),
                          iconSize: 18.0,
                          onPressed: () {
                            // Add your onPressed functionality here
                          },
                        ),
                      ),
                    )
                  ],
                ),

                //)
              )),

          SizedBox(height: 3.0),
          ListTile(
            leading: Image.asset(
              AppAssets.overviewIcon,
              width: 25.0,
              // height: 50.0,
            ),
            title: const Text('Overview', style: TextStyle(fontSize: 14.0)),
            onTap: () async {
              
            },
          ),
          SizedBox(height: 5.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          ListTile(
            leading: Image.asset(
              AppAssets.kpiIcon,
              width: 25.0,
              // height: 50.0,
            ),
            title:
                const Text('Kpi Evolution', style: TextStyle(fontSize: 14.0)),
            onTap: () async {
           
            },
          ),
          SizedBox(height: 5.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          SizedBox(height: 5.0),

          // Branch Performance with sub-menu
          ExpansionTile(
            collapsedBackgroundColor: AppColors.light,
            leading: Image.asset(
              AppAssets.branchIcon,
              width: 25.0,
            ),
            title: const Text('Branch Performance',
                style: TextStyle(fontSize: 14.0)),
            tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
            childrenPadding: EdgeInsets.only(left: 12.0),
            backgroundColor: AppColors.light,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: BorderSide(
                  color: AppColors
                      .light), // Removes the top and bottom border when collapsed
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: BorderSide(
                  color: AppColors
                      .light), // Removes the top and bottom border when expanded
            ),
            children: <Widget>[
              Container(
                color: AppColors.light,
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.circle, size: 8.0, color: AppColors.darkBlue),
                      SizedBox(width: 8.0),
                      Text('Branch Key Metrics',
                          style: TextStyle(fontSize: 14.0))
                    ],
                  ),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) =>
                    //             MainContainer(childWidget: KeyMatricsPage())));
                  },
                ),
              ),
              Container(
                color: AppColors.light,
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.circle, size: 8.0, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text('Branch Analysis', style: TextStyle(fontSize: 14.0))
                    ],
                  ),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => MainContainer(
                    //             childWidget: BranchAnalysisPage())));
                  },
                ),
              ),
              Container(
                color: AppColors.light,
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.circle, size: 8.0, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text('Branch Comparision',
                          style: TextStyle(fontSize: 14.0))
                    ],
                  ),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => MainContainer(
                    //             childWidget: BranchComparisionPage())));
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 5.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          SizedBox(height: 5.0),
          ListTile(
            leading: Image.asset(
              AppAssets.salesIcon,
              width: 25.0,
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            title: const Text('Sales', style: TextStyle(fontSize: 14.0)),
            onTap: () {
              Navigator.pushNamed(context, '/audio-player-bg');
            },
          ),
          SizedBox(height: 7.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          SizedBox(height: 7.0),
          ListTile(
            leading: Image.asset(
              AppAssets.salesmanIcon,
              width: 25.0,
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            title: const Text('Sales Man', style: TextStyle(fontSize: 14.0)),
            onTap: () {
              Navigator.pushNamed(context, '/audio-player-bg');
            },
          ),
          SizedBox(height: 5.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          SizedBox(height: 5.0),
          ListTile(
            leading: Image.asset(
              AppAssets.inventoryIcon,
              width: 25.0,
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            title: const Text('Inventory', style: TextStyle(fontSize: 14.0)),
            onTap: () {
              Navigator.pushNamed(context, '/audio-playerbg');
            },
          ),
          SizedBox(height: 5.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          SizedBox(height: 5.0),
          ListTile(
            leading: Image.asset(
              AppAssets.customerIcon,
              width: 25.0,
            ),
            title: const Text('Customers', style: TextStyle(fontSize: 14.0)),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () {
              Navigator.pushNamed(context, '/audio-recorder');
            },
          ),
          SizedBox(height: 5.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          SizedBox(height: 5.0),
          ListTile(
            leading: Image.asset(
              AppAssets.behavioralIcon,
              width: 25.0,
            ),
            title: const Text('Behavioral Segment',
                style: TextStyle(fontSize: 14.0)),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () {
              Navigator.pushNamed(context, '/vcall-recorder');
            },
          ),
          SizedBox(height: 5.0),
          Divider(
            height: 1,
            thickness: 0.0,
            color: AppColors.grey,
          ),
          SizedBox(height: 5.0),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.help),
          //   title: const Text('Help'),
          //   onTap: () {},
          // ),

          SizedBox(
            height: 30.0,
          ),

          Center(
            child: Image.asset(
              AppAssets.logo,
              // width: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width - 270.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),

          Center(
            child: SubHeadingWidget(
              title: "Copyright ©2024 All",
              fontSize: 13.0,
            ),
          ),

          Center(
              child: SubHeadingWidget(
            title: "rights reserved",
            fontSize: 13.0,
          ))
        ],
      ),
    );
  }
}
