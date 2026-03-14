import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
//#import 'package:open_file/open_file.dart';
import '../modelos/producto_model.dart';

// SOLO PARA WEB
import 'package:universal_html/html.dart' as html;

class PdfAlertService {

  /// GENERAR PDF
  static Future<void> generarPdf(List<ProductoModel> productos) async {

    if (productos.isEmpty) {
      throw Exception('No hay productos para generar el reporte');
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        build: (context) {
          return [

            /// TITULO
            pw.Text(
              "REPORTE DE ALERTAS DE INVENTARIO",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Text(
              "Fecha: ${DateTime.now().toString().split(' ')[0]}",
              style: const pw.TextStyle(fontSize: 12),
            ),

            pw.Text(
              "Total de productos: ${productos.length}",
              style: const pw.TextStyle(fontSize: 12),
            ),

            pw.SizedBox(height: 20),

            /// TABLA
            pw.TableHelper.fromTextArray(
              headers: [
                "Producto",
                "Stock",
                "Stock Mínimo",
                "Estado"
              ],

              data: productos.map((p) {
                return [
                  p.name,
                  p.stock.toString(),
                  p.stockMinimo.toString(),
                  p.tipo.toUpperCase(),
                ];
              }).toList(),

              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),

              cellStyle: const pw.TextStyle(
                fontSize: 10,
              ),

              border: pw.TableBorder.all(
                width: 0.5,
                color: PdfColors.grey,
              ),

              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    final bytes = await pdf.save();

    final fileName =
        "reporte_alertas_${DateTime.now().millisecondsSinceEpoch}.pdf";

    /// WEB
    if (kIsWeb) {

      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();

      html.Url.revokeObjectUrl(url);

    }

    /// ANDROID / IOS
    else {

      final directory = await getApplicationDocumentsDirectory();

      final file = File("${directory.path}/$fileName");

      await file.writeAsBytes(bytes);

      // await OpenFile.open(file.path);
    }
  }
}