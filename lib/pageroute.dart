import 'package:flutter/cupertino.dart';

class CurvedAnimations extends PageRouteBuilder {
  final Widget widget;
  final curve;
  CurvedAnimations({this.widget, this.curve})
      : super(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(
                curve: curve,
                parent: animation,
              );

              return ScaleTransition(
                scale: animation,
                alignment: Alignment.center,
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return widget;
            });
}
