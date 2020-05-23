import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/avatar.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class AccountPage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are you sure you want to logout?",
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        actions: <Widget>[
          FlatButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
        bottom: PreferredSize(
          child:_buildUserInfo(user), 
                    preferredSize: Size.fromHeight(130)),
                ),
              );
            }
          
 Widget _buildUserInfo(User user) {
   return Column(
     children: <Widget>[
       Avatar(photoUrl: user.photoUrl, radius: 50),
       SizedBox(height: 8.0),
       if(user.displayName != null)
        Text(
          user.displayName,
          style: TextStyle(color: Colors.white, ),
        ),
       SizedBox(height: 8.0),
     ],
   );
 }
}