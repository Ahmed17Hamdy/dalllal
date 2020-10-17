import 'package:flutter/material.dart';


import '../constants.dart';

class CustomTextFeild extends StatelessWidget {
  CustomTextFeild(
      {this.label, this.helperText, this.icon, this.maxLen,this.textInputType});

  final String label;
  final IconData icon;
  final int maxLen;
  final String helperText;
  final TextInputType textInputType;

  String _errorMessage(String er) {
    switch (label) {
      case 'الإسم':
        return "من فضلك أدخل الإسم";
      case 'رقم الهاتف':
        return "من فضلك أدخل رقم الهاتف";
         case 'الكود':
        return "من فضلك أدخل الكود";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: TextFormField(
        keyboardType: textInputType,
        maxLength: maxLen,
        validator: (value) {
          if (value.isEmpty) {
            return _errorMessage(label);
          } else
            return null;
        },
        style: TextStyle(color: Colors.white),
        autofocus: true,
        decoration: InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
          ),
          filled: true,
          fillColor: mycolor,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
          helperText: helperText,
          helperStyle: TextStyle(color: Colors.white,fontSize: 8),
          labelText: label,
          hintStyle: TextStyle(color: Colors.white),
          suffixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          labelStyle: TextStyle(color: Colors.white,fontSize: 24),
          errorStyle: TextStyle(fontSize: 10,),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
            borderSide: BorderSide(
              color: mycolor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(50.0),
            ),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
