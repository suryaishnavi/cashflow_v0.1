part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ReportState {}

class CirclesLoadedState extends ReportState {
  final List<Circle> circles;

  const CirclesLoadedState(this.circles);
}

class DocsReadyState extends ReportState {
  final pw.Document doc;

  const DocsReadyState(this.doc);
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);
}

class EmptyState extends ReportState {
  final String message;

  const EmptyState({required this.message});
}
