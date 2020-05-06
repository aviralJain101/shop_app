import 'dart:math';

import 'package:flutter/material.dart';
import '../provider/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({Key key, this.order}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded=false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded? min(widget.order.products.length*20.0+110,200):95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          ListTile(
            title: Text('${widget.order.amount}Rs'),
            subtitle: Text(DateTime.now().toString()),
            trailing: IconButton(icon: Icon(_expanded?Icons.expand_less:Icons.expand_more), 
            onPressed: (){
              setState(() {
                _expanded=!_expanded;
              });
            }),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _expanded?min(widget.order.products.length*20.0+10,100):0,
            child: ListView(children: widget.order.products.map((prod)=>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(prod.title),
                  Text('${prod.quantity}x  ${prod.price}Rs')
                ],
              )
            ).toList(),),
          )
        ],),
      ),
    );
  }
}