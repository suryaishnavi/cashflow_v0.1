import 'package:flutter/foundation.dart';

import '../models/ModelProvider.dart';
import 'custom_transaction_modal.dart';

class ChatModel {
  final Loan loan;
  final List<CustomTransactionModel> transaction;

  ChatModel({
    required this.loan,
    required this.transaction,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatModel &&
      other.loan == loan &&
      listEquals(other.transaction, transaction);
  }

  @override
  int get hashCode => loan.hashCode ^ transaction.hashCode;
}
