import 'dart:developer';

import 'package:code_challenge/bloc/historycal_bloc.dart';
import 'package:code_challenge/config/app_colors.dart';
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
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _trackballBehavior = TrackballBehavior(
      // Enables the trackball
      enable: true,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        color: Colors.red,
      ),
    );
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
      body: SafeArea(
        child: Column(
          children: [
            ...componentCarting(historycalBloc),
            const SizedBox(height: 16),
            watchlist(historycalBloc),
          ],
        ),
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
    var data = historycalBloc.historycalData[historycalBloc.getSelectedKey];

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
        Container(
          decoration: BoxDecoration(
            color: AppColors.black700,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                historycalBloc.getSelectedKey,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$ ${AppFormats.commaFormat(data!.last.p)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppFormats.upDownColorFormat(data.last.dc),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 1, 6, 1),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Icon(
                          AppFormats.isNeg(data.last.dc)
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          color: AppColors.white,
                          size: 24,
                        ),
                        Text(
                          '${data.last.dc} %',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                AppFormats.addPlusSign(AppFormats.commaFormat(data.last.dd)),
                style: TextStyle(
                  color: AppFormats.upDownColorFormat(data.last.dd),
                ),
              ),
              const SizedBox(height: 16),
              SfCartesianChart(
                margin: const EdgeInsets.all(0),
                trackballBehavior: _trackballBehavior,
                primaryXAxis: CategoryAxis(
                  axisLine: const AxisLine(width: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0.5),
                  majorGridLines: const MajorGridLines(width: 0.1),
                  labelStyle: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
                series: [
                  AreaSeries<HistorycalModel, String>(
                    onRendererCreated: (ChartSeriesController controller) {
                      historycalBloc.chartSeriesController = controller;
                    },
                    dataSource: data,
                    xValueMapper: (HistorycalModel data, int index) =>
                        AppFormats.minuteFormat.format(data.t),
                    yValueMapper: (HistorycalModel data, _) =>
                        double.parse(data.p),
                    borderColor: AppColors.primary300,
                    borderWidth: 2,
                    color: AppColors.primary500,
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary1000,
                        AppColors.primary300,
                        AppColors.primary500,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
