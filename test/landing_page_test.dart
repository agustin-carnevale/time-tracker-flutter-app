import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/app/signin/signin_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;
  StreamController<User> onAuthStateChangedController;

  //Before tests
  setUp((){
    mockAuth = MockAuth();
    onAuthStateChangedController = StreamController<User>();
  });

  //after tests
  tearDown((){
    onAuthStateChangedController.close();
  });

  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: LandingPage()
      ),
    ));
    await tester.pump();
  }

  void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged){
    onAuthStateChangedController.addStream( Stream<User>.fromIterable(onAuthStateChanged));
    when(mockAuth.onAuthStateChanged)
      .thenAnswer((_) => onAuthStateChangedController.stream
    );
  }

  testWidgets('stream waiting', (WidgetTester tester) async{
    stubOnAuthStateChangedYields([]);
    await pumpLandingPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  testWidgets('null user', (WidgetTester tester) async{
    stubOnAuthStateChangedYields([null]);
    await pumpLandingPage(tester);
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (WidgetTester tester) async{
    stubOnAuthStateChangedYields([User(uid: '123', photoUrl: '',displayName: 'Agustin')]);
    await pumpLandingPage(tester);
    expect(find.byType(HomePage), findsOneWidget);
  });
}
