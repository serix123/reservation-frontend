import 'dart:io';
import 'package:flutter/services.dart';
import 'package:online_reservation/Data/API_Services/PDF_Services/pdfApi.service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';


class PDFService{

  static Future<File> generatePDF() async {
    final font = await rootBundle.load("assets/opensans.ttf");
    final ttf = Font.ttf(font);

    // Create a PDF document
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Receipt', style: pw.TextStyle(font: ttf,fontSize: 20)),
          );
        },
      ),
    );

    return PdfApi.saveDocument(name: 'reservation.pdf', pdf: pdf);
    // Save the PDF to a file
    // final file = File('receipt.pdf');
    // await file.writeAsBytes(await pdf.save());
  }
  // static Future<void> generateWebPDF() async {
  //   // Create a PDF document
  //   final pdf = pw.Document();
  //
  //   // Add content to the PDF
  //   pdf.addPage(
  //     pw.Page(
  //       build: (pw.Context context) {
  //         return pw.Center(
  //           child: pw.Text('Receipt', style: pw.TextStyle(fontSize: 20)),
  //         );
  //       },
  //     ),
  //   );
  //
  //   return PDFWebService.saveDocument(name: 'reservation.pdf', pdf: pdf);
  // }

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


  static Future<void> generatePDFTest() async {
    final font = await rootBundle.load("assets/opensans.ttf");
    final ttf = Font.ttf(font);

    // Create a PDF document
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello, PDF!', style: pw.TextStyle(font: ttf,fontSize: 20)),
          );
        },
      ),
    );

    // Save the PDF to a file
    final file = File('example.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}
