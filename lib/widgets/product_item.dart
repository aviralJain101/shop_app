import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final product=Provider.of<Product>(context);
    final cart=Provider.of<Cart>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id
            );
          },
          child: Image.network(product.imageUrl,fit: BoxFit.cover,)),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(product.title,textAlign: TextAlign.center,),
          leading: Consumer<Product>(//replaces Provider so Provider set to false
            builder: (context,product,child)=>IconButton(
              icon: Icon(
                product.isFav?Icons.favorite:Icons.favorite_border),
              onPressed: (){
                product.toggleFav(authData.token, authData.userId);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: (){
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Item added to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: (){
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}