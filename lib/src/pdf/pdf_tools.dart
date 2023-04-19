import 'dart:io';

import 'package:deckorator/src/pdf/cut_lines.dart';
import 'package:pool/pool.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../game_component.dart';

enum PageSide { front, back }

const decoratorAuthor = 'Deckorator by Jimmy Forrester-Fellowes';

/// Outputs a single pdf files containing the component provided
Future outputComponentPdf(String outputPath, GameComponent component,
    {required double bleed}) async {
  final _pdf = Document(
    author: decoratorAuthor,
    compress: true,
    pageMode: PdfPageMode.none,
  );

  _pdf.addPage(Page(
      pageFormat: PdfPageFormat(component.width, component.height),
      build: (context) => component.buildFront(context, bleed)));

  final file = File(outputPath);
  await file.writeAsBytes(await _pdf.save());
}

/// Outputs PDF sheets containing the components provided
Future outputPdfSheet(
  String outputPath,
  double width,
  double height,
  List<GameComponent> components, {
  required double bleed,
  bool seperateFiles: false,
  bool seperateFilesSeperateBacks: true,
  bool componentOutline: false,
  required double frontSheetOffsetTop,
  required double frontSheetOffsetLeft,
  required double backSheetOffsetTop,
  required double backSheetOffsetLeft,
}) async {
  final pool = Pool(10);

  pool.withResource(() async {
    final _pdf = <Document?>[
      Document(
        author: decoratorAuthor,
        compress: true,
        pageMode: PdfPageMode.none,
      )
    ];

    Map<String, List<GameComponent>> componentsBySize = {};
    Map<int, GameComponent> componentsHashMap = {};
    // sort components in to size groups
    for (var c in components) {
      (componentsBySize['${c.width}x${c.height}'] ??= []).add(c);

      // TODO: This could be replaced with uuid
      componentsHashMap[c.hashCode] = c;
    }
    print('Grouped components by size');

    for (var sizeGroup in componentsBySize.keys) {
      List componentsInGroup = componentsBySize[sizeGroup]!;
      final cWidthWithoutBleed = componentsBySize[sizeGroup]!.first.width;
      final cHeightWithoutBleed = componentsBySize[sizeGroup]!.first.height;
      final cWidthWithBleed =
          componentsBySize[sizeGroup]!.first.widthWithBleed(bleed);
      final cHeightWithBleed =
          componentsBySize[sizeGroup]!.first.heightWithBleed(bleed);
      final colsPerPage = (width / cWidthWithBleed).floor();
      final rowsPerPage = (height / cHeightWithBleed).floor();

      final colMargin =
          (width - (colsPerPage * cWidthWithBleed)) / (colsPerPage + 1);
      final rowMargin =
          (height - (rowsPerPage * cHeightWithBleed)) / (rowsPerPage + 1);
      final itemsPerPage = colsPerPage * rowsPerPage;
      int pagesInGroup = (componentsInGroup.length / itemsPerPage).ceil();

      // while (++i < 3) {

      print('''

    Size Group $sizeGroup (${componentsInGroup.length} components)
    Will fit: $colsPerPage (cols) x $rowsPerPage (rows)
    Layout margins:: $colMargin (cols), $rowMargin (rows)
    Items per page: $itemsPerPage Pages: $pagesInGroup
    
    ''');

      int pagesWithBacks = 0;
      for (var p = 0; p < pagesInGroup; p++) {
        print('Adding page $p');

        for (var side in [PageSide.front, PageSide.back]) {
          final double offsetY =
              side == PageSide.back ? backSheetOffsetTop : frontSheetOffsetTop;
          final double offsetX = side == PageSide.back
              ? backSheetOffsetLeft
              : frontSheetOffsetLeft;

          _pdf[seperateFiles ? pagesWithBacks : 0]!.addPage(Page(
              pageFormat: PdfPageFormat(width, height),
              build: (Context context) {
                return Stack(children: [
                  ...componentCutLineIndicatorsForPage(
                      componentWidth: cWidthWithoutBleed,
                      componentHeight: cHeightWithoutBleed,
                      bleed: bleed,
                      rowCount: rowsPerPage,
                      colCount: colsPerPage,
                      rowMargin: rowMargin,
                      colMargin: colMargin,
                      offsetTop: offsetY,
                      offsetLeft: offsetX),
                  for (var row = 0; row < rowsPerPage; row++)
                    for (var col = 0; col < colsPerPage; col++)
                      if (componentsInGroup.length >
                          _componentIdx(
                              itemsPerPage: itemsPerPage,
                              page: p,
                              row: row,
                              // For the back- the cols need to be reversed
                              col: col,
                              colsPerPage: colsPerPage,
                              rowsPerPage: rowsPerPage))
                        Positioned(
                          top: offsetY +
                              (row * cHeightWithBleed) +
                              ((row + 1) * rowMargin),

                          // If we're on the back then reverse the column
                          left: offsetX +
                              ((side == PageSide.back
                                      ? colsPerPage - col - 1
                                      : col) *
                                  cWidthWithBleed) +
                              (((side == PageSide.back
                                          ? colsPerPage - col - 1
                                          : col) +
                                      1) *
                                  colMargin),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     border: BoxBorder(
                            //         color: PdfColorCmyk(0, 1, 0, 0),
                            //         top: true,
                            //         left: true,
                            //         right: true,
                            //         bottom: true)),
                            width: cWidthWithBleed,
                            height: cHeightWithBleed,
                            // child: Transform.rotate(
                            //   angle: -math.pi / 2,
                            //   child: Container(
                            //       child: components[currentComponentIdx++]
                            //           .buildFront(context, bleed)),
                            // ),
                            child: side == PageSide.front
                                ? components[_componentIdx(
                                        itemsPerPage: itemsPerPage,
                                        page: p,
                                        row: row,
                                        col: col,
                                        colsPerPage: colsPerPage,
                                        rowsPerPage: rowsPerPage)]
                                    .buildFront(context, bleed)
                                : components[_componentIdx(
                                        itemsPerPage: itemsPerPage,
                                        page: p,
                                        row: row,
                                        col: col,
                                        colsPerPage: colsPerPage,
                                        rowsPerPage: rowsPerPage)]
                                    .buildBack(context, bleed),
                          ),
                        ),
                  // Include the component outline if desired
                  if (componentOutline)
                    for (var row = 0; row < rowsPerPage; row++)
                      for (var col = 0; col < colsPerPage; col++)
                        Positioned(
                            top: offsetY +
                                (row * cHeightWithBleed) +
                                ((row + 1) * rowMargin) +
                                bleed,
                            left: offsetX +
                                (col * cWidthWithBleed) +
                                ((col + 1) * colMargin) +
                                bleed,
                            child: Container(
                              width: cWidthWithoutBleed,
                              height: cHeightWithoutBleed,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: PdfColorCmyk(0, 0, 0, 0.2))),
                            )),
                ]); // Center
              }));

          if (side == PageSide.front) {
            if (seperateFiles && seperateFilesSeperateBacks) {
              pagesWithBacks++;
              _pdf.add(Document(
                author: decoratorAuthor,
                compress: true,
                pageMode: PdfPageMode.none,
              ));
            }
          } else {
            if (p < (pagesInGroup - 1) && seperateFiles) {
              _pdf.add(Document(
                author: decoratorAuthor,
                compress: true,
                pageMode: PdfPageMode.none,
              ));
            }
            pagesWithBacks++;
          }
        }
      }
    }
    var f = 0;
    for (var i = 0; i < _pdf.length; i++) {
      final pdfFile = _pdf[i];
      var filePath = seperateFiles
          ? outputPath.replaceFirst(new RegExp(r'\.pdf'), '_${++f}.pdf')
          : outputPath;
      final file = File(filePath);
      await file.writeAsBytes(await pdfFile!.save());
      _pdf[i] = null;
    }
  });
}

int _componentIdx(
    {required int itemsPerPage,
    required int page,
    required int row,
    required int col,
    required int colsPerPage,
    required int rowsPerPage}) {
  var itemsOnPreviousPages = page * itemsPerPage;
  var itemsOnPreviousRows = row * colsPerPage;
  return itemsOnPreviousPages + itemsOnPreviousRows + col;
}
