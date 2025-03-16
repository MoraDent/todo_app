import 'package:flutter/material.dart';

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
