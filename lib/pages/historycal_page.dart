import 'dart:developer';

import 'package:code_challenge/bloc/historycal_bloc.dart';
import 'package:code_challenge/config/app_formats.dart';
import 'package:code_challenge/datasources/watchlist_datasource.dart';
import 'package:code_challenge/models/historycal_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HistorycalPage extends StatefulWidget {
  const HistorycalPage({super.key});

  @override
  State<HistorycalPage> createState() => _HistorycalPageState();
}

class _HistorycalPageState extends State<HistorycalPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      state == AppLifecycleState.resumed
          ? context.read<HistorycalBloc>().add(SubscribeToHistorycalWebSocket())
          : context
              .read<HistorycalBloc>()
              .add(UnsubscribeToHistorycalWebSocket());

      if (state == AppLifecycleState.resumed) {
        log("///Resumed///");
      } else if (state == AppLifecycleState.inactive) {
        log("///Inactive///");
      } else if (state == AppLifecycleState.paused) {
        log("///Paused///");
      } else if (state == AppLifecycleState.detached) {
        log("///Detached///");
      } else if (state == AppLifecycleState.hidden) {
        log("///Hidden///");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var historycalBloc = context.watch<HistorycalBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text("Crypto Historycal Data")),
      body: Column(
        children: [
          ...componentCarting(historycalBloc),
          const SizedBox(height: 16),
          watchlist(historycalBloc),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<HistorycalBloc>()
              .add(UnsubscribeToHistorycalWebSocket());
        },
        child: const Icon(Icons.pause),
      ),
    );
  }

  List<Widget> componentCarting(HistorycalBloc historycalBloc) {
    return [
      Wrap(
        children: [
          ...historycalBloc.historycalData.entries.map((e) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    historycalBloc.selectedKey = e.key;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    margin: const EdgeInsets.all(4),
                    color: Colors.orange,
                    child: Text(
                      e.key,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
      if (historycalBloc.getSelectedKey != '') ...[
        Text('Selected Key: ${historycalBloc.getSelectedKey}'),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: [
            SplineSeries<HistorycalModel, String>(
              splineType: SplineType.monotonic,
              onRendererCreated: (ChartSeriesController controller) {
                historycalBloc.chartSeriesController = controller;
              },
              dataSource:
                  historycalBloc.historycalData[historycalBloc.getSelectedKey]!,
              xValueMapper: (HistorycalModel data, int index) =>
                  AppFormats.hourFormat.format(
                data.t,
              ),
              yValueMapper: (HistorycalModel data, _) => double.parse(data.p),
              markerSettings: const MarkerSettings(isVisible: false),
              dataLabelSettings: const DataLabelSettings(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    ];
  }

  BlocBuilder<HistorycalBloc, HistorycalState> watchlist(
      HistorycalBloc historycalBloc) {
    return BlocBuilder<HistorycalBloc, HistorycalState>(
      builder: (_, state) {
        if (state is HistorycalWebSocketMessageLoaded) {
          WatchlistDatasource data = WatchlistDatasource(
              historycalData: historycalBloc.historycalData.entries
                  .map((e) => e.value.last)
                  .toList());

          return Column(
            children: [
              SfDataGrid(
                source: data,
                columns: [
                  for (int i = 0; i < 4; i++)
                    GridColumn(
                      columnName: ['Symbol', 'Last', 'Chg', 'Chg%'][i],
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: i == 0
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          ['Symbol', 'Last', 'Chg', 'Chg%'][i],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        } else {
          return const Center(child: Text('No data yet.'));
        }
      },
    );
  }
}
