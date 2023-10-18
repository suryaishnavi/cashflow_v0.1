import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

import '../../models/ModelProvider.dart';

class UpdateLoanView extends StatelessWidget {
  final List<Loan> loans;
  final Customer customer;
  const UpdateLoanView({
    super.key,
    required this.loans,
    required this.customer,
  });

  get child => null;

  @override
  Widget build(BuildContext context) {
    l10n() => AppLocalizations.of(context)!;
    return DefaultTabController(
        length: loans.length,
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
                tabs: loans
                    .map((loan) => Tab(text: 'Loan ID: ${loan.loanIdentity}'))
                    .toList(),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: loans.map((loan) => ChatView(loan: loan)).toList(),
                ),
              ),
            ],
          ),
        ));
  }
}

class ChatView extends StatelessWidget {
  final Loan loan;
  const ChatView({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExampleGradientBubbles(
          loan: loan,
        ),
        // UpdateLoanForm(loan: loan),
      ],
    );
  }
}

class UpdateLoanForm extends StatelessWidget {
  final Loan loan;
  const UpdateLoanForm({super.key, required this.loan});
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
      // margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: getColor(dueDate: loan.nextDueDate.getDateTime()),
          // borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
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
          const Divider(color: Colors.white),
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
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}

@immutable
class ExampleGradientBubbles extends StatefulWidget {
  final Loan loan;
  const ExampleGradientBubbles({super.key, required this.loan});

  @override
  State<ExampleGradientBubbles> createState() => _ExampleGradientBubblesState();
}

class _ExampleGradientBubblesState extends State<ExampleGradientBubbles> {
  late final List<Message> data;

  @override
  void initState() {
    super.initState();
    data = MessageGenerator.generate(60, 1337);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      reverse: true,
      slivers: <Widget>[
        // silver app bar
        const SliverAppBar(
          backgroundColor: Color(0xFF6C7689),
          surfaceTintColor: Color(0xFF6C7689),
          // expandedHeight:50.0,
          collapsedHeight: 60.0,
          automaticallyImplyLeading: false,
          pinned: true,

          flexibleSpace: FlexibleSpaceBar(
            background: EmipaymentFormField(),
          ),
        ),

        // list of messages
        SliverList.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final message = data[index];
            return MessageBubble(
              message: message,
              child: Text(message.text),
            );
          },
        ),
      ],
    );
  }
}

@immutable
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.child,
  });

  final Message message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        message.isMine ? Alignment.topLeft : Alignment.topRight;

    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: BubbleBackground(
              colors: [
                if (message.isMine) ...const [
                  Color(0xFF6C7689),
                  Color(0xFF3A364B),
                ] else ...const [
                  Color(0xFF19B7FF),
                  Color(0xFF491CCB),
                ],
              ],
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: child,
                ),
              ),
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

enum MessageOwner { myself, other }

@immutable
class Message {
  const Message({
    required this.owner,
    required this.text,
  });

  final MessageOwner owner;
  final String text;

  bool get isMine => owner == MessageOwner.myself;
}

class MessageGenerator {
  static List<Message> generate(int count, [int? seed]) {
    final random = Random(seed);
    return List.unmodifiable(List<Message>.generate(count, (index) {
      return Message(
        owner: random.nextBool() ? MessageOwner.myself : MessageOwner.other,
        text: _exampleData[random.nextInt(_exampleData.length)],
      );
    }));
  }

  static final _exampleData = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'In tempus mauris at velit egestas, sed blandit felis ultrices.',
    'Ut molestie mauris et ligula finibus iaculis.',
    'Sed a tempor ligula.',
    'Test',
    'Phasellus ullamcorper, mi ut imperdiet consequat, nibh augue condimentum nunc, vitae molestie massa augue nec erat.',
    'Donec scelerisque, erat vel placerat facilisis, eros turpis egestas nulla, a sodales elit nibh et enim.',
    'Mauris quis dignissim neque. In a odio leo. Aliquam egestas egestas tempor. Etiam at tortor metus.',
    'Quisque lacinia imperdiet faucibus.',
    'Proin egestas arcu non nisl laoreet, vitae iaculis enim volutpat. In vehicula convallis magna.',
    'Phasellus at diam a sapien laoreet gravida.',
    'Fusce maximus fermentum sem a scelerisque.',
    'Nam convallis sapien augue, malesuada aliquam dui bibendum nec.',
    'Quisque dictum tincidunt ex non lobortis.',
    'In hac habitasse platea dictumst.',
    'Ut pharetra ligula libero, sit amet imperdiet lorem luctus sit amet.',
    'Sed ex lorem, lacinia et varius vitae, sagittis eget libero.',
    'Vestibulum scelerisque velit sed augue ultricies, ut vestibulum lorem luctus.',
    'Pellentesque et risus pretium, egestas ipsum at, facilisis lectus.',
    'Praesent id eleifend lacus.',
    'Fusce convallis eu tortor sit amet mattis.',
    'Vivamus lacinia magna ut urna feugiat tincidunt.',
    'Sed in diam ut dolor imperdiet vehicula non ac turpis.',
    'Praesent at est hendrerit, laoreet tortor sed, varius mi.',
    'Nunc in odio leo.',
    'Praesent placerat semper libero, ut aliquet dolor.',
    'Vestibulum elementum leo metus, vitae auctor lorem tincidunt ut.',
  ];
}

class EmipaymentFormField extends StatefulWidget {
  const EmipaymentFormField({super.key});

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      .bodyMedium!
                      .copyWith(color: Colors.white.withOpacity(0.8)),
                  hintText: AppLocalizations.of(context)!.hintRepaymentAmount,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some amount';
                  }
                  return null;
                },
                // onSaved: (newValue) {},
              ),
            ),
            const SizedBox(width: 16.0),
            // !-----------------Pay Button-----------------
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // _formKey.currentState!.save();
                  final numericValue = int.parse(
                      controller.text.replaceAll(',', '').replaceAll('₹', ''));
                  // context.read<UpdateLoanDialogCubit>().updateLoan(
                  //       customer: widget.customer,
                  //       loan: widget.loans[index],
                  //       emiValue: numericValue.toString(),
                  //     );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.greenAccent.shade700),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('PAY'),
            ),
          ],
        ),
      ),
    );
  }
}
