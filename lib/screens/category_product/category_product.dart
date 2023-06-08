import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/product.dart';
import '../main/components/show_products.dart';

class CategoryProducts extends StatefulWidget {
  final String categoryName;

  const CategoryProducts({super.key, required this.categoryName});
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  List<Product> products = [];
  bool _loader = false;
  Future<List<DocumentSnapshot>> fetchProductsByCategory() async {
    setState(() {
      _loader = true;
    });
    log('check');
    // Reference to the products collection
    /*  CollectionReference productsRef =
        FirebaseFirestore.instance.collection('products');

    // Query products by category
    QuerySnapshot querySnapshot =
        await productsRef.where('category', isEqualTo: categoryId).get(); */
    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    final querySnapshot = await productsCollection
        .where('category', isEqualTo: widget.categoryName)
        .get();
    print('asdfasdfasdfasdf');
    print(querySnapshot.docs.length);
    querySnapshot.docs.forEach((doc) {
      // Extract the data from the document snapshot
      String id = doc.id;
      String productName = doc['productName'];
      String productThumbnail = doc['thumbnail'];
      double productPrice =
          doc['price'] == '' ? 0.0 : double.parse(doc['price']);
      String productDetail = doc['productDetail'];
      List<dynamic> images = doc['images'];
      String category = doc['category'];

      // Create a Product object and add it to the list
      Product product = Product(id, productThumbnail, productName,
          productDetail, productPrice, images, category);

      products.add(product);
    });
    log(products.length.toString());
    print('ho gya' + products.length.toString());
    // Return the list of product documents
    setState(() {
      _loader = false;
    });
    return querySnapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF9F9F9),
      child: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Водопровод',
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Flexible(
              child: _loader
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding:
                          EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.57,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        children: products
                            .map((product) => ProductWidget(product: product))
                            .toList(),
                      )),
            )
          ],
        ),
      ),
    );
  }
}
