import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/product.dart';
import '../main/components/show_products.dart';

class CategoryProducts extends StatefulWidget {
  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  List<Product> products = [
    Product('assets/product1.jpg', 'Bag', 'Beautiful bag', 2.33),
    Product('assets/product2.jpg', 'Cap', 'Cap with beautiful design', 10),
    Product('assets/category1.png', 'Jeans', 'Jeans for you', 20),
    Product('assets/category2.png', 'Woman Shoes',
        'Shoes with special discount', 30),
    Product('assets/category3.png', 'Bag Express', 'Bag for your shops', 40),
    Product('assets/category4.png', 'Jeans', 'Beautiful Jeans', 102.33),
    Product('assets/category5.png', 'Silver Ring', 'Description', 52.33),
    Product('assets/category6.png', 'Shoes', 'Description', 62.33),
    Product('assets/product1.jpg', 'Headphones', 'Description', 72.33),
  ];
  @override
  void initState() {
    super.initState();
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
              child: Container(
                  padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
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
