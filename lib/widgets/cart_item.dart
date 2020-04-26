import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id,title,productId;
  final double price;
  final int quantity;
  CartItem(this.productId,this.id,this.price,this.quantity,this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete_sweep,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right:20),
        margin: EdgeInsets.symmetric(horizontal:15,vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (c)=>
          AlertDialog(
            title: Text('Are You Sure'),
            content: Text('Do you want to remove the item from the cart'),
            actions: <Widget>[
              FlatButton(child: Text('No'),onPressed: (){Navigator.of(c).pop(false);},),
              FlatButton(child: Text('Yes'),onPressed: (){Navigator.of(c).pop(true);},),
            ],
          )
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal:15,vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text(price.toString()+'Rs')),
            ),
            title: Text(title),
            subtitle: Text('Total: ${price*quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}