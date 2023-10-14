import 'package:get_it/get_it.dart';

import 'emi_date_calculator.dart';

final GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  getIt.registerSingleton<EmiDateCalculator>(EmiDateCalculator());
}
