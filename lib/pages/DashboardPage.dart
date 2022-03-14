import 'package:flutter/material.dart';
import 'package:lara_flu_quizapp/models/QuizDash.dart';
import 'package:lara_flu_quizapp/scope_models/AppModel.dart';
import 'package:scoped_model/scoped_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  bool _isLoading = false;
  Map<String,dynamic>  _result;
  List<QuizDash> _quizzes = List();
  List<dynamic> _data = List();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    ScopedModel.of<AppModel>(context).dashboard().then((result){
      setState(() {
        _isLoading = false;
        _result = result;
        _data = _result["data"];
        _data.forEach((res) {
          dynamic result = res["result"];
          QuizDash qd = new QuizDash(
              description: res["description"],
              id: res["quiz_id"],
              quizName: res["quiz_name"],
              questionsNo: res["questions_no"],
              result: result.length == 0 ? new Map() : res["result"]
          );
          _quizzes.add(qd);
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Quiz App"),
      ),
      body: _isLoading ? _buildLoader() :  _buildDashboard(),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(title: Text("") ,),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Dashboard"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context,"/dashboard");
              },
            ),
            ListTile(leading: Icon(Icons.list),title: Text("My Quizes"),),
            ListTile(leading: Icon(Icons.settings),title: Text("Settings"),),
            ListTile(leading: Icon(Icons.exit_to_app),title: Text("Logout"),),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: new Text("2022 © Cherished Dream"),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleDashboardItem(BuildContext context, int index){
      bool isResultEmpty = _quizzes[index].result.isEmpty;
      return Column(
        children: [
          Card(
            color: isResultEmpty ? Colors.deepOrangeAccent : Colors.black,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: isResultEmpty ? Icon(Icons.list, color: Colors.white, size: 25.0,) : Icon(Icons.beenhere, color: Colors.white, size: 25.0,),
                trailing: isResultEmpty ? Text('START QUIZ', style: TextStyle(color: Colors.white),) : Text('VIEW RESULTS', style: TextStyle(color: Colors.white),),
                title: Text(_quizzes[index].quizName, style: TextStyle(color: Colors.white),),
                subtitle: !isResultEmpty
                    ? Text('Questions: ' + _quizzes[index].questionsNo.toString() +
                    '\n\rScore: [' + _quizzes[index].result["score"].toString() +
                    ']' + '\n\rRank: [' + _quizzes[index].result["rank"].toString() +
                    ']', style: TextStyle(color: Colors.white),)
                    : Text('Questions: ' + _quizzes[index].questionsNo.toString(), style: TextStyle(color: Colors.white)),
                onTap: (){
                  if(isResultEmpty){
                    //Start Quiz
                  }else{
                    //View Quiz Result
                  }
                },
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildDashboard() {
    if(_result["success"] == false){
        Navigator.pushReplacementNamed(context, "/");
    }
    if(_data.length == 0){
      return Center(
        child: Text("Welcome to Quiz App!"),
      );
    }else{
      return Container(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
            itemBuilder: _buildSingleDashboardItem,
            itemCount: _data.length,
        ),
      );
    }
  }

  Widget _buildLoader(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

}
