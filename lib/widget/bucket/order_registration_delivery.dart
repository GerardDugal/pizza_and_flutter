import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/my_orders/my_orders_main.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';
import 'package:provider/provider.dart';
import '../my_orders/delivery_orders/delivery_orders.dart';

class CheckoutScreenDeliv extends StatefulWidget {
  @override
  _CheckoutScreenDelivState createState() => _CheckoutScreenDelivState();
}

class _CheckoutScreenDelivState extends State<CheckoutScreenDeliv> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _intercomController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime? _selectedPickupDate;
  TimeOfDay? _selectedPickupTime;
  bool _orderSubmitted = false;

  @override
  void initState() {
    super.initState();

    // Устанавливаем время доставки на текущие дата и время + 1 час
    DateTime now = DateTime.now().add(Duration(hours: 1));
    _selectedPickupDate = now;
    _selectedPickupTime = TimeOfDay.fromDateTime(now);
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return _orderSubmitted
                ? _buildOrderSuccessContent()
                : _buildPaymentOptionsContent(modalSetState);
          },
        );
      },
    );
  }

  Widget _buildPaymentOptionsContent(StateSetter modalSetState) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Выберите способ оплаты", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListTile(
            title: Text("Картой"),
            leading: Radio(
              value: 'card',
              groupValue: 'payment',
              onChanged: (value) {
                modalSetState(() {
                  _completeOrder(modalSetState);
                });
              },
            ),
          ),
          ListTile(
            title: Text("Наличными"),
            leading: Radio(
              value: 'cash',
              groupValue: 'payment',
              onChanged: (value) {
                modalSetState(() {
                  _completeOrder(modalSetState);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSuccessContent() {
    return Container(
      height: 800,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.red, size: 100),
          SizedBox(height: 20),
          Text("Ваш заказ отправлен на оформление", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  void _completeOrder(StateSetter modalSetState) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    setState(() {
      _orderSubmitted = true;
    });

    final List<CartItem> ListOfDishes = List.from(cart.items);
    ListOfsDelivOrders.add(Deliv(
      number: 1,
      price: cart.calctotalToPay(),
      date: DateFormat('dd.MM.yyyy').format(DateTime.now()),
      status: Status.inprogress,
      count_positions: cart.positionsAmount,
      detailedStatus: DetailedStatus.adopted,
      dishList: ListOfDishes,
    ));

    cart.clearCart();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text("Оформление заказа", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Адрес доставки", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _streetController,
                          decoration: InputDecoration(labelText: "Улица", border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _houseController,
                          decoration: InputDecoration(labelText: "Дом", border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _apartmentController,
                          decoration: InputDecoration(labelText: "Квартира", border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _intercomController,
                          decoration: InputDecoration(labelText: "Домофон", border: OutlineInputBorder()),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _floorController,
                          decoration: InputDecoration(labelText: "Этаж", border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Время доставки", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "${DateFormat('EEE, MMM d').format(_selectedPickupDate!)} ${_selectedPickupTime!.format(context)}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Комментарии", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(labelText: "Комментарий", border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 243, 243, 243),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Заказ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Сумма"),
                      Text("${cart.totalAmount().toString()} ₽", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Скидка -${cart.discountPercent}%", style: TextStyle(color: Colors.red)),
                      Text(" ${cart.calculatediscountInRublesTotal().toStringAsFixed(0)} ₽",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Всего к оплате", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
                      Text("${cart.calctotalToPay().toStringAsFixed(0)} ₽",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.red)),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _showPaymentOptions(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Оформить заказ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
