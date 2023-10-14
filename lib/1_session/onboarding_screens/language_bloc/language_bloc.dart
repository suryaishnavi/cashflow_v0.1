import 'package:amplify_flutter/amplify_flutter.dart'
    show AmplifySecureStorage, AmplifySecureStorageConfig;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<ChangeLanguageEvent>(_onLanguageChanged);
    on<GetLanguage>(_onGetLanguage);
  }
  // ignore: invalid_use_of_internal_member
  final storage = AmplifySecureStorage(
    config: AmplifySecureStorageConfig(
      scope: 'userDetails',
    ),
  );

  _onLanguageChanged(ChangeLanguageEvent event, Emitter<LanguageState> emit) {
    storage.write(
      key: 'isLanguageSelected',
      value: event.selectedLanguage.value.languageCode,
    );
    emit(state.copyWith(
      value: event.value,
      selectedLanguage: event.selectedLanguage,
    ));
  }

  _onGetLanguage(GetLanguage event, Emitter<LanguageState> emit) async {
    final isLanguageSelected = await storage.read(key: 'isLanguageSelected');
    emit(
      state.copyWith(
        selectedLanguage: isLanguageSelected != null
            ? Language.values
                .where((item) => item.value.languageCode == isLanguageSelected)
                .first
            : Language.english,
      ),
    );
  }
}
