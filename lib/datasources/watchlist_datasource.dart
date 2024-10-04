import 'package:code_challenge/config/app_formats.dart';
import 'package:code_challenge/models/historycal_model.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class WatchlistDatasource extends DataGridSource {
  WatchlistDatasource({required List<HistorycalModel> historycalData}) {
    _historycalData = historycalData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: 'Symbol', value: e.s),
              DataGridCell(columnName: 'Last', value: e.p),
              DataGridCell(columnName: 'Chg', value: e.dd),
              DataGridCell(columnName: 'Chg%', value: e.dc),
            ]))
        .toList();
  }

  List<DataGridRow> _historycalData = [];

  @override
  List<DataGridRow> get rows => _historycalData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: dataGridCell.columnName == 'Symbol'
            ? Alignment.centerLeft
            : Alignment.centerRight,
        padding: const EdgeInsets.all(12),
        child: Text(
          dataGridCell.columnName == 'Symbol'
              ? dataGridCell.value
              : AppFormats.commaFormat(dataGridCell.value),
        ),
      );
    }).toList());
  }
}
