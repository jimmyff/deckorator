# Deckorator

Tools for creating card games.

## http.dart

Http tools.

### fetchCsvFromGoogleSpeadsheet

```dart
// import BrowserClient or IoClient as required from package:http
final client = new IoClient();
final String csvString = fetchCsvFromGoogleSpeadsheet(
    client, 'your-spreadsheet-id-here', 'Sheet 1');
```

## csv.dart

Csv tools

### csvToDataTable

Creates a `DataTable` representing the data stored in a csv.

```dart
final DataTable data = csvToDataTable(csvString);
```
