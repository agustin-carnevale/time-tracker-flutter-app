import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/signin/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async{
    updateWith(submitted: true, isLoading: true);
    try{
      //await Future.delayed(Duration(seconds: 5));
      if(this.formType == EmailSignInFormType.signIn){
        await auth.signInWithEmailAndPassword(this.email, this.password);
      }else{
        await auth.createUserWithEmailAndPassword(this.email, this.password);
      }
    }catch(e){
      updateWith(isLoading: false);
      rethrow;
    }finally{
      //updateWith(isLoading: false);
    }
  }

  String get primaryButtonText =>
      formType == EmailSignInFormType.signIn ? "Sign in" : "Create Account";

  String get secondaryButtonText => formType == EmailSignInFormType.signIn
      ? "Need an account? Register"
      : "Have an account? Sign in";

  bool get canSubmit =>
      emailValidator.isValid(email) &&
      passwordValidator.isValid(password) &&
      !isLoading;

  String get passwordErrorText{
    bool showErrorText =
        submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }     

  String get emailErrorText{
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }     

  void toggleFormType(){
    final formType = this.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.email= email ?? this.email;
    this.password= password ?? this.password;
    this.formType= formType ?? this.formType;
    this.isLoading= isLoading ?? this.isLoading;
    this.submitted= submitted ?? this.submitted;
    notifyListeners();
  }
}
