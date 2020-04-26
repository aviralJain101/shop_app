import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';

class EditScreen extends StatefulWidget {
  static const routeName='/edit';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode=FocusNode();
  final _descriptionFocusNode=FocusNode();
  final _imageUrlController=TextEditingController();
  final _imageUrlFocusNode=FocusNode();
  final _form=GlobalKey<FormState>();//to interact with the form widget
  Product _edittedProduct=Product(id: null,title: '',price: 0,description: '',imageUrl: '');
  var isInit=true;
  var _initValues = {
    'title':'',
    'description':'',
    'price':'',//TextFormFields only works with Strings
    'imageUrl':''
  };
  var isLoading=false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(isInit){
      final id=ModalRoute.of(context).settings.arguments as String;
      if(id!=null){
        _edittedProduct = Provider.of<Products>(context,listen: false).findById(id);
        _initValues = {
          'title':_edittedProduct.title,
          'description':_edittedProduct.description,
          'price':_edittedProduct.price.toString(),
          'imageUrl':''
        };
        _imageUrlController.text=_edittedProduct.imageUrl;
      }
    }
    isInit=false;
    super.didChangeDependencies();
  }
  @override
  void dispose() { //you have to dispose FocusNodes
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl(){
    if(_imageUrlFocusNode.hasFocus){
      setState(() {});
    }
  }

  Future<void> _saveForm()async{
    final isValid=_form.currentState.validate();
    if(!isValid){return ;}
    _form.currentState.save();
    setState(() {
      isLoading=true;
    });
    if(_edittedProduct.id!=null){
      await Provider.of<Products>(context,listen: false).updateProduct(
        _edittedProduct.id,
        _edittedProduct
      );
      setState(() {
        isLoading=false;
      });
      Navigator.of(context).pop();
    }else{
      try{
        await Provider.of<Products>(context,listen: false).addProduct(_edittedProduct);
      }catch(error){
          await showDialog(context: context,builder:(context)=>AlertDialog(
          title: Text('An error occured'),
          content: Text(error),
          actions: <Widget>[
            FlatButton(child: Text('OK'),onPressed: (){Navigator.of(context).pop();},)
          ],
        ));
      }finally{//always run no matter error or what
        setState(() {
          isLoading=false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),):Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){return 'Title cant be Empty';}
                  return null;
                },
                onSaved:(value){
                  _edittedProduct=Product(title: value,
                    description: _edittedProduct.description,
                    price: _edittedProduct.price,
                    id: _edittedProduct.id,
                    isFav: _edittedProduct.isFav,
                    imageUrl: _edittedProduct.imageUrl
                  );
                } ,
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                 validator: (value){
                  if(value.isEmpty){return 'Price cant be Empty';}
                  if(double.tryParse(value)==null){return 'Enter a valid number';}
                  return null;
                },
                onSaved:(value){
                  _edittedProduct=Product(title: _edittedProduct.title,
                    description: _edittedProduct.description,
                    price: double.parse(value),
                    id: _edittedProduct.id,
                    isFav: _edittedProduct.isFav,
                    imageUrl: _edittedProduct.imageUrl
                  );
                }
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                 validator: (value){
                  if(value.isEmpty){return 'Description cant be Empty';}
                  return null;
                },
                onSaved:(value){
                  _edittedProduct=Product(title: _edittedProduct.title,
                    description: value,
                    price: _edittedProduct.price,
                    id: _edittedProduct.id,
                    isFav: _edittedProduct.isFav,
                    imageUrl: _edittedProduct.imageUrl
                  );
                }
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.grey)),
                    margin: EdgeInsets.only(top:8,right: 10),
                    child: _imageUrlController.text.isEmpty?Text('Enter a URL'):FittedBox(
                      child: Image.network(_imageUrlController.text,fit: BoxFit.cover,),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,//cant use controller and initial values at the same time
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_){_saveForm();},
                      validator: (value){
                        if(value.isEmpty){return 'ImageUrl cant be empty';}
                        if(!value.startsWith('http')&&!value.startsWith('https')){
                          return 'Enter a Valid Url';
                        }
                        return null;
                      },
                      onSaved:(value){
                      _edittedProduct=Product(title: _edittedProduct.title,
                        description: _edittedProduct.description,
                        price: _edittedProduct.price,
                        id: _edittedProduct.id,
                        isFav: _edittedProduct.isFav,
                        imageUrl: value
                        );
                      }
                    ),
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}