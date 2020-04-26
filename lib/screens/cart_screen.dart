import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart'show Cart;
import 'package:shop_app/provider/order.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName='/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total',style:TextStyle(fontSize:20)),
                  Spacer(),
                  //SizedBox(width: 20,),
                  Chip(label: Text(cart.totalAmount.toString()+'Rs')),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (c,i)=> CartItem(
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].id,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title
              ),
            ),
          )
      ],),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isloading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(child: isloading?CircularProgressIndicator():
    Text('ORDER NOW'),onPressed:(widget.cart.totalAmount<=0||isloading)?null:
     ()async{
      setState(() {
        isloading=true;
      });
      await Provider.of<Order>(context,listen: false).addOrders(
        widget.cart.items.values.toList(),
        widget.cart.totalAmount
      );
      setState(() {
        isloading=false;
      });
      widget.cart.clear();
    },);
  }
}