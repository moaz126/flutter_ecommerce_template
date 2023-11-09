import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/custom_background.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/category/category_list_page.dart';
import 'package:ecommerce_int2/screens/main/components/recommended_list.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:ecommerce_int2/screens/search_page.dart';
import 'package:ecommerce_int2/screens/shop/check_out_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';
import 'ecplast_website.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

List<String> timelines = ['Weekly featured', 'Best of June', 'Best of 2018'];
String selectedTimeline = 'Weekly featured';

List<Product> products = [];

class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin<MainPage> {
  late TabController tabController;
  late TabController bottomTabController;
  bool _loader = false;
  List<Product> products = [];
  Future<List<DocumentSnapshot>> fetchProductsByCategory() async {
    setState(() {
      _loader = true;
    });

    final productsCollection =
        FirebaseFirestore.instance.collection('products');
    final querySnapshot = await productsCollection.get();
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
      String category =
          doc.data().containsKey('category') ? doc['category'] : ' ';

      // Create a Product object and add it to the list
      Product product = Product(id, productThumbnail, productName,
          productDetail, productPrice, images, category);

      products.add(product);
    });
    searchProducts = products;
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
    tabController = TabController(length: 6, vsync: this);
    bottomTabController = TabController(length: 5, vsync: this);
    fetchProductsByCategory();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          /* IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NotificationsPage())),
              icon: Icon(Icons.notifications)), */
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage())),
              icon: SvgPicture.asset('assets/icons/search_icon.svg'))
        ],
      ),
    );

    Widget topHeader = Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTimeline = timelines[0];
                  });
                },
                child: Text(
                  timelines[0],
                  style: TextStyle(
                      fontSize: timelines[0] == selectedTimeline ? 20 : 14,
                      color: darkGrey),
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTimeline = timelines[1];
                  });
                },
                child: Text(timelines[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: timelines[1] == selectedTimeline ? 20 : 14,
                        color: darkGrey)),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTimeline = timelines[2];
                  });
                },
                child: Text(timelines[2],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: timelines[2] == selectedTimeline ? 20 : 14,
                        color: darkGrey)),
              ),
            ),
          ],
        ));

    Widget tabBar = TabBar(
      tabs: [
        Tab(text: 'Водопровод'),
        Tab(text: 'Канализация'),
        Tab(text: 'Водонагреватели'),
        Tab(text: 'Сантехническая мебель'),
        Tab(text: 'Санфаянс'),
        Tab(text: 'Утеплители для труб'),
      ],
      labelStyle: TextStyle(fontSize: 16.0),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.0,
      ),
      labelColor: darkGrey,
      unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
      isScrollable: true,
      controller: tabController,
    );

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
      body: CustomPaint(
        painter: MainBackground(),
        child: TabBarView(
          controller: bottomTabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SafeArea(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  // These are the slivers that show up in the "outer" scroll view.
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: appBar,
                    ),
                    /*  SliverToBoxAdapter(
                      child: topHeader,
                    ), */
                    _loader
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                                height: 200,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          )
                        : SliverToBoxAdapter(
                            child: ProductList(
                              products: products.take(3).toList(),
                            ),
                          ),
                    SliverToBoxAdapter(
                      child: tabBar,
                    )
                  ];
                },
                body: TabView(
                  tabController: tabController,
                ),
              ),
            ),
            CategoryListPage(),
            CheckOutPage(),
            ProfilePage(),
            EcoplastWebsite(),
          ],
        ),
      ),
    );
  }
}
