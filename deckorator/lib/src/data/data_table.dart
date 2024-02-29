import 'dart:collection';

/// A convinent way to itterate over and fetch values from a table of data.
class DataTable extends ListBase<DataTableRow> {
  List<String> keys;
  List<DataTableRow> data;

  int get length => data.length;
  void set length(int newLength) {
    data.length = newLength;
  }

  DataTable(this.keys, List<List<dynamic>> values)
      : data = values
            .map<DataTableRow>((List<dynamic> d) => DataTableRow(keys, d))
            .toList();

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

  bool has(String key) =>
      keys.contains(key) &&
      data[keys.indexOf(key)].toString().trim().isNotEmpty;

  String? value(String key) {
    final index = keys.indexOf(key);
    if (index == -1) throw RangeError('Key "$key" not found $keys');
    try {
      return data[index] == "" ? null : data[index].toString().trim();
    } catch (e, _) {
      throw RangeError(
          'Data not found for "$key" with index $index. Row length: ${data.length} $data');
    }
  }

  int? valueAsInt(String key) {
    // TODO: This try catch needs to be generic for this and value
    try {
      return data[keys.indexOf(key)] == ""
          ? null
          : int.parse(data[keys.indexOf(key)].toString().trim());
    } catch (e, _) {
      if (keys.indexOf(key) == -1)
        throw Exception("No column with key: '$key'");
      rethrow;
    }
  }

  double? valueAsDouble(String key) {
    // TODO: This try catch needs to be generic for this and value
    try {
      return data[keys.indexOf(key)] == ""
          ? null
          : double.parse(data[keys.indexOf(key)].toString().trim());
    } catch (e, _) {
      if (keys.indexOf(key) == -1)
        throw Exception("No column with key: '$key'");
      rethrow;
    }
  }

  List<String> valueAsList(String key) {
    // TODO: This try catch needs to be generic for this and value
    try {
      return data[keys.indexOf(key)] == ""
          ? []
          : data[keys.indexOf(key)]
              .toString()
              .split(',')
              .map((e) => e.trim())
              .toList();
    } catch (e, _) {
      if (keys.indexOf(key) == -1)
        throw Exception("No column with key: '$key'");
      rethrow;
    }
  }
}
