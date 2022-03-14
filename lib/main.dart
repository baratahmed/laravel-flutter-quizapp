import 'package:flutter/material.dart';
import 'package:lara_flu_quizapp/pages/AuthPage.dart';
import 'package:lara_flu_quizapp/pages/DashboardPage.dart';
import 'package:lara_flu_quizapp/pages/RegisterPage.dart';
import 'package:lara_flu_quizapp/scope_models/AppModel.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyQuizApp());
}

class MyQuizApp extends StatefulWidget {
  const MyQuizApp({Key key}) : super(key: key);

  @override
  _MyQuizAppState createState() => _MyQuizAppState();
}

class _MyQuizAppState extends State<MyQuizApp> {

  AppModel model = new AppModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
         model: model,
         child: MaterialApp(
           debugShowCheckedModeBanner: false,
           theme: ThemeData(
             primaryColor: Colors.redAccent,
             colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
           ),
           routes:  {
             '/' : (context){
                return AuthPage();
             },
             '/register' : (context){
               return RegisterPage();
             },
             '/dashboard' : (context){
               return DashboardPage();
             },


           },
         )
    );
  }
}
