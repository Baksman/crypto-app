import 'package:crypto_app/blocs/crypto/crypto_bloc.dart';
import 'package:crypto_app/repository/crypto_repository.dart';
import 'package:crypto_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CryptoBloc>(
          create: (_) =>  CryptoBloc(cryptoRespository:CryptoRepository() )..add(AppStarted()),
          child: MaterialApp(
        title: "crypto app",
        debugShowCheckedModeBanner: false,
        theme:ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.tealAccent
        ),
        home:HomeScreen(),
      ),
    );
  }
}
