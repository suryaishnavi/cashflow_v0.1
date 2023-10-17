import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cashflow/0_repositories/customers_and_loan_data_repository.dart';
import 'dart:math';

import '../0_repositories/city_repository.dart';
import '../models/ModelProvider.dart';

class GetCity {
  static final List<String> _names = [
    'Tirupati',
    'Chittoor',
    'Madanapalle',
    'Puttur',
    'Nagari',
    'Punganur',
    'Srikalahasti',
    'Renigunta',
    'Kuppam',
    'Palamaner',
    'Kanipakam',
    'Tirumala',
    'Pileru',
    'Narayanavanam',
    'Vayalpad',
    'Nagapattinam',
    'K.V. B. Puram',
    'Shantipuram',
    'Thamballapalle',
    'Puthalapattu'
  ];
  // int index = -1;
  // String getRandomCity() {
  //   index++;
  //   return _names[index];
  // }
}

class NameGenerator {
  static final List<String> _firstNames = [
    'Sandeep',
    'Shalini',
    'Arun',
    'Deepak',
    'Divya',
    'Harish',
    'Jyoti',
    'Kiran',
    'Madhavi',
    'Nikhil',
    'Pooja',
    'Rajesh',
    'Shruti',
    'Suresh',
    'Swati',
    'Varun',
    'Vidya',
    'Asha',
    'Karthik',
    'Rahul',
    'Rekha',
    'Vijaya',
    'Vishal',
    'Nandini',
    'Rohit',
  ];

  static final List<String> _lastNames = [
    'Choudhary',
    'Gowda',
    'Joshi',
    'Kumar',
    'Mishra',
    'Nair',
    'Patel',
    'Rajput',
    'Seth',
    'Sharma',
    'Singh',
    'Verma',
    'Yadav',
    'Reddy',
    'Gupta',
    'Rao',
    'Malhotra',
    'Shah',
    'Chopra',
    'Mehta',
    'Agarwal',
    'Gandhi',
    'Bhat',
    'Mukherjee',
    'Thakur',
  ];

// You can add more first and last names as needed.

  static final Random _random = Random();

  static String getRandomName() {
    final firstName = _firstNames[_random.nextInt(_firstNames.length)];
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    return '$firstName $lastName';
  }
}

class CityDetailsProvider {
  // List<CityDetails> cities = [];
  List<City> cities = [];

  static final Random _random = Random();
  City getRandomCity() {
    final cityName = cities[_random.nextInt(cities.length)];
    return cityName;
  }
}

class TestCustomers {
  CustomerAndLoanDataRepository customerAndLoanDataRepository =
      CustomerAndLoanDataRepository();
  // final String sub = '11830dfa-6021-7040-3211-405b458b4f9f'; // raisingStar
  final String sub = 'd1afb895-274a-4ed5-95ef-c5c3ab9f9be4'; // arr9182
  final String circleId = 'aef98c1a-a6f0-4c92-a279-947136df3744';
  final String date = DateTime.now().toString().split(' ')[0];
  String generateUniqueRandomNumber() {
    Random random = Random();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int randomPart =
        random.nextInt(1000000); // You can adjust this range as needed

    String uniqueNumber = '$timestamp$randomPart';

    if (uniqueNumber.length > 12) {
      uniqueNumber =
          uniqueNumber.substring(0, 12); // Trim if length exceeds 12 digits
    } else if (uniqueNumber.length < 12) {
      int zerosToAdd = 12 - uniqueNumber.length;
      String zeros = '0' * zerosToAdd;
      uniqueNumber =
          '$zeros$uniqueNumber'; // Add leading zeros if length is less than 12
    }

    return uniqueNumber;
  }

  String generateRandomPhoneNumber() {
    Random random = Random();

    // Generate the first digit (country code) and ensure it starts with 7, 8, or 9
    int countryCode = 7 + random.nextInt(3);

    // Generate the remaining 9 digits
    int remainingDigits = 100000000 + random.nextInt(900000000);

    // Combine the country code and remaining digits
    String phoneNumber = countryCode.toString() + remainingDigits.toString();

    return phoneNumber;
  }

// creating 4 digit sequential number
  int currentSerialNumber = 1000;
  String fourDigitSequencialNumber() {
    currentSerialNumber = currentSerialNumber + 1;
    return currentSerialNumber.toString();
  }
  // return new CityDetails every time

  Future<bool> createTestCustomer() async {
    // *on submission first try to save Customer
    final customer = await customerAndLoanDataRepository.createCustomer(
      appUser: sub,
      uId: generateUniqueRandomNumber(),
      name: NameGenerator.getRandomName(),
      mobileNumber: generateRandomPhoneNumber(),
      address: 'test address',
      city: CityDetailsProvider().getRandomCity(),
      date: date,
      circleID: circleId,
      loanIdentity: fourDigitSequencialNumber(),
    );

    // *on success of save customer then save loan
    final loan = await customerAndLoanDataRepository.createNewLoan(
      appUser: sub,
      totalLoanAmount: 9800,
      loanEmiAmount: 1000,
      loanTotalEmis: 12,
      loanIssuedDate: date,
      customer: customer,
      emiType: EmiType.WEEKLY,
      isAddtionalLoan: false,
      isNewLoan: true,
      paidEmis: 0,
      loanIdentity: currentSerialNumber.toString(),
    );

    const paidEmis = '0';

    // *on success of save loan then save emi
    bool result = paidEmis.isEmpty || int.parse(paidEmis) == 0
        ? true
        : await customerAndLoanDataRepository.createEmis(
            appUser: sub,
            loanID: loan.id,
            singleEmiAmount: 1000,
            totalEmis: 12,
            loanTakenDate: loan.dateOfCreation.getDateTime(),
            customer: customer,
            loan: loan,
            emiFrequency: WeekDay.MONDAY,
            paidEmis: 0,
            isAddtionalLoan: false,
            loanIdentity: currentSerialNumber.toString(),
          );
    return result;
  }

  Future<void> runTestCustomers() async {
    int successfulCreations = 0;
    for (int i = 0; i < 200; i++) {
      bool result = await createTestCustomer();
      if (result) {
        successfulCreations++;
        safePrint('*** Successfully created customer $i ***');
      } else {
        safePrint('*** Failed to create customer $i ***');
      }
    }
    safePrint(
        '**** Successfully created $successfulCreations customers out of 100 ****');
  }

  // create 20 new cities in a circle

  Future<void> createTestCities() async {
    final cityRepository = CityRepository();
    for (int i = 0; i < 20; i++) {
      await cityRepository.addNewCity(
        name: GetCity._names[i],
        circleID: 'aef98c1a-a6f0-4c92-a279-947136df3744',
      );
    }
  }
}
