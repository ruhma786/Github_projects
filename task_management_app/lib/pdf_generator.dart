import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:task_management_app/task.dart';

class PDFGenerator {
  static Future<void> generatePDF(Task task) async {
    final pdf = pw.Document();

    // Add a page to the document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Task Title: ${task.title}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Description: ${task.description}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Due Date: ${task.dueDate}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Completed: ${task.isCompleted ? "Yes" : "No"}', style: pw.TextStyle(fontSize: 16)),
            ],
          );
        },
      ),
    );

    // Save the PDF file
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'task_${task.id}.pdf',
    );
  }
}

