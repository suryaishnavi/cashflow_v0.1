import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../../info_helper/chat_model.dart';
import '../../info_helper/custom_transaction_modal.dart';
import '../../models/ModelProvider.dart';
import 'confirm_button_status_cubit/confirm_button_status_cubit.dart';
import 'update_loan_dialog_bloc/update_loan_dialog_bloc.dart';

class UpdateLoanView extends StatelessWidget {
  final CreatedChatViewState state;
  final Customer customer;
  const UpdateLoanView({
    super.key,
    required this.state,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;
    final List<ChatModel> chatModels = state.chatModels;
    return DefaultTabController(
      length: chatModels.length,
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              text: customer.customerName.length > 15
                  ? '${customer.customerName[0].toUpperCase() + customer.customerName.substring(1, 15).toLowerCase()}... ${l10n().loanRepayments}'
                  : '${customer.customerName[0].toUpperCase() + customer.customerName.substring(1).toLowerCase()}... ${l10n().loanRepayments}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size(0, 30),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: chatModels
                  .map((chatModel) =>
                      Tab(text: 'Loan ID: ${chatModel.loan.loanIdentity}'))
                  .toList(),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: chatModels
                    .map((chatModel) => ChatView(
                          loan: chatModel.loan,
                          transactions: chatModel.transaction,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  final Loan loan;
  final List<CustomTransactionModel> transactions;
  const ChatView({
    super.key,
    required this.loan,
    required this.transactions,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GradientBubbles(
          transactions: transactions,
        ),
        // DraggableButton(
        //   loan: loan,
        // ),
        CurrentLoanTrack(loan: loan),
        // CurrentLoanDetails(loan: loan),
        Align(
          alignment: Alignment.bottomCenter,
          child: EmipaymentFormField(
            loan: loan,
          ),
        ),
      ],
    );
  }
}

class CurrentLoanTrack extends StatelessWidget {
  final Loan loan;
  const CurrentLoanTrack({super.key, required this.loan});
  DateTime today() => DateTime.parse('${DateTime.now()}'.split(' ')[0]);

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

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;

    TextSpan getRemainingDays({required DateTime dueDate}) {
      final DateTime date = DateTime.parse(dueDate.toString().split(' ')[0]);
      Duration difference = date.difference(today());

      String description = switch (difference) {
        Duration(inDays: -1) => l10n().difference('yesterday'),
        Duration(inDays: 0) => l10n().difference('today'),
        Duration(inDays: 1) => l10n().difference('tomorrow'),
        Duration(inDays: int d, isNegative: false) =>
          '$d ${l10n().difference('positive')}',
        Duration(inDays: int d, isNegative: true) =>
          '${d.abs()} ${l10n().difference('negative')}',
      };

      return TextSpan(
        text: '\n($description)',
        style: getStyle(dueDate: dueDate),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TransprentCard(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: AppLocalizations.of(context)!.dueDate,
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text:
                      '\n${intl.DateFormat('dd-MM-yyyy').format(loan.nextDueDate.getDateTime())}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // !-----------------Loan Due Date-----------------
                getRemainingDays(dueDate: loan.nextDueDate.getDateTime()),
              ],
            ),
          ),
        ),
        TransprentCard(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: AppLocalizations.of(context)!.loanEnd,
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text:
                      '\n${intl.DateFormat('dd-MM-yyyy').format(loan.endDate.getDateTime())}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // !-----------------Loan End Date-----------------
                getRemainingDays(dueDate: loan.endDate.getDateTime()),
              ],
            ),
          ),
        ),
        TransprentCard(
          child: GestureDetector(
            onTap: () {
              showDetails(context);
            },
            child: Text(
              'more...',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 64.0),
      ],
    );
  }

  void showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 0.0,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: CurrentLoanDetails(loan: loan),
        );
      },
    );
  }
}

class TransprentCard extends StatelessWidget {
  final Widget child;
  const TransprentCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white60,
              Colors.white70,
            ],
            stops: [0.0, 0.7],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CurrentLoanDetails extends StatelessWidget {
  final Loan loan;
  const CurrentLoanDetails({super.key, required this.loan});
  DateTime today() => DateTime.parse('${DateTime.now()}'.split(' ')[0]);

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

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;

    TextSpan getRemainingDays({required DateTime dueDate}) {
      final DateTime date = DateTime.parse(dueDate.toString().split(' ')[0]);
      Duration difference = date.difference(today());

      String description = switch (difference) {
        Duration(inDays: -1) => l10n().difference('yesterday'),
        Duration(inDays: 0) => l10n().difference('today'),
        Duration(inDays: 1) => l10n().difference('tomorrow'),
        Duration(inDays: int d, isNegative: false) =>
          '$d ${l10n().difference('positive')}',
        Duration(inDays: int d, isNegative: true) =>
          '${d.abs()} ${l10n().difference('negative')}',
      };

      return TextSpan(
        text: '\n($description)',
        style: getStyle(dueDate: dueDate),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          color: getColor(dueDate: loan.nextDueDate.getDateTime()),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white60,
              Colors.white70,
            ],
            stops: [0.0, 0.7],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          text: 'Balance: ',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '\u{20B9}${intl.NumberFormat('#,##,###').format(loan.collectibleAmount)} - \u{20B9}${intl.NumberFormat('#,##,###').format(loan.paidAmount)} = ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\u{20B9}${intl.NumberFormat('#,##,###').format(loan.collectibleAmount - loan.paidAmount)}',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
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
                                '\n${intl.DateFormat('dd-MM-yyyy').format(loan.dateOfCreation.getDateTime())}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                                '\n${intl.DateFormat('dd-MM-yyyy').format(loan.endDate.getDateTime())}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // !-----------------Remaining Days-----------------
                          getRemainingDays(dueDate: loan.endDate.getDateTime()),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.paidInstallments,
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: '\n${loan.paidEmis}/${loan.totalEmis}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.installmentAmount,
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '\n\u{20B9}${intl.NumberFormat('#,##,###').format(loan.emiAmount)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white70),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: AppLocalizations.of(context)!.dueDate,
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            ': ${intl.DateFormat('dd-MM-yyyy').format(loan.nextDueDate.getDateTime())}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // !-----------------Remaining Days-----------------
                      getRemainingDays(dueDate: loan.nextDueDate.getDateTime()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class GradientBubbles extends StatefulWidget {
  final List<CustomTransactionModel> transactions;
  const GradientBubbles({super.key, required this.transactions});

  @override
  State<GradientBubbles> createState() => _GradientBubblesState();
}

class _GradientBubblesState extends State<GradientBubbles> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animateToMaximumExtent();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void animateToMaximumExtent() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      scrollBehavior: const MaterialScrollBehavior(),
      physics: const BouncingScrollPhysics(),
      // reverse: true,
      slivers: <Widget>[
        SliverList.builder(
          itemCount: widget.transactions.length,
          itemBuilder: (context, index) {
            final transaction = widget.transactions[index];
            return MessageBubble(
              transaction: transaction,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.greenAccent[400],
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '\u{20B9}${intl.NumberFormat('#,##,###').format(transaction.amount)}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.white.withAlpha(100)),
                    Row(
                      children: [
                        const SizedBox(width: 8.0),
                        Text(
                          transaction.isLoan ? 'Given' : 'Received',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        // icon
                        Icon(
                          transaction.isLoan
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Colors.white.withAlpha(200),
                          size: 16.0,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        intl.DateFormat('dd-MM-yy').format(transaction.date),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 64.0)),
      ],
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(GradientBubbles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transactions.length > oldWidget.transactions.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }
}

@immutable
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.transaction,
    required this.child,
  });

  final CustomTransactionModel transaction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        transaction.isLoan ? Alignment.topLeft : Alignment.topRight;

    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.6,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: BubbleBackground(
              colors: [
                if (transaction.isLoan) ...const [
                  Color(0xFF6C7689),
                  Color(0xFF3A364B),
                ] else ...const [
                  Color(0xFF19B7FF),
                  Color(0xFF491CCB),
                ],
              ],
              child: child,
              // DefaultTextStyle.merge(
              //   style: const TextStyle(
              //     fontSize: 18.0,
              //     color: Colors.white,
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: child,
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    super.key,
    required this.colors,
    this.child,
  });

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        scrollable: Scrollable.of(context),
        bubbleContext: context,
        colors: colors,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors,
        super(repaint: scrollable.position);

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}

// !-----------------EMI Payment Form-----------------
class EmipaymentFormField extends StatefulWidget {
  final Loan loan;
  const EmipaymentFormField({
    super.key,
    required this.loan,
  });

  @override
  State<EmipaymentFormField> createState() => _EmipaymentFormFieldState();
}

class _EmipaymentFormFieldState extends State<EmipaymentFormField> {
  // formkey
  final _formKey = GlobalKey<FormState>();
  // controller
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const BoxDecoration(
          color: Color(0xFF6C7689),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                // format like currency
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      final numericValue = int.tryParse(newValue.text);
                      if (numericValue != null) {
                        final formatter = intl.NumberFormat.simpleCurrency(
                          locale: 'en_IN',
                          decimalDigits: 0,
                        );
                        final newText = formatter.format(
                            numericValue); // Divide by 100 to format as currency
                        return TextEditingValue(
                          text: newText,
                          selection:
                              TextSelection.collapsed(offset: newText.length),
                        );
                      }
                      return newValue;
                    },
                  ),
                ],
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  // remove border
                  border: InputBorder.none,
                  // isDense: true,
                  filled: true,
                  fillColor: const Color(0xFF6C7689),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white.withOpacity(0.9)),
                  hintText: AppLocalizations.of(context)!.hintRepaymentAmount,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    context
                        .read<ConfirmButtonStatusCubit>()
                        .changeStatus(false);
                  } else {
                    context.read<ConfirmButtonStatusCubit>().changeStatus(true);
                  }
                },
              ),
            ),
            const SizedBox(width: 16.0),
            // !-----------------Confirm Button-----------------
            ElevatedButton(
              onPressed: context.watch<ConfirmButtonStatusCubit>().state.status
                  ? () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        final parsedEmiValue = controller.text
                            .replaceAll(',', '')
                            .replaceAll('₹', '');
                        context.read<UpdateLoanDialogBloc>().add(NewEmiEvent(
                              loan: widget.loan,
                              emiValue: parsedEmiValue,
                            ));
                      }
                      controller.clear();
                      context
                          .read<ConfirmButtonStatusCubit>()
                          .changeStatus(false);
                    }
                  : null,
              // disabled button style
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

// class DraggableButton extends StatefulWidget {
//   final Loan loan;
//   const DraggableButton({super.key, required this.loan});

//   @override
//   State<DraggableButton> createState() => _DraggableButtonState();
// }

// class _DraggableButtonState extends State<DraggableButton> {
//   Offset position = const Offset(70, 120);

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: position.dx,
//       top: position.dy,
//       child: Draggable(
//         feedback: ClipOval(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.5),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.currency_rupee,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         onDragEnd: (details) {
//           setState(() {
//             position = details.offset;
//           });
//         },
//         child: RoundedTransprentButton(loan: widget.loan),
//       ),
//     );
//   }
// }

// class RoundedTransprentButton extends StatelessWidget {
//   final Loan loan;
//   const RoundedTransprentButton({super.key, required this.loan});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 5, // set the elevation here
//       shape: const CircleBorder(),
//       clipBehavior: Clip.hardEdge,
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           showDetails(context);
//           // Navigator.of(context).pop();
//         },
//         child: Container(
//           width: 56,
//           height: 56,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.greenAccent.shade200,
//                 Colors.blue.shade400,
//                 Colors.blueAccent.shade700,
//               ],
//             ),
//           ),
//           child: const Icon(
//             Icons.currency_rupee_sharp,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   void showDetails(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       elevation: 0.0,
//       barrierColor: Colors.transparent,
//       backgroundColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(16.0),
//         ),
//       ),
//       isScrollControlled: true,
//       useRootNavigator: true,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 60.0),
//           child: CurrentLoanDetails(loan: loan),
//         );
//       },
//     );
//   }
// }
