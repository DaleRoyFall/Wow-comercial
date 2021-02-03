import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_comercial/bloc_list/list_cubit.dart';
import 'package:wow_comercial/page/part/painter.dart';

import 'part/product_bottom_navigation_bar.dart';
import '../helper/size_config.dart';
import '../model/product.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.product, this.productImage}) : super(key: key);
  final Product product;
  final Image productImage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: buildAppBar(context),
        body: MyProductPage(
          productId: product.id,
          productImage: productImage,
        ),
        bottomNavigationBar: ProductBottomNavigationBar());
  }

  Widget buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(
          SizeConfig.screenWidth,
          SizeConfig.screenHeight * .1,
        ),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              size: SizeConfig.adaptWidth(8),
            ),
            color: Colors.white,
          ),
          title: Image.asset("assets/images/wow_logo.png",
              width: SizeConfig.adaptWidth(24),
              height: SizeConfig.adaptHeight(20)),
          centerTitle: true,
          backgroundColor: Colors.indigo[900],
        ));
  }
}

class MyProductPage extends StatefulWidget {
  MyProductPage({Key key, this.productId, this.productImage, this.state})
      : super(key: key);
  final int productId;
  final Image productImage;
  final ListState state;

  @override
  _MyProductPageState createState() => _MyProductPageState();
}

class _MyProductPageState extends State<MyProductPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit, ListState>(builder: (context, state) {
      return buildProductInformation(context, state);
    });
  }

  Widget buildProductInformation(BuildContext context, ListState state) {
    Product product =
        state.products.firstWhere((product) => product.id == widget.productId);

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: SizeConfig.adaptHeight(4),
            ),
            Column(
              children: [
                Stack(alignment: Alignment.topRight, children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.productImage,
                  ),
                  FavoriteArc(diameter: 100),
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.adaptHeight(1.5),
                        right: SizeConfig.adaptWidth(2)),
                    child: IconButton(
                        onPressed: () => {
                              context
                                  .read<ListCubit>()
                                  .setProductFavorite(product.id),
                            },
                        icon: product.favorite
                            ? Image.asset(
                                "assets/images/favorite.png",
                                width: SizeConfig.adaptWidth(10),
                                color: Colors.red,
                              )
                            : Image.asset(
                                "assets/images/favorite_border.png",
                                width: SizeConfig.adaptWidth(10),
                                color: Colors.red,
                              )),
                  ),
                ]),
                Container(
                  width: SizeConfig.adaptWidth(100),
                  height: SizeConfig.adaptHeight(0.2),
                  color: Colors.grey[200],
                ),
                SizedBox(
                  height: SizeConfig.adaptHeight(4),
                ),
                Text(
                  product.title,
                  style: TextStyle(
                      fontSize: SizeConfig.adaptFontSize(6),
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w900,
                      color: Colors.indigo[900]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: SizeConfig.adaptHeight(2),
                ),
                Text(
                  product.shortDescription,
                  style: TextStyle(
                    fontSize: SizeConfig.adaptFontSize(4),
                    fontFamily: 'OpenSans',
                    color: const Color(0xff424a56),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: SizeConfig.adaptHeight(2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$ " +
                          determineSalePrice(product.price, product.salePrecent)
                              .toString() +
                          ",-  ",
                      style: TextStyle(
                          fontSize: SizeConfig.adaptFontSize(6),
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    product.salePrecent != 0
                        ? Text(
                            "\$ " + product.price.toString() + ",- ",
                            style: TextStyle(
                                fontSize: SizeConfig.adaptFontSize(5),
                                fontFamily: 'OpenSans',
                                color: Colors.blue[100],
                                decoration: TextDecoration.lineThrough),
                            textAlign: TextAlign.center,
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.adaptHeight(4),
            ),
            Container(
              width: SizeConfig.adaptWidth(90),
              height: SizeConfig.adaptHeight(0.2),
              color: Colors.grey[200],
            ),
            SizedBox(
              height: SizeConfig.adaptHeight(4),
            ),
            Container(
              width: SizeConfig.adaptHeight(53),
              alignment: Alignment.centerLeft,
              child: Text(
                "INFORMATION",
                style: TextStyle(
                    fontSize: SizeConfig.adaptFontSize(6),
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w900,
                    color: Colors.indigo[900]),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: SizeConfig.adaptHeight(4),
            ),
            Container(
              width: SizeConfig.adaptHeight(50),
              alignment: Alignment.bottomLeft,
              child: Text(
                product.details.replaceAll("\\n ", "\n"),
                style: TextStyle(
                  fontSize: SizeConfig.adaptFontSize(4),
                  fontFamily: 'OpenSans',
                  color: const Color(0xff424a56),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: SizeConfig.adaptHeight(4),
            ),
          ],
        ),
      ),
    );
  }

  int determineSalePrice(int price, int salePrecent) {
    return price - ((price * salePrecent) / 100).round();
  }
}
