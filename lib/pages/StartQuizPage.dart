import 'package:flutter/material.dart';
import 'package:lara_flu_quizapp/scope_models/AppModel.dart';

class StartQuizPage extends StatefulWidget {
  final int _quizId;
  final String _quizName;
  final AppModel _model;
  StartQuizPage(this._quizId, this._quizName, this._model);

  @override
  _StartQuizPageState createState() => _StartQuizPageState();
}

class _StartQuizPageState extends State<StartQuizPage> {

  bool _isLoading = false;
  String _textLoading = 'Loading...';
  bool _refreshedPage = false;
  List<dynamic> _resData;

  @override
  void initState() {
    int quizId = widget._quizId;
    setState(() {
      _isLoading = true;
    });
    widget._model.startQuiz(quizId).then((res){
      setState(() {
        _isLoading = false;
        _resData = res["data"];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start Quiz Page"),
      ),
      body: Container(
        child: Center(
          child: Text("Start Quiz Page " + widget._quizId.toString()),
        ),
      ),
    );
  }
}
