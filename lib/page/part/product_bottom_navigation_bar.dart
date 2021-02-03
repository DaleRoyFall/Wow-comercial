import 'package:flutter/material.dart';
import 'package:wow_comercial/helper/size_config.dart';

class ProductBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.adaptHeight(13),
      child: Row(
        children: [
          SizedBox(
            width: SizeConfig.adaptWidth(7),
          ),
          ButtonTheme(
            minWidth: SizeConfig.adaptWidth(42),
            height: SizeConfig.adaptHeight(8),
            child: RaisedButton(
              onPressed: () => {print("Add to card")},
              textColor: Colors.white,
              color: Colors.indigo[900],
              child: new Text(
                "ADD TO CART",
                style: TextStyle(
                    fontSize: SizeConfig.adaptFontSize(4),
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.adaptWidth(3),
          ),
          ButtonTheme(
            minWidth: SizeConfig.adaptWidth(42),
            height: SizeConfig.adaptHeight(8),
            child: RaisedButton(
              onPressed: () => {print("Buy now")},
              textColor: Colors.white,
              color: Colors.deepPurple,
              // padding: const EdgeInsets.all(8.0),
              child: new Text(
                "BUY NOW",
                style: TextStyle(
                    fontSize: SizeConfig.adaptFontSize(4),
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
