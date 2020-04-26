import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

import 'screens/edit_screen.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),//.value approach is better than builder when using listener on list items
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context,auth,prevProduct)=>Products(
            auth.token,
            auth.userId,
            prevProduct==null?[]:prevProduct.items
          ),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (context,auth,prevOrder)=>Order(
            auth.token,
            auth.userId,
            prevOrder==null?[]:prevOrder.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _)=>MaterialApp(
          title:'shopApp',
          home: auth.isAuth ? ProductOvrviewScreen(): FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, snapshot)=>snapshot.connectionState==ConnectionState.waiting?
              SplashScreen(): AuthScreen()
          ),
          routes: {
            //'/':(ct)=>ProductOvrviewScreen(),
            ProductDetailsScreen.routeName: (ct)=>ProductDetailsScreen(),
            CartScreen.routeName:(c)=>CartScreen(),
            OrdersScreen.routeName:(c)=>OrdersScreen(),
            UserProductScreen.routeName:(c)=>UserProductScreen(),
            EditScreen.routeName:(c)=>EditScreen(),
          },
        ),
      ) 
    );
  }
}

