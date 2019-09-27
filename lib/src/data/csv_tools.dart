import 'data_table.dart';

import 'package:csv/csv.dart';

DataTable csvToDataTable(String csv) {
  // parse the csv
  var _csv = const CsvToListConverter(
          fieldDelimiter: ',', eol: '\n', shouldParseNumbers: false)
      .convert(csv);

  List<String> _keys = _csv.removeAt(0).cast<String>();

  return new DataTable(_keys, _csv);
}