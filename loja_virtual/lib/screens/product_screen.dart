import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product_data.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {

  // Properties:
  final ProductData product;

  // Constructor:
  ProductScreen(this.product);

  // Overridden Methods:
  @override
  _ProductScreenState createState() => _ProductScreenState(this.product);
}

class _ProductScreenState extends State<ProductScreen> {

  // Properties:
  String size;
  final ProductData product;
  _ProductScreenState(this.product);

  // Overridden Methods:
  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              dotIncreasedColor: primaryColor,
              autoplay: false,
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),

                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    children: product.sizes.map((size) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            this.size = size;
                          });
                        },
                        child: Container(
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: this.size == size ? primaryColor : Colors.grey[500],
                              width: 3,
                            )
                          ),
                          child: Text(size),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: this.size != null ? () {
                      if (UserModel.of(context).isLoggedIn()) {
                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = size;
                        cartProduct.quantity = 1;
                        cartProduct.productId = product.id;
                        cartProduct.category = product.category;
                        cartProduct.productData = product;
                        CartModel.of(context).addCartItem(cartProduct);

                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return CartScreen();
                        }));

                      } else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      }

                    } : null,
                    color: primaryColor,
                    child: Text(
                      UserModel.of(context).isLoggedIn() ?
                      "Adicionar ao carrinho" :
                      "Entre para comprar",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

}
