# Deckorator

Tools for creating card games & board games. This is intended to be used by a developer. It contains various tools that aid the development of a card or boardgame.

## Usage

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

## package:deckorator/pdf.dart

PDF related tools.

### outputPdfSheet(...)

Outputs a sheet of PDF components. Provide it with the sheet size, a list of `GameComponent` and it will lay the components out. You can also provide optional parameters for: 

 1. `bleed` : bleed for artwork
 1. `seperateFiles` : Each page of components will be seperate PDFs
 1. `seperateFilesSeperateBacks` : If using `seperateFiles` you can have front and back in same file by setting this to false.
 1. `componentOutline` will outline your components for cutting. Note this is only advised if creating a rough draft. If using for production just leave the default cut lines on which will not enter the bleed.
 1. backSheetOffsetVertical : Useful for duplex printing, if the reverse side of the print has a vertical offset set that here.
 1. backSheetOffsetHorizontal : Useful for duplex printing, if the reverse side of the print has a horizontal offset set that here.

### outputPdfCard(...)

Outputs a PDF card.
