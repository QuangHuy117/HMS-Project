import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String text;
  final Icon icon;
  final bool hidePass;
  final TextEditingController controller;

  const TextInput({
    Key key,
    this.text,
    this.icon,
    this.hidePass,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        bottom: 25,
      ),
      width: size.width * 0.7,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: const Offset(0, 5),
        )
      ]),
      child: TextFormField(
        obscureText: hidePass,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: text,
          hintStyle: TextStyle(
              color: Color(0xFF707070),
              fontWeight: FontWeight.bold,
              fontSize: 18),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
