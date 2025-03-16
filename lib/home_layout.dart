import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/archived-tasks.dart';
import 'package:todo_app/done_tasks.dart';
import 'package:todo_app/new_tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared_components/shared_components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  Database? db;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          titles[currentIndex],
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(isBottomSheetShown)
            {
              if(formKey.currentState!.validate())
                {
                  formKey.currentState!.save();
                  insertToDatabase(
                    date: dateController.text,
                    time: timeController.text,
                    title: titleController.text,
                  ).then((value){
                    Navigator.pop(context);
                    isBottomSheetShown = false;
                    setState(() {
                      fabIcon = Icons.edit;
                    });
                  });
                }
            } else
              {
                scaffoldKey.currentState?.showBottomSheet(
                      (context) => Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                  controller: titleController,
                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                    {
                                      return 'title can\'t be empty';
                                    }
                                    return null;
                                  },
                                  type: TextInputType.text,
                                  label: 'Task Title',
                                  prefix: Icons.title,
                              ),
                              SizedBox(height: 15.0),
                              defaultFormField(
                                controller: dateController,
                                onTap: ()
                                  {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2029-10-20'),).then((value)
                                    {
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                validate: (value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'date can\'t be empty';
                                  }
                                  return null;
                                },
                                type: TextInputType.datetime,
                                label: 'Task Date',
                                prefix: Icons.date_range,
                              ),
                              SizedBox(height: 15.0),
                              defaultFormField(
                                controller: timeController,
                                onTap: ()
                                {
                                  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value)
                                  {
                                    timeController.text = value!.format(context).toString();
                                  });
                                },
                                validate: (value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'time can\'t be empty';
                                  }
                                  return null;
                                },
                                type: TextInputType.datetime,
                                label: 'Task Time',
                                prefix: Icons.watch_later_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                  elevation: 30.0,
                );
                isBottomSheetShown = true;
                setState(() {
                  fabIcon = Icons.add;
                });
              }
        },
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: Icon(fabIcon, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archive',
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return 'Amr Mustafa';
  }

  void makeDatabase() async {
    db = await openDatabase(
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
        print('database opened');
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
}) async
  {
    return await db!.transaction((txn) {
      return txn
          .rawInsert(
            'INSERT INTO task(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
          )
          .then((value) {
            print('$value inserted successfully');
          })
          .catchError((error) {
            print('error when inserting new record');
          });
    });
  }
}
