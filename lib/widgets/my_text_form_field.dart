//this class need to work


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  String labelText;
  Icon icon;
  TextEditingController controller;


  MyTextFormField({required this.labelText, required this.icon, required this.controller});

  // const MyTextFormField({Key? key, this.labelText, this.icon, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          // labelText: 'a ${labelText}',
          // icon: icon,
      ),
      controller: controller,
    );
  }
}
