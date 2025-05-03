import 'package:cloud_firestore/cloud_firestore.dart';

class CrimeReport {
  final String id;
  final String crimeType;
  final String location;
  final String details;
  final DateTime dateTime;

  CrimeReport({
    required this.id,
    required this.crimeType,
    required this.location,
    required this.details,
    required this.dateTime,
  });

  // Factory constructor for creating a CrimeReport from Firestore snapshot
  factory CrimeReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CrimeReport(
      id: doc.id,
      crimeType: data['crimeType'] ?? '',
      location: data['location'] ?? '',
      details: data['details'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }

  // If you ever need from Map only (without DocumentSnapshot)
  factory CrimeReport.fromMap(Map<String, dynamic> data, {required String id}) {
    return CrimeReport(
      id: id,
      crimeType: data['crimeType'] ?? '',
      location: data['location'] ?? '',
      details: data['details'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
    );
  }
}
