import 'dart:collection';

/// A convinent way to itterate over and fetch values from a table of data.
class DataTable extends ListBase<DataTableRow> {
  List<String> keys;
  List<DataTableRow> data;

  int get length => data.length;
  void set length(int newLength) {
    data.length = newLength;
  }

  DataTable(this.keys, List<List<dynamic>> values) {
    this.data = values
        .map<DataTableRow>((List<dynamic> d) => new DataTableRow(keys, d))
        .toList();
  }

  DataTableRow operator [](int index) => data[index];
  void operator []=(int index, DataTableRow value) {
    data[index] = value;
  }
}

class DataTableRow extends ListBase<dynamic> {
  List<String> keys;
  List<dynamic> data;

  int get length => data.length;
  void set length(int newLength) {
    data.length = newLength;
  }

  DataTableRow(this.keys, this.data);

  dynamic operator [](int index) => data[index];
  void operator []=(int index, dynamic value) {
    data[index] = value;
  }

  String value(String key) => data[keys.indexOf(key)] == ""
      ? null
      : data[keys.indexOf(key)].toString().trim();
  int valueAsInt(String key) => data[keys.indexOf(key)] == ""
      ? null
      : int.parse(data[keys.indexOf(key)].toString().trim());
}
