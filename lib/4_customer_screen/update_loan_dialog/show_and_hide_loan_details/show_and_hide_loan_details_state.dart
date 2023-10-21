part of 'show_and_hide_loan_details_bloc.dart';

sealed class ShowAndHideLoanDetailsState extends Equatable {
  const ShowAndHideLoanDetailsState();

  @override
  List<Object> get props => [];
}

final class ShowAndHideLoanDetailsInitial extends ShowAndHideLoanDetailsState {}

final class ShowLoanDetailsState extends ShowAndHideLoanDetailsState {}

final class HideLoanDetailsState extends ShowAndHideLoanDetailsState {}
