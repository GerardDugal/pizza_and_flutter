import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/my_orders/my_orders_main.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';
import 'package:pizza_and_flutter/widget/my_orders/pickup_orders/pickup_orders.dart';
import 'package:provider/provider.dart';

import '../my_orders/delivery_orders/delivery_orders.dart'; // Для форматирования времени

class CheckoutScreenPickUp extends StatefulWidget {
  @override
  _CheckoutScreenPickUpState createState() => _CheckoutScreenPickUpState();
}

class _CheckoutScreenPickUpState extends State<CheckoutScreenPickUp> {
  String? _selectedAddress; // Выбранный адрес самовывоза
  TimeOfDay? _selectedPickupTime; // Выбранное время самовывоза
  final TextEditingController _commentController = TextEditingController();
  final List<String> _addresses = ['Адрес 1', 'Адрес 2', 'Адрес 3']; // Список адресов

  

  @override
  void initState() {
    super.initState();
  }

  

  // Выбор времени самовывоза
  Future<void> _selectPickupTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedPickupTime) {
      setState(() {
        _selectedPickupTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Оформление заказа"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Блок "Адрес самовывоза"
              Text(
                "Адрес самовывоза",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Адрес компании",
                  border: OutlineInputBorder(),
                ),
                value: _selectedAddress,
                items: _addresses.map((String address) {
                  return DropdownMenuItem<String>(
                    value: address,
                    child: Text(address),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAddress = newValue;
                  });
                },
              ),
              SizedBox(height: 20),

              // Блок "Время самовывоза"
              Text(
                "Время самовывоза",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectPickupTime(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    _selectedPickupTime == null
                        ? "Выберите время"
                        : DateFormat('HH:mm').format(
                            DateTime(
                              0,
                              0,
                              0,
                              _selectedPickupTime!.hour,
                              _selectedPickupTime!.minute,
                            ),
                          ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Блок "Комментарии"
              Text(
                "Комментарии",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: "Комментарий",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),

              // Блок "Заказ"
              Text(
                "Заказ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Сумма заказа: ${cart.totalAmount().toString()} р"),
                    Text("Скидка: ${cart.discountPercent}% (${cart.calculatediscountInRublesTotal().toStringAsFixed(2)} р)"),
                    SizedBox(height: 10),
                    Text(
                      "Всего к оплате: ${cart.calctotalToPay().toStringAsFixed(2)} р",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Кнопка "Оформить заказ"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ListOfsDelivOrders.add(PickUp(number: 1,
                    price: cart.calctotalToPay(),
                    date: DateFormat('dd.MM.yyyy').format(DateTime.now()),
                    status: Status.inprogress,
                    count_positions: cart.positionsAmount,
                    detailedStatus: DetailedStatus.adopted,
                    dishList: cart.items,
                    pickup_adress: _selectedAddress.toString(),
                    pickup_time: _selectedPickupTime.toString(),));
                    print("Оформить заказ");
                  },
                  child: Text("Оформить заказ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
