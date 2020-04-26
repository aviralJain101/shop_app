import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/products_grid_view.dart';

import 'cart_screen.dart';

enum Filter{
  Favorites,
  All
}

class ProductOvrviewScreen extends StatefulWidget {

  @override
  _ProductOvrviewScreenState createState() => _ProductOvrviewScreenState();
}

class _ProductOvrviewScreenState extends State<ProductOvrviewScreen> {
  bool showFavorite=false;
  bool isLoading = false;
  bool isInit = true;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_){    //NOT WORKING USE DIDCHANGEDEPENDENCIES
  //      setState(() {
  //       isLoading=true;
  //     });
  //     Provider.of<Products>(context).fetchProducts().then((_){
  //       setState(() {
  //         isLoading=false;
  //       });
  //     });
  //   });
  //   super.initState();
  // }
  @override
  void didChangeDependencies() {
    if(isInit){
      setState(() {
        isLoading=true;
      });
      Provider.of<Products>(context).fetchProducts().then((_){
        setState(() {
          isLoading=false;
        });
      });
    }
    isInit=false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showFavorite?'Favorites':'My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (Filter value){
              setState(() {
                if(value==Filter.Favorites){
                //products.showFavOnly();
                showFavorite=true;
                }
                else{
                  showFavorite=false;
                  // products.showAll();
                }
              });
            },
            itemBuilder: (_)=>[
              PopupMenuItem(child: Text('Show Favorites'),value:Filter.Favorites),
              PopupMenuItem(child: Text('Show All'),value:Filter.All),
            ],
          ),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
            Navigator.of(context).pushNamed(CartScreen.routeName);
          })
        ],
      ),
      drawer: AppDrawer(),
      body:isLoading?Center(child: CircularProgressIndicator(),): ProductsGridView(showFavorite)
    );
  }
}