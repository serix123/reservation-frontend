
import 'dart:html' as html;
import 'dart:html';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';


class PDFWebService {

  static Future<void> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    // final bytes = await pdf.save();

    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    var anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'pdf.pdf';
    html.document.body?.children.add(anchor);
  }

}