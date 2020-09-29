import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/data/repositories/sensors_repository.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/authenticate/cubit/auth_cubit.dart';
import 'package:acoustic_event_detector/screens/event/event_screen.dart';
import 'package:acoustic_event_detector/screens/history/history_screen.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/screens/sensors/sensors_screen.dart';
import 'package:acoustic_event_detector/screens/user/user_screen.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/user/row_buttons_widget.dart';
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
            addUser: _addUser, exitRegistration: _triggerRegistration);
      default:
        return UserScreen(
            addUser: _addUser, exitRegistration: _triggerRegistration);
    }
  }

  Widget get _floatingButton {
    switch (_selectedIndex) {
      case 0:
        return SizedBox.shrink();
      case 1:
        return IconButton(icon: Icon(Icons.add), onPressed: () {});
      case 2:
        return SizedBox.shrink();
      case 3:
        return RowButtonsWidget(
          rights: Provider.of<User>(context, listen: false).rights,
          firstButtonOnPressed: () {
            setState(() {
              _addUser = true;
            });
          },
          secondButtonOnPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => CustomPlatformAlertDialog(
                title: S.current.log_out_question,
                oneOptionOnly: false,
              ),
            );
            if (result == CustomAction.First) {
              BlocProvider.of<AuthCubit>(context).logOutUser();
            }
          },
        );
      default:
        return SizedBox.shrink();
    }
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

  void _triggerRegistration() {
    setState(() {
      _addUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screenOptions,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: ColorHelper.darkBlue,
          unselectedItemColor: ColorHelper.defaultGrey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: _title,
              backgroundColor: ColorHelper.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_input_antenna),
              label: _title,
              backgroundColor: ColorHelper.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: _title,
              backgroundColor: ColorHelper.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: _title,
              backgroundColor: ColorHelper.lightBlue,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.shifting,
        ),
        floatingActionButton: _floatingButton,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
      ),
    );
  }
}
