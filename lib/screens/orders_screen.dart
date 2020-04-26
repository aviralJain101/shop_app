import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart' show Order;
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/order_item.dart';
class OrdersScreen extends StatefulWidget {
  static const routeName='/order-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var isLoading = false;
  // @override
  // void initState() {
  //   //Future.delayed(Duration.zero).then((_)async{
  //     isLoading=true;
  //     Provider.of<Order>(context,listen: false).fetchOrder().then((_){
  //       setState(() {
  //         isLoading=false;
  //       });
  //     });
      
  //   //});
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    //final orderData=Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context,listen: false).fetchOrder(),
        builder: (c,data){
          if(data.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else{
            if(data.error!=null){
              return Center(child: Text('AN ERROR OCCURED'),);
            }else{
              return Consumer<Order>(
                builder: (c,orderData,child)=>ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (c,i)=>OrderItem(order:orderData.orders[i]),
                ),
              );
            }
          }
        },
      )
    );
  }
}