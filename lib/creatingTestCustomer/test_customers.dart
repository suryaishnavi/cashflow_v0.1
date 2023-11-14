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
    'సందీప్',
    'శాలిని',
    'అరుణ్',
    'దీపక్',
    'దివ్య',
    'హరీష్',
    'జ్యోతి',
    'కిరణ్',
    'మాధవి',
    'నిఖిల్',
    'పూజ',
    'రాజేష్',
    'శ్రుతి',
    'సురేష్',
    'స్వాతి',
    'వరుణ్',
    'విద్య',
    'ఆశ',
    'కార్తిక్',
    'రాహుల్',
    'రేఖ',
    'విజయ',
    'విషాల్',
    'నందిని',
    'రోహిత్',
  ];

  static final List<String> _lastNames = [
    'చౌధరి',
    'గౌడ',
    'జోషి',
    'కుమార్',
    'మిశ్ర',
    'నాయిర్',
    'పటేల్',
    'రాజ్పుత్',
    'సేత్',
    'శర్మ',
    'సింగ్',
    'వెర్మా',
    'యాదవ్',
    'రెడ్డి',
    'గుప్త',
    'రావు',
    'మల్హోత్ర',
    'షా',
    'చోప్రా',
    'మేహతా',
    'అగర్వాల్',
    'గాంధి',
    'భట్',
    'ముఖర్జీ',
    'తాకూర్',
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
        id: "5c1e4c02-b65f-4c59-862f-e0a8f268903c",
        name: "tirupati",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "a4ff3f37-8672-465f-80e5-62a9ae9b4ecc",
        name: "Talakona",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "d9d4b5b0-0237-4129-931d-3307679e5a26",
        name: "Chittoor",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "16b3528b-1005-4c11-87f0-e8ae19b7627f",
        name: "Madanapalle",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "5dd9cfee-cf17-4490-bef8-bd09d7f889b8",
        name: "Puttur",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "7d5511af-4066-46e5-9891-c8a7c6b42d13",
        name: "Nagari",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "28f0ae7f-6605-4a1d-a736-3124edeb2254",
        name: "Punganur",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "175c24c0-460f-4a04-a3e7-e57cd35d807e",
        name: "Srikalahasti",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "0b3b34a0-ad78-48e0-a43a-5952a1e1b2f6",
        name: "Renigunta",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "f66d210c-7129-434d-8f3a-a361a2e762f4",
        name: "Kuppam",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "a9c7779b-3a79-4604-ab6d-759bc6e7256a",
        name: "Palamaner",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "ee48ddd4-d980-4b11-a953-60be48aadebc",
        name: "Kanipakam",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "ad305ef6-d5a1-4d7c-a08d-f45c8f9d79af",
        name: "Tirumala",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "4496a6b5-4f8a-42cb-a7dd-4b9c817b3b3d",
        name: "Pileru",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "eaed70e6-7332-4ce4-b384-831e8594e5f7",
        name: "Narayanavanam",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "d6f5f1bc-cd7f-4293-a335-c83b645a3faa",
        name: "Vayalpad",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "a585364c-3dd3-42cf-b6de-eb1cc3198367",
        name: "Nagapattinam",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "4c9ea943-6fde-42b4-a9e3-f5cfeade481c",
        name: "K.V. B. Puram",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "fdd6fd32-2db8-41c9-a80d-4b911c11d969",
        name: "Shantipuram",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "878fa170-d307-4e56-8eaa-7eb2331b89b9",
        name: "Thamballapalle",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f"),
    City(
        id: "bc6c4bbe-9a89-42d7-b262-40d8412f3b0e",
        name: "Puthalapattu",
        circleID: "2263ba92-73d7-4c78-9030-86f36ece811f")
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
  final String sub = '11830dfa-6021-7040-3211-405b458b4f9f'; // raisingStar
  // final String sub = 'd1afb895-274a-4ed5-95ef-c5c3ab9f9be4'; // arr9182
  final String circleId = '2263ba92-73d7-4c78-9030-86f36ece811f';
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
  int currentSerialNumber = 7777;
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
      selectedCity: CityDetailsProvider().getRandomCity(),
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
            city: customer.city.name,
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
        circleID: '2263ba92-73d7-4c78-9030-86f36ece811f',
      );
    }
  }
}
