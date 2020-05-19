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

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc, @required this.isLoading}) : super(key: key);
  final SignInBloc bloc;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
              builder: (context, bloc, _) => SignInPage(bloc: bloc, isLoading: isLoading.value,)),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(title: "SignIn Failed", exception: exception)
        .show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final bool appleSignInAvailable = await AppleSignIn.isAvailable();
      if (appleSignInAvailable) {
        await bloc.signInWithApple(scopes: [Scope.email, Scope.fullName]);
      } else {
        print("Sorry Apple SignIn not allowed for this Device!");
      }
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: true, builder: (context) => EmailSignInPage()),
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
            SizedBox(height: 50.0, child: _buildHeader()),
            SizedBox(
              height: 48.0,
            ),
            SocialSignInButton(
              assetName: 'images/google-logo.png',
              text: "Sign-In with Google",
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            SizedBox(
              height: 10,
            ),
            AppleSignInButton(
              style: ButtonStyle.black,
              type: ButtonType.signIn,
              onPressed: isLoading ? null : () => _signInWithApple(context),
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
              text: "Sign-In with Email",
              color: Colors.teal[700],
              textColor: Colors.white,
              onPressed: isLoading ? null : () => _signInWithEmail(context),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "or",
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            SignInButton(
              text: "Go Anonymous",
              color: Colors.lime[400],
              textColor: Colors.black,
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),
          ]),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
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
