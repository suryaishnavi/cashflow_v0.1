import '../models/ModelProvider.dart';

class OnCreationCustomerData {
  final String sub;
  final String uId;
  final String name;
  final String phone;
  final String address;
  final String circleID;
  final WeekDay frequency;
  final CityDetails city;
  final String loanIdentity;

  OnCreationCustomerData({
    required this.sub,
    required this.uId,
    required this.frequency,
    required this.name,
    required this.phone,
    required this.address,
    required this.circleID,
    required this.city,
    required this.loanIdentity,
  });
}
