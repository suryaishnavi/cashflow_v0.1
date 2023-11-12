import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';

class NewEmiPrintModel extends Equatable {
  final String bookId;
  final String name;
  final int emiAmount;
  final TemporalDate date;
  const NewEmiPrintModel({
    required this.bookId,
    required this.name,
    required this.emiAmount,
    required this.date,
  });
  @override
  List<Object?> get props => [
        bookId,
        name,
        emiAmount,
      ];
}
