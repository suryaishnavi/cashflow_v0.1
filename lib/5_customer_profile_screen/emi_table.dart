import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../models/ModelProvider.dart';
import '3_emi_details/emi_cubit.dart';

class EmiTable extends StatefulWidget {
  final List<Emi> emiList;

  /// Creates a screen that demonstrates the TableView widget.
  const EmiTable({super.key, required this.emiList});

  @override
  State<EmiTable> createState() => _EmiTableState();
}

class _EmiTableState extends State<EmiTable> {
  late final ScrollController _verticalController = ScrollController();
  i18n () => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n().emiTable),
        centerTitle: true,
      ),
      body: TableView.builder(
        verticalDetails:
            ScrollableDetails.vertical(controller: _verticalController),
        cellBuilder: _buildCell,
        columnCount: 6,
        columnBuilder: _buildColumnSpan,
        rowCount: widget.emiList.length + 1,
        rowBuilder: _buildRowSpan,
      ),
    );
  }

  final List<String> headings = [
    'No.',
    'Installment Date',
    'Paid Date',
    'Amount',
    'Updated Date',
    'Initial Amount',
  ];

  Widget _buildCell(BuildContext context, TableVicinity vicinity) {
    ({TextStyle text, TextStyle heading, TextStyle textModified}) textStyle() {
      return (
        text: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 15.0,
        ),
        textModified: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.red,
          fontSize: 15.0,
        ),
        heading: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 16.0,
        )
      );
    }

    switch (vicinity.row) {
      case 0:
        return Center(
          child: Text(
            headings[vicinity.column],
            textAlign: TextAlign.center,
            style: textStyle().heading,
          ),
        );
    }
    switch (vicinity.column) {
      case 0:
        return Center(
          child: Text(
            '${vicinity.row}',
            textAlign: TextAlign.center,
            style: textStyle().text,
          ),
        );
      case 1:
        return Center(
          child: Text(
            intl.DateFormat('dd-MM-yyyy')
                .format(widget.emiList[vicinity.row - 1].dueDate.getDateTime()),
            textAlign: TextAlign.center,
            style: widget.emiList[vicinity.row - 1].isExtraEmi ?? false
                ? textStyle().textModified
                : textStyle().text,
          ),
        );
      case 2:
        return Center(
          child: Text(
            widget.emiList[vicinity.row - 1].paidDate != null
                ? intl.DateFormat('dd-MM-yyyy').format(
                    widget.emiList[vicinity.row - 1].paidDate?.getDateTime()
                        as DateTime)
                : '-',
            textAlign: TextAlign.center,
            style: textStyle().text,
          ),
        );
      case 3:
        return Center(
          child: widget.emiList[vicinity.row - 1].paidAmount != null
              ? GestureDetector(
                  onTap: () {
                    final Emi emi = widget.emiList[vicinity.row - 1];
                    _showDialog(
                      context: context,
                      updateEmiPaidAmount: updateEmiPaidAmount,
                      emi: emi,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\u{20B9}${widget.emiList[vicinity.row - 1].paidAmount}',
                        textAlign: TextAlign.center,
                        style: textStyle().text,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.blue[900],
                      ),
                    ],
                  ),
                )
              : Text(
                  '-',
                  textAlign: TextAlign.center,
                  style: textStyle().text,
                ),
        );
      case 4:
        return Center(
          child: widget.emiList[vicinity.row - 1].updatedDate != null
              ? Text(
                  intl.DateFormat('dd-MM-yyyy').format(widget
                      .emiList[vicinity.row - 1].updatedDate
                      ?.getDateTime() as DateTime),
                  textAlign: TextAlign.center,
                  style: textStyle().textModified,
                )
              : Text('-', textAlign: TextAlign.center, style: textStyle().text),
        );
      case 5:
        return Center(
            child: widget.emiList[vicinity.row - 1].initialAmount != null
                ? Text(
                    '\u{20B9}${widget.emiList[vicinity.row - 1].initialAmount}',
                    textAlign: TextAlign.center,
                    style: textStyle().textModified,
                  )
                : Text(
                    '-',
                    textAlign: TextAlign.center,
                    style: textStyle().text,
                  ));
    }
    return const Center(
      child: Text(
        'Not found',
        textAlign: TextAlign.center,
      ),
    );
  }

  ({TableSpan columnTableSpan, TableSpan rowTableSpan}) columnSpan(int index) {
    final TableSpanDecoration rowDecoration = TableSpanDecoration(
      color: index == 0
          ? Colors.blue[900]
          : (index.isOdd ? Colors.white : Colors.blue[50]),
    );
    TableSpanDecoration columnDecoration = const TableSpanDecoration(
      border: TableSpanBorder(
        trailing: BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
      ),
    );
    return (
      columnTableSpan: TableSpan(
        foregroundDecoration: columnDecoration,
        extent: FractionalTableSpanExtent((index == 0) ? 0.15 : 0.35),
        // recognizerFactories: <Type, GestureRecognizerFactory>{
        //   TapGestureRecognizer:
        //       GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
        //     () => TapGestureRecognizer(),
        //     (TapGestureRecognizer t) =>
        //         t.onTap = () => print('Tap coulmn $index'),
        //   ),
        // },
      ),
      rowTableSpan: TableSpan(
        backgroundDecoration: rowDecoration,
        extent: const FractionalTableSpanExtent(0.065),
        // recognizerFactories: <Type, GestureRecognizerFactory>{
        //   TapGestureRecognizer:
        //       GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
        //     () => TapGestureRecognizer(),
        //     (TapGestureRecognizer t) => t.onTap = () => print('Tap row $index'),
        //   ),
        // },
      ),
    );
  }

  TableSpan _buildColumnSpan(int index) {
    for (var i = 0; i < headings.length; i++) {
      if (index == i) {
        return columnSpan(index).columnTableSpan;
      }
    }
    throw AssertionError(
        'This should be unreachable, as every index is accounted for in the switch clauses.');
  }

  TableSpan _buildRowSpan(int index) {
    for (var i = 0; i < widget.emiList.length + 1; i++) {
      if (index == i) {
        return columnSpan(index).rowTableSpan;
      }
    }
    throw AssertionError(
        'This should be unreachable, as every index is accounted for in the switch clauses.');
  }

  updateEmiPaidAmount(
      {required String newAmount,
      required DateTime newDate,
      required Emi emi}) {
    context.read<EmiCubit>().updateEmiPaidAmount(
          emi: emi,
          newAmount: double.parse(newAmount).round(),
          newDate: newDate,
        );
  }

  _showDialog({
    required BuildContext context,
    required Emi emi,
    required Function updateEmiPaidAmount,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        TextEditingController emiPaidController = TextEditingController();
        TextEditingController emiDateController = TextEditingController();
        emiPaidController.text = emi.paidAmount.toString();
        emiDateController.text = emi.paidDate.toString().split(' ')[0];
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close, color: Colors.red),
              ),
              const SizedBox(width: 16),
              Text(
                AppLocalizations.of(context)!.updateAmount,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // * Date Field to update
              TextFormField(
                controller: emiDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Enter Date',
                  // AppLocalizations.of(context)!.updateDateHint,
                  labelText: 'Date',
                  // AppLocalizations.of(context)!.updateDateLabel,
                ),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: emi.paidDate!.getDateTime(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    emiDateController.text =
                        pickedDate.toString().split(' ')[0];
                  }
                },
              ),

              const SizedBox(height: 20),
              // * update amount
              TextFormField(
                controller: emiPaidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.updateAmountHint,
                  labelText: AppLocalizations.of(context)!.updateAmountLabel,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (emiPaidController.text.length < 6) {
                  updateEmiPaidAmount(
                    newAmount: emiPaidController.text,
                    newDate: DateTime.parse(emiDateController.text),
                    emi: emi,
                  );
                  emiPaidController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.updateAmountError),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}


  /*  SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: DataTable(
        columnSpacing: 25,
        headingRowColor: MaterialStateProperty.all(Colors.lightBlue[900]),
        headingTextStyle: const TextStyle(
          color: Colors.white,
        ),
        // horizontalMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        showBottomBorder: false,
        dividerThickness: 0.0,
        showCheckboxColumn: false,
        columns: [
          DataColumn(
            label: Text(
              AppLocalizations.of(context)!.number,
              textAlign: TextAlign.center,
            ),
          ),
          DataColumn(
            label: Text(AppLocalizations.of(context)!.installmentDate,
                textAlign: TextAlign.center),
          ),
          DataColumn(
            label: Text(AppLocalizations.of(context)!.paidDate,
                textAlign: TextAlign.center),
          ),
          DataColumn(
            label: Text(AppLocalizations.of(context)!.amount,
                textAlign: TextAlign.center),
          ),
          const DataColumn(
              label: Text('Updated Date', textAlign: TextAlign.center)),
          const DataColumn(
              label: Text('Updated Amount', textAlign: TextAlign.center)),
        ],
        rows: [
          for (var i = 0; i < emiList.length; i++)
            DataRow(
              cells: [
                DataCell(
                  Text(
                    emiList[i].emiNumber.toString(),
                    textAlign: TextAlign.center,
                    style: textStyle(),
                  ),
                ),
                DataCell(
                  Text(
                    intl.DateFormat('dd-MM-yyyy')
                        .format(emiList[i].dueDate.getDateTime()),
                    textAlign: TextAlign.center,
                    style: textStyle(),
                  ),
                ),
                DataCell(
                  Text(
                    emiList[i].paidDate != null
                        ? intl.DateFormat('dd-MM-yyyy').format(
                            emiList[i].paidDate?.getDateTime() as DateTime)
                        : '-',
                    textAlign: TextAlign.center,
                    style: textStyle(),
                  ),
                ),
                DataCell(
                  showEditIcon: emiList[i].paidAmount != null ? true : false,
                  onTap: () {
                    if (emiList[i].paidAmount != null) {
                      final Emi emi = emiList[i];
                      _showDialog(
                        context: context,
                        updateEmiPaidAmount: updateEmiPaidAmount,
                        emi: emi,
                      );
                    }
                  },
                  Text(
                    emiList[i].paidAmount != null
                        ? '\u{20B9}${emiList[i].paidAmount}'
                        : '-',
                    textAlign: TextAlign.center,
                    style: textStyle(),
                  ),
                ),
                DataCell(
                  Text(
                    emiList[i].updatedDate != null
                        ? intl.DateFormat('dd-MM-yyyy').format(
                            emiList[i].updatedDate?.getDateTime() as DateTime)
                        : '-',
                    textAlign: TextAlign.center,
                    style: textStyle(),
                  ),
                ),
                DataCell(
                  Text(
                    emiList[i].updatedAmount != null
                        ? '\u{20B9}${emiList[i].updatedAmount}'
                        : '-',
                    textAlign: TextAlign.center,
                    style: textStyle(),
                  ),
                ),
              ],
              // * alternate row color
              color: i % 2 == 0
                  ? MaterialStateProperty.all(Colors.white)
                  : MaterialStateProperty.all(Colors.lightBlue[50]),
            ),
        ],
      ),
    );

*/