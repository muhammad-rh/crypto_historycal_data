part of 'historycal_bloc.dart';

sealed class HistorycalEvent extends Equatable {
  const HistorycalEvent();

  @override
  List<Object> get props => [];
}

class ConnectHistorycalWebSocket extends HistorycalEvent {}

class SubscribeToHistorycalWebSocket extends HistorycalEvent {}

class UnsubscribeToHistorycalWebSocket extends HistorycalEvent {}

class ReceiveMessageHistorycalWebSocket extends HistorycalEvent {
  final String message;
  const ReceiveMessageHistorycalWebSocket(this.message);
}
