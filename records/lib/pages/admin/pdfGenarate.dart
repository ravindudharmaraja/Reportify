// import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';
// import 'package:pdf/widgets.dart' as pdfWidgets;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<void> generatePDF(String userId) async {
//   final pdf = pw.Document();

//   final databaseReference = FirebaseFirestore.instance;

//   final querySnapshot = await databaseReference
//       .collection('records')
//       .doc(userId)
//       .collection('sales')
//       .get();

//   final List<SalesRecord> salesData = [];

//   querySnapshot.docs.forEach((doc) {
//     final List<Map<String, dynamic>> salesDataList =
//         List<Map<String, dynamic>>.from(doc['salesData']);

//     salesDataList.forEach((data) {
//       salesData.add(SalesRecord.fromJson(data));
//     });
//   });

//   // Calculate the total sales for each category
//   final Map<String, int> categoryTotals = {
//     'FTTH': 0,
//     'Peo TV': 0,
//     'LTE': 0,
//     'Fixed BB': 0,
//     'U-SIM': 0,
//   };

//   salesData.forEach((salesRecord) {
//     categoryTotals[salesRecord.product] =
//         categoryTotals[salesRecord.product]! + salesRecord.sales;
//   });

//   // Calculate the total sales
//   final int totalSales = categoryTotals.values.reduce((a, b) => a + b);

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'Monthly Sales Report',
//               style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
//             ),
//             pw.SizedBox(height: 20),
//             pw.Text('User ID: $userId'),
//             pw.SizedBox(height: 10),
//             pw.Table.fromTextArray(
//               context: context,
//               data: <List<String>>[
//                 <String>['Category', 'Sales'],
//                 ...categoryTotals.entries.map((entry) => [
//                       entry.key,
//                       entry.value.toString(),
//                     ]),
//                 <String>['Total', totalSales.toString()],
//               ],
//               headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//               cellAlignment: pw.Alignment.center,
//               cellStyle: const pw.TextStyle(fontSize: 12),
//               border: pw.TableBorder.all(),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   final output = await getTemporaryDirectory();
//   final file = File('${output.path}/monthly_sales_report.pdf');
//   await file.writeAsBytes(await pdf.save());

//   // Open the PDF file
//   // You can use any PDF viewer app installed on the device to open the generated PDF file
//   await OpenFile.open(file.path);
// }
