import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {

  // Properties:
  String cartId;
  String category;
  String productId;
  int quantity;
  String size;
  ProductData productData; // Must be loaded from DB.

  // Constructor:
  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot documentSnapshot) {
    cartId = documentSnapshot.documentID;
    category = documentSnapshot.data["category"];
    productId = documentSnapshot.data["productId"];
    quantity = documentSnapshot.data["quantity"];
    size = documentSnapshot.data["size"];
  }

  // Public Methods:
  Map<String, dynamic> toMap() {
    return {
      "category" : this.category,
      "productId" : this.productId,
      "quantity" : this.quantity,
      "size" : this.size,
      "product" : productData.toResumeMap(),
    };
  }

}