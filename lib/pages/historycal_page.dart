import 'dart:developer';

import 'package:code_challenge/bloc/historycal_bloc.dart';
import 'package:code_challenge/config/app_assets.dart';
import 'package:code_challenge/config/app_colors.dart';
import 'package:code_challenge/config/app_formats.dart';
import 'package:code_challenge/datasources/watchlist_datasource.dart';
import 'package:code_challenge/models/historycal_model.dart';
import 'package:code_challenge/widgets/historycal_skeleton.dart';
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
      body: historycalBloc.historycalData.isEmpty
          ? const HistorycalSkeleton()
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerBuild(historycalBloc),
                  _cartingBuild(historycalBloc),
                  Expanded(child: _watchlistBuild(historycalBloc))
                ],
              ),
            ),
    );
  }

  Widget _headerBuild(HistorycalBloc historycalBloc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.appLogo,
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 8),
              const Text(
                'NexGen Crypto',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Analytics',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            children: [
              ...historycalBloc.historycalData.entries.map((e) {
                return InkWell(
                  onTap: e.key == historycalBloc.getSelectedKey
                      ? null
                      : () {
                          historycalBloc.selectedKey = e.key;
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: e.key == historycalBloc.getSelectedKey
                          ? AppColors.orange
                          : AppColors.black500,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    margin: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppFormats.iconCrypto(e.key),
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          e.key,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cartingBuild(HistorycalBloc historycalBloc) {
    var data = historycalBloc.historycalData[historycalBloc.getSelectedKey];

    if (historycalBloc.getSelectedKey != '') {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.black700,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  AppFormats.iconCrypto(historycalBloc.getSelectedKey),
                  height: 16,
                  width: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  historycalBloc.getSelectedKey,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
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
                          fontWeight: FontWeight.w600,
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
                axisLabelFormatter: (args) {
                  // Format label untuk sumbu Y
                  return ChartAxisLabel(
                      AppFormats.commaFormat(args.value.toString()), null);
                },
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
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return const Center(child: Text('No data yet.'));
    }
  }

  BlocBuilder<HistorycalBloc, HistorycalState> _watchlistBuild(
      HistorycalBloc historycalBloc) {
    return BlocBuilder<HistorycalBloc, HistorycalState>(
      builder: (_, state) {
        if (state is HistorycalWebSocketMessageLoaded) {
          WatchlistDatasource data = WatchlistDatasource(
              historycalData: historycalBloc.historycalData.entries
                  .map((e) => e.value.last)
                  .toList());

          return Container(
            decoration: const BoxDecoration(
              color: AppColors.black700,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Text(
                    'Watchlist',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SfDataGrid(
                    source: data,
                    headerRowHeight: 36,
                    rowHeight: 38,
                    shrinkWrapRows: true,
                    columns: [
                      for (int i = 0; i < 4; i++)
                        GridColumn(
                          columnName: ['Symbol', 'Last', 'Chg', 'Chg%'][i],
                          label: Container(
                            padding: EdgeInsets.fromLTRB(
                                i == 0 ? 6 : 0, 0, i == 4 ? 6 : 0, 0),
                            alignment: i == 0
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Text(
                              ['Symbol', 'Last', 'Chg', 'Chg%'][i],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No data yet.'));
        }
      },
    );
  }
}
