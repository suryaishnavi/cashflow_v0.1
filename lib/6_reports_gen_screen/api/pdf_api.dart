import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../models/ModelProvider.dart';

class PdfApi {
  static Future<pw.Document> pdfInvoice({
    required List<Customer> customers,
    required List<Loan> loans,
    required List<Emi> emis,
    required Circle circle,
  }) async {
    final doc = pw.Document(
        compress: true,
        pageMode: PdfPageMode.outlines,
        author: 'Surya',
        creator: 'CFC',
        title: 'CREATING DAILY TRANSACTIONS PDF');
    final customFont =
        await fontFromAssetBundle('assets/fonts/NotoSerifTelugu-Regular.ttf');

    // Calculate the total amount of loans
    final double totalLoanAmount = loans.fold(
      0.0,
      (previousValue, loan) => previousValue + loan.givenAmount,
    );

    // Create a list of rows for the loan table
    final List<pw.TableRow> loanRows = [
      pw.TableRow(
        children: [
          pw.Container(
            height: 30,
            child: pw.Text('S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Loan S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Phone',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Given Amount',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
        ],
      ),
      ...loans.asMap().entries.map(
        (entry) {
          final index = entry.key + 1;
          final loan = entry.value;
          final customer = customers.firstWhere((c) => c.id == loan.customerID);
          return pw.TableRow(
            children: [
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('$index',
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(customer.loanIdentity,
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  customer.customerName.length > 25
                      ? '${customer.customerName.substring(0, 25)}...'
                      : customer.customerName,
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: customFont,
                  ),
                ),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(customer.phone.substring(3),
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(loan.givenAmount)}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
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
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
              '-----------\nTotal \u{20B9}${intl.NumberFormat('#,##,000').format(totalLoanAmount)}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 13,
                font: customFont,
              ),
            ),
          ),
        ],
      ),
    ];

    pw.Widget headers() {
      return pw.Container(
          color: PdfColors.grey100,
          child: pw.Text(
              'Report for the ${circle.circleName} circle on ${intl.DateFormat('dd-MM-yyyy').format(getDate(tDate: loans[0].dateOfCreation))}',
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 15)),
          width: double.infinity,
          alignment: pw.Alignment.center);
    }

    // Calculate the number of pages needed for the loan table
    final int loanPages = (loanRows.length / 20).ceil();

    // Add loan table pages
    for (int i = 0; i < loanPages; i++) {
      final startIndex = i * 20;
      final endIndex = (i + 1) * 20;
      final pageLoanRows = loanRows.sublist(
          startIndex, endIndex > loanRows.length ? loanRows.length : endIndex);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              headers(),
              pw.SizedBox(height: 20),
              if (i == 0)
                pw.Text('*** New Customers ***',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                      font: customFont,
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
      (previousValue, emi) =>
          previousValue + (emi.paidAmount != null ? emi.paidAmount! : 0),
    );

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
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Loan S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('EMI No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Paid Amount',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: customFont,
                )),
          ),
        ],
      ),
      ...emis.asMap().entries.map(
        (entry) {
          final index = entry.key + 1;
          final emi = entry.value;
          return pw.TableRow(
            children: [
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('$index',
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(emi.loanIdentity,
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  emi.customerName.toString().length > 25
                      ? '${emi.customerName.toString().substring(0, 25)}...'
                      : emi.customerName.toString(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: customFont,
                  ),
                ),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(emi.emiNumber.toString(),
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
                    )),
              ),
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(emi.paidAmount)}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      font: customFont,
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
          pw.Text(''),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
              '-----------\nTotal \u{20B9}${intl.NumberFormat('#,##,000').format(totalPaidEmiAmount)}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 13,
                font: customFont,
              ),
            ),
          ),
        ],
      ),
    ];

    // Calculate the number of pages needed for the emi table
    final int emiPages = (emiRows.length / 27).ceil();

    // Add emi table pages
    for (int i = 0; i < emiPages; i++) {
      final startIndex = i * 27;
      final endIndex = (i + 1) * 27;
      final pageEmiRows = emiRows.sublist(
        startIndex,
        endIndex > emiRows.length ? emiRows.length : endIndex,
      );

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (i == 0)
                pw.Text('*** Collection Amount Details ***',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                      font: customFont,
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

  static DateTime getDate({required TemporalDate tDate}) {
    DateTime convertedDate = tDate.getDateTime();
    return convertedDate;
  }

  //! ---------ONLY NEW CUSTOMER PDF------------

  static Future<pw.Document> pdfInvoiceLoans({
    required List<Customer> customers,
    required List<Loan> loans,
    required Circle circle,
  }) async {
    final doc = pw.Document(
        pageMode: PdfPageMode.outlines,
        author: 'Surya',
        creator: 'CFC',
        title: 'ONLY NEW CUSTOMER PDF');
    final font =
        await rootBundle.load("assets/fonts/NotoSerifTelugu-Regular.ttf");
    final poppins = pw.Font.ttf(font);
    // await fontFromAssetBundle('assets/fonts/NotoSansTelugu-Regular.ttf');

    // Calculate the total amount of loans
    final double totalLoanAmount = loans.fold(
        0.0, (previousValue, loan) => previousValue + loan.givenAmount);

    // header
    pw.Widget headers() {
      return pw.Container(
          color: PdfColors.grey100,
          child: pw.Text(
              'Report for the ${circle.circleName} circle on ${intl.DateFormat('dd-MM-yyyy').format(getDate(tDate: loans[0].dateOfCreation))}',
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 17)),
          width: double.infinity,
          alignment: pw.Alignment.center);
    }

    // Define the maximum number of rows that can fit on a page
    const int maxRowsPerPage = 30;

    // Create a list of rows for the loan table
    final List<pw.TableRow> loanRows = [
      pw.TableRow(
        children: [
          pw.Container(
            height: 30,
            child: pw.Text('S.No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: poppins,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: poppins,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Phone',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: poppins,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Given Amount',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: poppins,
                )),
          ),
        ],
      ),

      ...loans.asMap().entries.map(
        (entry) {
          final index = entry.key + 1;
          final loan = entry.value;
          final customer = customers.firstWhere((c) => c.id == loan.customerID);
          return pw.TableRow(
            children: [
              pw.Container(
                height: 25,
                color: index % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text('$index',
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
                        text: customer.customerName.length > 25
                            ? '${customer.customerName.substring(0, 25)}...'
                            : customer.customerName,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ))),
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
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                    '\u{20B9}${intl.NumberFormat('#,##,000').format(loan.givenAmount)}',
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
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Text(
                '-----------\nTotal \u{20B9}${intl.NumberFormat('#,##,000').format(totalLoanAmount)}',
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
          theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: poppins)),
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
    required List<Emi> emis,
    required Circle circle,
  }) async {
    final doc = pw.Document(
        pageMode: PdfPageMode.outlines,
        author: 'Surya',
        creator: 'CFC',
        title: 'ONLY EMIS PDF');
    final poppins =
        await fontFromAssetBundle('assets/fonts/NotoSerifTelugu-Regular.ttf');

    // Calculate the total amount of paid emis
    final double totalEmiAmount = emis.fold(
      0.0,
      (previousValue, emi) =>
          previousValue + (emi.paidAmount != null ? emi.paidAmount! : 0),
    );
    pw.Widget headers() {
      return pw.Container(
          color: PdfColors.grey100,
          child: pw.Text(
              'Report for the ${circle.circleName} circle on ${intl.DateFormat('dd-MM-yyyy').format(getDate(tDate: emis[0].paidDate!))}',
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
                  font: poppins,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Name',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: poppins,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('EMI No.',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: poppins,
                )),
          ),
          pw.Container(
            height: 30,
            child: pw.Text('Paid Amount',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                  font: poppins,
                )),
          ),
        ],
      ),
    ];

    int serialNumber = 1;
    for (final emi in emis) {
      emiRows.add(
        pw.TableRow(
          children: [
            pw.Container(
              height: 25,
              color:
                  serialNumber % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(serialNumber.toString(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: poppins,
                  )),
            ),
            pw.Container(
              height: 25,
              color:
                  serialNumber % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                  emi.customerName.toString().length > 25
                      ? '${emi.customerName.toString().substring(0, 25)}...'
                      : emi.customerName.toString(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: poppins,
                  )),
            ),
            pw.Container(
              height: 25,
              color:
                  serialNumber % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(emi.emiNumber.toString(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: poppins,
                  )),
            ),
            pw.Container(
              height: 25,
              color:
                  serialNumber % 2 == 0 ? PdfColors.grey100 : PdfColors.white,
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                  '\u{20B9}${intl.NumberFormat('#,##,000').format(emi.paidAmount)}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: poppins,
                  )),
            ),
          ],
        ),
      );
      serialNumber++;
    }

    const int maxRowsPerPage = 30;
    int numRows = emiRows.length;
    int startIndex = 0;

    while (startIndex < numRows) {
      int endIndex = startIndex + maxRowsPerPage;
      if (endIndex > numRows) {
        endIndex = numRows;
      }

      final List<pw.TableRow> currentPageRows =
          emiRows.sublist(startIndex, endIndex);

      doc.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              headers(),
              pw.SizedBox(height: 20),
              pw.Text(
                '*** Collection Amount Details ***',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                  font: poppins,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table(
                children: currentPageRows,
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 10),
                    child: pw.Text(
                      '-----------\nTotal \u{20B9}${intl.NumberFormat('#,##,000').format(totalEmiAmount)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                        font: poppins,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
      startIndex = endIndex;
    }
    return doc;
  }
}
