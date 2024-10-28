import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pizza_and_flutter/widget/addresses/addresses.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/menu/dishes_model.dart';
import 'package:pizza_and_flutter/widget/my_orders/my_orders_main.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';
import 'package:pizza_and_flutter/widget/my_orders/pickup_orders/pickup_orders.dart';
import '../my_orders/delivery_orders/delivery_orders.dart'; // Для форматирования времени

class CheckoutScreenPickUp extends StatefulWidget {
  @override
  _CheckoutScreenPickUpState createState() => _CheckoutScreenPickUpState();
}

class _CheckoutScreenPickUpState extends State<CheckoutScreenPickUp> {
  final TextEditingController _commentController = TextEditingController();
  DateTime? _selectedPickupDateTime; // Выбранные дата и время
  String? _selectedAddress;
  bool _orderSubmitted = false;

  // Список доступных времен самовывоза
  List<String> timeSlots = List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');

  // Выбор даты и времени самовывоза
  Future<void> _selectPickupDateTime(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        DateTime tempSelectedDate = DateTime.now();
        String tempSelectedTime = timeSlots[0];

        return Container(
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 15, 15),
                child: Text("ДАТА И ВРЕМЯ ПОЛУЧЕНИЯ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800), ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Выбор даты
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          tempSelectedDate = DateTime.now().add(Duration(days: index));
                        },
                        children: List<Widget>.generate(30, (index) {
                          DateTime date = DateTime.now().add(Duration(days: index));
                          return Center(
                            child: Text(DateFormat('E, MMM d').format(date)),
                          );
                        }),
                      ),
                    ),
                    // Выбор времени
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          tempSelectedTime = timeSlots[index];
                        },
                        children: timeSlots.map((time) => Center(child: Text(time))).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              // Кнопка "Готово"
              Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                child: CupertinoButton(
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _selectedPickupDateTime = DateTime(
                        tempSelectedDate.year,
                        tempSelectedDate.month,
                        tempSelectedDate.day,
                        int.parse(tempSelectedTime.split(":")[0]),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Готово', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Показываем панель выбора оплаты
  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Чтобы нельзя было закрыть свайпом
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return _orderSubmitted
                ? _buildOrderSuccessContent() // Показ галочки и сообщения об успехе
                : _buildPaymentOptionsContent(modalSetState); // Показ вариантов оплаты
          },
        );
      },
    );
  }

  // Содержимое панели с вариантами оплаты
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
                  _completeOrder(modalSetState); // Завершаем заказ при выборе оплаты картой
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
                  _completeOrder(modalSetState); // Завершаем заказ при выборе оплаты наличными
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Содержимое после отправки заказа (галочка и сообщение)
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

  // Завершение заказа и обновление состояния
  void _completeOrder(StateSetter modalSetState) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    setState(() {
      _orderSubmitted = true;
    });

    final List<CartItem> ListOfDishes = List.from(cart.items);
    ListOfPickUpOrders.add(PickUp(
      number: 1,
      price: cart.calctotalToPay(),
      date: DateFormat('dd.MM.yyyy').format(DateTime.now()),
      status: Status.inprogress,
      count_positions: cart.positionsAmount,
      detailedStatus: DetailedStatus.adopted,
      dishList: ListOfDishes,
      pickup_adress: _selectedAddress.toString(),
      pickup_time: _selectedPickupDateTime.toString(),
    ));

    cart.clearCart();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Закрываем модальное окно
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Оформление заказа", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Адрес самовывоза", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: Text("Адрес компании"),
                    value: _selectedAddress,
                    items: listOfAdressesForPickUp
                        .map((addressMap) => addressMap["address"])
                        .toSet()
                        .map((uniqueAddress) {
                      return DropdownMenuItem<String>(
                        value: uniqueAddress,
                        child: Text(uniqueAddress, overflow: TextOverflow.ellipsis, maxLines: 1),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAddress = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Время самовывоза", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectPickupDateTime(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _selectedPickupDateTime == null
                            ? "Выберите дату и время"
                            : DateFormat('E, MMM d, HH:mm').format(_selectedPickupDateTime!),
                        style: TextStyle(fontSize: 16),
                      ),
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
