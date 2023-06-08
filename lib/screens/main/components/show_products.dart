import 'package:flutter/material.dart';
import 'package:ecommerce_int2/models/product.dart';

import '../../product/product_page.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProductPage(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.image.contains('https')
                  ? Image.network(
                      product.image,
                      height: 150,
                    )
                  : Image.asset(
                      product.image,
                      height: 150,
                    ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Text('\$${product.price}'),
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
