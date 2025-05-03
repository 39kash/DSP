import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:london_crime/controller/crime_report_controller.dart';
import 'package:london_crime/utils/theme/colors.dart';

class SubmitCrimeReportPage extends StatelessWidget {
  final controller = Get.put(SubmitCrimeReportController());
  SubmitCrimeReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios)),
        title: Text('Submit Crime Report',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crime Type', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(
                  () => DropdownButtonFormField<String>(
                value: controller.crimeType.value,
                items: ['Theft', 'Assault', 'Vandalism', 'Fraud', 'Other']
                    .map((type) => DropdownMenuItem(
                  child: Text(type),
                  value: type,
                ))
                    .toList(),
                onChanged: (value) {
                  controller.crimeType.value = value!;
                },
              ),
            ),
            const SizedBox(height: 16),

            Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.locationController,
              decoration: InputDecoration(
                hintText: 'Enter location',
                hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.detailsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter crime details',
                hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.w300),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Text('Date and Time', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GetBuilder<SubmitCrimeReportController>(
              builder: (_) => GestureDetector(
                onTap: () => controller.pickDateTime(context),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  //padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      controller.selectedDateTime == null
                          ? 'yyyy/mm/dd --:--:.--'
                          : '${controller.selectedDateTime}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            Center(
              child: GestureDetector(
                onTap: controller.submitReport,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Submit Report",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
