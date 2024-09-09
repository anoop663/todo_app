import 'package:flutter/material.dart';
import 'package:flutter_application_todo/todo_bloc/navig_cubit.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_todo/todo_bloc/todo_bloc.dart';
import 'package:flutter_application_todo/widgets/bottom_navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()), 
        BlocProvider(
          lazy: false,
          create: (_) => TodoBloc()),
          BlocProvider(
      create: (_) => TodoBloc()..add(LoadTodos())),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: BottomNavigate(),
          ),
        ),
      ),
    );
  }
}