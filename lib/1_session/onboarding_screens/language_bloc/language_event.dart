part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguageEvent extends LanguageEvent {
  final Language selectedLanguage;
  final int? value;

  const ChangeLanguageEvent({
    this.value,
    required this.selectedLanguage,
  });
  @override
  List<Object> get props => [selectedLanguage];
}

class GetLanguage extends LanguageEvent {}
