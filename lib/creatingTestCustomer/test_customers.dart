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
  List<CityDetails> cities = [
    CityDetails(
        id: "5274054e-ac08-442f-961a-f05be7c9f219",
        name: "Tirupati",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "6b025770-2e3f-406d-9761-c5047c4b5e7b",
        name: "Tirupati",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "c4107331-3fe7-4613-950f-879ec133fd4e",
        name: "Chittoor",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "371e4b6b-ec7d-4c3b-ae68-a78ed79b5be2",
        name: "Madanapalle",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "0619cdae-67bd-42ee-b00c-c8a5aae26886",
        name: "Puttur",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "4f480d94-b286-45f3-8092-14ba0216a0c2",
        name: "Nagari",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "bf8cdd4b-192f-4e42-9d5f-612ceabe861f",
        name: "Punganur",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "892f9064-d400-4d95-a1bd-83ed655b476d",
        name: "Srikalahasti",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "eca76b07-622b-4591-9afe-8610fa99ac6a",
        name: "Renigunta",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "aecbc892-3b76-4488-bf2f-798b0ca4d6c8",
        name: "Kuppam",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "77a1f199-8df2-4932-a940-2c5c12f072a2",
        name: "Palamaner",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "c9e330ee-dd49-4833-90c0-3d68e7ccf39a",
        name: "Kanipakam",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "26b8ca9d-efba-4362-9bc0-b6d109bb3c84",
        name: "Tirumala",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "4928ca4e-0a71-4bc2-a32c-d57b7ec89964",
        name: "Pileru",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "9c8d182e-96c2-4a59-87b6-e9be4a0b2576",
        name: "Narayanavanam",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "3575fb96-d67f-4625-aab2-44b8a2e884c4",
        name: "Vayalpad",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "087fdbba-2b57-4b16-82ab-84a7084e418e",
        name: "Nagapattinam",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "f6bae9a5-7302-4843-93d5-5aa0eb3fc144",
        name: "K.V. B. Puram",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "35493761-680a-4a16-ad60-8bfad02e7599",
        name: "Shantipuram",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "4fbe9825-e3d8-472e-a9c4-b1bbf64618bd",
        name: "Thamballapalle",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744"),
    CityDetails(
        id: "f25737a9-c16e-46c2-be51-4b7bd010b85a",
        name: "Puthalapattu",
        circleID: "aef98c1a-a6f0-4c92-a279-947136df3744")
  ];

  static final Random _random = Random();
  CityDetails getRandomCity() {
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
