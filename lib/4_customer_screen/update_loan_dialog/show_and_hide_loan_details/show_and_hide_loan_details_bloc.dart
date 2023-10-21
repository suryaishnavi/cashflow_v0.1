import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'show_and_hide_loan_details_event.dart';
part 'show_and_hide_loan_details_state.dart';

class ShowAndHideLoanDetailsBloc
    extends Bloc<ShowAndHideLoanDetailsEvent, ShowAndHideLoanDetailsState> {
  ShowAndHideLoanDetailsBloc() : super(ShowAndHideLoanDetailsInitial()) {
    on<ShowLoanDetailsEvent>((event, emit) {
      emit(ShowLoanDetailsState());
    });
    on<HideLoanDetailsEvent>((event, emit) {
      emit(HideLoanDetailsState());
    });
  }
}
