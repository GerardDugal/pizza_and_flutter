import 'package:flutter/material.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:provider/provider.dart';

class DishDetailScreen extends StatefulWidget {
  final String dishName;
  final String description;
  final String image;
  final int basePrice;
  final String weight;
  final List<Map<String, int>> fillings; // Наполнения с ценой
  final List<Map<String, int>> additionalFillings; // Дополнительные наполнения с ценой

  DishDetailScreen({
    required this.dishName,
    required this.description,
    required this.image,
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
  void initState() {
    super.initState();
    if (widget.fillings.isNotEmpty) {
      selectedFilling = widget.fillings.first.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(widget.image),
                // Кнопка возврата
                Positioned(
                  top: 50.0, // Отступ сверху
                  left: 16.0, // Отступ слева
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 0, 0, 0)), // Иконка назад
                    onPressed: () {
                      Navigator.pop(context); // Возвращает на предыдущий экран
                    },
                    // Оформление кнопки
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.white, // Белый фон кнопки
                    ),
                  ),
                ),
              ],
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
                   fillColor: WidgetStateProperty.resolveWith((states) {
                    if (!states.contains(WidgetState.selected)) {
                      return Colors.grey;
                    }
                    return null;
                  }),
                  activeColor: Colors.red,
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
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.red,
                  value: selectedAdditionalFillings.contains(fillingName),
                  title: Text("$fillingName (+$price р)"),
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
        height: 170,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Первая строка: Название, вес, цена
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 170,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      widget.dishName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Text(
                    "${widget.weight} г",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(width: 50),
                  Text(
                    "${calculateTotalPrice()} р",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Вторая строка: Выбранные дополнения
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${selectedFilling} ${selectedAdditionalFillings.join(", ")}",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Третья строка: Количество и кнопка "Добавить"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Количество товара (+ и - кнопки)
                  Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () {
                                cart.minusItem(widget.dishName);
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                        icon: Icon(
                          Icons.remove,
                          color: quantity > 1 ? Colors.black : Colors.grey,
                        ),
                      ),
                      Text(quantity.toString(), style: TextStyle(fontSize: 20)),
                      IconButton(
                        onPressed: quantity == 1 ? () {
                          cart.addItem(
                        widget.dishName,
                        calculateTotalPrice(),
                        widget.weight,
                        widget.image,
                        widget.description,
                        selectedFilling!,
                        selectedAdditionalFillings,
                      );
                          setState(() {
                            quantity++;
                          });
                        } : 
                        () {
                          cart.plusItem(widget.dishName);
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  // Кнопка "Добавить"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Более квадратная форма
                      ),
                    ),
                    onPressed: () {
                      cart.addItem(
                        widget.dishName,
                        calculateTotalPrice(),
                        widget.weight,
                        widget.image,
                        widget.description,
                        selectedFilling!,
                        selectedAdditionalFillings,
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Добавить",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
