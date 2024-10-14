import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:provider/provider.dart';

class DishDetailScreen extends StatefulWidget {
  final String dishName;
  final String description;
  final String imageUrl;
  final int basePrice;
  final int weight;
  final List<Map<String, int>> fillings; // Наполнения с ценой
  final List<Map<String, int>> additionalFillings; // Дополнительные наполнения с ценой

  DishDetailScreen({
    required this.dishName,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.weight,
    required this.fillings,
    required this.additionalFillings,
  });

  @override
  _DishDetailScreenState createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  String? selectedFilling; // Выбранное наполнение
  List<String> selectedAdditionalFillings = []; // Выбранные дополнительные наполнения
  int quantity = 1;

  int calculateTotalPrice() {
    int totalPrice = widget.basePrice;

    // Добавляем цену выбранного наполнения
    if (selectedFilling != null) {
      totalPrice += widget.fillings.firstWhere((filling) => filling.keys.first == selectedFilling!).values.first;
    }

    // Добавляем цену всех выбранных дополнительных наполнений
    for (String additional in selectedAdditionalFillings) {
      totalPrice += widget.additionalFillings.firstWhere((filling) => filling.keys.first == additional).values.first;
    }

    return totalPrice * quantity;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dishName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Картинка блюда
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Название блюда
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.dishName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Описание
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),

            // Дополнительные начинки
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Дополнительные начинки",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Единичный выбор наполнения
            Column(
              children: widget.fillings.map((filling) {
                String fillingName = filling.keys.first;
                int price = filling.values.first;
                return RadioListTile<String>(
                  title: Text("$fillingName (+$price р)"),
                  value: fillingName,
                  groupValue: selectedFilling,
                  onChanged: (String? value) {
                    setState(() {
                      selectedFilling = value;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Выбор дополнительных наполнений
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Выберите ещё",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Column(
              children: widget.additionalFillings.map((additional) {
                String fillingName = additional.keys.first;
                int price = additional.values.first;
                return CheckboxListTile(
                  title: Text("$fillingName (+$price р)"),
                  value: selectedAdditionalFillings.contains(fillingName),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        selectedAdditionalFillings.add(fillingName);
                      } else {
                        selectedAdditionalFillings.remove(fillingName);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),

      // Bottom App Bar
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Количество товара
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text(quantity.toString(), style: TextStyle(fontSize: 20)),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),

              // Стоимость и вес
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${widget.weight} г", style: TextStyle(fontSize: 16)),
                  Text("${calculateTotalPrice()} р", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),

              // Кнопка "Добавить"
              ElevatedButton(
                onPressed: () {
                  cart.addItem(widget.dishName, calculateTotalPrice(), widget.weight, widget.imageUrl);
                  Navigator.pop(context);
                },
                child: Text("Добавить"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
