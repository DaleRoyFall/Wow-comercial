import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_comercial/page/part/painter.dart';

import '../bloc_list/list_cubit.dart';
import '../helper/connection.dart';
import '../helper/size_config.dart';
import '../model/product.dart';
import '../page/product_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _listViewController = ScrollController();
  ListCubit _listCubit;

  @override
  void initState() {
    super.initState();

    _listViewController.addListener(_listViewScrollListener);

    _onInitListCheck();
  }

  void _onInitListCheck() async {
    if (await verifyConection() == false) {
      buildLostConnectionSnackBar(context);
      _listCubit.setStatus(ListStatus.failure);
      _getProductsDelayed();
    }
  }

  void _getProductsDelayed() async {
    bool connectionValidator = await verifyConection();

    while (connectionValidator == false) {
      await Future.delayed(const Duration(milliseconds: 5000), () async {
        connectionValidator = await verifyConection();
        if (connectionValidator) {
          _listCubit.fetchList();
        }
      });
    }

    Scaffold.of(context)..hideCurrentSnackBar();
  }

  void _listViewScrollListener() async {
    // Reach the bottom
    final maxScroll = _listViewController.position.maxScrollExtent;
    final currentScroll = _listViewController.position.pixels;
    if (maxScroll - currentScroll <= 0) {
      if (await verifyConection() == false) {
        buildLostConnectionSnackBar(context);
        _getProductsDelayed();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit, ListState>(builder: (context, state) {
      _listCubit = BlocProvider.of<ListCubit>(context);
      return buildScaffold(context, state);
    });
  }

  Widget buildScaffold(BuildContext context, ListState state) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: buildAppBar(state),
      body: state.status == ListStatus.failure
          ? const Center(child: Text('Something went wrong!'))
          : state.status == ListStatus.success
              ? buildListWithProducts(context, state)
              : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildAppBar(ListState state) {
    return PreferredSize(
        preferredSize: Size(
          SizeConfig.screenWidth,
          SizeConfig.screenHeight * .09,
        ),
        child: AppBar(
          leading: Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              onPressed: () => {},
              icon: Image.asset(
                "assets/images/profile_icon.png",
              ),
            ),
          ),
          title: Image.asset("assets/images/wow_logo.png",
              width: SizeConfig.adaptWidth(24),
              height: SizeConfig.adaptHeight(20)),
          centerTitle: true,
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20),
              onPressed: () => {
                context.read<ListCubit>().setFavoritePage(!state.favorite),
              },
              icon: state.favorite
                  ? Image.asset(
                      "assets/images/favorite.png",
                      color: Colors.red,
                    )
                  : Image.asset(
                      "assets/images/favorite_border.png",
                      color: Colors.white,
                    ),
            ),
          ],
          backgroundColor: Colors.indigo[900],
        ));
  }

  Widget buildListWithProducts(BuildContext context, ListState state) {
    List<Product> productsToDisplay = getProductsToDisplay(state);

    if (productsToDisplay.length == 0) {
      return Center(child: Text("No favorite products"));
    } else {
      return ListView.builder(
        controller: _listViewController,
        itemCount: productsToDisplay.length,
        itemBuilder: (context, index) {
          return buildListItemTile(productsToDisplay[index], state,
              productsToDisplay.length - 1 == index);
        },
      );
    }
  }

  List<Product> getProductsToDisplay(ListState state) {
    if (state.favorite) {
      return state.products
          .where((product) => product.favorite == true)
          .toList();
    } else {
      return state.products;
    }
  }

  Widget buildListItemTile(Product product, ListState state, bool isLastItem) {
    Image image = Image.network(
      product.image,
    );
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image.resolve(new ImageConfiguration()).addListener(
        ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(info.image)));

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: SizeConfig.adaptHeight(8),
          ),
          GestureDetector(
              onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return BlocProvider.value(
                        value: _listCubit,
                        child: ProductPage(
                          product: product,
                          productImage: image,
                        ),
                      );
                    }))
                  },
              child: Column(
                children: [
                  FutureBuilder<ui.Image>(
                    future: completer.future,
                    builder: (BuildContext context,
                        AsyncSnapshot<ui.Image> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                            child: Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: image,
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
                            ]));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.adaptHeight(6),
                  ),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: SizeConfig.adaptFontSize(6),
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w900,
                      color: Colors.indigo[900],
                    ),
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
                            _determineSalePrice(
                                    product.price, product.salePrecent)
                                .toString() +
                            ",-  ",
                        style: TextStyle(
                            fontSize: SizeConfig.adaptFontSize(5),
                            fontFamily: 'OpenSans',
                            color: Colors.blue[800],
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      product.salePrecent != 0
                          ? Text(
                              "\$ " + product.price.toString() + ",- ",
                              style: TextStyle(
                                  fontSize: SizeConfig.adaptFontSize(4),
                                  fontFamily: 'OpenSans',
                                  color: const Color(0xff9cb1bc),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.lineThrough),
                              textAlign: TextAlign.center,
                            )
                          : Container()
                    ],
                  ),
                ],
              )),
          SizedBox(
            height: SizeConfig.adaptHeight(2),
          ),
          !isLastItem
              ? Container(
                  width: SizeConfig.adaptWidth(90),
                  height: SizeConfig.adaptHeight(0.2),
                  color: Colors.grey[200],
                )
              : Container(),
          SizedBox(
            height: SizeConfig.adaptHeight(2),
          )
        ],
      ),
    );
  }

  int _determineSalePrice(int price, int salePrecent) {
    return price - ((price * salePrecent) / 100).round();
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }
}
