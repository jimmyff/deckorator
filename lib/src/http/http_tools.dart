import 'package:http/http.dart';

/// Fetches the CSV output of a 'Google Sheet' single sheet.
Future<String> fetchCsvFromGoogleSpeadsheet(
    Client httpClient, String spreadsheetId, String sheetRef) async {
  final uri = Uri.parse(
      "https://docs.google.com/spreadsheets/d/$spreadsheetId" +
          "/gviz/tq?tqx=out:csv&headers=0&sheet=$sheetRef");

  print(uri);
  Response response = await httpClient.get(uri);

  if (response.statusCode != 200)
    throw new Exception('Could not download sheet $sheetRef');

  // print(response.body);
  return response.body;
}
