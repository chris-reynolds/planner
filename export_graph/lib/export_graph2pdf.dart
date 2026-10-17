import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

int calculate() {
  return 6 * 7;
}

void driver(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Invalid usage: export_graph file_in.csv fileout.pdf');
    exitCode = 16;
  } else if (!File(args[0]).existsSync()) {
    stderr.writeln('export_graph (${args[0]}) does not exist');
  } else {
    final csvData = await loadCsvData(args[0]);
    await xportLineChartToPdf(csvData, args[1]);
  }
}

Future<List<List<dynamic>>> loadCsvData(String path) async {
  final input = File(path).openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .toList();
  return fields;
}

class ChartData {
  final int x;
  final double y;

  ChartData(this.x, this.y);
}

Future<void> xportLineChartToPdf(
    List<List<dynamic>> csvData, String outputPath) async {
  final pdf = pw.Document();
  final data = <ChartData>[];

  // Parse CSV data into ChartData instances
  for (var row in csvData) {
    if (row.length >= 2) {
      int x = int.tryParse(row[0].toString()) ?? 0;
      double y = double.tryParse(row[1].toString()) ?? 0.0;
      data.add(ChartData(x, y));
    }
  }

  // Find the min and max for scaling the chart
  final xMin = data.map((e) => e.x).reduce((a, b) => a < b ? a : b);
  final xMax = data.map((e) => e.x).reduce((a, b) => a > b ? a : b);
  final yMin = data.map((e) => e.y).reduce((a, b) => a < b ? a : b);
  final yMax = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            height: 400,
            width: 600,
            child: pw.CustomPaint(
              size: PdfPoint(600, 400),
              painter: (PdfGraphics canvas, PdfPoint size) {
                // Draw X and Y axes
                canvas.setStrokeColor(PdfColors.black);
                canvas.drawLine(50, 350, 550, 350); // X-axis
                canvas.drawLine(50, 50, 50, 350); // Y-axis

                // Plot the data points and lines
                canvas.setStrokeColor(PdfColors.blue);
                canvas.setLineWidth(2);

                for (int i = 1; i < data.length; i++) {
                  final x1 =
                      50 + (500 * (data[i - 1].x - xMin) / (xMax - xMin));
                  final y1 =
                      350 - (300 * (data[i - 1].y - yMin) / (yMax - yMin));
                  final x2 = 50 + (500 * (data[i].x - xMin) / (xMax - xMin));
                  final y2 = 350 - (300 * (data[i].y - yMin) / (yMax - yMin));

                  canvas.drawLine(x1, y1, x2, y2);
                }
              },
            ),
          ),
        );
      },
    ),
  );

  // Save the PDF file
  final file = File(outputPath);
  await file.writeAsBytes(await pdf.save());

  print("PDF generated at: $outputPath");
}
