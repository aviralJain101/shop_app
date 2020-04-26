import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';
class Auth with ChangeNotifier{
  String _token,_userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth{
    return token!=null;
  }

  String get token{
    if(_expiryDate!=null&&
      _expiryDate.isAfter(DateTime.now())&&
      _token!=null){
        return _token;
      }
      return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> signUp(String email, String password)async{
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key= AIzaSyDJ0U7lQhht62mr91KlyAPi4aZmWw4oLcQ';
    try{
      final response = await http.post(url,body: json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    }));
    final responseData = json.decode(response.body);
    if(responseData['error']!=null){
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(Duration(
      seconds: int.parse(responseData['expiresIn'])
    ));
    autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String()
    });
    prefs.setString('userData', userData);
    }catch(error){
      throw error;
    }
    //print(json.decode(response.body));
  }

  Future<void> login(String email, String password)async{
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key= AIzaSyDJ0U7lQhht62mr91KlyAPi4aZmWw4oLcQ';
    try{
      final response = await http.post(url,body: json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    }));
    final responseData = json.decode(response.body);
    if(responseData['error']!=null){
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(Duration(
      seconds: int.parse(responseData['expiresIn'])
    ));
    autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String()
    });
    prefs.setString('userData', userData);
    }catch(error){
      throw error;
    }
    //print(json.decode(response.body));

  }

  Future<bool> tryAutoLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){return false;}
    final data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(data['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){return false;}
    _token = data['token'];
    _userId = data['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logOut()async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void autoLogout(){
    if(_authTimer!=null){
      _authTimer.cancel();
    }
    var timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }
} 