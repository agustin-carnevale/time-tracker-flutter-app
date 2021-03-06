import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
     Key key,
    this.child,
    this.color,
    this.borderRadius: 4.0,
    this.height: 50.0,
    this.onPressed,
  }) : assert(borderRadius != null),
      assert(height != null), super(key: key,);
  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: height,
          child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        color: color,
        disabledColor: color,
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
