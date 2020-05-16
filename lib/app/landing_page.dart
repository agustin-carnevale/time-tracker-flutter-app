import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/signin/apple_signin_available.dart';
import 'package:time_tracker_flutter_course/app/signin/signin_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context,snapshot) {
        if (snapshot.connectionState == ConnectionState.active){
          User user = snapshot.data;
          if (user ==null){
            return SignInPage(
              auth: auth,
            );
          }else{
            return HomePage(
              auth: auth,
            );
          }
        }else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}