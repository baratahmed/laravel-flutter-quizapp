import 'dart:convert';
import 'package:lara_flu_quizapp/config/AppConfig.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

mixin QuizModel on Model{
  Future<Map<String, dynamic>> startQuiz(int quizId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = "quiz/start/$quizId";
    final http.Response response = await http.get(AppConfig.BASE_URL + url + '?token=${prefs.getString('token')}', headers: {"Content-Type": "application/json"});
    final Map<String, dynamic>  quizData = jsonDecode(response.body);

    return {"data" : (quizData["data"]["quiz"]["detail"])};
  }
}