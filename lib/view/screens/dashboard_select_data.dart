import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'accounts.dart';
import 'activity_report.dart';
import 'business.dart';
import 'collection.dart';
import 'desigining.dart';

class ActivitySelectionPage extends StatefulWidget {
  const ActivitySelectionPage({super.key});

  @override
  State<ActivitySelectionPage> createState() => _ActivitySelectionPageState();
}

class _ActivitySelectionPageState extends State<ActivitySelectionPage> {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color secondaryColor = Color(0xFF1E40AF);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color textPrimaryColor = Color(0xFF1E293B);

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required List<Color> colors, // <-- pass gradient colors here
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: Colors.white.withOpacity(0.15),
                child: Icon(icon, color: Colors.white, size: 28.sp),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Daily Activities",
          style: GoogleFonts.dmSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const ActivityDataTablePage());
            },
            icon: Icon(Icons.table_chart, size: 24.sp, color: Colors.white),
            tooltip: 'View Activities',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        children: [
          _buildActivityCard(
            icon: Icons.business_center,
            title: "Business",
            onTap: () => Get.to(() => const BusinessDailyActivity()),
            colors: [const Color(0xFF2563EB), const Color(0xFF1E40AF)], // blue
          ),
          _buildActivityCard(
            icon: Icons.collections_bookmark,
            title: "Collection",
            onTap: () => Get.to(() => const CollectionDailyActivity()),
            colors: [const Color(0xFF10B981), const Color(0xFF047857)], // green
          ),
          _buildActivityCard(
            icon: Icons.design_services,
            title: "Designing",
            onTap: () => Get.to(() => const DesigningDailyActivity()),
            colors: [
              const Color(0xFFF59E0B),
              const Color(0xFFB45309),
            ], // orange
          ),
          _buildActivityCard(
            icon: Icons.account_balance,
            title: "Account",
            onTap: () => Get.to(() => Accounts()),
            colors: [
              const Color(0xFF8B5CF6),
              const Color(0xFF6D28D9),
            ], // purple
          ),
          _buildActivityCard(
            icon: Icons.manage_accounts,
            title: "Manager",
            onTap: () => Get.to(() => const Accounts()),
            colors: [const Color(0xFFEF4444), const Color(0xFFB91C1C)], // red
          ),
        ],
      ),
    );
  }
}
