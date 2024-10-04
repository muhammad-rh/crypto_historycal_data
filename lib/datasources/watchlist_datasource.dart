import 'package:code_challenge/config/app_colors.dart';
import 'package:code_challenge/config/app_formats.dart';
import 'package:code_challenge/models/historycal_model.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class WatchlistDatasource extends DataGridSource {
  WatchlistDatasource({required List<HistorycalModel> historycalData}) {
    _historycalData = historycalData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: [
              DataGridCell(columnName: 'Symbol', value: e.s),
              DataGridCell(columnName: 'Last', value: e.p),
              DataGridCell(columnName: 'Chg', value: e.dd),
              DataGridCell(columnName: 'Chg%', value: e.dc),
            ],
          ),
        )
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
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.white,
                width: 1,
              ),
            ),
          ),
          alignment: dataGridCell.columnName == 'Symbol'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          padding: const EdgeInsets.all(8),
          child: dataGridCell.columnName == 'Symbol'
              ? Row(
                  children: [
                    Image.asset(
                      AppFormats.iconCrypto(dataGridCell.value),
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      dataGridCell.value,
                      style: getTextStyle(dataGridCell).copyWith(fontSize: 13),
                    ),
                  ],
                )
              : Text(
                  AppFormats.commaFormat(dataGridCell.value),
                  style: getTextStyle(dataGridCell).copyWith(fontSize: 13),
                ),
        );
      }).toList(),
    );
  }

  TextStyle getTextStyle(DataGridCell<dynamic> dataGridCell) {
    if (dataGridCell.columnName == 'Chg') {
      return TextStyle(
        color: AppFormats.upDownColorFormat(dataGridCell.value),
      );
    } else if (dataGridCell.columnName == 'Chg%') {
      return TextStyle(
        color: AppFormats.upDownColorFormat(dataGridCell.value),
      );
    } else {
      return const TextStyle(
        color: AppColors.white,
      );
    }
  }
}
