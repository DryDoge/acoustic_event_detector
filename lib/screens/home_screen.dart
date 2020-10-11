import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/event/event_screen.dart';
import 'package:acoustic_event_detector/screens/history/history_screen.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/screens/sensors/sensors_screen.dart';
import 'package:acoustic_event_detector/screens/user/user_screen.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/widgets/custom_app_bar.dart';
import 'package:acoustic_event_detector/widgets/logout_appbar_action.dart';
import 'package:acoustic_event_detector/widgets/user/custom_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  static const routeName = '/home';
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 3;
  bool _addUser = false;

  Widget get _screenOptions {
    switch (_selectedIndex) {
      case 0:
        return EventScreen();
      case 1:
        return SensorsScreen();
      case 2:
        return HistoryScreen();
      case 3:
        return UserScreen(
            addUser: _addUser, exitRegistration: _cancelRegistration);
      default:
        return UserScreen(
            addUser: _addUser, exitRegistration: _cancelRegistration);
    }
  }

  String getTitle(index) {
    switch (index) {
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

  Widget get _floatingButton {
    switch (_selectedIndex) {
      case 0:
        return SizedBox.shrink();
      case 1:
        return Provider.of<User>(context, listen: false).rights == 1
            ? CustomFloatingButton(
                onPressed: () {
                  BlocProvider.of<SensorsBloc>(context)
                      .add(AddSensorRequested());
                },
                icon: Icon(
                  Icons.leak_add_rounded,
                  color: ColorHelper.white,
                ),
                label: S.current.add_sensor,
              )
            : SizedBox.shrink();
      case 2:
        return SizedBox.shrink();
      case 3:
        return _addUser
            ? SizedBox.shrink()
            : CustomFloatingButton(
                icon: Icon(
                  Icons.group_add,
                  color: ColorHelper.white,
                  size: 24.0,
                ),
                label: S.current.new_user,
                onPressed: () => setState(() {
                  _addUser = true;
                }),
              );
      default:
        return SizedBox.shrink();
    }
  }

  List<Widget> get _actions {
    switch (_selectedIndex) {
      case 0:
        return [];
      case 1:
        return [];
      case 2:
        return [];
      case 3:
        return [LogoutAppBarAction()];
      default:
        return [];
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      BlocProvider.of<SensorsBloc>(context).add(SensorsRequested());
    }
    if (index == 3) {
      _addUser = false;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _cancelRegistration() {
    setState(() {
      _addUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorHelper.darkBlue,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(actions: _actions),
          body: _screenOptions,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 4.0,
            selectedItemColor: ColorHelper.darkBlue,
            unselectedItemColor: ColorHelper.defaultGrey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.place),
                label: getTitle(0),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_input_antenna),
                label: getTitle(1),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: getTitle(2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: getTitle(3),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
          floatingActionButton: _floatingButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}
