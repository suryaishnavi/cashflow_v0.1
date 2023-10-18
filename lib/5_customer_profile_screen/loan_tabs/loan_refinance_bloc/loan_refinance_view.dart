import 'package:cashflow/0_repositories/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../../../0_repositories/emi_date_calculator.dart';
import '../../../4_customer_screen/loan_creation_bloc/loan_creation_bloc/loan_creation_bloc.dart';
import '../../../widgets/custom_eleveted_button.dart';
import 'bloc/loan_refinance_bloc.dart';

// * Loan Refinance
class LoanRefinanceView extends StatelessWidget {
  const LoanRefinanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[20],
      appBar: AppBar(
        title:
            context.watch<LoanRefinanceBloc>().state is ModifyLoanDetailsState
                ? const Text('Modify Loan Details')
                : const Text('Refinance Loan'),
        centerTitle: true,
        // watch if state is EditLoanDetailsState then show close button else show nothing
        leading: context.watch<LoanRefinanceBloc>().state
                is ModifyLoanDetailsState
            ? IconButton(
                onPressed: () {
                  context.read<LoanRefinanceBloc>().add(CloseLoanEditEvent());
                },
                icon: const Icon(Icons.close, color: Colors.red),
              )
            : null,
      ),
      body: BlocListener<LoanCreationBloc, LoanCreationState>(
        listener: (context, state) {
          if (state is LoanCreationSuccessState) {
            // * if loan creation is success then close the dialog
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<LoanRefinanceBloc, LoanRefinanceState>(
          builder: (context, state) {
            switch (state) {
              case LoanRefinanceInitialState():
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: LoansOverviewScreen(
                    state: state,
                  ),
                );
              case LoanRefinanceLoadingState():
                return const Center(child: CircularProgressIndicator());
              case LoanRefinanceSuccess():
                return const Center(
                    child: Text('Loan Refinanced Successfully'));
              case LoanRefinanceFailure():
                return const Center(child: Text('Loan Refinance Failed'));
              case ModifyLoanDetailsState():
                return const SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: EditNewLoanDetails(),
                );
            }
          },
        ),
      ),
    );
  }
}

class LoansOverviewScreen extends StatelessWidget {
  final LoanRefinanceInitialState state;
  const LoansOverviewScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Old Loan Details :',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.red[900],
                ),
          ),
          const SizedBox(height: 8),
          OldLoanDetails(
            state: state,
          ),
          const SizedBox(height: 24),
          Text(
            'New Loan Details :',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.green[800],
                ),
          ),
          const SizedBox(height: 8),
          NewLoanDetailsOverView(
            state: state,
          ),
          const SizedBox(height: 36),
          // row with two buttons edit and refinance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  context.read<LoanRefinanceBloc>().add(EditLoanDetailsEvent());
                },
                child: const Text(
                  'Edit Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  if (state.newGivenAmount > 0) {
                    context
                        .read<LoanRefinanceBloc>()
                        .add(SubmitLoanRefinancingEvent());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        showCloseIcon: true,
                        content:
                            Text('Refinance is not possible for this loan'),
                      ),
                    );
                  }
                },
                child: const Text('Refinance'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///! Edit New Loan Details
class EditNewLoanDetails extends StatefulWidget {
  const EditNewLoanDetails({super.key});

  @override
  State<EditNewLoanDetails> createState() => _EditNewLoanDetailsState();
}

class _EditNewLoanDetailsState extends State<EditNewLoanDetails> {
  final _formKey = GlobalKey<FormState>();
  final _givenAmountController = TextEditingController();
  final _emiAmountController = TextEditingController();
  final _emiCountController = TextEditingController();
  final _givenDateController = TextEditingController();
  final _loanIdentityController = TextEditingController();
  l10n() => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _givenAmountController.dispose();
    _emiAmountController.dispose();
    _emiCountController.dispose();
    _givenDateController.dispose();
    _loanIdentityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanRefinanceBloc, LoanRefinanceState>(
      builder: (context, state) {
        if (state is ModifyLoanDetailsState) {
          _givenAmountController.text =
              '${state.givenAmount}'.replaceAll(',', '');
          _emiAmountController.text = '${state.emiAmount}'.replaceAll(',', '');
          _emiCountController.text = '${state.emiCount}'.replaceAll(',', '');
          _loanIdentityController.text = state.loanIdentity;
          return _form();
        }
        return const Center(child: Text('Something went wrong'));
      },
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 24.0,
        ),
        child: Column(
          children: [
            _totalGivenAmount(),
            const SizedBox(height: 16.0),
            _emiAmount(),
            const SizedBox(height: 16.0),
            _totalEmis(),
            const SizedBox(height: 16.0),
            _loanIdentity(),
            const SizedBox(height: 16.0),
            _date(),
            const SizedBox(height: 32.0),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  TextStyle getLabelStyle() {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  Widget _totalGivenAmount() {
    return TextFormField(
      controller: _givenAmountController,
      style: getLabelStyle(),
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction(
          (oldValue, newValue) {
            final numericValue = int.tryParse(newValue.text);
            if (numericValue != null) {
              final formatter = intl.NumberFormat.simpleCurrency(
                locale: 'en_IN',
                decimalDigits: 0,
              );
              final newText = formatter
                  .format(numericValue); // Divide by 100 to format as currency
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }
            return newValue;
          },
        ),
      ],
      maxLength: 7,
      decoration: InputDecoration(
        isDense: true,
        icon: const Icon(Icons.currency_rupee),
        hintText: '${l10n().totalGivenAmountField('hint')} (\u20B99,800)',
        labelText: l10n().totalGivenAmountField('label'),
      ),
      validator: (value) {
        final amount =
            int.parse(value!.replaceAll(',', '').replaceAll('₹', ''));
        if (value.isEmpty) {
          return l10n().totalGivenAmountField('error');
        } else if (amount < 100) {
          return l10n().totalGivenAmountField('error2');
        } else {
          return null;
        }
      },
    );
  }

  Widget _emiAmount() {
    return TextFormField(
      controller: _emiAmountController,
      style: getLabelStyle(),
      maxLength: 6,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction(
          (oldValue, newValue) {
            final numericValue = int.tryParse(newValue.text);
            if (numericValue != null) {
              final formatter = intl.NumberFormat.simpleCurrency(
                locale: 'en_IN',
                decimalDigits: 0,
              );
              final newText = formatter.format(numericValue);
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }
            return newValue;
          },
        ),
      ],
      decoration: InputDecoration(
        isDense: true,
        icon: const Icon(Icons.auto_mode),
        hintText: '${l10n().installmentAmountField('hint')} (\u20B91,000)',
        labelText: l10n().installmentAmountField('label'),
      ),
      validator: (value) {
        final amount =
            int.parse(value!.replaceAll(',', '').replaceAll('₹', ''));
        if (value.isEmpty) {
          return l10n().installmentAmountField('error');
        } else if (amount < 50) {
          return l10n().installmentAmountField('error2');
        } else {
          return null;
        }
      },
    );
  }

  Widget _totalEmis() {
    return TextFormField(
      controller: _emiCountController,
      style: getLabelStyle(),
      maxLength: 3,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        isDense: true,
        icon: const Icon(Icons.star),
        hintText: l10n().totalInstallmentsField('hint'),
        labelText: l10n().totalInstallmentsField('label'),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return l10n().totalInstallmentsField('error');
        } else if (int.parse(value) < 1) {
          return l10n().totalInstallmentsField('error2');
        } else if (int.parse(value) > 200) {
          return l10n().totalInstallmentsField('error3');
        } else {
          return null;
        }
      },
    );
  }

  Widget _loanIdentity() {
    return TextFormField(
      controller: _loanIdentityController,
      maxLength: 5,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid loan identity';
        }
        return null;
      },
      decoration: InputDecoration(
        isDense: true,
        icon: const Icon(Icons.menu_book),
        labelText: AppLocalizations.of(context)!.loanIdField('label'),
        hintText: AppLocalizations.of(context)!.loanIdField('hint'),
      ),
    );
  }

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day); // * default date is today

  Widget _date() {
    _givenDateController.text = '$date'.split(' ')[0];
    return TextFormField(
      textInputAction: TextInputAction.done,
      style: getLabelStyle(),
      decoration: InputDecoration(
        isDense: true,
        icon: const Icon(Icons.calendar_today),
        labelText: l10n().loanDate,
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2050),
        );
        if (selectedDate != null) {
          setState(() {
            date = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
            );
            _givenDateController.text = '$selectedDate'.split(' ')[0];
          });
        }
      },
      readOnly: true,
      controller: _givenDateController,
    );
  }

  Widget _submitButton() {
    return BlocBuilder<LoanRefinanceBloc, LoanRefinanceState>(
      builder: (context, state) {
        return state is LoanRefinanceLoadingState
            ? const CircularProgressIndicator()
            : CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final givenAmount = int.parse(
                      _givenAmountController.text
                          .replaceAll(',', '')
                          .replaceAll('₹', ''),
                    );
                    final emiAmount = int.parse(
                      _emiAmountController.text
                          .replaceAll(',', '')
                          .replaceAll('₹', ''),
                    );
                    final emiCount = int.parse(_emiCountController.text);
                    final collectableAmount = (emiAmount * emiCount);
                    if (givenAmount > collectableAmount) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Collectible amount should be greater than given amount',
                          ),
                        ),
                      );
                      return;
                    }
                    context.read<LoanRefinanceBloc>().add(
                          SubmitModifiedLoanEvent(
                            givenAmount: givenAmount,
                            emiAmount: emiAmount,
                            emiCount: emiCount,
                            startDate: date,
                            loanIdentity: _loanIdentityController.text,
                          ),
                        );
                  }
                },
                child: Text(
                  l10n().submit,
                  style: const TextStyle(fontSize: 16.0),
                ),
              );
      },
    );
  }
}

///! New Loan Details Overview
class NewLoanDetailsOverView extends StatelessWidget {
  final LoanRefinanceInitialState state;
  const NewLoanDetailsOverView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // new loan given amount
          NewAmountForRefinance(
            state: state,
          ),
          // A white color divider
          const Divider(
            color: Colors.white,
            height: 48,
            thickness: 1.5,
          ),
          // new loan emi details
          NewEmiDetailsForRefiance(
            state: state,
          ),
          // A white color divider
          const Divider(
            color: Colors.white,
            height: 48,
            thickness: 1.5,
          ),
          // refinace loan dates
          RefinaceLoanDates(
            state: state,
          ),
        ],
      ),
    );
  }
}

///! Old Loan Details
class OldLoanDetails extends StatelessWidget {
  final LoanRefinanceInitialState state;
  const OldLoanDetails({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.red[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // old loan collectible amount
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  '\u20B9${intl.NumberFormat('#,##,###').format(state.oldLoan.collectibleAmount)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '\n${l10n().collectibleAmount}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),

          // - symbol

          const Text(
            '-',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),

          // old loan given amount
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  '\u20B9${intl.NumberFormat('#,##,###').format(state.oldLoan.paidAmount)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                    text: '\n${l10n().paidAmount}',
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          // = symbol
          const Text(
            '=',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),

          // old loan remaining amount
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  '\u20B9${intl.NumberFormat('#,##,###').format(state.oldLoan.collectibleAmount - state.oldLoan.paidAmount)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
              children: [
                TextSpan(
                  text: '\n${l10n().balance}',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewAmountForRefinance extends StatelessWidget {
  final LoanRefinanceInitialState state;
  const NewAmountForRefinance({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                '\u20B9${intl.NumberFormat('#,##,###').format(state.givenAmount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '\n${l10n().givenAmount}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        // - symbol
        const Text(
          '-',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        // remaining amount
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                '\u20B9${intl.NumberFormat('#,##,###').format(state.balanceAmount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '\n${l10n().balance}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        // = symbol
        const Text(
          '=',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        // new amount to give
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                '\u20B9${intl.NumberFormat('#,##,###').format(state.newGivenAmount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
            children: [
              TextSpan(
                text: '\nRemaining',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Colors.green,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NewEmiDetailsForRefiance extends StatelessWidget {
  final LoanRefinanceInitialState state;
  const NewEmiDetailsForRefiance({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                '\u20B9${intl.NumberFormat('#,##,###').format(state.emiAmount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '\n${l10n().installmentAmount}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        // new loan total emis
        // multiply symbol
        const Text(
          'x',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '${state.emiCount}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '\n${l10n().totalInstallments}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        // = symbol
        const Text(
          '=',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        // new loan Collectible amount
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                '\u20B9${intl.NumberFormat('#,##,###').format(state.emiAmount * state.emiCount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                  text: '\n${l10n().amount}',
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ],
    );
  }
}

class RefinaceLoanDates extends StatelessWidget {
  final LoanRefinanceInitialState state;
  const RefinaceLoanDates({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final calcEndDate = getIt<EmiDateCalculator>();
    String endDate() {
      return calcEndDate.calculateLoanEndDate(
          loanTakenDate: state.startDate,
          totalEmis: state.emiCount,
          emiFrequency: state.oldLoan.emiType);
    }

    l10n() => AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: intl.DateFormat('dd-MM-yyyy').format(state.startDate),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: '\n${l10n().loanDate}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]),
        ),
        // new loan end date
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                intl.DateFormat('dd-MM-yyyy').format(DateTime.parse(endDate())),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: '\n${l10n().endDate}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
