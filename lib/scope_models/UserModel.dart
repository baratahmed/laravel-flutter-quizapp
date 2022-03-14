import 'package:lara_flu_quizapp/config/AppConfig.dart';
import 'package:lara_flu_quizapp/models/User.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

mixin UserModel on Model{
  User _authUser;
  String _token;
  String apiBaseUrl = AppConfig.BASE_URL;
  //String apiBaseUrl = 'http://192.168.1.2/lara_flu_quiz/public/api';

  User get authUser{
    return _authUser;
  }

  //Get Token
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> dashboard() async {
      // String token = await getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(apiBaseUrl + "/dashboard?token=${prefs.getString('token')}");
    if(response.statusCode == 200){
      final Map<String, dynamic> dataFound = convert.jsonDecode(response.body);
      num len = dataFound["data"].length;
      if(len == 0){
        return {"success": true, "data": []};
      }
      return {"success": true, "data": dataFound["data"]["quizzes"]};
    }else{
      return {"success": false};
    }

  }

  //Invalid User
  void setAuthUserNull(){
    _authUser = null;
  }

  //Login Method
  Future<Map<String,dynamic>> login(String email, String password) async {
    Map<String,dynamic> authData = {
        "email": email,
        "password": password,
    };
    Map<String,dynamic> result;

    var response  = await http.post(
      apiBaseUrl + "/auth",
      headers: {
        "Content-type": "application/json"
      },
      body:  convert.jsonEncode(authData)
    );

    if(response.statusCode == 401 || response.statusCode == 400){
      //Auth Error
      result = {
        "error": true,
        "msg": "Invalid User"
      };
    }else if(response.statusCode == 200){
        Map<String, dynamic> authedData = convert.jsonDecode(response.body);
        _authUser = User(
          id: authedData["user"]["id"],
          email: authedData["user"]["email"],
          token: authedData["token"],
          roleId: authedData["user"]["role_id"],
        );
        setToken();
        notifyListeners();
        result = {
          "error": false,
          "msg": "Successfully Authenticated"
        };
    }else{
      print('Network Error');
    }
    return result;
  }

  //Set Token
  void setToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", authUser.token);
  }

  //Register Method

  Future<Map<String,dynamic>> register(String email, String password, String cpassword, String mobile, String fullname) async {
    Map<String,dynamic> authData = {
      "email": email,
      "password": password,
      "password_confirmation": cpassword,
      "mobile": mobile,
      "name": fullname,
    };

    final http.Response response = await http.post(
        apiBaseUrl + "/register",
        body: convert.jsonEncode(authData),
        headers: {"Content-type": "application/json"},

    );

    final Map<String,dynamic> authResponseData = convert.jsonDecode(response.body);


    if(response.statusCode == 400){

      if(authResponseData.containsKey("email")){
          return {
            "success": false,
            "data": authResponseData,
            "message": authResponseData["email"][0]
          };
      }
      if(authResponseData.containsKey("name")){
        return {
          "success": false,
          "data": authResponseData,
          "message": authResponseData["name"][0]
        };
      }
      if(authResponseData.containsKey("password")){
        return {
          "success": false,
          "data": authResponseData,
          "message": authResponseData["password"][0]
        };
      }
    }else if(response.statusCode == 201){
      _authUser = User(
        email: authResponseData["user"]["email"],
        name: authResponseData["user"]["name"],
        roleId: authResponseData["user"]["role_id"],
        token: authResponseData["token"],
        id: authResponseData["user"]["id"],
      );
      setToken();
      // notifyListeners();
      return {
        "success": true,
        "data": authResponseData
      };
    }
  }

}