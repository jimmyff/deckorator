# Deckorator

Tools for creating card games games. This is intended to be used by a developer.

The deckorator packages allow you to rapidly develop your card layouts which can be output as Flutter widgets for use digitally or as PDFs. It ships with an small subset of layout functions allowing you to utilise assets, fonts, masking etc.

This package is undergoing a major rework. It is not production ready!

---

## Usage (legacy information)

import `deckorator.dart` to get all the tools or just import the specific category of tools listed below.

## package:deckorator/http.dart

Http tools.

### fetchCsvFromGoogleSpeadsheet(...)

Fetches the CSV output form a google spreadsheet. In order for this to work you need to make sure you have sharing options for the spreadsheet set to 'Anyone with a link can view'.

```dart
// import BrowserClient or IoClient as required from package:http
final client = new IoClient();
final String csvString = fetchCsvFromGoogleSpeadsheet(
    client, 'your-spreadsheet-id-here', 'Sheet 1');
```

## package:deckorator/data.dart

Data tools

### csvToDataTable(...)

Creates a `DataTable` representing the data stored in a csv.

```dart
final DataTable data = csvToDataTable(csvString);
```
