import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product_data.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  // Properties:
  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  // Constructor:
  CartModel(this.user) {
    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  // Public Methods:
  void addCartItem(CartProduct cartProduct) async {
    products.add(cartProduct);
    Firestore.instance.collection("users").document(user.fireBaseUser.uid).collection("cart").add(cartProduct.toMap()).then((document) {
      cartProduct.cartId = document.documentID;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) async {
    await Firestore.instance.collection("users").document(user.fireBaseUser.uid).collection("cart").document(cartProduct.cartId).delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    Firestore.instance.collection("users").document(user.fireBaseUser.uid).collection("cart").document(cartProduct.cartId).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    Firestore.instance.collection("users").document(user.fireBaseUser.uid).collection("cart").document(cartProduct.cartId).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * (discountPercentage/100);
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {

    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    
    DocumentReference refOrder = await Firestore.instance.collection("orders").add({
      "clientId" : user.fireBaseUser.uid,
      "products" : products.map((cartProduct) {
        return cartProduct.toMap();
      }).toList(),
      "shipPrice" : shipPrice,
      "productsPrice" : productsPrice,
      "discount" : discount,
      "total" : productsPrice - discount + shipPrice,
      "status" : 1,
    });

    await Firestore.instance.collection("users").document(user.fireBaseUser.uid).
    collection("orders").document(refOrder.documentID).setData({
      "orderId" : refOrder.documentID,
    });

    QuerySnapshot query = await Firestore.instance.collection("users").
    document(user.fireBaseUser.uid).collection("cart").getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }
    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }

  // Private Methods:
  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.fireBaseUser.uid).collection("cart").getDocuments();
    products = query.documents.map((documentSnapshot) {
      return CartProduct.fromDocument(documentSnapshot);
    }).toList();
    notifyListeners();
  }

  // Static Public Methods:
  static CartModel of(BuildContext context) {
    return ScopedModel.of<CartModel>(context);
  }

}