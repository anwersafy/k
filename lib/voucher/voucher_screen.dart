import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVoucherCodeScreen extends StatefulWidget {
  @override
  _AddVoucherCodeScreenState createState() => _AddVoucherCodeScreenState();
}

class _AddVoucherCodeScreenState extends State<AddVoucherCodeScreen> {
  final TextEditingController _voucherCodeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  // Reference to the Firestore collection
  final CollectionReference _voucherCollection =
  FirebaseFirestore.instance.collection('voucherID');

  Future<void> _addVoucherCode() async {
    String voucherCode = _voucherCodeController.text.trim();
    String discount = _discountController.text.trim();

    if (voucherCode.isNotEmpty && discount.isNotEmpty) {
      // Check if the voucher code already exists
      QuerySnapshot querySnapshot = await _voucherCollection
          .where('code', isEqualTo: voucherCode)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If the voucher code doesn't exist, add it to Firestore
        DocumentReference voucherDocumentRef =
        await _voucherCollection.add({'code': voucherCode, 'discount': discount});

        // Access the subcollection 'usageHistory' and add data
        await voucherDocumentRef.collection('usageHistory').add({
          'timestamp': FieldValue.serverTimestamp(), // Add timestamp or any other data
          // Add more fields as needed
        });

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voucher code added successfully'),
          ),
        );
        Navigator.pop(context);

      } else {
        // Show error message if the voucher code already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voucher code already exists'),
          ),
        );
      }
    } else {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both voucher code and discount'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Voucher Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _voucherCodeController,
              decoration: InputDecoration(
                labelText: 'Voucher Code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: 'Discount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addVoucherCode,
              child: Text('Add Voucher Code'),
            ),
          ],
        ),
      ),
    );
  }
}
