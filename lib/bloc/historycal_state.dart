part of 'historycal_bloc.dart';

sealed class HistorycalState extends Equatable {
  const HistorycalState();

  @override
  List<Object> get props => [];
}

final class HistorycalInitial extends HistorycalState {}

final class HistorycalWebSocketMessageLoaded extends HistorycalState {
  final Map<String, List<HistorycalModel>> historycalData;
  const HistorycalWebSocketMessageLoaded(this.historycalData);
}
