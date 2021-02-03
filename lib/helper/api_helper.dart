import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:wow_comercial/helper/connection.dart';
import 'package:wow_comercial/model/product.dart';

Future<List<Product>> getProducts(String url, int offset, int limit) async {
  if (await verifyConection()) {
    Map<String, String> params = {
      "offset": "$offset",
      "limit": "$limit",
    };

    String paramsToString = Uri(queryParameters: params).query;

    http.Response response = await http.get(
      url + "?" + paramsToString,
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      return body.map((product) => Product.fromJson(product)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load products');
    }
  }

  return null;
}
