import 'package:amplify_core/amplify_core.dart';
import 'package:equatable/equatable.dart';

class NewCustomerPrintModel extends Equatable {
  final String bookId;
  final String name;
  final String city;
  final String phone;
  final int tenure;
  final int collectbleAmount;
  final int givenAmount;
  final int interest;
  final TemporalDate date;
  final String? oldBookNumber;
  final int? oldBookAmount;
  const NewCustomerPrintModel({
    required this.name,
    required this.city,
    required this.phone,
    required this.bookId,
    required this.tenure,
    required this.givenAmount,
    required this.collectbleAmount,
    required this.date,
    this.oldBookNumber,
    this.oldBookAmount,
  }) : interest = (collectbleAmount - givenAmount);

  @override
  List<Object?> get props => [
        name,
        city,
        phone,
        bookId,
        tenure,
        givenAmount,
        collectbleAmount,
        date,
        interest,
        oldBookNumber,
        oldBookAmount,
      ];
}
