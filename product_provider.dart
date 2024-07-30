import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:muhmad_omar_haj_hmdo/constants.dart';
import 'package:muhmad_omar_haj_hmdo/product_model.dart';
import 'package:http/http.dart' as http;


// this example for products
//  {
//     "id": 1,
//     "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
//     "price": 109.95,
//     "description": "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
//     "category": "men's clothing",
//     "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
//     "rating": {
//       "rate": 3.9,
//       "count": 120
//     }
//   },

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    String apiLink = API_LINK;

    try {
      print("-------------111----------------------------------");
      final response = await http.get(Uri.parse(apiLink));
      print("-------------2222----------------------------------");
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _products = data.map((json) => Product.fromJson(json)).toList();
        print(_products);
        notifyListeners();
      } else {
        throw Exception("حدث خطأ أثناء تحميل المنتجات");
      }
    } on Exception catch (e) {
      print(e);
      _products = [];
      notifyListeners();
    }
  }
}