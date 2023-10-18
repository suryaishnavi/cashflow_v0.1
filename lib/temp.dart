/* 
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../../models/ModelProvider.dart';
import 'update_loan_dialog_cubit/update_loan_dialog_cubit.dart';

class UpdateLoanView extends StatefulWidget {
  final List<Loan> loans;
  final Customer customer;
  final double scrollPosition;
  const UpdateLoanView({
    super.key,
    required this.loans,
    required this.customer,
    required this.scrollPosition,
  });

  @override
  State<UpdateLoanView> createState() => _UpdateLoanViewState();
}

class _UpdateLoanViewState extends State<UpdateLoanView> {
  // late ScrollController _controller;
  // bool _isVisible = true;

  // void _listen() {
  //   final ScrollDirection direction = _controller.position.userScrollDirection;
  //   if (direction == ScrollDirection.forward) {
  //     _show();
  //   } else if (direction == ScrollDirection.reverse) {
  //     _hide();
  //   }
  // }

  // void _show() {
  //   if (!_isVisible) {
  //     setState(() => _isVisible = true);
  //   }
  // }

  // void _hide() {
  //   if (_isVisible) {
  //     setState(() => _isVisible = false);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _controller = ScrollController();
    // _controller.addListener(_listen);
  }

  @override
  void dispose() {
    // _controller.removeListener(_listen);
    // _controller.dispose();
    super.dispose();
  }

  DateTime today() => DateTime.parse('${DateTime.now()}'.split(' ')[0]);

  TextSpan getRemainingDays({required DateTime dueDate}) {
    final DateTime date = DateTime.parse(dueDate.toString().split(' ')[0]);
    Duration difference = date.difference(today());

    String description = switch (difference) {
      Duration(inDays: -1) =>
        AppLocalizations.of(context)!.difference('yesterday'),
      Duration(inDays: 0) => AppLocalizations.of(context)!.difference('today'),
      Duration(inDays: 1) =>
        AppLocalizations.of(context)!.difference('tomorrow'),
      Duration(inDays: int d, isNegative: false) =>
        '$d ${AppLocalizations.of(context)!.difference('positive')}',
      Duration(inDays: int d, isNegative: true) =>
        '${d.abs()} ${AppLocalizations.of(context)!.difference('negative')}',
    };

    return TextSpan(
      text: '\n($description)',
      style: getStyle(dueDate: dueDate),
    );
  }

  Color? getColor({required DateTime dueDate}) {
    if (dueDate.difference(today()).inDays <= 0) {
      return Colors.red[50];
    } else {
      return Colors.green[50];
    }
  }

  TextStyle getStyle({required DateTime dueDate}) {
    if (dueDate.difference(today()).inDays <= 0) {
      return const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );
    } else {
      return const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (widget.loans.isEmpty) {
      return MarkCustomerInactive(customer: widget.customer);
    }
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: widget.customer.customerName.length > 15
                ? '${widget.customer.customerName[0].toUpperCase() + widget.customer.customerName.substring(1, 15).toLowerCase()}... ${AppLocalizations.of(context)!.loanRepayments}'
                : '${widget.customer.customerName[0].toUpperCase() + widget.customer.customerName.substring(1).toLowerCase()}... ${AppLocalizations.of(context)!.loanRepayments}',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          color: Colors.red,
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // floatingActionButton: _isVisible
      //     ? FloatingActionButton.extended(
      //         extendedPadding: const EdgeInsets.symmetric(horizontal: 48.0),
      //         extendedTextStyle:
      //             Theme.of(context).textTheme.bodyLarge!.copyWith(
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //         onPressed: () {
      //           if (_formKey.currentState!.validate()) {
      //             _formKey.currentState!.save();
      //             context.read<CustomerBloc>().add(
      //                   ScrollPositionEvent(
      //                     scrollPosition: widget.scrollPosition,
      //                   ),
      //                 );
      //             Navigator.pop(context);
      //           }
      //         },
      //         icon: const Icon(Icons.check),
      //         label: Text(AppLocalizations.of(context)!.payEmiBtn),
      //       )
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Form(
                key: _formKey,
                child: ListView.separated(
                  // controller: _controller,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: widget.loans.length,
                  itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: getColor(
                            dueDate:
                                widget.loans[index].nextDueDate.getDateTime()),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text:
                                      'ID - ${widget.loans[index].loanIdentity} : ',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '\u{20B9}${intl.NumberFormat('#,##,###').format(widget.loans[index].collectibleAmount)} - \u{20B9}${intl.NumberFormat('#,##,###').format(widget.loans[index].paidAmount)} = ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '\u{20B9}${intl.NumberFormat('#,##,###').format(widget.loans[index].collectibleAmount - widget.loans[index].paidAmount)}',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.loanDate,
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '\n${intl.DateFormat('dd-MM-yyyy').format(widget.loans[index].dateOfCreation.getDateTime())}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.loanEnd,
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        '\n${intl.DateFormat('dd-MM-yyyy').format(widget.loans[index].endDate.getDateTime())}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // !-----------------Remaining Days-----------------
                                  getRemainingDays(
                                      dueDate: widget.loans[index].endDate
                                          .getDateTime()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: AppLocalizations.of(context)!
                                    .paidInstallments,
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '\n${widget.loans[index].paidEmis}/${widget.loans[index].totalEmis}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: AppLocalizations.of(context)!
                                    .installmentAmount,
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '\n\u{20B9}${intl.NumberFormat('#,##,###').format(widget.loans[index].emiAmount)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.dueDate,
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ': ${intl.DateFormat('dd-MM-yyyy').format(widget.loans[index].nextDueDate.getDateTime())}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              // !-----------------Remaining Days-----------------
                              getRemainingDays(
                                  dueDate: widget.loans[index].nextDueDate
                                      .getDateTime()),
                            ],
                          ),
                        ),
                        // const

                        // TextFormField(
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        //   // format like currency
                        //   inputFormatters: [
                        //     FilteringTextInputFormatter.digitsOnly,
                        //     LengthLimitingTextInputFormatter(6),
                        //     TextInputFormatter.withFunction(
                        //       (oldValue, newValue) {
                        //         final numericValue =
                        //             int.tryParse(newValue.text);
                        //         if (numericValue != null) {
                        //           final formatter =
                        //               intl.NumberFormat.simpleCurrency(
                        //             locale: 'en_IN',
                        //             decimalDigits: 0,
                        //           );
                        //           final newText = formatter.format(
                        //               numericValue); // Divide by 100 to format as currency
                        //           return TextEditingValue(
                        //             text: newText,
                        //             selection: TextSelection.collapsed(
                        //                 offset: newText.length),
                        //           );
                        //         }
                        //         return newValue;
                        //       },
                        //     ),
                        //   ],
                        //   decoration: InputDecoration(
                        //     filled: true,
                        //     fillColor: Colors.white,
                        //     isDense: true,
                        //     labelText: AppLocalizations.of(context)!
                        //         .labelRepaymentAmount,
                        //     hintText: AppLocalizations.of(context)!
                        //         .hintRepaymentAmount,
                        //   ),
                        //   keyboardType: TextInputType.number,
                        //   onSaved: (newValue) {
                        //     if (newValue == null || newValue == '') return;
                        //     final numericValue = int.parse(newValue
                        //         .replaceAll(',', '')
                        //         .replaceAll('₹', ''));
                        //     context.read<UpdateLoanDialogCubit>().updateLoan(
                        //           customer: widget.customer,
                        //           loan: widget.loans[index],
                        //           emiValue: numericValue.toString(),
                        //         );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 16.0);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarkCustomerInactive extends StatelessWidget {
  final Customer customer;
  const MarkCustomerInactive({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(AppLocalizations.of(context)!.noActiveLoans),
          leading: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(height: 32.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            AppLocalizations.of(context)!.inActiveCustomer,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 32.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
              onPressed: () {
                context
                    .read<UpdateLoanDialogCubit>()
                    .markAsInactive(customer: customer);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.markInactive)),
        )
      ],
    );
  }
}
*/