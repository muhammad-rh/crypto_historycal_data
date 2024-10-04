import 'package:code_challenge/bloc/historycal_bloc.dart';
import 'package:code_challenge/config/app_formats.dart';
import 'package:code_challenge/models/historycal_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistorycalPage extends StatefulWidget {
  const HistorycalPage({super.key});

  @override
  State<HistorycalPage> createState() => _HistorycalPageState();
}

class _HistorycalPageState extends State<HistorycalPage> {
  @override
  Widget build(BuildContext context) {
    var historycalBloc = context.watch<HistorycalBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text("Crypto Historycal Data")),
      body: Column(
        children: [
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
              primaryXAxis: const CategoryAxis(),
              series: [
                SplineSeries<HistorycalModel, String>(
                  onRendererCreated: (ChartSeriesController controller) {
                    historycalBloc.chartSeriesController = controller;
                  },
                  dataSource: historycalBloc
                      .historycalData[historycalBloc.getSelectedKey]!,
                  xValueMapper: (HistorycalModel data, int index) =>
                      AppFormats.hourFormat.format(
                    AppFormats.msFormat(ms: data.t),
                  ),
                  yValueMapper: (HistorycalModel data, _) =>
                      double.parse(data.p),
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
        ],
      ),
      // BlocBuilder<HistorycalBloc, HistorycalState>(
      //   builder: (_, state) {
      //     if (state is HistorycalWebSocketMessageLoaded) {
      //       return Column(
      //         children: [
      //           Wrap(
      //             children: [
      //               ...historycalBloc.historycalData.entries.map((e) {
      //                 return Column(
      //                   children: [
      //                     InkWell(
      //                       onTap: () {
      //                         historycalBloc.selectedKey = e.key;
      //                       },
      //                       child: Container(
      //                         padding: const EdgeInsets.symmetric(
      //                           vertical: 4,
      //                           horizontal: 8,
      //                         ),
      //                         margin: const EdgeInsets.all(4),
      //                         color: Colors.orange,
      //                         child: Text(
      //                           e.key,
      //                           style: const TextStyle(color: Colors.white),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 );
      //               }).toList(),
      //             ],
      //           ),
      //           if (historycalBloc.getSelectedKey != '') ...[
      //             Text('Selected Key: ${historycalBloc.getSelectedKey}'),
      //             SfCartesianChart(
      //               primaryXAxis: const CategoryAxis(),
      //               series: [
      //                 LineSeries<HistorycalModel, String>(
      //                   onRendererCreated: (ChartSeriesController controller) {
      //                     historycalBloc.chartSeriesController = controller;
      //                   },
      //                   dataSource: historycalBloc
      //                       .historycalData[historycalBloc.getSelectedKey]!,
      //                   xValueMapper: (HistorycalModel data, int index) =>
      //                       // '${index + 1}',
      //                       '${data.dateTime.hour}:${data.dateTime.minute}:${data.dateTime.second}',
      //                   yValueMapper: (HistorycalModel data, _) =>
      //                       double.parse(data.p),
      //                   markerSettings: const MarkerSettings(isVisible: false),
      //                   dataLabelSettings: const DataLabelSettings(
      //                     // isVisible: true,
      //                     textStyle: TextStyle(
      //                       color: Colors.black,
      //                       fontWeight: FontWeight.w500,
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ],
      //       );
      //     } else {
      //       return const Center(child: Text('No messages yet.'));
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HistorycalBloc>().add(SubscribeToHistorycalWebSocket());
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
