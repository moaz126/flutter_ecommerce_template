import 'dart:developer';

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/screens/main/components/show_products.dart';
import 'package:flutter/material.dart';

List<Product> searchProducts = [];

class RecommendedList extends StatefulWidget {
  final String category;

  const RecommendedList({super.key, required this.category});
  @override
  State<RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  bool _loader = false;
  List<Product> products = [];
  Future<List<DocumentSnapshot>> fetchProductsByCategory(
      String categoryId) async {
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
        .where('category', isEqualTo: widget.category)
        .get();
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
    searchProducts = products;
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
    // TODO: implement initState
    fetchProductsByCategory('Водопровод');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loader
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              SizedBox(
                height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    IntrinsicHeight(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                        width: 4,
                        color: mediumYellow,
                      ),
                    ),
                    Center(
                        child: Text(
                      'Рекомендуемые',
                      style: TextStyle(
                          color: darkGrey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                    padding: EdgeInsets.only(
                        top: 16.0, right: 16.0, left: 16.0, bottom: 10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.64,
                      padding: EdgeInsets.only(left: 16, right: 16),
                      children: products
                          .map((product) => ProductWidget(product: product))
                          .toList(),
                    ) /* MasonryGridView.count(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              crossAxisCount: 4,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) => new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProductPage(product: products[index]))),
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                            colors: [
                              Colors.grey.withOpacity(0.3),
                              Colors.grey.withOpacity(0.7),
                            ],
                            center: Alignment(0, 0),
                            radius: 0.6,
                            focal: Alignment(0, 0),
                            focalRadius: 0.1),
                      ),
                      child: Hero(
                          tag: products[index].image,
                          child: Image.asset(products[index].image))),
                ),
              ),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ), */
                    ),
              ),
            ],
          );
  }
}
