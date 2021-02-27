import 'package:flutter/material.dart';
import 'package:letsbeenextgenrider/core/utils/config.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key key,
    this.actions,
    this.implyLeading = true,
  }) : super(key: key, actions: actions);

  final List<Widget> actions;
  final bool implyLeading;

  @override
  Widget get title => const Text(
        'Lets Bee',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );

  @override
  bool get centerTitle => false;

  @override
  bool get automaticallyImplyLeading => this.implyLeading;

  @override
  Color get backgroundColor => const Color(Config.LETSBEE_COLOR).withOpacity(1);
}