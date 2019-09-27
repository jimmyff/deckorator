import 'package:http/http.dart';

/// Fetches the CSV output of a 'Google Sheet' single sheet.
Future<String> fetchCsvFromGoogleSpeadsheet(
    Client httpClient, String spreadsheetId, String sheetRef) async {
  Response response = await httpClient.get(
      "https://docs.google.com/spreadsheets/d/$spreadsheetId" +
          "/gviz/tq?tqx=out:csv&sheet=$sheetRef");

  if (response.statusCode != 200)
    throw new Exception('Could not download sheet $sheetRef');

  return response.body;
}
