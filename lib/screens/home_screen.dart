import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/event/event_screen.dart';
import 'package:acoustic_event_detector/screens/history/history_screen.dart';
import 'package:acoustic_event_detector/screens/sensors/sensors_screen.dart';
import 'package:acoustic_event_detector/screens/user/user_screen.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  static const routeName = '/home';
}

class _HomeScreenState extends State<HomeScreen> {
  final _screenOptions = [
    EventScreen(),
    SensorsScreen(),
    HistoryScreen(),
    UserScreen()
  ];
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return S.current.current_event;
      case 1:
        return S.current.sensors;
      case 2:
        return S.current.history;
      case 3:
        return S.current.account;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screenOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: ColorHelper.darkBlue,
          unselectedItemColor: ColorHelper.grey2,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              title: Text(_title),
              backgroundColor: ColorHelper.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_antenna),
              title: Text(_title),
              backgroundColor: ColorHelper.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text(_title),
              backgroundColor: ColorHelper.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text(_title),
              backgroundColor: ColorHelper.lightBlue,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.shifting,
        ),
      ),
    );
  }
}
