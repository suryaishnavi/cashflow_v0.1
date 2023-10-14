import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../../../models/ModelProvider.dart';
import '../2_loan_details/loan_data_cubit.dart';
import '../3_emi_details/emi_cubit.dart';
import '../emi_table.dart';
import 'loan_refinance_bloc/bloc/loan_refinance_bloc.dart';
import 'loan_refinance_bloc/loan_refinance_view.dart';

class Loans extends StatelessWidget {
  final LoanStatus loanStatus;
  const Loans({super.key, required this.loanStatus});

  // snakebar with color and message
  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoanDataCubit, LoanDataState>(
      listener: (context, state) {
        if (state is LoanUpdatedState) {
          showSnackBar(context, AppLocalizations.of(context)!.loanUpdateSuccess,
              Colors.green);
        }
        if (state is LoanFailedToUpdate) {
          showSnackBar(context, AppLocalizations.of(context)!.loanUpdateFailed,
              Colors.red);
        }
      },
      builder: (context, state) {
        if (state is LoanLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoanDataErrorState) {
          return Center(child: Text(AppLocalizations.of(context)!.errorMsg));
        } else if (state is LoanLoadedState) {
          if (state.loansData.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noLoans),
            );
          }
          final List<Loan> customerLoans = state.loansData
              .where((element) => element.status == loanStatus)
              .toList();
          return ListView.builder(
            itemCount: customerLoans.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                surfaceTintColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: InkWell(
                  splashColor: Colors.blue[100],
                  onTap: () async {
                    // ! get emis for the loan
                    context
                        .read<EmiCubit>()
                        .getEmis(loan: customerLoans[index]);
                    await Future.delayed(const Duration(milliseconds: 200), () {
                      showEmiTable(context: context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 8, left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //* loan id and date of creation and end date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!.loanBookID,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        ': ${customerLoans[index].loanIdentity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' (${intl.DateFormat('dd/MM/yy').format(customerLoans[index].dateOfCreation.getDateTime())} - ${intl.DateFormat('dd/MM/yy').format(customerLoans[index].endDate.getDateTime())})',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LoanItemPopupMenu(loan: customerLoans[index]),
                          ],
                        ),
                        // * loan amount and emi amount and total emis
                        RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.balance,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: customerLoans[index].collectibleAmount -
                                          customerLoans[index].paidAmount <=
                                      0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    ': \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].collectibleAmount)}',
                              ),
                              TextSpan(
                                text:
                                    ' - \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].paidAmount)}',
                              ),
                              TextSpan(
                                text:
                                    ' = \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].collectibleAmount - customerLoans[index].paidAmount)}',
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.givenAmount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    ': \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].givenAmount)}',
                              ),
                            ],
                          ),
                        ),
                        Text(
                            '${AppLocalizations.of(context)!.installmentAmount}: \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].emiAmount)}'),
                        Text(
                            '${AppLocalizations.of(context)!.totalInstallments}: ${customerLoans[index].paidEmis}/${customerLoans[index].totalEmis}'),
                        // show reason for loan termination only when loan is closed
                        customerLoans[index].reasonForLoanTermination == null
                            ? const SizedBox.shrink()
                            : Text(
                                '${customerLoans[index].reasonForLoanTermination}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        customerLoans[index].ttl == null
                            ? const SizedBox.shrink()
                            : Text(
                                '${DateTime.fromMillisecondsSinceEpoch(customerLoans[index].ttl!.toSeconds() * 1000).difference(DateTime.now()).inDays} ${AppLocalizations.of(context)!.daysLeft}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Center(child: Text(AppLocalizations.of(context)!.errorMsg));
      },
    );
  }

  // full screen dialog to update loan amount
  void showEmiTable({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: BlocBuilder<EmiCubit, EmiState>(
            builder: (context, state) {
              if (state is EmiLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is EmiLoaded) {
                // ! show emi table
                return EmiTable(emiList: state.emiList);
              } else if (state is EmiError) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.errorMsg),
                );
              }
              return Center(
                child: Text(AppLocalizations.of(context)!.errorMsg),
              );
            },
          ),
        );
      },
    );
  }
}

enum MenuItem { changeLoanAmount, closeLoan, loanRefinancing, deleteLoan }

class LoanItemPopupMenu extends StatefulWidget {
  final Loan loan;
  const LoanItemPopupMenu({super.key, required this.loan});

  @override
  State<LoanItemPopupMenu> createState() => _LoanItemPopupMenuState();
}

class _LoanItemPopupMenuState extends State<LoanItemPopupMenu> {
  modifyCollectionAmount() {
    final TextEditingController amountController = TextEditingController(
      text: widget.loan.collectibleAmount.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Column(
            children: [
              AppBar(
                title:
                    Text(AppLocalizations.of(context)!.updateCollectionAmount),
                leading: IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      maxLength: 7,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.currency_rupee),
                        hintText:
                            AppLocalizations.of(context)!.enterCollectionAmount,
                        labelText: AppLocalizations.of(context)!.givenAmount,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        context.read<LoanDataCubit>().updateLoanAmount(
                              loan: widget.loan,
                              updatedAmount: int.parse(amountController.text),
                            );
                        Navigator.pop(context);
                      },
                      child: const Text('Update Amount',
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  loanRefinancing() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog.fullscreen(child: LoanRefinanceView());
      },
    );
  }

  closeLoan() {
    close() {
      context.read<LoanDataCubit>().closeLoan(
            reasonForLoanTermination:
                AppLocalizations.of(context)!.loanCloseReason,
            loan: widget.loan,
          );
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(AppLocalizations.of(context)!.loanClosed),
        ),
      );
    }

    // show dialog to confirm and pass the close function
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning, color: Colors.black),
              const SizedBox(width: 16),
              Text(AppLocalizations.of(context)!.warning),
            ],
          ),
          content: Text(AppLocalizations.of(context)!.loanCloseWarning),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                close();
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.closeLoan,
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  deleteLoan() {
    // show dialog to confirm and pass the close function
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Theme.of(context).colorScheme.error,
          title: Row(
            children: [
              Icon(Icons.dangerous, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 16),
              Text(AppLocalizations.of(context)!.warning),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!
                .deleteOptionsTxt('delLoanPopupHeading'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<LoanDataCubit>().deleteLoan(loan: widget.loan);
                Navigator.pop(context);
              },
              child: Text(
                  AppLocalizations.of(context)!.deleteOptionsTxt('delete'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      // Callback that sets the selected popup menu item.
      onSelected: (MenuItem item) {
        if (item == MenuItem.changeLoanAmount) {
          modifyCollectionAmount();
        } else if (item == MenuItem.loanRefinancing) {
          loanRefinancing();
          context.read<LoanRefinanceBloc>().add(
                OldLoanRefinanceEvent(oldLoan: widget.loan),
              );
        } else if (item == MenuItem.closeLoan) {
          closeLoan();
        } else if (item == MenuItem.deleteLoan) {
          deleteLoan();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
        PopupMenuItem<MenuItem>(
          enabled: widget.loan.status == LoanStatus.ACTIVE,
          value: MenuItem.changeLoanAmount,
          child: Text(AppLocalizations.of(context)!.changeLoanAmount),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<MenuItem>(
          value: MenuItem.loanRefinancing,
          child: Text(AppLocalizations.of(context)!.loanRefinancing),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<MenuItem>(
          enabled: widget.loan.status == LoanStatus.ACTIVE,
          value: MenuItem.closeLoan,
          child: Text(AppLocalizations.of(context)!.closeLoan),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<MenuItem>(
          value: MenuItem.deleteLoan,
          child: Text(
            AppLocalizations.of(context)!.deleteOptionsTxt('delLoan'),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

//! Deprecated code

/** 
              ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // loan id and date of creation and end date
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.loanBookID,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ': ${customerLoans[index].loanIdentity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' (${intl.DateFormat('dd/MM/yy').format(customerLoans[index].dateOfCreation.getDateTime())} - ${intl.DateFormat('dd/MM/yy').format(customerLoans[index].endDate.getDateTime())})',
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    //  loan amount and emi amount and total emis
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.balance,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: customerLoans[index].collectibleAmount -
                                      customerLoans[index].paidAmount <=
                                  0
                              ? Colors.green
                              : Colors.red,
                        ),
                        children: [
                          TextSpan(
                            text:
                                ': \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].collectibleAmount)}',
                          ),
                          TextSpan(
                            text:
                                ' - \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].paidAmount)}',
                          ),
                          TextSpan(
                            text:
                                ' = \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].collectibleAmount - customerLoans[index].paidAmount)}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.givenAmount,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text:
                                ': \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].givenAmount)}',
                          ),
                        ],
                      ),
                    ),
                    Text(
                        '${AppLocalizations.of(context)!.installmentAmount}: \u20B9${intl.NumberFormat('#,##,###').format(customerLoans[index].emiAmount)}'),
                    Text(
                        '${AppLocalizations.of(context)!.totalInstallments}: ${customerLoans[index].paidEmis}/${customerLoans[index].totalEmis}'),
                    // show reason for loan termination only when loan is closed
                    customerLoans[index].reasonForLoanTermination == null
                        ? const SizedBox.shrink()
                        : Text(
                            '${customerLoans[index].reasonForLoanTermination}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    customerLoans[index].ttl == null
                        ? const SizedBox.shrink()
                        : Text(
                            '${DateTime.fromMillisecondsSinceEpoch(customerLoans[index].ttl!.toSeconds() * 1000).difference(DateTime.now()).inDays} ${AppLocalizations.of(context)!.daysLeft}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                  ],
                ),
                // show trailing icon only when loan is active
                trailing: LoanItemPopupMenu(loan: customerLoans[index]),

                onExpansionChanged: (bool expand) {
                  if (expand) {
                    context
                        .read<EmiCubit>()
                        .getEmis(loan: customerLoans[index]);
                  }
                },
                children: [
                  SizedBox(
                    height: 300,
                    child: BlocBuilder<EmiCubit, EmiState>(
                      builder: (context, state) {
                        if (state is EmiLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is EmiLoaded) {
                          // ! show emi table
                          return EmiTable(emiList: state.emiList);
                        } else if (state is EmiError) {
                          return Center(
                            child: Text(AppLocalizations.of(context)!.errorMsg),
                          );
                        }
                        return Center(
                          child: Text(AppLocalizations.of(context)!.errorMsg),
                        );
                      },
                    ),
                  ),
                ],
              );
*/
