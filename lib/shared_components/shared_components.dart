import 'package:flutter/material.dart';
import 'package:todo_app/shared_components/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.cyan,
  bool isUpperCase = true,
  double radius  = 20.0,
  required void Function()? function,
  required String text,
}) => Container(
  width: width,
  height: 50.0,
  child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      autofocus: true,
      onPressed: function,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
  ),
);

Widget defaultFormField({
  required TextEditingController controller,
  required FormFieldValidator<String>? validate,
  required TextInputType type,
  required String label,
  required IconData prefix,
  IconData? suffix,
  void Function(String)? onSubmit,
  void Function()? onTap,
  void Function(String)? onChange,
  void Function()? suffixPressed,
  bool isPassword = false,
}) => TextFormField(
  controller: controller,
  validator: validate,
  keyboardType: type,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  onTap: onTap,
  obscureText: isPassword,
  decoration: InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
    prefixIcon: Icon(prefix),
    suffixIcon: suffix != null ? IconButton(
onPressed: suffixPressed,
icon: Icon(suffix),
) : null,
  ),
  );

Widget buildTaskItem(Map model, context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.cyan,
          child: Text(
            '${model['time']}',
            style: TextStyle(color: Colors.white,),
          ),
        ),
        SizedBox(width: 20.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.0,),
        IconButton(onPressed:()
        {
          AppCubit.get(context).updateData(
            status: 'done',
            id: model['id'],
          );
        },
            icon: Icon(
              Icons.check_box_outlined,
              color: Colors.green,
            )
        ),
        IconButton(onPressed:()
        {
          AppCubit.get(context).updateData(
            status: 'archive',
            id: model['id'],
          );
        },
            icon: Icon(
              Icons.archive_outlined,
              color: Colors.black45,
            )
        ),
      ]
  ),
);
