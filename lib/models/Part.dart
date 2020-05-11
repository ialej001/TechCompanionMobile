class Part {
  int id;
  String partNumber;
  String description;
  String name;
  double price;
  int quantity;

  Part({this.partNumber, this.description, this.price, this.quantity});

  factory Part.fromMap(Map<String, dynamic> json) => new Part(
      partNumber: json["partNumber"],
      description: json["description"],
      price: json["price"],
      quantity: json["quantity"]);

  Map<String, dynamic> toMap() => {
        "partNumber": partNumber,
        "description": description,
        "price": price,
        "quantity": quantity
      };
}
