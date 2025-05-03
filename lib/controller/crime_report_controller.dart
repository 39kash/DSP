import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:london_crime/service/notification_service.dart';
import '../models/crime_report_model.dart';

class SubmitCrimeReportController extends GetxController {
  final locationController = TextEditingController();
  final detailsController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<CrimeReport> reports = <CrimeReport>[].obs;

  var crimeType = 'Theft'.obs;
  DateTime? selectedDateTime;

  @override
  void onInit() {
    super.onInit();
    listenToCrimeReports();
  }

  Future<void> pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        update();
      }
    }
  }

  Future<void> submitReport() async {
    if (crimeType.isNotEmpty &&
        locationController.text.isNotEmpty &&
        detailsController.text.isNotEmpty &&
        selectedDateTime != null) {
      try {
        await _firestore.collection('crime_reports').add({
          'crimeType': crimeType.value,
          'location': locationController.text,
          'details': detailsController.text,
          'dateTime': selectedDateTime,
          'submittedAt': Timestamp.now(),
        });
        Get.snackbar('Success', 'Report submitted successfully',
            snackPosition: SnackPosition.BOTTOM);

        // Clear fields after submission
        locationController.clear();
        detailsController.clear();
        selectedDateTime = null;
        crimeType.value = 'Theft';
        update();
      } catch (e) {
        Get.snackbar('Error', 'Failed to submit report',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Warning', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<CrimeReport>> fetchFirebaseReports() async {
    final snapshot = await _firestore
        .collection('crime_reports')
        .orderBy('submittedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => CrimeReport.fromFirestore(doc)).toList();
  }

  void listenToCrimeReports() {
    _firestore
        .collection('crime_reports')
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final latestReports = snapshot.docs
          .map((doc) => CrimeReport.fromFirestore(doc))
          .toList();

      if (latestReports.isNotEmpty &&
          (reports.isEmpty || latestReports.first.id != reports.first.id)) {
        final latest = latestReports.first;
        NotificationService.showNotification(
          title: 'New Crime Alert!',
          body: '${latest.crimeType} at ${latest.location}',
        );
      }

      reports.assignAll(latestReports);
    });
  }

  @override
  void onClose() {
    locationController.dispose();
    detailsController.dispose();
    super.onClose();
  }
}
