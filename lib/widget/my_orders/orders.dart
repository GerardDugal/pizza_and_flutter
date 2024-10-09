const String time = "1:30"; // Время, в колторое заказ будет завершен, будет хранить в себе время, когда заказ оказался у пользователя

enum Status {
  taketo,
  inprogress,
  uncompleted,
  completed
}

Map<Status, String> StatusMap =  {
  Status.taketo : "ЗАБРАТЬ К ",
  Status.inprogress : "В РАБОТЕ",
  Status.completed : "ВЫПОЛНЕН В $time",
  Status.uncompleted : "НЕ ВЫПОЛНЕН"
};

abstract class Orders {
  final int price;
  final int number;
  final String date;
  final Status status;
  // late String _timeready; // Время, когда заказ будет готов

  Orders (this.price, this.number, this.date, this.status);

  // set timeready(String value) => _timeready = value; 
}