# Deckorator

Tools for creating card games & boardgames.

## Usage

import `deckorator.dart` to get all the tools or just import the specific category of tools listed below. 

## http.dart

Http tools.

### fetchCsvFromGoogleSpeadsheet

Fetches the CSV output form a google spreadsheet. In order for this to work you need to make sure you have sharing options for the spreadsheet set to 'Anyone with a link can view'.

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

## pdf.dart

PDF related tools.

### outputPdfCard

Outputs a PDF card.
