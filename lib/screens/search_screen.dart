import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../main.dart';

class SearchScreen extends StatefulWidget {
  final AppState appState;
  const SearchScreen({super.key, required this.appState});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  Map<String, dynamic>? _productData;
  bool _isLoading = false;
  String? _error;
  bool _isScanning = false;

  Future<void> _searchProduct() async {
    final barcode = _barcodeController.text.trim();
    if (barcode.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _productData = null;
    });

    try {
      final url = Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['product'] != null) {
          setState(() => _productData = data['product']);
        } else {
          setState(() => _error = 'Product not found.');
        }
      } else {
        setState(() => _error = 'Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _startScanner() {
    setState(() => _isScanning = true);
  }

  void _stopScanner() {
    setState(() => _isScanning = false);
  }

  Widget _buildProductDetails(Map<String, dynamic> product) {
    String name = product['product_name'] ?? 'Unknown';
    String brand = product['brands'] ?? 'Unknown';
    String allergens = product['allergens_tags']?.join(', ') ?? 'None';
    String ingredients = product['ingredients_text'] ?? 'No ingredient info available';
    String imageUrl = product['image_url'] ?? '';
    String categories = product['categories_tags']?.join(', ') ?? 'Unspecified';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFF9fc7aa),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageUrl, height: 180, fit: BoxFit.contain),
            ),
          const SizedBox(height: 20),
          Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Brand', brand),
                  _infoRow('Categories', categories),
                  _infoRow('Allergens', allergens),
                  const SizedBox(height: 10),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(ingredients),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.appState;

    if (_isScanning) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Barcode'),
          backgroundColor: const Color(0xFF9fc7aa),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _stopScanner,
            )
          ],
        ),
        body: MobileScanner(
          onDetect: (barcodeCapture) {
            final String? code = barcodeCapture.barcodes.first.rawValue;
            if (code != null) {
              setState(() {
                _barcodeController.text = code;
                _isScanning = false;
              });
              _searchProduct();
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(app.t('search')),
        backgroundColor: const Color(0xFF9fc7aa),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: app.t('enter_barcode'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchProduct,
                ),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _searchProduct(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _startScanner,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Scan Barcode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9fc7aa),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xFF9fc7aa))),
            if (_error != null)
              Text(_error!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            if (_productData != null)
              Expanded(child: _buildProductDetails(_productData!)),
          ],
        ),
      ),
    );
  }
}
