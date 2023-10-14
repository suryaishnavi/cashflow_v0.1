part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final int value;
  final Language selectedLanguage;

  const LanguageState({
    int? value,
    Language? selectedLanguage,
  })  : selectedLanguage = selectedLanguage ?? Language.english,
        value = value ?? 0;

  LanguageState copyWith({
    int? value,
    Language? selectedLanguage,
  }) {
    return LanguageState(
      value: value ?? this.value,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object> get props => [selectedLanguage];
}
