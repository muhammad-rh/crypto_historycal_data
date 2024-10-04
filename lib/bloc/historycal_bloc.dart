import 'dart:convert';

import 'package:code_challenge/datasources/historycal_datasource.dart';
import 'package:code_challenge/models/historycal_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'historycal_event.dart';
part 'historycal_state.dart';

class HistorycalBloc extends Bloc<HistorycalEvent, HistorycalState> {
  final HistorycalDatasource _dataSource;
  bool _isSubscribe = false;

  HistorycalBloc(this._dataSource) : super(HistorycalInitial()) {
    _dataSource.messages.listen((message) {
      add(ReceiveMessageHistorycalWebSocket(message));
    });
    on<ConnectHistorycalWebSocket>(_connectHistorycalWebSocket);
    on<SubscribeToHistorycalWebSocket>(_subscribeToHistorycalWebSocket);
    on<UnsubscribeToHistorycalWebSocket>(_unsubscribeToHistorycalWebSocket);
    on<ReceiveMessageHistorycalWebSocket>(_receiveMessageHistorycalWebSocket);
  }

  void _connectHistorycalWebSocket(
      ConnectHistorycalWebSocket event, Emitter<HistorycalState> emit) {
    _dataSource.connect(
      'wss://ws.eodhistoricaldata.com/ws/crypto?api_token=demo',
    );

    // _dataSource.dispose();
  }

  void _subscribeToHistorycalWebSocket(
      SubscribeToHistorycalWebSocket event, Emitter<HistorycalState> emit) {
    add(ConnectHistorycalWebSocket());

    _dataSource.sendMessage(
      '{"action": "subscribe", "symbols": "ETH-USD,BTC-USD"}',
    );
    _isSubscribe = true;
  }

  void _unsubscribeToHistorycalWebSocket(
      UnsubscribeToHistorycalWebSocket event, Emitter<HistorycalState> emit) {
    _dataSource.sendMessage(
      '{"action": "unsubscribe", "symbols": "ETH-USD,BTC-USD"}',
    );
    _isSubscribe = false;
  }

  ChartSeriesController? chartSeriesController;

  Map<String, List<HistorycalModel>> historycalData = {};

  String _selectedKey = '';
  set selectedKey(String value) {
    _selectedKey = value;
  }

  get getSelectedKey => _selectedKey;

  void _receiveMessageHistorycalWebSocket(
      ReceiveMessageHistorycalWebSocket event, Emitter<HistorycalState> emit) {
    HistorycalModel data = HistorycalModel.fromJson(json.decode(event.message));

    if (!_isSubscribe || data.s == '') return;

    if (historycalData.containsKey(data.s)) {
      HistorycalModel? newData =
          onDataReceived(data, historycalData[data.s]!.last);
      if (newData != null) historycalData[data.s]!.add(newData);
      if (_selectedKey == '') _selectedKey = data.s;
    } else {
      historycalData.addAll(
        {
          data.s: [data],
        },
      );
    }

    updateData();

    emit(HistorycalInitial());
    emit(HistorycalWebSocketMessageLoaded(historycalData));
  }

  void updateData() {
    historycalData.forEach((key, value) {
      if (historycalData[key]!.length > 30) {
        historycalData[key]!.removeAt(0);
        chartSeriesController?.updateDataSource(
            addedDataIndexes: <int>[historycalData[key]!.length - 1],
            removedDataIndexes: <int>[0]);
      }
    });
  }

  HistorycalModel? onDataReceived(
    HistorycalModel newData,
    HistorycalModel oldData,
  ) {
    if (newData.s == '' || oldData.s == '') return null;

    Duration diff = newData.t.difference(oldData.t);

    if (diff.inSeconds >= 1) {
      // log('${oldData.p.toString()} | ${oldData.s}', name: 'oldData');
      // log('${newData.p.toString()} | ${newData.s}', name: 'newData');

      return newData;
    }

    return null;
  }

  @override
  Future<void> close() {
    _dataSource.dispose();
    return super.close();
  }
}
