import 'package:flutter/material.dart';

class BottomToTopRoute<T> extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  BottomToTopRoute({
    required this.page,
    required this.duration,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: duration,
        );

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return page;
  }

  @override
  Duration get transitionDuration => duration;

  @override
  Animation<double> createAnimation() {
    final animation = super.createAnimation();
    return CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart);
  }
}
