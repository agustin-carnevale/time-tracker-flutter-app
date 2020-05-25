import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_flutter_course/app/signin/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'mocks.dart';


//class to save valueNotifier values history
class MockValueNotifier<T> extends ValueNotifier<T>{
  MockValueNotifier(T value) : super(value);
  
  List<T> values = [];

  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}
void main(){
  MockAuth mockAuth;
  MockValueNotifier<bool> isLoading;
  SignInBloc bloc;

  setUp((){
    mockAuth = MockAuth();
    isLoading = MockValueNotifier<bool>(false);
    bloc = SignInBloc(auth: mockAuth, isLoading: isLoading);
  });

  test('sign-in' , () async{
    when(mockAuth.signInAnonymously()).thenAnswer((_) => 
      Future.value(User(uid:'123', photoUrl: '', displayName: 'Agustin'))
    );
    await bloc.signInAnonymously();

    expect(isLoading.values, [true]);
  });

  test('sign-in failure' , () async{
    when(mockAuth.signInAnonymously()).thenThrow(
      PlatformException(code: 'ERROR', message: 'Signin failed!!')
    );
    try {
      await bloc.signInAnonymously();
    }catch (e){
      expect(isLoading.values, [true, false]);
    }
  });
}
