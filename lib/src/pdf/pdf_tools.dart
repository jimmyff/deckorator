import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';

Future outputComponentPdf(double width, double height, String outputPath,
    Widget Function(Context context) cardRenderer) async {
  final _pdf = Document(
    author: 'Deckorator by Jimmy Forrester-Fellowes',
    // compress: false,
    pageMode: PdfPageMode.none,
  );

  _pdf.addPage(
      Page(pageFormat: PdfPageFormat(width, height), build: cardRenderer));

  final file = File(outputPath);
  await file.writeAsBytes(_pdf.save());
}
