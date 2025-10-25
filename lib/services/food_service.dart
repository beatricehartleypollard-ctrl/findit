import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodService {
  static Future<Map<String, dynamic>?> getProduct(String barcode) async {
    final url = Uri.parse("https://world.openfoodfacts.org/api/v0/product/$barcode.json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == 1) {
        return data["product"];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}