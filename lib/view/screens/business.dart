import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import 'activity_report.dart';
import 'daily_acticvity.dart';

class BusinessDailyActivity extends StatefulWidget {
  const BusinessDailyActivity({super.key});

  @override
  State<BusinessDailyActivity> createState() => _BusinessDailyActivityState();
}

class _BusinessDailyActivityState extends State<BusinessDailyActivity> {
  late double height;
  late double width;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _mediumController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _editionController = TextEditingController();
  final _sizeController = TextEditingController();
  final _locationController = TextEditingController();

  // Dropdown values
  String? _selectedCustomer;
  String? _selectedCallType;
  String? _selectedActivityType;
  String? _selectedProductCategory;
  String? _selectedReason;
  String? _selectedPosition;

  // Color scheme
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color secondaryColor = Color(0xFF1E40AF);
  static const Color accentColor = Color(0xFF3B82F6);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF1E293B);
  static const Color textSecondaryColor = Color(0xFF64748B);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  // Fixed business type
  final String _businessType = 'Business';

  // Customer options
  final List<String> _customers = ['Regent', 'Info', 'Solution'];

  // Activity type options
  final List<String> _activityTypes = [
    'Delivered',
    'Not Delivered',
    'Next Call Date',
    'On Going',
  ];

  // Product category options
  final List<String> _productCategories = [
    'Automobile',
    'Cinema',
    'Commercial',
    'Domestic Brand',
    'Electronics',
    'For Sale',
    'Furniture',
    'Greetings',
    'Homage',
    'Industrial',
    'Jewellery',
    'Mobiles',
    'Obituary',
    'Opening',
    'Political',
    'Real Estate - For Sale',
    'Real Estate - Promoters',
    'Real Estate - Rental',
    'Restaurants',
    'Spiritual',
    'Textiles',
    'Wanted',
  ];

  // Reason options
  final List<String> _reasons = [
    'Advertisement',
    'Proof Copy',
    'Cost Confirmation',
    'New Client Meeting',
    'Follow Up',
  ];

  // Position options
  final List<String> _positions = ['High', 'Medium', 'Low'];

  // Call type options
  final List<String> _callTypes = [
    'New Call - Cold Call',
    'New Call - Hot Call',
    'Old Call - Fresh',
    'Old Call - Repeat',
  ];

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

  @override
  void dispose() {
    _mediumController.dispose();
    _vehicleController.dispose();
    _editionController.dispose();
    _sizeController.dispose();
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
          customer: _selectedCustomer ?? '',
          callType: _selectedCallType ?? '',
          activityType: _selectedActivityType ?? '',
          productCategory: _selectedProductCategory ?? '',
          reason: _selectedReason ?? '',
          medium: _mediumController.text,
          vehicle: _vehicleController.text,
          edition: _editionController.text,
          position: _selectedPosition ?? '',
          size: _sizeController.text,
          location: _locationController.text,
          createdDate: DateTime.now(),
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
          "Business Daily Activities",
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
                          'New Business Activity Entry',
                          style: GoogleFonts.dmSans(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Track your daily business activities efficiently',
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
                        value: _selectedCustomer,
                        label: 'Customer',
                        icon: Icons.person,
                        items: _customers,
                        hint: 'Select customer',
                        onChanged: (value) {
                          setState(() {
                            _selectedCustomer = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // Activity Details Section
                  _buildFormSection(
                    title: 'Business Activity Details',
                    icon: Icons.assignment,
                    children: [
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
                        value: _selectedPosition,
                        label: 'Priority Level',
                        icon: Icons.place,
                        items: _positions,
                        hint: 'Select priority level',
                        onChanged: (value) {
                          setState(() {
                            _selectedPosition = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildTextFormField(
                        controller: _sizeController,
                        label: 'Size',
                        icon: Icons.photo_size_select_actual,
                        hint: 'Enter size details',
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // Product Information Section
                  _buildFormSection(
                    title: 'Business Product Information',
                    icon: Icons.inventory_2,
                    children: [
                      _buildDropdownField(
                        value: _selectedProductCategory,
                        label: 'Product Category',
                        icon: Icons.inventory,
                        items: _productCategories,
                        hint: 'Select product category',
                        onChanged: (value) {
                          setState(() {
                            _selectedProductCategory = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildDropdownField(
                        value: _selectedReason,
                        label: 'Business Purpose',
                        icon: Icons.help_outline,
                        items: _reasons,
                        hint: 'Select business purpose',
                        onChanged: (value) {
                          setState(() {
                            _selectedReason = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // Publication Details Section
                  _buildFormSection(
                    title: 'Business Publication Details',
                    icon: Icons.newspaper,
                    children: [
                      _buildTextFormField(
                        controller: _mediumController,
                        label: 'Medium',
                        icon: Icons.media_bluetooth_on,
                        hint: 'Enter medium details',
                      ),
                      SizedBox(height: 20.h),
                      _buildTextFormField(
                        controller: _vehicleController,
                        label: 'Vehicle',
                        icon: Icons.directions_car,
                        hint: 'Enter vehicle details',
                      ),
                      SizedBox(height: 20.h),
                      _buildTextFormField(
                        controller: _editionController,
                        label: 'Edition',
                        icon: Icons.edit,
                        hint: 'Enter edition details',
                      ),

                      SizedBox(height: 20.h),
                      _buildDropdownField(
                        value: _selectedActivityType,
                        label: 'Activity Status',
                        icon: Icons.assignment_turned_in,
                        items: _activityTypes,
                        hint: 'Select activity status',
                        onChanged: (value) {
                          setState(() {
                            _selectedActivityType = value;
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
                              _mediumController.clear();
                              _vehicleController.clear();
                              _editionController.clear();
                              _sizeController.clear();
                              _locationController.clear();
                              setState(() {
                                _selectedCustomer = null;
                                _selectedCallType = null;
                                _selectedActivityType = null;
                                _selectedProductCategory = null;
                                _selectedReason = null;
                                _selectedPosition = null;
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
