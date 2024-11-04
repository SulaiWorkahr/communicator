import 'package:communicator/services/communicator_api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/constants.dart';
import '../../services/comFuncService.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/heading_widget.dart';
import '../../../widgets/sub_heading_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../widgets/custom_dropdown_login.dart';
import '../../widgets/custom_text_field_login.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'login_model.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 
  final CommunicatorApiService apiService = CommunicatorApiService();


  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  List? allBranchList = [];

  bool isChecked = false;

  var obscureText = true;

   @override
  void initState() {
 //usernameCtrl.text ="suntech_dev_team";
    super.initState();
  }

  errValidateUseranme(value) {
    return (value) {
      if (value.isEmpty) {
        return 'Username is required';
      }
      return null;
    };
  }

  errValidatePassword(value) {
    return (value) {
      if (value.isEmpty) {
        return 'Password is required';
      }
      return null;
    };
  }
 String? dropdownValue;
  Future userLogin() async {
    if (loginForm.currentState!.validate()) {
      if(usernameCtrl.text != "" && passwordCtrl.text != ""){
      var result = await apiService.userLogin(usernameCtrl.text, passwordCtrl.text);
      LoginModel response = loginModelFromJson(result);

      if (response.status.toString() == 'Success') {
          showInSnackBarTop(context,"Logged In Successfully");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedin', true);
        //await prefs.setString('auth_token', response.authToken ?? '');
        await prefs.setString('username', usernameCtrl.text ?? '');
      
      Future.delayed(Duration(seconds: 4), () {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/home', 
            ModalRoute.withName('/home')
          );
        });
      } else {
        print(response.message.toString());
        showInSnackBar(context, response.message.toString());
      }
    } else {
      showInSnackBar(context, "Please fill all fields");
    }
  }
  }

   List<DropdownMenuItem<String>> items = [
      // Dynamic items for dropdown
      DropdownMenuItem(
        value: 'suntech_dev_team',
        child: Text('suntech_dev_team'),
      ),
     
    ];

      errValidateUserName(String? value) {
    return (value) {
      if (value.isEmpty) {
        return 'User Name is required';
      }
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Center(
                child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                padding: const EdgeInsets.all(25),
                // decoration: BoxDecoration(
                //     boxShadow: const [BoxShadow(blurRadius: 10.0)],
                //     color: AppColors.light,
                //     borderRadius: BorderRadius.circular(15)),
                child: Form(
                  key: loginForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130.0,
                      ),

                      Center(
                        child: Image.asset(
                          AppAssets.logo,
                          width: 200.0,
                          // width: MediaQuery.of(context).size.width / 2,
                          // width: MediaQuery.of(context).size.width - 20.0,
                        ),
                      ),
                      
                      const SizedBox(
                        height: 90,
                      ),

                     Padding(padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                     child:
                       Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SubHeadingWidget(
                            title: 'Username',
                            color: AppColors.dark,
                            fontSize: 16.0,
                          ),

                        ],
                      ), ),
                    
                      CustomeTextFieldLogin(
                        labelText: 'Username',
                        control: usernameCtrl,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.iconBlue,
                        ),
                        borderColor: AppColors.shadowGrey,
                        width: MediaQuery.of(context).size.width / 1.2,
                        validator: errValidateUseranme(usernameCtrl.text),
                      ),

                    //  CustomeDropdownLogin(
                    //     labelText: 'Username',
                    //    // control: usernameCtrl,
                    //     prefixIcon: const Icon(
                    //       Icons.person,
                    //       color: AppColors.iconBlue,
                    //     ),
                    //     width: MediaQuery.of(context).size.width / 1.2, 
                    //      value: dropdownValue, // Currently selected value
                    //       onChanged: (String? newValue) {
                    //         setState(() {
                    //           dropdownValue = newValue; // Update selected value
                    //         });
                    //       },
                    //         items: items,
                    //          validator: errValidateUserName(dropdownValue),
                    //   ),

                      // ),
                      const SizedBox(
                        height: 10.0,
                      ),

                       Padding(padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                     child:
                       Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SubHeadingWidget(
                            title: 'Password',
                            color: AppColors.dark,
                            fontSize: 16.0,
                          ),

                        ],
                      ), ),

                      CustomeTextFieldLogin(
                        obscureText: obscureText,
                        control: passwordCtrl,
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.iconBlue,
                        ),
                        borderColor: AppColors.shadowGrey,
                        suffixIcon: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 5.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: obscureText
                                ? SubHeadingWidget(
                                    title: "Show",
                                    color: AppColors.primary,
                                  )
                                : SubHeadingWidget(
                                    title: "Hide",
                                    color: AppColors.primary,
                                  ),
                          ), // _myIcon is a 48px-wide widget.
                        ),
                        width: MediaQuery.of(context).size.width / 1.2,
                        validator: errValidatePassword(passwordCtrl.text),
                      ),
                   
                     

                      

                      const SizedBox(
                        height: 55.0,
                      ),

                      ButtonWidget(
                        title: 'Login',
                        width: MediaQuery.of(context).size.width / 1.3,
                        onTap: (){
                          userLogin();
                        },
                        borderRadius: 20.0,
                        color: AppColors.darkBlue3,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                     
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              )
            ],
          ),
        ))));
  }
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return AppColors.primary;
  }
  return AppColors.background;
}
