import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names_app/src/pages/home_page.dart';

import 'package:band_names_app/src/services/socket_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        )
      ],
      child: MaterialApp(
        title: 'Band Names App',
        theme: ThemeData(
          //
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
        },
      ),
    );
  }
}
