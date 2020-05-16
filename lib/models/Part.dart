

class Part {
  int id;
  String partNumber;
  String description;
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

  factory Part.fromJson(Map<String, dynamic> json) {
    return new Part(
        description: json['description'],
        partNumber: json['partNumber'],
        price: json['price'],
        quantity: getQuantity(json['quantity']));
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'partNumber': partNumber,
    'price': price,
    'quantity': quantity
  };
}

int getQuantity(dynamic json) {
  if (json == null) {
    return 0;
  }

  return json;
}
