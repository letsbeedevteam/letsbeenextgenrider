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
        'Let\'s Bee',
        style: const TextStyle(
          fontFamily: 'CooperBlack',
          fontSize: 35,
        ),
      );

  @override
  bool get centerTitle => false;

  @override
  bool get automaticallyImplyLeading => this.implyLeading;

  @override
  Color get backgroundColor => const Color(Config.LETSBEE_COLOR).withOpacity(1);
}
