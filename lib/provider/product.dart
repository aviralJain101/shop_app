import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id,title,description,imageUrl;
  final double price;
  bool isFav;

  Product({
    this.id, 
    this.title, 
    this.description, 
    this.price,
    this.imageUrl,
    this.isFav=false
    }
  );
  Future<void> toggleFav(String authToken, String userId)async{
    final oldStatus=isFav;
    isFav=!isFav;
    notifyListeners();
    final url='https://shopapp-e6c8f.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try{
      final response = await http.put(url,body: json.encode(
        isFav
      ));
      if(response.statusCode>=400){
        isFav=oldStatus;
        notifyListeners();
      }
    }catch(error){
      isFav=oldStatus;
      notifyListeners();
    }
  }
}