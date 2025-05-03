import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:london_crime/models/crime_report_model.dart';

class CrimeDetailsPage extends StatelessWidget {
  final CrimeReport report;

  const CrimeDetailsPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    // Format the date and time
    final String formattedDate = DateFormat.yMMMMd().format(report.dateTime); // Example: April 27, 2025
    final String formattedTime = DateFormat.jm().format(report.dateTime);     // Example: 5:30 PM

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Details'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('📅 Date:', style: _titleStyle()),
                            Text(formattedDate, style: _contentStyle()),
                            Spacer(),
                            const SizedBox(height: 16),
                            Text('🕒 Time:', style: _titleStyle()),
                            Text(formattedTime, style: _contentStyle()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.cyanAccent,),
                        const SizedBox(height: 16),
                        Text('📝 Crime Type:', style: _titleStyle()),
                        Text(report.crimeType, style: _contentStyle()),

                        const SizedBox(height: 16),
                        Text('📍 Location:', style: _titleStyle()),
                        Text(report.location, style: _contentStyle()),

                        const SizedBox(height: 16),
                        Text('📝 Details:', style: _titleStyle()),
                        Text(report.details, style: _contentStyle()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _titleStyle() => const TextStyle(
      color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16);

  TextStyle _contentStyle() => const TextStyle(
      color: Colors.white, fontSize: 15, height: 1.4);
}
