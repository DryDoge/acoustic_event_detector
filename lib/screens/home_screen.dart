import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/event/event_screen.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/screens/history/history_screen.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/screens/sensors/sensors_screen.dart';
import 'package:acoustic_event_detector/screens/user/user_screen.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_app_bar.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/user/logout_appbar_action.dart';
import 'package:acoustic_event_detector/widgets/custom_floating_button.dart';
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
  bool _addUserMenuEnabled = false;
  bool _isMap = false;
  User _user;
  SensorsBloc _sensorsBloc;
  HistoricalEventsBloc _historicalEventsBloc;

  @override
  void dispose() {
    super.dispose();
    _sensorsBloc.close();
    _historicalEventsBloc.close();
  }

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User>(context, listen: false);
    _sensorsBloc = BlocProvider.of<SensorsBloc>(context);
    _historicalEventsBloc = BlocProvider.of<HistoricalEventsBloc>(context);
  }

  Widget get _screenOptions {
    switch (_selectedIndex) {
      case 0:
        return EventScreen();
      case 1:
        return BlocProvider.value(
          value: _sensorsBloc,
          child: SensorsScreen(
            userRights: _user.rights,
            setMap: () => _isMap = !_isMap,
          ),
        );
      case 2:
        return BlocProvider.value(
          value: _historicalEventsBloc,
          child: HistoryScreen(userRights: _user.rights),
        );
      case 3:
        return UserScreen(
          addUser: _addUserMenuEnabled,
          exitRegistration: _cancelRegistration,
        );
      default:
        return UserScreen(
          addUser: _addUserMenuEnabled,
          exitRegistration: _cancelRegistration,
        );
    }
  }

  String _getTitle(index) {
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
        return _user.rights == 1
            ? CustomFloatingButton(
                onPressed: () {
                  _sensorsBloc.add(AddSensorRequested());
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
        return !_addUserMenuEnabled && _user.rights == 1
            ? CustomFloatingButton(
                icon: Icon(
                  Icons.group_add,
                  color: ColorHelper.white,
                  size: 24.0,
                ),
                label: S.current.new_user,
                onPressed: () => setState(() {
                  _addUserMenuEnabled = true;
                }),
              )
            : SizedBox.shrink();
      default:
        return SizedBox.shrink();
    }
  }

  PreferredSizeWidget get _appBar {
    switch (_selectedIndex) {
      case 3:
        return CustomAppBar(actions: [LogoutAppBarAction()]);
      default:
        return null;
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _isMap
          ? _sensorsBloc.add(SensorsMapRequested())
          : _sensorsBloc.add(SensorsRequested());
    }

    if (index == 2) {
      _historicalEventsBloc.add(HistoricalEventsRequested());
    }

    if (index == 3) {
      _addUserMenuEnabled = false;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _cancelRegistration() {
    setState(() {
      _addUserMenuEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final action = await showDialog(
          context: context,
          builder: (context) => CustomPlatformAlertDialog(
            oneOptionOnly: false,
            onlySecondImportant: true,
            title: S.current.exit_app,
            message: Text(
              S.current.exit_app_message,
              style: Styles.defaultGreyRegular14,
            ),
          ),
        );

        if (action == CustomAction.First) {
          return true;
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: _appBar,
          body: _screenOptions,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 4.0,
            selectedItemColor: ColorHelper.darkBlue,
            unselectedItemColor: ColorHelper.defaultGrey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.place),
                label: _getTitle(0),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_input_antenna),
                label: _getTitle(1),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: _getTitle(2),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: _getTitle(3),
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
