import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:london_crime/utils/theme/colors.dart';
import 'package:london_crime/view/search/crime_search.dart';
import 'package:london_crime/view/crime_statistic/crime_state.dart';
import 'package:london_crime/view/home.dart';
import 'package:london_crime/view/prediction.dart';
import 'package:london_crime/view/profile.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<CustomBottomBar> {
  int indexColor = 0;
  final List<Widget> screens = [
    OverViewCrimeStatsPage(),
    CrimeStatsPage(),
    CrimeSearchPage(),
    AnalysisPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: screens[indexColor],
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          color: kWhiteColor,
          shape: const CircularNotchedRectangle(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBottomNavigationItem(Icons.map, 1,"Statistics"),
                  _buildBottomNavigationItem(CupertinoIcons.lock_shield, 2, "Search"),
                  _buildBottomNavigationItem(Icons.home, 0,"Dashboard"),
                  _buildBottomNavigationItem(Icons.dynamic_feed, 3, "Analysis "),
                  _buildBottomNavigationItem(Icons.person_pin, 4, "Account"),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10.sp,
          backgroundColor: kRedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.sp)),
          onPressed: () {
            _showSOSConfirmation(context);
          },
          child: Icon(Icons.sos, color: kWhiteColor, size: 28.sp),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          indexColor = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: indexColor == index ? kPrimaryColor : kGreyColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: indexColor == index ? kPrimaryColor : kGreyColor,),),
          ),
        ],
      ),
    );
  }

  void _showSOSConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Are you in danger?",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Press Yes to alert the police immediately.",
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRedColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSOSAlert(context);
            },
            child: Text("Yes", style: TextStyle(color: kWhiteColor, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  void _showSOSAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: kRedColor.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: kWhiteColor, size: 30.sp),
            SizedBox(width: 10),
            Text(
              "Emergency!",
              style: TextStyle(color: kWhiteColor, fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Police has been alerted. Stay calm and safe!",
          style: TextStyle(color: kWhiteColor, fontSize: 16.sp),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
            ),
          )
        ],
      ),
    );
  }

}