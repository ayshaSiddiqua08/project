// Mock API methods
import 'dart:math';

import 'package:Taayza/controllers/list_courses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentApi {
  static Future<bool> makePayment(
      String cardNumber, String expirationDate, String cvv) async {
    // Simulate API call and return a random payment status
    await Future.delayed(const Duration(seconds: 2)); // Simulating API delay
    final random = Random().nextBool(); // Simulating random payment status
    return random;
  }
}

// Payment screen widget
class PaymentScreen extends StatefulWidget {
  final String? courseId;

  const PaymentScreen({super.key, this.courseId});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final controller = Get.put(ListCoursesController());
  final _formKey = GlobalKey<FormState>();
  late String _cardNumber;
  late String _expirationDate;
  late String _cvv;
  bool _isLoading = false;

  void _submitPaymentForm() async {
    _expirationDate = '';
    _cvv = '';
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      // Simulate payment API call
      final paymentStatus =
          await PaymentApi.makePayment(_cardNumber, _expirationDate, _cvv);

      setState(() {
        _isLoading = false;
      });

      if (paymentStatus) {
        controller.saveCourseForStudent(
            courseId: widget.courseId!, teacherId: controller.teacherUID);
        controller.getCourseDetails(widget.courseId!);
        Future.delayed(const Duration(milliseconds: 100), () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Payment Successful'),
              content: const Text('Your payment was processed successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child:  Text('OK'),
                ),
              ],
            ),
          );
        });
        Get.back();
        Get.back();
      } else {
        // Payment failed, show error message
        Future.delayed(const Duration(milliseconds: 100), () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Payment Failed'),
              content:
                  const Text('There was an error processing your payment.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid card number.';
                  }
                  return null;
                },
                onSaved: (value) => _cardNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'OTP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid card number.';
                  }
                  return null;
                },
                onSaved: (value) => _cardNumber = value!,
              ),
              // Add more input fields for expiration date, CVV, etc.
              const SizedBox(height: 16.0),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitPaymentForm,
                      child: const Text('Pay'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
