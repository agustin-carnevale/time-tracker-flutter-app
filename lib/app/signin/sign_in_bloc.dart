import 'dart:async';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose(){
    _isLoadingController.close();
  }

  void _setIsLoding(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async{
    try {
      _setIsLoding(true);
      return await signInMethod();
    } catch (e) {
       _setIsLoding(false);
      rethrow;
    }finally{
      //_setIsLoding(false);
    }
  }

  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);
  
  Future<User> signInWithGoogle()async => await _signIn(auth.signInWithGoogle);
  
  Future<User> signInWithApple({List<Scope> scopes = const []})async => await _signIn(() => auth.signInWithApple(scopes: [Scope.email, Scope.fullName]));

  
}