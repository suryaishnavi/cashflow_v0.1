enum TransactionType { loan, emi }

class CustomTransactionModel {
  final int amount;
  final DateTime date;
  final TransactionType type;

  CustomTransactionModel({
    required this.amount,
    required this.date,
    required this.type,
  });
  bool get isLoan => type == TransactionType.loan;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomTransactionModel &&
        other.amount == amount &&
        other.date == date &&
        other.type == type;
  }

  @override
  int get hashCode => amount.hashCode ^ date.hashCode ^ type.hashCode;
}
