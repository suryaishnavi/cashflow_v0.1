import '../../../models/ModelProvider.dart';

class FromCustomerProfile {
  String? appUserId;
  String? circleId;
  WeekDay? frequency;
  Customer? customer;
  FromCustomerProfile({
    this.appUserId,
    this.circleId,
    this.frequency,
    this.customer,
  });
}
