import '../models/Customer.dart';

class CustomerForExtraEmi {
  Customer? customer;
  set setCustomer(Customer? customer) {
    this.customer = customer;
  }

  Customer? get getCustomer => customer;
}
