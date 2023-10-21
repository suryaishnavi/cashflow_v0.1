part of 'show_and_hide_loan_details_bloc.dart';

sealed class ShowAndHideLoanDetailsEvent extends Equatable {
  const ShowAndHideLoanDetailsEvent();

  @override
  List<Object> get props => [];
}

class ShowLoanDetailsEvent extends ShowAndHideLoanDetailsEvent {
  const ShowLoanDetailsEvent();

  @override
  List<Object> get props => [];
}

class HideLoanDetailsEvent extends ShowAndHideLoanDetailsEvent {
  const HideLoanDetailsEvent();

  @override
  List<Object> get props => [];
}