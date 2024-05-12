// import 'dart:html';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:online_reservation/Data/API_Services/pdfWeb.service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


class PDFService{

  static Future<File> generatePDF() async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Receipt', style: pw.TextStyle(fontSize: 20)),
          );
        },
      ),
    );

    return PdfApi.saveDocument(name: 'reservation.pdf', pdf: pdf);
    // Save the PDF to a file
    // final file = File('receipt.pdf');
    // await file.writeAsBytes(await pdf.save());
  }
  static Future<void> generateWebPDF() async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Receipt', style: pw.TextStyle(fontSize: 20)),
          );
        },
      ),
    );

    return PDFWebService.saveDocument(name: 'reservation.pdf', pdf: pdf);
  }

  // static Future<File> generate(Invoice invoice) async {
  //   final pdf = Document();
  //
  //   pdf.addPage(MultiPage(
  //     build: (context) => [
  //       buildHeader(invoice),
  //       SizedBox(height: 3 * PdfPageFormat.cm),
  //       buildTitle(invoice),
  //       buildInvoice(invoice),
  //       Divider(),
  //       buildTotal(invoice),
  //     ],
  //     footer: (context) => buildFooter(invoice),
  //   ));
  //
  //   return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  // }
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}