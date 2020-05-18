import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/signin/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/signin/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/signin/signin_button.dart';
import 'package:time_tracker_flutter_course/app/signin/social_signin_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
//Shift Option F (code format)

class SignInPage extends StatefulWidget {
  static Widget create(BuildContext context){
    return Provider<SignInBloc>(
      create: (_)=>SignInBloc(),
      child: SignInPage(),
    );
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  void _showSignInError(BuildContext context, PlatformException exception){
    PlatformExceptionAlertDialog(title: "SignIn Failed", exception: exception).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async{
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
    bloc.setIsLoding(true);
     final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
       _showSignInError(context,e);
    }finally{
      bloc.setIsLoding(false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async{
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      bloc.setIsLoding(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      if(e.code != 'ERROR_ABORTED_BY_USER'){
       _showSignInError(context,e);
      }
    }finally{
       bloc.setIsLoding(false);
    }
  }

  Future<void> _signInWithApple(BuildContext context) async{
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      bloc.setIsLoding(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final bool appleSignInAvailable = await AppleSignIn.isAvailable();
      if(appleSignInAvailable){
         await auth.signInWithApple(scopes: [Scope.email, Scope.fullName]);
      }else{
        print("Sorry Apple SignIn not allowed for this Device!");
      }
    }on PlatformException catch (e) {
      if(e.code != 'ERROR_ABORTED_BY_USER'){
       _showSignInError(context,e);
      }
    }finally{
      bloc.setIsLoding(false);
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context)=> EmailSignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 10.0,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContent(context, snapshot.data);
        }
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50.0,child: _buildHeader(isLoading)),
            SizedBox(height: 48.0,),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              text:"Sign-In with Google",
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: isLoading? null : ()=>_signInWithGoogle(context),
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
              onPressed: isLoading? null : ()=>_signInWithApple(context),
            ),
            SizedBox(height: 10,),
            SignInButton(
              text: "Sign-In with Email",
              color: Colors.teal[700],
              textColor: Colors.white,
              onPressed: isLoading? null :()=> _signInWithEmail(context),
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
              onPressed: isLoading? null :()=>_signInAnonymously(context),
            ),
          ]),
    );
  }

  Widget _buildHeader(bool isLoading){
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign In", 
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        ),
    );
  }
}
