import 'package:flutter/material.dart';
import 'package:sjq/custom_icons_icons.dart';
import 'package:sjq/pages/pages.dart';
import 'package:sjq/themes/color.dart';

const List<Widget> bodies = [
  EventScreen(),
  FormScreen(),
  PlanListScreen(),
  ChatPage(),
  ProfileScreen(),
];

const List<BottomNavigationBarItem> items = [
  BottomNavigationBarItem(
    icon: Icon(CustomIcons.event),
    label: "Event",
    backgroundColor: colorLightBlue,
  ),
  BottomNavigationBarItem(
    icon: Icon(CustomIcons.form),
    label: "Form",
    backgroundColor: colorLightBlue,
  ),
  BottomNavigationBarItem(
    icon: Icon(CustomIcons.meal),
    label: "Plan",
    backgroundColor: colorLightBlue,
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.perm_contact_calendar_rounded),
    label: "Contact",
    backgroundColor: colorLightBlue,
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.account_circle),
    label: "Profile",
    backgroundColor: colorLightBlue,
  ),
];
