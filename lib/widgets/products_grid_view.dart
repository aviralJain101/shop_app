import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products.dart';
import 'product_item.dart';

class ProductsGridView extends StatelessWidget {
  final bool showFavorite;
  ProductsGridView(this.showFavorite);
  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<Products>(context);
    final products=showFavorite?productData.favorites:productData.items;
    return GridView.builder(
        padding:const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: products.length,
        itemBuilder: (context,index)=>
          ChangeNotifierProvider.value(//dont use it without value here
            value: products[index],
            child: ProductItem(),
          ),
      );
  }
}