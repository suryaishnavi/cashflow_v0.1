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

  void storeCredentials({
    required Circle circle,
    required DateTime date,
  }) {
    try {
      TemporalDate temporalDate = TemporalDate.fromString(date.toString().split(' ')[0]);
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
        final loanEmis = await getCustomerData.getEmi(loanId: loan.id);
        emis.addAll(loanEmis);
      }

      final List<Loan> filteredLoans =
          loans.where((l) => l.dateOfCreation == temporalDate).toList();

      final List<Emi> filteredEmis =
          emis.where((e) => e.paidDate == temporalDate).toList();

      if (filteredLoans.isEmpty && filteredEmis.isEmpty) {
        emit(const EmptyState(
            message: 'It seems like there is no data for this date'));
      } else {
        final pw.Document document = await generateInvoiceDocument(
          customers: customers,
          loans: filteredLoans,
          emis: filteredEmis,
          circle: circle,
        );
        emit(DocsReadyState(document));
      }
    } catch (e) {
      // Handle and log the error appropriately
      // print('An error occurred while fetching data: $e');
      emit(ReportError(e.toString()));
    }
  }

  Future<pw.Document> generateInvoiceDocument({
    required List<Customer> customers,
    required List<Loan> loans,
    required List<Emi> emis,
    required Circle circle,
  }) async {
    if (loans.isEmpty && emis.isNotEmpty) {
      return PdfApi.pdfInvoiceEmis(
        emis: emis,
        circle: circle,
      );
    } else if (loans.isNotEmpty && emis.isEmpty) {
      return PdfApi.pdfInvoiceLoans(
        customers: customers,
        loans: loans,
        circle: circle,
      );
    } else {
      return PdfApi.pdfInvoice(
        circle: circle,
        customers: customers,
        loans: loans,
        emis: emis,
      );
    }
  }
}
