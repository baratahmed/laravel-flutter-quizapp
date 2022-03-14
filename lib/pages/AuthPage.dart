import 'package:flutter/material.dart';
import 'package:lara_flu_quizapp/scope_models/AppModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  String _email;
  String _password;
  bool _isloading = false;

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isloading,
        child: _buildLogin(),
      )
    );
  }

  Widget _buildLogin(){
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.all(40.0),
      child: _buildLoginWrapper(),
    );
  }

  Widget _buildLoginWrapper(){
    return SingleChildScrollView(
      child: _buildLoginWrapperContent(),
    );
  }

  Widget _buildLoginWrapperContent(){
    return Column(
      children: [
        _buildLogo(),
        _buildLoginForm(),
      ],
    );
  }

  Widget _buildLogo(){
    return Image.asset('assets/quiz.jpg');
  }

  Widget _buildLoginForm(){
    return _buildForm();
  }

  Widget _buildForm(){
    return Form(
      key: _formState,
      child: Column(
        children: [
          _buildEmailField(),
          SizedBox(height: 15.0,),
          _buildPasswordField(),
          SizedBox(height: 40.0,),
          SizedBox(
            width: double.infinity,
            child: _buildLoginButton(),
          ),
          SizedBox(height: 10.0,),
          SizedBox(
            width: double.infinity,
            child: _buildRegisterButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(){
    return TextFormField(
      validator: (value){
        if(value.trim().length <= 0){
          return "Email is Required!";
        }
      },
      onSaved: (value){
          setState(() {
            _email = value;
          });
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPasswordField(){
    return TextFormField(
      validator: (value){
        if(value.trim().length <= 0){
          return "Password is Required!";
        }
      },
      onSaved: (value){
        setState(() {
          _password = value;
        });
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildLoginButton(){
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, AppModel model){
        return _loginButton(context, child, model);
    });
  }

  Widget _loginButton(BuildContext context, Widget child, AppModel model){
      return RaisedButton(
          textColor: Colors.white,
          color: Colors.redAccent,
          child: Text("Login"),
          onPressed: (){
            if(!_formState.currentState.validate()){
                return;
            }
            _formState.currentState.save();
            setState(() {
              _isloading = true;
            });
            model.login(_email, _password).then((res){
              setState(() {
                _isloading = false;
              });
              if(res["error"]){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                        return AlertDialog(
                          content: Text(res["msg"]),
                          actions: [
                            new FlatButton(onPressed: (){Navigator.of(context).pop();}, child: new Text("OK"))
                          ],
                        );
                    }
                );
              }else{
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
            }).catchError((e){print(e.toString());});
          }
      );
  }

  Widget _buildRegisterButton(){
    return RaisedButton(
        textColor: Colors.white,
        color: Colors.blueAccent,
        child: Text("Create Account"),
        onPressed: (){}
    );
  }
}
