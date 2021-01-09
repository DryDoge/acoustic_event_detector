import 'package:acoustic_event_detector/data/repositories/auth_repository.dart';
import 'package:acoustic_event_detector/data/repositories/history_repository.dart';
import 'package:acoustic_event_detector/data/repositories/sensors_repository.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/authenticate/authenticate_screen.dart';
import 'package:acoustic_event_detector/screens/authenticate/cubit/auth_cubit.dart';
import 'package:acoustic_event_detector/screens/history/bloc/historical_events_bloc.dart';
import 'package:acoustic_event_detector/screens/home_screen.dart';
import 'package:acoustic_event_detector/screens/loading_screen.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: ColorHelper.darkBlue,
        unselectedWidgetColor: ColorHelper.defaultGrey,
        iconTheme: IconThemeData(color: ColorHelper.defaultGrey),
      ),
      onGenerateTitle: (context) => S.current.appName,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder<FirebaseApp>(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: RaisedButton.icon(
                onPressed: () => Firebase.initializeApp(),
                icon: Icon(Icons.refresh),
                label: Text('Click to refresh!'),
              ),
            );
          }

          if (snapshot.hasData) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>(
                  create: (context) =>
                      AuthCubit(authRepository: AuthRepository()),
                ),
                BlocProvider<HistoricalEventsBloc>(
                  create: (context) => HistoricalEventsBloc(
                      historyRepository: HistoryRepository()),
                ),
                BlocProvider<SensorsBloc>(
                  create: (context) =>
                      SensorsBloc(sensorsRepository: SensorsRepository()),
                ),
              ],
              child: ScreenWrapper(),
            );
          }

          return LoadingScreen();
        },
      ),
    );
  }
}

class ScreenWrapper extends StatefulWidget {
  @override
  _ScreenWrapperState createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends State<ScreenWrapper> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).tryToLoginAutomaticly();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return LoadingScreen();
        } else if (state is Unauthenticated) {
          return AuthenticateScreen();
        } else if (state is Authenticated) {
          return Provider(
            create: (context) => state.user,
            child: HomeScreen(),
          );
        }
        return AuthenticateScreen();
      },
      listener: (context, state) async {
        if (state is AuthError) {
          showDialog(
            context: context,
            builder: (context) => CustomPlatformAlertDialog(
              title: S.current.register_error_default,
              message: Text(
                state.message,
                style: Styles.defaultGreyRegular14,
              ),
            ),
          );
        }
      },
    );
  }
}
