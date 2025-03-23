import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/archived-tasks.dart';
import 'package:todo_app/done_tasks.dart';
import 'package:todo_app/new_tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared_components/constants.dart';
import 'package:todo_app/shared_components/cubit/cubit.dart';
import 'package:todo_app/shared_components/cubit/states.dart';
import 'package:todo_app/shared_components/shared_components.dart';

class HomeLayout extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..makeDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.cyan,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(cubit.isBottomSheetShown)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDatabase(
                      date: dateController.text,
                      time: timeController.text,
                      title: titleController.text,
                    );
                    formKey.currentState!.save();
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
                              noKeyboard: true,
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
                              noKeyboard: true,
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
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);

                }
              },
              backgroundColor: Colors.blue,
              shape: CircleBorder(),
              child: Icon(cubit.fabIcon, color: Colors.white),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              showSelectedLabels: true,
              currentIndex: cubit.currentIndex,
              onTap: (index)
              {
                  cubit.changeIndex(index);
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
        },
      ),
    );
  }

  // Future<String> getName() async {
  //   return 'Amr Mustafa';
  // }


}

