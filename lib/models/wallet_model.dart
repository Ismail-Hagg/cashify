class Wallet {
  String name;
  double amount;
  String currency;
  Wallet({required this.name, required this.amount, required this.currency});

  toMap() {
    return <String, dynamic>{
      'name': name,
      'amount': amount,
      'currency': currency
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
        name: map['name'], amount: map['amount'], currency: map['currency']);
  }
}
