import 'package:flutter/cupertino.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'New Tasks',
        style: TextStyle(
          fontSize: 55.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
