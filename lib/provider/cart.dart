import 'package:flutter/foundation.dart';

class CartItem{
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier{
  Map<String,CartItem> _items={};

  Map<String,CartItem> get items{
    return {..._items};
  }

  // List<CartItem> get getValues{
  //   return _items.values.toList();
  // }

  double get totalAmount{
    var total=0.0;
    _items.forEach((key,item)=>
      total+=item.price*item.quantity
    );
    return total;
  }

  void addItem(String productId,String title,double price,){
    if(_items.containsKey(productId)){
      //change quantity
      _items.update(productId, (prev)=>CartItem(
        id: prev.id,price: prev.price,title: prev.title,quantity: prev.quantity+1)
      );
    }else{
      _items.putIfAbsent(productId, ()=>
        CartItem(id: DateTime.now().toString(),title: title,price: price,quantity: 1)
      );
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){return;}
    if(_items[productId].quantity>1){
       _items.update(productId, (prev)=>CartItem(
        id: prev.id,
        price: prev.price,
        title: prev.title,
        quantity: prev.quantity-1)
      );
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear(){
    _items={};
    notifyListeners();
  }
}