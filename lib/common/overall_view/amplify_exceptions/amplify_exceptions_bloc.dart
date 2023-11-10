import 'package:amplify_flutter/amplify_flutter.dart' show AmplifyException;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'amplify_exceptions_event.dart';
part 'amplify_exceptions_state.dart';

class AmplifyExceptionsBloc
    extends Bloc<AmplifyExceptionsEvent, AmplifyExceptionsState> {
  AmplifyExceptionsBloc() : super(AmplifyExceptionsInitial()) {
    on<AmplifyPlugInExceptionsEvent>(_onAmplifyPlugInExceptionsEvent);
  }

  _onAmplifyPlugInExceptionsEvent(
    AmplifyPlugInExceptionsEvent event,
    Emitter<AmplifyExceptionsState> emit,
  ) {
    emit(AmplifyPlugInExceptionsState(error: event.error));
  }
}
