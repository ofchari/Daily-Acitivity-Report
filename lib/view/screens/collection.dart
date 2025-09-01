import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/activity_hive_model.dart';
import '../../utils/route_map/location.dart';
import 'activity_report.dart';

class CollectionDailyActivity extends StatefulWidget {
  const CollectionDailyActivity({super.key});

  @override
  State<CollectionDailyActivity> createState() =>
      _CollectionDailyActivityState();
}

class _CollectionDailyActivityState extends State<CollectionDailyActivity> {
  late double height;
  late double width;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _invoiceNoController = TextEditingController();
  final _issuesController = TextEditingController();
  final _locationController = TextEditingController();

  // Date controllers
  DateTime? _nextCallDate;

  // Dropdown values
  String? _selectedCallType;
  String? _selectedClientName;
  String? _selectedPayType;
  String? _selectedIssues;
  String? _selectedResult;

  // Color scheme
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color secondaryColor = Color(0xFF1E40AF);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF1E293B);
  static const Color textSecondaryColor = Color(0xFF64748B);

  // Fixed business type
  final String _businessType = 'Collection';

  // Call type options
  final List<String> _callTypes = ['Bill', 'Payment'];

  // Client name options
  final List<String> _clientNames = ['Regent', 'Info', 'Solution'];

  // Pay type options
  final List<String> _payTypes = ['Cash', 'Cheque', 'NEFT', 'Next Call Date'];

  // Result options
  final List<String> _results = [
    'Delivered',
    'Not Delivered',
    'Next Call Date',
  ];

  // Issues options
  final List<String> _issuesOptions = [
    'Product Issues',
    'Bill Issues',
    'Other Issues',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) _showLocationPermissionDialog();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) _showLocationPermissionDialog();
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) _showLocationServiceDialog();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _locationController.text =
            'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
      });

      // Show success message only if user is already in screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  'Location captured successfully!',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white, size: 16.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Failed to get location: $e',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          margin: EdgeInsets.all(16.w),
        ),
      );
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.location_disabled, color: Colors.orange, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Location Permission',
                style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'This app needs location access to capture your current coordinates. Please enable location permission in settings.',
            style: GoogleFonts.dmSans(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Open Settings',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.location_off, color: Colors.red, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Location Service',
                style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Location services are disabled. Please enable location services to get your current coordinates.',
            style: GoogleFonts.dmSans(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Enable Location',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _locationController,
          style: GoogleFonts.dmSans(fontSize: 14.sp, color: textPrimaryColor),
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Fetching location...',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 14.sp,
              color: textSecondaryColor,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(12.w),
              child: Icon(Icons.location_on, color: primaryColor, size: 20.sp),
            ),
            // 🚫 Removed suffix icon (no button)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please capture location';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _selectNextCallDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _nextCallDate) {
      setState(() {
        _nextCallDate = picked;
      });
    }
  }

  Widget _buildDateFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Next Call Date',
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: _selectNextCallDate,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
              borderRadius: BorderRadius.circular(12.r),
              color: const Color(0xFFFAFAFA),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.all(12.w),
                  child: Icon(
                    Icons.calendar_today,
                    color: primaryColor,
                    size: 20.sp,
                  ),
                ),
                Expanded(
                  child: Text(
                    _nextCallDate == null
                        ? 'Select next call date'
                        : '${_nextCallDate!.day}/${_nextCallDate!.month}/${_nextCallDate!.year}',
                    style: GoogleFonts.dmSans(
                      fontSize: 14.sp,
                      color: _nextCallDate == null
                          ? textSecondaryColor
                          : textPrimaryColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: textSecondaryColor,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _issuesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Save data to Hive
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final box = await Hive.openBox<DailyActivityModel>('daily_activities');

        final activity = DailyActivityModel(
          businessType: _businessType,
          customer: _selectedClientName ?? '',
          callType: _selectedCallType ?? '',
          activityType: _selectedResult ?? '',
          productCategory: _selectedPayType ?? '',
          reason: _issuesController.text,
          medium: _invoiceNoController.text,
          vehicle: '',
          edition: '',
          position: '',
          size: '',
          location: _locationController.text,
          createdDate: DateTime.now(),
          media: '',
          cost: '',
        );

        await box.add(activity);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12.w),
                Text(
                  'Activity saved successfully!',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );

        // Navigate to data table page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ActivityDataTablePage(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12.w),
                Text(
                  'Error saving data: $e',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Collection Daily Activities",
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
              Get.to(() => const RouteMapPage());
            },
            icon: Icon(Icons.location_on, size: 24.sp, color: Colors.white),
            tooltip: 'View Map',
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const ActivityDataTablePage());
            },
            icon: Icon(Icons.table_chart, size: 24.sp, color: Colors.white),
            tooltip: 'View Activities',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [backgroundColor, Color(0xFFE2E8F0)],
          ),
        ),
        child: SizedBox(
          width: width.w,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.assignment_add,
                          size: 32.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'New Collection Activity Entry',
                          style: GoogleFonts.dmSans(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Track your daily collection activities efficiently',
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Basic Information Section
                  _buildFormSection(
                    title: 'Basic Information',
                    icon: Icons.info_outline,
                    children: [
                      _buildLocationFormField(),
                      SizedBox(height: 20.h),
                      _buildDropdownField(
                        value: _selectedCallType,
                        label: 'Call Type',
                        icon: Icons.call,
                        items: _callTypes,
                        hint: 'Select call type',
                        onChanged: (value) {
                          setState(() {
                            _selectedCallType = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildDropdownField(
                        value: _selectedClientName,
                        label: 'Client Name',
                        icon: Icons.person,
                        items: _clientNames,
                        hint: 'Select client name',
                        onChanged: (value) {
                          setState(() {
                            _selectedClientName = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // Invoice & Payment Details Section
                  _buildFormSection(
                    title: 'Invoice & Payment Details',
                    icon: Icons.receipt_long,
                    children: [
                      _buildTextFormField(
                        controller: _invoiceNoController,
                        label: 'Invoice No',
                        icon: Icons.receipt,
                        hint: 'Enter invoice number',
                      ),
                      SizedBox(height: 20.h),
                      _buildDropdownField(
                        value: _selectedPayType,
                        label: 'Pay Type',
                        icon: Icons.payment,
                        items: _payTypes,
                        hint: 'Select payment type',
                        onChanged: (value) {
                          setState(() {
                            _selectedPayType = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // Result & Follow-up Section
                  _buildFormSection(
                    title: 'Result & Follow-up',
                    icon: Icons.assignment_turned_in,
                    children: [
                      _buildDropdownField(
                        value: _selectedResult,
                        label: 'Result',
                        icon: Icons.check_circle_outline,
                        items: _results,
                        hint: 'Select result',
                        onChanged: (value) {
                          setState(() {
                            _selectedResult = value;
                          });
                        },
                      ),
                      // SizedBox(height: 20.h),
                      // _buildDateFormField(),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // Issues Section
                  _buildFormSection(
                    title: 'Issues',
                    icon: Icons.warning_amber,
                    children: [
                      _buildDropdownField(
                        value: _selectedIssues,
                        label: 'Issues',
                        icon: Icons.report_problem,
                        items: _issuesOptions,
                        hint: 'Select Issues',
                        onChanged: (value) {
                          setState(() {
                            _selectedIssues = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: textSecondaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // Clear form
                              _formKey.currentState?.reset();
                              _invoiceNoController.clear();
                              _issuesController.clear();
                              _locationController.clear();
                              setState(() {
                                _selectedCallType = null;
                                _selectedClientName = null;
                                _selectedPayType = null;
                                _selectedResult = null;
                                _nextCallDate = null;
                              });
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              'Clear \n  Form',
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: textSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _saveData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save_alt,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Save Activity',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: primaryColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          style: GoogleFonts.dmSans(fontSize: 14.sp, color: textPrimaryColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.dmSans(
              fontSize: 14.sp,
              color: textSecondaryColor,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(12.w),
              child: Icon(icon, color: primaryColor, size: 20.sp),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: const Color(0xFFDC2626),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFFDC2626), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: value,
          style: GoogleFonts.dmSans(fontSize: 14.sp, color: textPrimaryColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.dmSans(
              fontSize: 14.sp,
              color: textSecondaryColor,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(12.w),
              child: Icon(icon, color: primaryColor, size: 20.sp),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: const Color(0xFFDC2626),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFFDC2626), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: textPrimaryColor,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: textSecondaryColor,
            size: 24.sp,
          ),
          elevation: 8,
        ),
      ],
    );
  }
}
