import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared_components/constants.dart';
import 'package:todo_app/shared_components/cubit/cubit.dart';
import 'package:todo_app/shared_components/cubit/states.dart';
import 'package:todo_app/shared_components/shared_components.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, states)
      {
        var tasks = AppCubit.get(context).archivedTasks;
        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[400],
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
