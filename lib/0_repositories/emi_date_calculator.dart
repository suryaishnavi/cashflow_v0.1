import '../models/EmiType.dart';

class EmiDateCalculator {
  DateTime getEmiDuration(EmiType emiType) {
    switch (emiType) {
      case EmiType.WEEKLY:
        return DateTime.now().add(const Duration(days: 7));
      case EmiType.DAILY:
        return DateTime.now().add(const Duration(days: 1));
      default:
        return DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
          DateTime.now().day,
        );
    }
  }

  String calculateLoanEndDate({
    required DateTime loanTakenDate,
    required int totalEmis,
    required EmiType emiFrequency,
  }) {
    DateTime dueDate;

    if (emiFrequency == EmiType.DAILY) {
      dueDate = loanTakenDate.add(Duration(days: totalEmis));
    } else if (emiFrequency == EmiType.MONTHLY) {
      dueDate = DateTime(loanTakenDate.year, loanTakenDate.month + totalEmis,
          loanTakenDate.day);
    } else {
      final int daysToAdd = 7 * totalEmis;
      dueDate = loanTakenDate.add(Duration(days: daysToAdd));
    }

    return dueDate.toString().split(' ')[0];
  }
}
