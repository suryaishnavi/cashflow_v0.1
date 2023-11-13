import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/ModelProvider.dart';
import '../../0_repositories/circle_data_repository.dart';
import '../../0_repositories/for_reports_generation/get_customer_data.dart';
import '../../1_session/session_cubit/session_cubit.dart';
import '../api/pdf_api.dart';
import '../models/new_customer_print_model.dart';
import '../models/new_emi_print_model.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  SessionCubit sessionCubit;
  CircleDataRepository circleDataRepo;
  GetCustomerData getCustomerData;
  ReportCubit({
    required this.sessionCubit,
    required this.circleDataRepo,
    required this.getCustomerData,
  }) : super(LoadingState()) {
    getCircles();
  }

  void getCircles() async {
    emit(LoadingState());
    try {
      final List<Circle> circles =
          await circleDataRepo.getCircles(id: sessionCubit.user.id);
      emit(
        CirclesLoadedState(circles),
      );
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  void generateReport({
    required Circle circle,
    required DateTime date,
  }) {
    try {
      TemporalDate temporalDate =
          TemporalDate.fromString(date.toString().split(' ')[0]);
      emit(LoadingState());
      fetchData(circle: circle, temporalDate: temporalDate);
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

// --- Fetching all the circle data from the server.

  Future<void> fetchData({
    required Circle circle,
    required TemporalDate temporalDate,
  }) async {
    try {
      final List<Customer> customers =
          await getCustomerData.getCustomers(circleId: circle.id);

      final List<Loan> loans = [];
      final List<Emi> emis = [];

      for (final customer in customers) {
        final customerLoans =
            await getCustomerData.getLoan(customerId: customer.id);
        loans.addAll(customerLoans);
      }

      for (final loan in loans) {
        final loanEmis = await getCustomerData.getEmi(
          loanId: loan.id,
          date: temporalDate,
        );
        emis.addAll(loanEmis);
      }

      final List<Loan> filteredLoans = loans
          .where((l) => l.dateOfCreation == temporalDate)
          .toList()
        ..sort((a, b) => a.loanIdentity.compareTo(b.loanIdentity));

      final List<Emi> filteredEmis = emis
          .where((e) => e.paidDate == temporalDate)
          .toList()
        ..sort((a, b) => a.loanIdentity.compareTo(b.loanIdentity));

      if (filteredLoans.isEmpty && filteredEmis.isEmpty) {
        emit(const EmptyState(
            message:
                'No new loans or installments occurred on the selected date'));
        return;
      }
      final pw.Document document = await generateInvoiceDocument(
        newCustomers: generatePrintModels(
          customers: customers,
          loans: filteredLoans,
          emis: filteredEmis,
        ).newCustomers,
        newEmis: generatePrintModels(
          customers: customers,
          loans: filteredLoans,
          emis: filteredEmis,
        ).newEmis,
        circle: circle,
      );
      emit(DocsReadyState(document));
    } catch (e) {
      // Handle and log the error appropriately
      // print('An error occurred while fetching data: $e');
      emit(ReportError(e.toString()));
    }
  }
  

  ({
    List<NewCustomerPrintModel> newCustomers,
    List<NewEmiPrintModel> newEmis,
  }) generatePrintModels({
    required List<Customer> customers,
    required List<Loan> loans,
    required List<Emi> emis,
  }) {
    final List<NewCustomerPrintModel> newCustomerPrintModels = [];
    final List<NewEmiPrintModel> newEmiPrintModels = [];

    // for each loan in loans, find the customer and add it to newCustomerPrintModels
    for (final loan in loans) {
      final customer = customers.firstWhere((c) => c.id == loan.customerID);
      newCustomerPrintModels.add(
        NewCustomerPrintModel(
          name: customer.customerName,
          city: customer.city.name,
          phone: customer.phone,
          bookId: loan.loanIdentity,
          tenure: loan.totalEmis,
          givenAmount: loan.givenAmount,
          collectbleAmount: loan.collectibleAmount,
          date: loan.dateOfCreation,
          // oldBookNumber: loan.oldBookNumber,
          // oldBookAmount: loan.oldBookAmount,
        ),
      );
    }
    // for each emi in emis generate newEmiPrintModels
    for (final emi in emis) {
      newEmiPrintModels.add(
        NewEmiPrintModel(
          bookId: emi.loanIdentity,
          name: emi.customerName,
          emiAmount: emi.paidAmount!,
          date: emi.paidDate!,
        ),
      );
    }

    return (
      newCustomers: newCustomerPrintModels,
      newEmis: newEmiPrintModels,
    );
  }

  Future<pw.Document> generateInvoiceDocument({
    required List<NewCustomerPrintModel> newCustomers,
    required List<NewEmiPrintModel> newEmis,
    required Circle circle,
  }) async {
    if (newCustomers.isEmpty && newEmis.isNotEmpty) {
      return PdfApi.pdfInvoiceEmis(
        emis: newEmis,
        circle: circle,
      );
    } else if (newCustomers.isNotEmpty && newEmis.isEmpty) {
      return PdfApi.pdfInvoiceLoans(
        customers: newCustomers,
        circle: circle,
      );
    } else {
      return PdfApi.pdfInvoice(
        circle: circle,
        customers: newCustomers,
        emis: newEmis,
      );
    }
  }
}
