import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import 'edit_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName='/user_product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    //final userProduct=Provider.of<Products>(context);
    //print('rebuild');//to check for infinte loop
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){Navigator.of(context).pushNamed(EditScreen.routeName);},
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context,snapshot)=>snapshot.connectionState==ConnectionState.waiting?
        Center(child: CircularProgressIndicator(),) : RefreshIndicator(
          onRefresh: ()=>_refreshProducts(context),
          child: Consumer<Products>(
            builder: (c,userProduct,_)=>Padding(padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount:userProduct.items.length,
                itemBuilder: (context,i)=>Column(
                  children: [
                    UserProductItem(
                      userProduct.items[i].id,
                      userProduct.items[i].title,
                      userProduct.items[i].imageUrl
                    ),
                    Divider()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}