import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

Route createRouteSharedAxisTransition(Widget wi) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => wi,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}

OpenContainer<Never> itemToFullScreenTransition(item, screen) {
  return OpenContainer(
    closedBuilder: (context, action) => item,
    openBuilder: (context, action) => screen,
  );
}
