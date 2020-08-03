import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Coin extends Equatable {
  final String name;
  final String fullName;
  final double price;

  const Coin({@required this.name,
  @required this.fullName, 
  @required this.price});

  @override
  List<Object> get props => [price, fullName, name];



  @override
  String toString() {
    return "$name $price $fullName";
  }


  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      fullName: json["CoinInfo"]["Name"] as String,
      name: json["CoinInfo"]["fullName"] as String,
       price: (json["RAW"]["USD"]["PRICE"] as num).toDouble()
    );
  }
}
