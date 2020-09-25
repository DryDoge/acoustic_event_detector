import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './data/blocs/cubit/auth_cubit.dart';
import './data/repositories/auth_repository.dart';
import './screens/loading_screen.dart';
import './screens/home_screen.dart';
import './screens/authenticate/authenticate_screen.dart';
import './widgets/platform_alert_dialog.dart';
import './utils/color_helper.dart';
import './data/models/user.dart';
import './generated/l10n.dart';

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: ColorHelper.white,
      ),
      onGenerateTitle: (context) => S.current.appName,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        AuthenticateScreen.routeName: (context) => AuthenticateScreen(),
        LoadingScreen.routeName: (context) => LoadingScreen(),
      },
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
            return BlocProvider(
              create: (context) => AuthCubit(AuthRepository()),
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
    context.bloc<AuthCubit>().tryToLoginAutomaticly();
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
            create: (context) => state.props.first as User,
            child: HomeScreen(),
          );
        }
        return AuthenticateScreen();
      },
      listener: (context, state) async {
        if (state is AuthError) {
          showDialog(
            context: context,
            builder: (context) => PlatformAlertDialog('Error', state.message),
          );
        }
      },
    );
  }
}
