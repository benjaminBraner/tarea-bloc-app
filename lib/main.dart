import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/order_bloc.dart';
import 'screens/order_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => OrderBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Órdenes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OrderScreen(),
    );
  }
}