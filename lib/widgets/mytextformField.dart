import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final Function validation;
  final Function onChanged;
  final String name;
  final String hintname;
  final TextEditingController emailController;

  MyTextFormField(
      {this.onChanged,
      this.hintname,
      this.name,
      this.validation,
      this.emailController});

  final emailHolder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      validator: validation,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: name,
        hintText: hintname,
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.blue[900]),
        // ),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: customColor[10]),
        // ),
        suffix: GestureDetector(
          onTap: () {
            emailController.clear();
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PasswordTextFormField extends StatelessWidget {
  final bool obserText;
  final Function validation;
  final Function onChanged;
  final String name;
  final Function onTap;
  final Function shortCutLoginButton;

  PasswordTextFormField(
      {this.onChanged,
      this.onTap,
      this.name,
      this.obserText,
      this.validation,
      this.shortCutLoginButton});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obserText,
      validator: validation,
      onChanged: onChanged,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: shortCutLoginButton,
      decoration: InputDecoration(
        labelText: name,
        suffix: GestureDetector(
          onTap: onTap,
          child: Icon(
            obserText == true ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
