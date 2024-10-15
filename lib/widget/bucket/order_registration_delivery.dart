import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_and_flutter/widget/menu/dishes.dart';
import 'package:pizza_and_flutter/widget/my_orders/my_orders_main.dart';
import 'package:pizza_and_flutter/widget/my_orders/orders.dart';
import 'package:provider/provider.dart';
import '../my_orders/delivery_orders/delivery_orders.dart'; // Для форматирования времени

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
  TimeOfDay? _selectedPickupTime; // Выбранное время самовывоза
  bool _orderSubmitted = false;

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
      height: 250,
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

  // Содержимое после отправки заказа (галочка и сообщение)
  Widget _buildOrderSuccessContent() {
    return Container(
      height: 800,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 100),
          SizedBox(height: 20),
          Text("Ваш заказ отправлен на оформление", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  // Завершение заказа и обновление состояния
  void _completeOrder(StateSetter modalSetState) {
    // Обновляем состояние для отображения успеха
    setState(() {
      _orderSubmitted = true;
    });

    // Даем небольшую задержку перед закрытием модального окна
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Закрываем модальное окно
    });
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
              // Блок "Адрес доставки"
              Text(
                "Адрес доставки",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Поля для ввода улицы и дома
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _streetController,
                      decoration: InputDecoration(
                        labelText: "Улица",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _houseController,
                      decoration: InputDecoration(
                        labelText: "Дом",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Поля для квартиры, домофона и этажа
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _apartmentController,
                      decoration: InputDecoration(
                        labelText: "Квартира",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _intercomController,
                      decoration: InputDecoration(
                        labelText: "Домофон",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _floorController,
                      decoration: InputDecoration(
                        labelText: "Этаж",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Блок "Время самовывоза"
              Text(
                "Время доставки",
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
              
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Заказ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text("Сумма заказа: ${cart.totalAmount().toString()} р"),
                    Text("Скидка: ${cart.discountPercent}% ${cart.calculatediscountInRublesTotal().toStringAsFixed(2)} р", 
                    style: TextStyle(color: Colors.red)),
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
                    print("Оформить заказ");
                    print(ListOfsDelivOrders);
                    cart.clearCart();
                    _showPaymentOptions(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,// Белый цвет текста
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Небольшое закругление
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Уменьшение размера строки до минимального
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.white), // Иконка корзины
                      SizedBox(width: 8), // Отступ между иконкой и текстом
                      Text("Оформить заказ", style: TextStyle(color: Colors.white),), // Текст кнопки
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

