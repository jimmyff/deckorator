import 'dart:io';
import 'dart:typed_data';

import 'package:deckorator/src/pdf/cut_lines.dart';
import 'package:pool/pool.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '../game_component.dart';
import '../game.dart';

enum PageSide { front, back }

const decoratorAuthor = 'Deckorator by Jimmy Forrester-Fellowes';

/// Outputs a single pdf files containing the component provided
Future<Document> generateComponentPdf({
  required double dpi,
  required GameTheme theme,
  required GameComponent component,
  required double bleed,
  required Future<Uint8List> Function(String filename) loadAsset,
}) async {
  // load all assets
  final assetBundle = <String, Uint8List>{};
  for (var file in component.assets) {
    final fileData = await loadAsset(file);
    assetBundle[file] = fileData;
  }

  final _pdf = Document(
    author: decoratorAuthor,
    compress: true,
    pageMode: PdfPageMode.none,
  );

  final actualBleed = 2.0;
  final doubleBleed = bleed * 2;
  print('doubleBleed: $doubleBleed');
  print('component.size: ${component.size}');
  _pdf.addPage(Page(
      pageFormat: PdfPageFormat((component.size.x + doubleBleed) * dpi,
          (component.size.y + doubleBleed) * dpi),
      build: (context) => LayoutBuilder(
          builder: (context, constraints) => Stack(children: [
                Positioned(
                    top: (bleed - actualBleed) * dpi,
                    left: (bleed - actualBleed) * dpi,
                    right: (bleed - actualBleed) * dpi,
                    bottom: (bleed - actualBleed) * dpi,
                    child: component.frontBuilder(GameComponentUiContext(
                      theme: theme,
                      assets: assetBundle,
                      pdfContext: context,
                      constraints: constraints!,
                      bleed: actualBleed,
                      component: component,
                    )))
              ]))));

  _pdf.addPage(Page(
      pageFormat: PdfPageFormat((component.size.x + doubleBleed) * 12,
          (component.size.y + doubleBleed) * 12),
      build: (context) => LayoutBuilder(
          builder: (context, constraints) =>
              component.backBuilder(GameComponentUiContext(
                  theme: theme,
                  // loadAsset: loadAsset,
                  assets: assetBundle,
                  pdfContext: context,
                  constraints: constraints!,
                  bleed: bleed,
                  component: component)))));

  return _pdf;
}

Future writeComponentPdf({
  required GameTheme theme,
  required String path,
  required GameComponent component,
  required double bleed,
  required Future<Uint8List> Function(String filename) loadAsset,
}) async {
  final file = File(path);
  await file.writeAsBytes(await (await generateComponentPdf(
          dpi: 12,
          theme: theme,
          component: component,
          loadAsset: loadAsset,
          bleed: bleed))
      .save());
}

/// Outputs PDF sheets containing the components provided
Future<List<Document>> generatePdfSheets({
  required double dpi, // 12 = 300 dpi
  required double width,
  required double height,
  required GameTheme theme,
  required List<GameComponent> components,
  required Future<Uint8List> Function(String filename) loadAsset,
  bool seperateFiles: false,
  bool seperateFilesSeperateBacks: true,
  bool componentOutline: false,
  required double frontSheetOffsetTop,
  required double frontSheetOffsetLeft,
  required double backSheetOffsetTop,
  required double backSheetOffsetLeft,
}) async {
  final bleed = 2.0;
  final pool = Pool(10);
  final dpi = 8; //12;

  return await pool.withResource<List<Document>>(() async {
    final _pdf = <Document>[
      Document(
        author: decoratorAuthor,
        compress: true,
        pageMode: PdfPageMode.none,
      )
    ];

    Map<String, List<GameComponent>> componentsBySize = {};
    Map<int, GameComponent> componentsHashMap = {};
    final assetBundle = <String, Uint8List>{};
    // sort components in to size groups
    for (var c in components) {
      (componentsBySize['${c.size.x}x${c.size.y}'] ??= []).add(c);

      // TODO: This could be replaced with uuid
      componentsHashMap[c.hashCode] = c;

      // TODO: THIS SHOULD BE ONLY ON SHEET
      for (var file in c.assets) {
        if (!assetBundle.containsKey(file)) {
          final fileData = await loadAsset(file);
          assetBundle[file] = fileData;
        }
      }
    }
    print('Grouped components by size');

    for (var sizeGroup in componentsBySize.keys) {
      List componentsInGroup = componentsBySize[sizeGroup]!;
      final cWidthWithoutBleed = componentsBySize[sizeGroup]!.first.size.x;
      final cHeightWithoutBleed = componentsBySize[sizeGroup]!.first.size.y;
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
    Layout margins: $colMargin (cols), $rowMargin (rows)
    Items per page: $itemsPerPage Pages: $pagesInGroup
    
    ''');

      int pagesWithBacks = 0;
      for (var p = 0; p < pagesInGroup; p++) {
        print('Adding page $p');

        for (var side in [PageSide.front, PageSide.back]) {
          final double offsetY = (side == PageSide.back
                  ? backSheetOffsetTop
                  : frontSheetOffsetTop) *
              dpi;
          final double offsetX = (side == PageSide.back
                  ? backSheetOffsetLeft
                  : frontSheetOffsetLeft) *
              dpi;

          // calculate the idx of components on the page
          final componentsIdx = [];
          for (var row = 0; row < rowsPerPage; row++) {
            for (var col = 0; col < colsPerPage; col++) {
              final componentIdx = _componentIdx(
                  itemsPerPage: itemsPerPage,
                  page: p,
                  row: row,
                  // For the back- the cols need to be reversed
                  col: col,
                  colsPerPage: colsPerPage,
                  rowsPerPage: rowsPerPage);

              if (componentsInGroup.length > componentIdx) {
                componentsIdx.add(componentIdx);
              }
            }
          }
          print('componentsIdx: $componentsIdx');

          _pdf[seperateFiles ? pagesWithBacks : 0].addPage(Page(
              pageFormat: PdfPageFormat(width * dpi, height * dpi),
              build: (Context context) {
                return Stack(children: [
                  for (var row = 0; row < rowsPerPage; row++)
                    for (var col = 0; col < colsPerPage; col++)
                      if ((col + (row * colsPerPage)) < componentsIdx.length)
                        Positioned(
                          top: offsetY +
                              ((row * cHeightWithBleed) * dpi) +
                              (((row + 1) * rowMargin) * dpi),

                          // If we're on the back then reverse the column
                          left: offsetX +
                              (((side == PageSide.back
                                          ? colsPerPage - col - 1
                                          : col) *
                                      cWidthWithBleed) *
                                  dpi) +
                              ((((side == PageSide.back
                                              ? colsPerPage - col - 1
                                              : col) +
                                          1) *
                                      dpi) *
                                  colMargin),
                          child: Container(
                              // decoration: BoxDecoration(
                              //     border: BoxBorder(
                              //         color: PdfColorCmyk(0, 1, 0, 0),
                              //         top: true,
                              //         left: true,
                              //         right: true,
                              //         bottom: true)),
                              width: cWidthWithBleed * dpi,
                              height: cHeightWithBleed * dpi,
                              // child: Transform.rotate(
                              //   angle: -math.pi / 2,
                              //   child: Container(
                              //       child: components[currentComponentIdx++]
                              //           .buildFront(context, bleed)),
                              // ),
                              child: LayoutBuilder(
                                builder: (context, constraints) => side ==
                                        PageSide.front
                                    ? components[componentsIdx[col + (row * colsPerPage)]!]
                                        .frontBuilder(GameComponentUiContext(
                                            theme: theme,
                                            assets: assetBundle,
                                            pdfContext: context,
                                            constraints: constraints!,
                                            bleed: bleed,
                                            component: components[componentsIdx[
                                                col + (row * colsPerPage)]!]))
                                    : components[0].backBuilder(
                                        GameComponentUiContext(
                                            theme: theme,
                                            assets: assetBundle,
                                            pdfContext: context,
                                            constraints: constraints!,
                                            bleed: bleed,
                                            component: components[componentsIdx[
                                                col + (row * colsPerPage)]!])),
                              )),
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

                  ...componentCutLineIndicatorsForPage(
                      borderWidth: 1.0 * dpi,
                      borderColor: PdfColors.white,
                      componentWidth: cWidthWithoutBleed * dpi,
                      componentHeight: cHeightWithoutBleed * dpi,
                      bleed: bleed * dpi,
                      rowCount: rowsPerPage,
                      colCount: colsPerPage,
                      rowMargin: rowMargin * dpi,
                      colMargin: colMargin * dpi,
                      offsetTop: offsetY * dpi,
                      offsetLeft: offsetX * dpi),

                  ...componentCutLineIndicatorsForPage(
                      borderWidth: 0.2 * dpi,
                      borderColor: PdfColors.black,
                      componentWidth: cWidthWithoutBleed * dpi,
                      componentHeight: cHeightWithoutBleed * dpi,
                      bleed: bleed * dpi,
                      rowCount: rowsPerPage,
                      colCount: colsPerPage,
                      rowMargin: rowMargin * dpi,
                      colMargin: colMargin * dpi,
                      offsetTop: offsetY * dpi,
                      offsetLeft: offsetX * dpi),
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

    return _pdf;

    // var f = 0;
    // for (var i = 0; i < _pdf.length; i++) {
    //   final pdfFile = _pdf[i];
    //   var filePath = seperateFiles
    //       ? outputPath.replaceFirst(new RegExp(r'\.pdf'), '_${++f}.pdf')
    //       : outputPath;
    //   final file = File(filePath);
    //   await file.writeAsBytes(await pdfFile!.save());
    //   _pdf[i] = null;
    // }
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
