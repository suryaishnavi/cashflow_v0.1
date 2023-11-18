import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lottie/lottie.dart';

import '../../info_helper/loading_view.dart';
import '../../models/EmiType.dart';
import '../../widgets/custom_eleveted_button.dart';
import '../../widgets/elevated_tonal_button.dart';
import 'loan_creation_bloc/loan_creation_bloc.dart';

class CreateLoanView extends StatefulWidget {
  final bool isAdditionalLoan;
  final bool isNewLoan;
  final Map<String, int>? swapDetails;
  const CreateLoanView({
    Key? key,
    required this.isAdditionalLoan,
    required this.isNewLoan,
    this.swapDetails,
  }) : super(key: key);

  @override
  State<CreateLoanView> createState() => _CreateLoanViewState();
}

class _CreateLoanViewState extends State<CreateLoanView> {
  DateTime date = DateTime.now();

  l10n() => AppLocalizations.of(context)!;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emiAmountController = TextEditingController();
  final TextEditingController _totalEmisController = TextEditingController();
  final TextEditingController _paidEmisController = TextEditingController();
  final TextEditingController _totalGivenAmountController =
      TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(text: '${DateTime.now()}'.split(' ')[0]);
  final TextEditingController _loanIdentityController = TextEditingController();

  @override
  void dispose() {
    _formKey.currentState?.reset();
    _emiAmountController.dispose();
    _totalEmisController.dispose();
    _totalGivenAmountController.dispose();
    _dateController.dispose();
    _loanIdentityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanCreationBloc, LoanCreationState>(
      listener: (context, state) {
        if (state is LoanCreationLoadingState) {
          Navigator.pop(context);
        } else if (state is LoanCreationSuccessState) {
          // Navigator.pop(context);
        } else if (state is LoanCreationErrorState) {
          // Navigator.pop(context);
        }
      },
      builder: (context, state) {
        switch (state) {
          case LoanCreationLoadingState():
            return const LoadingView();
          case LoanCreationSuccessState():
            return LoanSuccessScreen(
              createdLoanId: state.loanIdentity,
            );
          case LoanCreationErrorState():
            return const LoanCreationErrorScreen();
          case LoanCreationInitial():
            {
              _loanIdentityController.text =
                  widget.isNewLoan ? state.loanIdentity : '';
              return Scaffold(
                appBar: !widget.isAdditionalLoan
                    ? AppBar(
                        title: widget.isNewLoan
                            ? Text(l10n().enterNewLoanDetails)
                            : Text(l10n().enterExistingLoanDetails),
                      )
                    : null,
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _form(),
                      ],
                    ),
                  ),
                ),
              );
            }
        }
      },
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _totalGivenAmount(),
          const SizedBox(height: 16.0),
          _emiAmount(),
          const SizedBox(height: 16.0),
          _totalEmis(),
          const SizedBox(height: 16.0),
          // *if it not new loan then show paid emis field
          if (!widget.isNewLoan) ...[
            _paidEmis(),
            const SizedBox(height: 16.0),
          ],
          // *if isAdditionalLoan is true then show loanIdentity field
          if (widget.isAdditionalLoan) ...[
            _loanIdentity(),
            const SizedBox(height: 16.0),
          ],
          _date(),
          const SizedBox(height: 32.0),
          _submitButton(),
        ],
      ),
    );
  }

  TextStyle getLabelStyle() {
    return const TextStyle(fontWeight: FontWeight.bold);
  }

  Widget _totalGivenAmount() {
    return TextFormField(
      controller: _totalGivenAmountController,
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
      maxLength: 10,
      decoration: InputDecoration(
        isDense: !widget.isNewLoan,
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
      maxLength: 9,
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
        isDense: !widget.isNewLoan,
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
      controller: _totalEmisController,
      style: getLabelStyle(),
      maxLength: 3,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        isDense: !widget.isNewLoan,
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

  Widget _paidEmis() {
    return TextFormField(
      controller: _paidEmisController,
      style: getLabelStyle(),
      maxLength: 3,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        isDense: !widget.isNewLoan,
        icon: const Icon(Icons.star_half),
        hintText: l10n().paidInstallmentsField('hint'),
        labelText: l10n().paidInstallmentsField('label'),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return l10n().paidInstallmentsField('error');
        } else if (int.parse(value) < 0) {
          return l10n().paidInstallmentsField('error2');
        } else if (int.parse(value) > 200) {
          return l10n().paidInstallmentsField('error3');
        } else if (int.parse(value) > int.parse(_totalEmisController.text)) {
          return l10n().paidInstallmentsField('error4');
        } else if (_totalEmisController.text.isEmpty) {
          return l10n().paidInstallmentsField('error5');
        } else {
          return null;
        }
      },
    );
  }

  Widget _date() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      style: getLabelStyle(),
      decoration: InputDecoration(
        isDense: !widget.isNewLoan,
        icon: const Icon(Icons.calendar_today),
        labelText: l10n().loanDate,
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          setState(() {
            date = selectedDate;
            _dateController.text = '$selectedDate'.split(' ')[0];
          });
        }
      },
      readOnly: true,
      controller: _dateController,
    );
  }

  Widget _loanIdentity() {
    return TextFormField(
      controller: _loanIdentityController,
      style: getLabelStyle(),
      maxLength: 5,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        isDense: !widget.isNewLoan,
        icon: const Icon(Icons.menu_book),
        labelText: l10n().loanIdField('label'),
        hintText: l10n().loanIdField('hint'),
      ),
    );
  }

  Widget _submitButton() {
    return BlocBuilder<LoanCreationBloc, LoanCreationState>(
      builder: (context, state) {
        return state is LoanCreationLoadingState
            ? const CircularProgressIndicator()
            : CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showDialog();
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

  // full screen dialog
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextStyle? getLableStyle() {
          return Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w400,
                height: 2,
              );
        }

        TextStyle? getAmountStyle() {
          return Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
              );
        }

        String collectableAmount() {
          int emiAmount = _emiAmountController.text.isNotEmpty
              ? int.parse(_emiAmountController.text
                  .replaceAll(',', '')
                  .replaceAll('₹', ''))
              : 0;
          int totalEmis = _totalEmisController.text.isNotEmpty
              ? int.parse(_totalEmisController.text
                  .replaceAll(',', '')
                  .replaceAll('₹', ''))
              : 0;
          int collectableAmount = emiAmount * totalEmis;
          return '\n\u{20B9}${intl.NumberFormat('#,##,###').format(collectableAmount)}';
        }

        // calculate end date and make it string
        String calculateEndDate(EmiType emiType) {
          final totalInstallments = int.parse(_totalEmisController.text);
          final endDate = emiType == EmiType.DAILY
              ? date.add(Duration(days: totalInstallments))
              : emiType == EmiType.WEEKLY
                  ? date.add(Duration(days: 7 * totalInstallments))
                  : DateTime(
                      date.year, date.month + totalInstallments, date.day);
          return intl.DateFormat('dd-MM-yyyy').format(endDate);
        }

        return Dialog.fullscreen(
          child: Column(
            children: [
              AppBar(
                title: Text(l10n().confirmLoanDetails),
                centerTitle: true,
                leading: IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.blue.shade50,
                ),
                margin: const EdgeInsets.all(12.0),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: '${l10n().loanDate} : '.toUpperCase(),
                        style: getLableStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text: intl.DateFormat('dd-MM-yyyy').format(date),
                            style: getLableStyle()!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: Colors.white),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: l10n().givenAmount.toUpperCase(),
                            style: getLableStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '\n\u{20B9}${intl.NumberFormat('#,##,###').format(int.parse(
                                  _totalGivenAmountController.text
                                      .replaceAll(',', '')
                                      .replaceAll('₹', ''),
                                ))}',
                                style: getAmountStyle(),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: l10n().collectibleAmount.toUpperCase(),
                            style: getLableStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text: collectableAmount(),
                                style: getAmountStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: Colors.white),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: l10n().installmentAmount.toUpperCase(),
                            style: getLableStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '\n\u{20B9}${intl.NumberFormat('#,##,###').format(int.parse(
                                  _emiAmountController.text
                                      .replaceAll(',', '')
                                      .replaceAll('₹', ''),
                                ))}',
                                style: getAmountStyle(),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: l10n().totalInstallments.toUpperCase(),
                            style: getLableStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text: '\n${_totalEmisController.text}',
                                style: getAmountStyle(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: Colors.white),
                    const SizedBox(height: 16.0),
                    BlocBuilder<LoanCreationBloc, LoanCreationState>(
                      builder: (context, state) {
                        if (state is LoanCreationInitial) {
                          final endDate = calculateEndDate(state.emiType);
                          return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: '${l10n().loanEnd} : '.toUpperCase(),
                              style: getLableStyle(),
                              children: <TextSpan>[
                                TextSpan(
                                  text: endDate,
                                  style: getLableStyle()!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomElevatedButton(
                  onPressed: () {
                    if (widget.isAdditionalLoan) {
                      context.read<LoanCreationBloc>().add(
                            AdditionalLoanCreationEvent(
                              givenAmount: _totalGivenAmountController.text
                                  .replaceAll(',', '')
                                  .replaceAll('₹', ''),
                              emiAmount: _emiAmountController.text
                                  .replaceAll(',', '')
                                  .replaceAll('₹', ''),
                              totalEmis: _totalEmisController.text,
                              date: _dateController.text,
                              loanIdentity: _loanIdentityController.text,
                              paidEmis: _paidEmisController.text,
                              isNewLoan: widget.isNewLoan,
                            ),
                          );
                      return;
                    }

                    context.read<LoanCreationBloc>().add(
                          LoanSubmissionEvent(
                            givenAmount: _totalGivenAmountController.text
                                .replaceAll(',', '')
                                .replaceAll('₹', ''),
                            emiAmount: _emiAmountController.text
                                .replaceAll(',', '')
                                .replaceAll('₹', ''),
                            totalEmis: _totalEmisController.text,
                            paidEmis: _paidEmisController.text,
                            isNewLoan: widget.isNewLoan,
                            date: _dateController.text,
                            loanIdentity: _loanIdentityController.text,
                          ),
                        );
                  },
                  child: Text(l10n().confirm),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoanSuccessScreen extends StatelessWidget {
  final String createdLoanId;
  const LoanSuccessScreen({super.key, required this.createdLoanId});

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/success.json',
              height: 250,
              width: 250,
              repeat: false,
            ),
            Text(
              l10n().loanCreated,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              '${l10n().loanBookID}: $createdLoanId',
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            // add sized box to give space between two widgets and add close button to close this page
            const SizedBox(height: 32.0),
            ElevatedTonalButton(
              backgroundColor: MaterialStateProperty.all(Colors.green[50]),
              foregroundColor: MaterialStateProperty.all(Colors.green[900]),
              shadowColor: MaterialStateProperty.all(Colors.green[400]),
              onPressed: () {
                // reset Loan creation Bloc
                context
                    .read<LoanCreationBloc>()
                    .add(LoanCreationInitialEvent());
                Navigator.pop(context);
              },
              text: l10n().close,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}

class LoanCreationErrorScreen extends StatelessWidget {
  const LoanCreationErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 48.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              l10n().loanCreationError,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedTonalButton(
              backgroundColor: MaterialStateProperty.all(Colors.red[50]),
              foregroundColor: MaterialStateProperty.all(Colors.red[900]),
              shadowColor: MaterialStateProperty.all(Colors.red[400]),
              onPressed: () {
                context
                    .read<LoanCreationBloc>()
                    .add(LoanCreationInitialEvent());
                Navigator.pop(context);
              },
              text: l10n().close,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}
