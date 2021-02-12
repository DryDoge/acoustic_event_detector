import 'package:acoustic_event_detector/data/models/user.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/event/bloc/current_events_bloc.dart';
import 'package:acoustic_event_detector/screens/event/event_screen.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/screens/history/history_screen.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/screens/sensors/sensors_screen.dart';
import 'package:acoustic_event_detector/screens/user/user_screen.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/firebase_const.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_app_bar.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_safe_area.dart';
import 'package:acoustic_event_detector/widgets/user/logout_appbar_action.dart';
import 'package:acoustic_event_detector/widgets/custom_floating_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  final FirebaseMessaging fcm = FirebaseMessaging();

  static const routeName = '/home';
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex;
  bool _addUserMenuEnabled = false;
  bool _isMap = false;
  User _user;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<User>(context, listen: false);

    widget.fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        var a = await showDialog(
          context: context,
          builder: (context) => CustomPlatformAlertDialog(
            title: S.current.new_event_alert_title,
            message: Text(
              S.current.new_event_alert_message,
              style: Styles.defaultGreyRegular14,
            ),
            onlyFirstImportant: true,
            oneOptionOnly: false,
          ),
        );

        if (a == CustomAction.First) {
          _navigateToEventsScreen();
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        _navigateToEventsScreen();
      },
      onResume: (Map<String, dynamic> message) async {
        _navigateToEventsScreen();
      },
    );

    widget.fcm.subscribeToTopic(FirebaseConst.eventsToken);

    if (_selectedIndex == null) {
      _selectedIndex = 3;
    }
  }

  void _navigateToEventsScreen() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() {
      _selectedIndex = 0;
    });
    BlocProvider.of<CurrentEventsBloc>(context, listen: false)
        .add(CurrentEventsRequested());
  }

  Widget get _screenOptions {
    switch (_selectedIndex) {
      case 0:
        return EventScreen(
            userRights: _user.rights,
            goToHistory: () {
              setState(() {
                _selectedIndex = 2;
              });
            });
      case 1:
        return SensorsScreen(
          userRights: _user.rights,
          setMap: () => _isMap = !_isMap,
        );
      case 2:
        return HistoryScreen(userRights: _user.rights);
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
    if (_selectedIndex == index) {
      return;
    }

    switch (index) {
      case 0:
        {
          BlocProvider.of<CurrentEventsBloc>(context, listen: false)
              .add(CurrentEventsRequested());
          break;
        }
      case 1:
        {
          _isMap
              ? BlocProvider.of<SensorsBloc>(context, listen: false)
                  .add(SensorsMapRequested())
              : BlocProvider.of<SensorsBloc>(context, listen: false)
                  .add(SensorsRequested());
          break;
        }
      case 2:
        {
          BlocProvider.of<HistoricalEventsBloc>(context, listen: false)
              .add(HistoricalEventsRequested());
          break;
        }
      case 3:
        {
          _addUserMenuEnabled = false;
          break;
        }
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
      child: CustomSafeArea(
        child: Scaffold(
          backgroundColor: ColorHelper.white,
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
