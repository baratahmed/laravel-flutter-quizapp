import 'package:flutter/material.dart';
import 'package:lara_flu_quizapp/scope_models/AppModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _email;
  String _password;
  String _cpassword;
  String _mobileNumber;
  String _fullName;
  bool _isloading = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Create New Account"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isloading,
        child: _buildRegister(),
      ),
    );
  }

  Widget _buildRegister(){
    return Container(
      padding: EdgeInsets.all(20.0),
      child: _buildRegisterWrapper()
    );
  }

  Widget _buildRegisterWrapper(){
    return SingleChildScrollView(
      child: _buildForm()
    );
  }

  Widget _buildForm(){
    return Form(
      key: _formState,
      child: Column(
        children: [
          _buildFullName(),
          SizedBox(height: 8,),
          _buildEmail(),
          SizedBox(height: 8,),
          _buildMobile(),
          SizedBox(height: 15,),
          _buildPassword(),
          SizedBox(height: 8,),
          _buildConfirmPassword(),
          SizedBox(height: 25,),
          _buildCreateButton(),
          SizedBox(height: 10.0,),
          _buildLogin(),
          SizedBox(height: 30.0,),
          Text("Powered By Cherished Dream")


        ],
      ),
    );
  }

  Widget _buildCreateButton(){
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, AppModel model){
      return _createButton(context, child, model);
    });
  }

  Widget _createButton(BuildContext context, Widget child, AppModel model){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.green,
        child: Text("Create Account"),
        onPressed: (){
          if(!_formState.currentState.validate()){
            return;
          }
          _formState.currentState.save();
          setState(() {
            _isloading = false;
          });
          model.register(_email, _password, _cpassword, _mobileNumber, _fullName).then((res){
            setState(() {
              _isloading = false;
            });
            if(res["success"]){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      content: Text(res["message"]),
                      actions: [
                        new FlatButton(onPressed: (){Navigator.of(context).pop();}, child: new Text("OK"))
                      ],
                    );
                  }
              );
            }else{
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          });
        },
      ),
    );
  }


  Widget _buildLogin(){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        textColor: Colors.white,
        color: Colors.blueAccent,
        child: Text("Login"),
        onPressed: (){},
      ),
    );
  }

  Widget _buildFullName(){
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "Full Name",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildEmail(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: "Email Address",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildMobile(){
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Mobile Number",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildPassword(){
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Password",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

  Widget _buildConfirmPassword(){
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          labelText: "Confirm Password",
          filled: true,
          fillColor: Colors.white
      ),
    );
  }

}
