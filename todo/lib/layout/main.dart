import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/layout/MainScreen.dart';
import 'package:todo/modules/new_tasks/NewTasks.dart';
import 'package:todo/shared/observer/blocObserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

