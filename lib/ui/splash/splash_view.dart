import 'package:flutter/material.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 130,
          width: 240,
          child: Hero(
              tag: 'splash',
              child: Image.asset(Config.PNG_PATH + 'letsbee_logo.png')),
        ),
      ),
    );
  }
}
