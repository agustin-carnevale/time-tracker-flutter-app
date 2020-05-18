import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog{
  PlatformExceptionAlertDialog({
    @required String title, 
    @required PlatformException exception
  }): super(
    title: title, 
    content: _message(exception),
    defaultActionText: 'OK'
  );

  static String _message(PlatformException exception){
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String,String> _errors ={
    'ERROR_WEAK_PASSWORD': "Password is too weak.",
    'ERROR_INVALID_EMAIL':"The email is invalid.",
    'ERROR_EMAIL_ALREADY_IN_USE':"The email is already used",
    'ERROR_WRONG_PASSWORD':"The password is invalid.",
    'ERROR_USER_NOT_FOUND':"There is no user with these credentials.",
    'ERROR_USER_DISABLED':"The user has been disabled.",
    'ERROR_TOO_MANY_REQUESTS':"Too many request have been made.",
    'ERROR_OPERATION_NOT_ALLOWED': "This action is not allowed.",
  };
}