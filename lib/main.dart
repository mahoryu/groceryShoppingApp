import 'package:flutter/material.dart';

void main() {
  runApp(const GroceryApp());
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Cost Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const GroceryHomePage(title: 'Grocery Cost Tracker'),
    );
  }
}

class GroceryHomePage extends StatefulWidget {
  const GroceryHomePage({super.key, required this.title});
  final String title;

  @override
  State<GroceryHomePage> createState() => _GroceryHomePageState();
}

class _GroceryHomePageState extends State<GroceryHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
  List<GroceryItem> items = [];
}

class GroceryItem {
  String name;
  double pricePerUnit;
  int quantity;

  GroceryItem(this.name, this.pricePerUnit, this.quantity);
}

class GroceryInputForm extends StatefulWidget {
  final Function(GroceryItem) onNewItem;

  const GroceryInputForm({
    super.key,
    required this.onNewItem
  });

  @override
  State<GroceryInputForm> createState() => _GroceryInputFormState();
}

class _GroceryInputFormState extends State<GroceryInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an item name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price per Unit',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                final number = double.tryParse(value);
                if (number == null || number < 0) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of units';
                }
                final number = int.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final name = _nameController.text;
                  final price = double.parse(_priceController.text);
                  final quantity = int.parse(_quantityController.text);

                  widget.onNewItem(GroceryItem(name, price, quantity));

                  _nameController.clear();
                  _priceController.clear();
                  _quantityController.clear();
                }
              },
              child: const Text('Add Item'),
            ),
          ]
        ),
      )
    );
    // return Container();
  }
}

class GroceryListPage extends StatefulWidget {
  
}