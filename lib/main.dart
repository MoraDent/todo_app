import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared_components/cubit/observ_cubit.dart';

import 'home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}