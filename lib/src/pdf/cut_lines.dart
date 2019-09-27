import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

// List<Widget> _addCutLinesForComponent({
//   int left,
//   int top,
//   double bleed,
//   double width,
//   double height,
// }) {
//   return [];
// }

/// Adds a full page of cut line indicators
/// [colMargin] is the space between the columns
/// [rowMargin] is the space between the rows
List<Widget> componentCutLineIndicatorsForPage({
  double componentWidth,
  double componentHeight,
  double bleed,
  int rowCount,
  int colCount,
  double rowMargin,
  double colMargin,
  double offsetTop,
  double offsetLeft,
}) {
  final componentWidthWithBleed = componentWidth + (bleed * 2);
  final componentHeightWithBleed = componentHeight + (bleed * 2);

  return [
    // horizontal top left cutting marks
    for (var row = 0; row < rowCount; row++)
      for (var col = 0; col <= colCount; col++)
        Positioned(
            top: offsetTop +
                (row * componentHeightWithBleed) +
                ((row + 1) * rowMargin) +
                bleed,
            left: offsetLeft +
                (col * componentWidthWithBleed) +
                ((col) * colMargin),
            child: Container(
              width: colMargin,
              decoration: BoxDecoration(
                  border:
                      BoxBorder(color: PdfColorCmyk(0, 0, 0, 1), top: true)),
            )),

    // horizontal bottom left cutting marks
    for (var row = 0; row < rowCount; row++)
      for (var col = 0; col <= colCount; col++)
        Positioned(
            top: offsetTop +
                (row * componentHeightWithBleed) +
                ((row + 1) * rowMargin) +
                componentHeightWithBleed -
                bleed,
            left: offsetLeft +
                (col * componentWidthWithBleed) +
                ((col) * colMargin),
            child: Container(
              width: colMargin,
              decoration: BoxDecoration(
                  border:
                      BoxBorder(color: PdfColorCmyk(0, 0, 0, 1), top: true)),
            )),

    // vertical top left cutting marks
    for (var row = 0; row <= rowCount; row++)
      for (var col = 0; col < colCount; col++)
        Positioned(
            top: offsetTop +
                (row * componentHeightWithBleed) +
                ((row + 1) * rowMargin) -
                rowMargin,
            left: offsetLeft +
                ((col * componentWidthWithBleed) + ((col + 1) * colMargin)) +
                bleed,
            child: Container(
              height: rowMargin,
              decoration: BoxDecoration(
                  border:
                      BoxBorder(color: PdfColorCmyk(0, 0, 0, 1), left: true)),
            )),

    // vertical top right cutting marks
    for (var row = 0; row <= rowCount; row++)
      for (var col = 0; col < colCount; col++)
        Positioned(
            top: offsetTop +
                (row * componentHeightWithBleed) +
                ((row + 1) * rowMargin) -
                rowMargin,
            left: offsetLeft +
                ((col * componentWidthWithBleed) + ((col + 1) * colMargin)) +
                componentWidthWithBleed -
                bleed,
            child: Container(
              height: rowMargin,
              decoration: BoxDecoration(
                  border:
                      BoxBorder(color: PdfColorCmyk(0, 0, 0, 1), left: true)),
            )),
  ];
}
