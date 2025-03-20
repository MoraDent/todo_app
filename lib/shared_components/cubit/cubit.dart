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

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

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
        getFromDatabase(db);
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

        getFromDatabase(db);
      }).catchError((error) {
        print('error when inserting new record');
      });
    });
  }

  void getFromDatabase(db)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());

     db.rawQuery('SELECT * FROM tasks').then((value)
     {


       value.forEach((element) {

           if(element['status'] == 'new')
             {
               newTasks.add(element);
             }
             else if(element['status'] == 'done')
             {
               doneTasks.add(element);
             } else {
           archivedTasks.add(element);
         }
       });
       emit(AppGetDatabaseState());
     });
  }

  void updateData({
    required String status,
    required int id,
}) async
  {
     db!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getFromDatabase(db);
      emit(AppUpdateDatabaseState());
     } );
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