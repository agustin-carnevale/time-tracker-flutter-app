import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/signin/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/signin/signin_button.dart';
import 'package:time_tracker_flutter_course/app/signin/social_signin_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
//Shift Option F (code format)

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth});
  final AuthBase auth;

  Future<void> _signInAnonymously() async{
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async{
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithApple() async{
    try {
      final bool appleSignInAvailable = await AppleSignIn.isAvailable();
      if(appleSignInAvailable){
         await auth.signInWithApple(scopes: [Scope.email, Scope.fullName]);
      }else{
        print("Sorry Apple SignIn not allowed for this Device!");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context)=> EmailSignInPage(auth: auth)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 10.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Text(
              "Sign In", 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
               ),
            ),
            SizedBox(height: 48.0,),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              text:"Sign-In with Google",
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: _signInWithGoogle,
            ),
            SizedBox(height: 10,),
            // SocialSignInButton(
            //   assetName: 'images/facebook-logo.png',
            //   text:"Sign-In with Facebook",
            //     color: Color(0xFF334D92),
            //   textColor: Colors.white,
            //   onPressed: ()=>{},
            // ),
            //  SignInButton(
            //   text: "Sign-In with AppleID",
            //   color: Colors.black,
            //   textColor: Colors.white,
            //   onPressed: ()=>{},
            // ),
            AppleSignInButton(
              style: ButtonStyle.black,
              type: ButtonType.signIn,
              onPressed: ()=>_signInWithApple(),
            ),
            SizedBox(height: 10,),
            SignInButton(
              text: "Sign-In with Email",
              color: Colors.teal[700],
              textColor: Colors.white,
              onPressed: ()=> _signInWithEmail(context),
            ),
            SizedBox(height: 10,),
            Text(
              "or", 
              style: TextStyle(fontSize: 14.0 , color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            SignInButton(
              text: "Go Anonymous",
              color: Colors.lime[400],
              textColor: Colors.black,
              onPressed: _signInAnonymously,
            ),
          ]),
    );
  }
}
