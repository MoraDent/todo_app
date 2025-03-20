import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared_components/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../archived-tasks.dart';
import '../../done_tasks.dart';
import '../../new_tasks.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState() );

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Map> tasks = [];

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? db;

  void makeDatabase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
        )
            .then((value) {
          print('table created');
        })
            .catchError((error) {
          print('Error on creating table ${error.toString()}');
        });
      },
      onOpen: (db) {
        getFromDatabase(db).then((value)
        {
             tasks = value;
             print(tasks);
             emit(AppGetDatabaseState());
        });
        print('database opened');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
     });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await db!.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
      })
          .catchError((error) {
        print('error when inserting new record');
      });
    });
  }

  Future<List<Map>> getFromDatabase(db) async
  {
    return await db!.rawQuery('SELECT * FROM tasks');
  }

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

}