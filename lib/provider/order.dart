import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Order with ChangeNotifier{
  List<OrderItem> _orders=[];
  final String authToken;
  final String userId;
  Order(this.authToken,this.userId,this._orders);

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> fetchOrder()async{
    final url='https://shopapp-e6c8f.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final data = json.decode(response.body) as Map<String,dynamic>;
    if(data==null){return;}
    data.forEach((id,d){
      loadedOrders.add(OrderItem(
        id: id,
        amount: d['amount'],
        dateTime: DateTime.parse(d['dateTime']),
        products: (d['products']as List<dynamic>).map((item)=>
          CartItem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title']
          )
        ).toList()
      ));
    });
    _orders=loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts,double total)async{
    final url='https://shopapp-e6c8f.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final time=DateTime.now();
    final response = await http.post(url,body: json.encode({
      'amount':total,
      'dateTime':time.toIso8601String(),
      'products':cartProducts.map((cp)=>{
        'title':cp.title,
        'id':cp.id,
        'quantity':cp.quantity,
        'price':cp.price
      }).toList()
    }));
    _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      products: cartProducts,
      dateTime: time
    ));
    notifyListeners();
  }
}