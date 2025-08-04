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
      home: const GroceryListPage(title: 'Grocery Cost Tracker'),
    );
  }
}


class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key, required this.title});
  final String title;

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}


class _GroceryListPageState extends State<GroceryListPage> {
  final List<GroceryItem> _items = [];

  void _addItem(GroceryItem item) {
    setState(() {
      _items.add(item);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  double get _totalCost {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grocery Tracker')),
      body: SafeArea(
        child: Column(
          children: [
            GroceryInputForm(onNewItem: _addItem),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon:const Icon(Icons.delete),
                      onPressed: () => _removeItem(index),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Total: \$${_totalCost.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class GroceryItem {
  String name;
  double price;
  double quantity;

  GroceryItem(this.name, this.price, this.quantity);
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of units';
                }
                final number = double.tryParse(value);
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
                  final quantity = double.parse(_quantityController.text);

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
