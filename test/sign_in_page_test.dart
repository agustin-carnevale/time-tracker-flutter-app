import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/signin/signin_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  MockNavigatorObserver mockNavigatorObserver;

  //Before tests
  setUp((){
    mockAuth = MockAuth();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  //always pump the Widget you want to test, and all the needed ancestors 
  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Builder(
          builder: (context) => SignInPage.create(context)
        ),
        navigatorObservers: [mockNavigatorObserver],
      ),
    ));
    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  }

  testWidgets('email and password navigation', (WidgetTester tester) async{
    await pumpSignInPage(tester);

    final emailSignInButton = find.byKey(SignInPage.emailPasswordKey);
    expect(emailSignInButton, findsOneWidget);

    await tester.tap(emailSignInButton);
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });
}