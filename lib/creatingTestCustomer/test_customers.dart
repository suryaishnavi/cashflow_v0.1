import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cashflow/0_repositories/customers_and_loan_data_repository.dart';
import 'dart:math';

import '../0_repositories/city_repository.dart';
import '../models/ModelProvider.dart';

class GetCity {
  static final List<String> _names = [
    'Talakona',
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
  // List<City> cities = [];
  List<City> cities = [
    City(
        id: "34c8dec4-9d26-4ec7-b06a-403537f11c00",
        name: "Tirupati",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "cb567c56-8721-43c9-9409-acd184bd397f",
        name: "Talakona",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "30b6681f-d0e1-42d3-9d6d-686bec729ed1",
        name: "Chittoor",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "36358d9f-063b-415f-9b1c-10acf53044f5",
        name: "Madanapalle",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "3e27885f-afb2-4214-b496-9032e7096177",
        name: "Puttur",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "e90d85ed-166e-4c74-aa83-c0af9ea5ea31",
        name: "Nagari",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "40fecba6-4bad-4e60-a082-729ae074dc1f",
        name: "Punganur",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "c295418c-5447-493d-b2fc-0a6e5f66cfd0",
        name: "Srikalahasti",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "d9551f0f-1d32-4465-9884-8355a455d327",
        name: "Renigunta",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "b579e30f-f028-4fba-abaa-ca347743e9da",
        name: "Kuppam",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "031bed85-2568-4f79-9ca6-9b2f2dfd3eff",
        name: "Palamaner",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "33d1f593-4811-4774-a594-57ba1860c9eb",
        name: "Kanipakam",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "1a42fed1-1e10-4f36-82a9-b8e0bdbcd723",
        name: "Tirumala",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "313f42d0-0aa3-4817-9fa3-e49ebf0ec842",
        name: "Pileru",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "3425436f-0a08-4dd3-8b0b-41abab24dc81",
        name: "Narayanavanam",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "d3455d00-a2fd-48ba-9a94-273a38e9ab45",
        name: "Vayalpad",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "36464783-94d0-4b30-9964-e09abde65c1a",
        name: "Nagapattinam",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "aca97821-34a4-48dd-8414-0ab418893d20",
        name: "K.V. B. Puram",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "969563f5-a378-40c7-8062-56eb6d7ac491",
        name: "Shantipuram",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "0cb8942e-cc80-47ee-a60d-b1ff178283fd",
        name: "Thamballapalle",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153"),
    City(
        id: "dae273e8-91b7-45de-9d1a-a5fc4a5f8989",
        name: "Puthalapattu",
        circleID: "037b860f-c574-4d9c-aa90-2eb6756a4153")
  ];
  static final Random _random = Random();

  City getRandomCity() {
    final randomIndex = _random.nextInt(cities.length);
    return cities[randomIndex];
  }
}

class TestCustomers {
  CustomerAndLoanDataRepository customerAndLoanDataRepository =
      CustomerAndLoanDataRepository();
  // final String sub = '11830dfa-6021-7040-3211-405b458b4f9f'; // raisingStar
  final String sub = 'd1afb895-274a-4ed5-95ef-c5c3ab9f9be4'; // arr9182
  final String circleId = '037b860f-c574-4d9c-aa90-2eb6756a4153';
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
  int currentSerialNumber = 1114;
  String fourDigitSequencialNumber() {
    currentSerialNumber = currentSerialNumber + 1;
    return currentSerialNumber.toString();
  }
  // return new CityDetails every time

  Future<bool> createTestCustomer(index) async {
    // *on submission first try to save Customer
    final customer = await customerAndLoanDataRepository.createCustomer(
      appUser: sub,
      circleID: circleId,
      date: date,
      address: 'Test address $index',
      uId: generateUniqueRandomNumber(),
      mobileNumber: generateRandomPhoneNumber(),
      name: NameGenerator.getRandomName(),
      city: CityDetailsProvider().getRandomCity(),
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
    for (int i = 0; i < 100; i++) {
      bool result = await createTestCustomer(i);
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
        circleID: '037b860f-c574-4d9c-aa90-2eb6756a4153',
      );
    }
  }
}
