import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


@override
void initState() {
    // TODO: implement initState

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds: 1), ()=> 
       Navigator.pushNamedAndRemoveUntil(
            context, '/landing', ModalRoute.withName('/landing'))
            // context, '/home', ModalRoute.withName('/home'))
    );

    super.initState();
  }

  @override
void dispose() {
    // TODO: implement dispose

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Container(
        width: double.infinity, 
        child: Image.asset(AppAssets.splashScreen,
         fit: BoxFit.fill
         ),
         )
         );
  }
}