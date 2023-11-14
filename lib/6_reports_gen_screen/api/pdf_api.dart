import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/ModelProvider.dart';
import '../models/new_customer_print_model.dart';
import '../models/new_emi_print_model.dart';

class PdfApi {
  static DateTime getDate({required TemporalDate tDate}) {
    DateTime convertedDate = tDate.getDateTime();
    return convertedDate;
  }

  static Future<pw.Document> pdfInvoice({
    required List<NewCustomerPrintModel> customers,
    required List<NewEmiPrintModel> emis,
    required Circle circle,
  }) async {
    final doc = pw.Document(
      compress: true,
      pageMode: PdfPageMode.outlines,
      author: 'Surya',
      creator: 'CFC',
      title: 'CREATING DAILY TRANSACTIONS PDF',
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load("assets/fonts/NotoSerifTelugu-Regular.ttf")),
        bold: pw.Font.ttf(
            await rootBundle.load("assets/fonts/NotoSerifTelugu-Bold.ttf")),
      ),
    );

    // Calculate total Collectble Amount
    final double totalCollectableAmont = customers.fold(
        0.0,
        (previousValue, customers) =>
            previousValue + customers.collectbleAmount);
    // Calculate total Interest
    final double totalInterest = customers.fold(
        0.0, (previousValue, customers) => previousValue + customers.interest);
    // Calculate total Given Amount
    final double totalGivenAmount = customers.fold(0.0,
        (previousValue, customers) => previousValue + customers.givenAmount);

    // Define the maximum number of rows that can fit on a page
    const int maxRowsPerPage = 15;

    // customers new Loan Headers
    pw.Widget loanHeaders() {
      return pw.Container(
          color: PdfColors.grey100,
          child: pw.Text(
              'Report for the ${circle.circleName} circle on ${intl.DateFormat('dd-MM-yyyy').format(getDate(tDate: customers[0].date))}',
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 17)),
          width: double.infinity,
          alignment: pw.Alignment.center);
    }

    // Create a list of rows for the loan table
    // Create a list of rows for the loan table
    final List<pw.TableRow> loanRows = [
      pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          pw.Container(
            height: 30,
            child: pw.Text('S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Address',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('phone',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('tenure',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Collectable',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Interest',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Given',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
        ],
      ),

      ...customers.asMap().entries.map(
        (entry) {
          final index = entry.key;
          // final loan = entry.value;
          final customer = entry.value;
          // final customer = customers.firstWhere((c) => c.id == loan.customerID);
          return pw.TableRow(
            children: [
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(customer.bookId,
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.RichText(
                    text: pw.TextSpan(
                        text: customer.name.length > 25
                            ? '${customer.name.substring(0, 25)}...'
                            : customer.name,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ))),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    customer.city.length > 25
                        ? '${customer.city.substring(0, 25)}...'
                        : customer.city,
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(customer.phone.substring(3),
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.center,
                child: pw.Text('${customer.tenure}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.center,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(customer.collectbleAmount)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.center,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(customer.interest)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(customer.givenAmount)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
            ],
          );
        },
      ),
      // total column
      pw.TableRow(
        children: [
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
                '-------------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalCollectableAmont)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
                '-------------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalInterest)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
                '-------------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalGivenAmount)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          )
        ],
      ),
    ];

    // Calculate the number of pages needed for the loan table
    final int loanPages = (loanRows.length / maxRowsPerPage).ceil();

    // Add loan table pages
    for (int i = 0; i < loanPages; i++) {
      final startIndex = i * maxRowsPerPage;
      final endIndex = (i + 1) * maxRowsPerPage;
      final pageLoanRows = loanRows.sublist(
          startIndex, endIndex > loanRows.length ? loanRows.length : endIndex);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              loanHeaders(),
              pw.SizedBox(height: 20),
              pw.Text('*** New Customers ***',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  )),
              pw.SizedBox(height: 10),
              pw.Table(
                children: pageLoanRows,
              ),
            ],
          ),
        ),
      );
    }

    //* ---EMI TABLE---

    // Calculate the total amount of paid emis
    final double totalPaidEmiAmount = emis.fold(
      0.0,
      (previousValue, emi) => previousValue + emi.emiAmount,
    );
    // Define the maximum number of rows that can fit on a page
    const int maxEmiRowsPerPage = 20;

    pw.Widget emiHeaders() {
      return pw.Container(
          color: PdfColors.grey100,
          child: pw.Text(
              'Report for the ${circle.circleName} circle on ${intl.DateFormat('dd-MM-yyyy').format(getDate(tDate: customers[0].date))}',
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 17)),
          width: double.infinity,
          alignment: pw.Alignment.center);
    }

    // Create a list of rows for the emi table
    final List<pw.TableRow> emiRows = [
      pw.TableRow(
        children: [
          pw.Container(
            height: 30,
            child: pw.Text('S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('City',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Installment',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
        ],
      ),
      ...emis.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final emi = entry.value;
          return pw.TableRow(
            children: [
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(emi.bookId,
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  emi.name.toString().length > 25
                      ? '${emi.name.toString().substring(0, 25)}...'
                      : emi.name.toString(),
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  emi.city.toString().length > 25
                      ? '${emi.city.toString().substring(0, 25)}...'
                      : emi.city.toString(),
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,###').format(emi.emiAmount)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
            ],
          );
        },
      ),
      pw.TableRow(
        children: [
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
              '-----------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalPaidEmiAmount)}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ];

    // Calculate the number of pages needed for the emi table
    final int emiPages = (emiRows.length / maxEmiRowsPerPage).ceil();

    // Add emi table pages
    for (int i = 0; i < emiPages; i++) {
      final startIndex = i * maxEmiRowsPerPage;
      final endIndex = (i + 1) * maxEmiRowsPerPage;
      final pageEmiRows = emiRows.sublist(
        startIndex,
        endIndex > emiRows.length ? emiRows.length : endIndex,
      );

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.portrait,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              emiHeaders(),
              pw.SizedBox(height: 20),
              pw.Text('*** Collection Amount Details ***',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  )),
              pw.SizedBox(height: 10),
              pw.Table(
                children: pageEmiRows,
              ),
            ],
          ),
        ),
      );
    }
    return doc;
  }

  // ! -----Generate pdf ONLY WHEN NEW CUSTOMERS are avaliable-----

  static Future<pw.Document> pdfInvoiceLoans({
    required List<NewCustomerPrintModel> customers,
    required Circle circle,
  }) async {
    final doc = pw.Document(
        pageMode: PdfPageMode.outlines,
        title: 'ONLY NEW CUSTOMER PDF',
        author: 'Surya',
        creator: 'CFC',
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(await rootBundle
              .load("assets/fonts/NotoSerifTelugu-Regular.ttf")),
          bold: pw.Font.ttf(
              await rootBundle.load("assets/fonts/NotoSerifTelugu-Bold.ttf")),
        ));

    // Calculate total Collectble Amount
    final double totalCollectableAmont = customers.fold(
        0.0,
        (previousValue, customers) =>
            previousValue + customers.collectbleAmount);
    // Calculate total Interest
    final double totalInterest = customers.fold(
        0.0, (previousValue, customers) => previousValue + customers.interest);
    // Calculate total Given Amount
    final double totalGivenAmount = customers.fold(0.0,
        (previousValue, customers) => previousValue + customers.givenAmount);

    // Page Heading
    pw.Widget headers() {
      return pw.Container(
          color: PdfColors.grey100,
          child: pw.Text(
              'Report for the ${circle.circleName} circle on ${intl.DateFormat('dd-MM-yyyy').format(getDate(tDate: customers[0].date))}',
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 17)),
          width: double.infinity,
          alignment: pw.Alignment.center);
    }

    // Define the maximum number of rows that can fit on a page
    const int maxRowsPerPage = 15;

    // Create a list of rows for the loan table
    final List<pw.TableRow> loanRows = [
      pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          pw.Container(
            height: 30,
            child: pw.Text('S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Address',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('phone',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('tenure',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Collectable',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Interest',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Given',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
        ],
      ),

      ...customers.asMap().entries.map(
        (entry) {
          final index = entry.key;
          // final loan = entry.value;
          final customer = entry.value;
          // final customer = customers.firstWhere((c) => c.id == loan.customerID);
          return pw.TableRow(
            children: [
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(customer.bookId,
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.RichText(
                    text: pw.TextSpan(
                        text: customer.name.length > 25
                            ? '${customer.name.substring(0, 25)}...'
                            : customer.name,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ))),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    customer.city.length > 25
                        ? '${customer.city.substring(0, 25)}...'
                        : customer.city,
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(customer.phone.substring(3),
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.center,
                child: pw.Text('${customer.tenure}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.center,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(customer.collectbleAmount)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.center,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(customer.interest)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(customer.givenAmount)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
            ],
          );
        },
      ),
      // total column
      pw.TableRow(
        children: [
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
                '-------------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalCollectableAmont)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
                '-------------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalInterest)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
                '-------------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalGivenAmount)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          )
        ],
      ),
    ];

    // Calculate the number of pages needed
    final int numPages = (loanRows.length / maxRowsPerPage).ceil();

    // Create each page
    for (int pageNum = 1; pageNum <= numPages; pageNum++) {
      final startIndex = (pageNum - 1) * maxRowsPerPage;
      final endIndex = pageNum * maxRowsPerPage < loanRows.length
          ? pageNum * maxRowsPerPage
          : loanRows.length;
      final pageRows = loanRows.sublist(startIndex, endIndex);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              headers(),
              pw.SizedBox(height: 20),
              pw.Text('*** New Customers ***',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  )),
              pw.SizedBox(height: 10),
              pw.Table(
                children: pageRows,
              ),
            ],
          ),
        ),
      );
    }
    return doc;
  }

  //! ---------ONLY EMI PDF---------------------
  static Future<pw.Document> pdfInvoiceEmis({
    required List<NewEmiPrintModel> emis,
    required Circle circle,
  }) async {
    final doc = pw.Document(
      pageMode: PdfPageMode.outlines,
      author: 'Surya',
      creator: 'CFC',
      title: 'ONLY EMIS PDF',
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load("assets/fonts/NotoSerifTelugu-Regular.ttf")),
        bold: pw.Font.ttf(
            await rootBundle.load("assets/fonts/NotoSerifTelugu-Bold.ttf")),
      ),
    );

    // Calculate the total amount of paid emis
    final double totalPaidEmiAmount = emis.fold(
      0.0,
      (previousValue, emi) => previousValue + emi.emiAmount,
    );
    // Define the maximum number of rows that can fit on a page
    const int maxEmiRowsPerPage = 25;

    pw.Widget emiHeaders() {
      return pw.Container(
          color: PdfColors.grey100,
          child: pw.Text(
              'Report for the ${circle.circleName} circle on ${intl.DateFormat('dd-MM-yyyy').format(getDate(tDate: emis[0].date))}',
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 17)),
          width: double.infinity,
          alignment: pw.Alignment.center);
    }

    // Create a list of rows for the emi table
    List<pw.TableRow> emiRows = [
      pw.TableRow(
        children: [
          pw.Container(
            height: 30,
            child: pw.Text('S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('City',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Installment',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                )),
          ),
        ],
      ),
      ...emis.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final emi = entry.value;
          return pw.TableRow(
            children: [
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(emi.bookId,
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  emi.name.toString().length > 25
                      ? '${emi.name.toString().substring(0, 25)}...'
                      : emi.name.toString(),
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  emi.city.toString().length > 25
                      ? '${emi.city.toString().substring(0, 25)}...'
                      : emi.city.toString(),
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,###').format(emi.emiAmount)}',
                    style: const pw.TextStyle(
                      fontSize: 12,
                    )),
              ),
            ],
          );
        },
      ),
      pw.TableRow(
        children: [
          pw.Text(''),
          pw.Text(''),
          pw.Text(''),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
              '-----------\n\u{20B9}${intl.NumberFormat('#,##,###').format(totalPaidEmiAmount)}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ];

    // Calculate the number of pages needed for the emi table
    final int emiPages = (emiRows.length / maxEmiRowsPerPage).ceil();

    // Add emi table pages
    for (int i = 0; i < emiPages; i++) {
      final startIndex = i * maxEmiRowsPerPage;
      final endIndex = (i + 1) * maxEmiRowsPerPage;
      final pageEmiRows = emiRows.sublist(
        startIndex,
        endIndex > emiRows.length ? emiRows.length : endIndex,
      );

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.portrait,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              emiHeaders(),
              pw.SizedBox(height: 20),
              pw.Text('*** Collection Amount Details ***',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  )),
              pw.SizedBox(height: 10),
              pw.Table(
                children: pageEmiRows,
              ),
            ],
          ),
        ),
      );
    }
    return doc;
  }
}
