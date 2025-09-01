import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../utils/activity_hive_model.dart';
import 'dashboard_select_data.dart';

class ActivityDataTablePage extends StatefulWidget {
  const ActivityDataTablePage({super.key});

  @override
  State<ActivityDataTablePage> createState() => _ActivityDataTablePageState();
}

class _ActivityDataTablePageState extends State<ActivityDataTablePage> {
  List<DailyActivityModel> _activities = [];
  String _selectedType = 'All';

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final box = await Hive.openBox<DailyActivityModel>('daily_activities');
    setState(() {
      _activities = box.values.toList();
    });
  }

  List<DataColumn> _getColumns(String type) {
    switch (type) {
      case 'Business':
        return [
          _buildHeader('Business Type'),
          _buildHeader('Customer'),
          _buildHeader('Call Type'),
          _buildHeader('Activity Status'),
          _buildHeader('Product Category'),
          _buildHeader('Business Purpose'),
          _buildHeader('Medium'),
          _buildHeader('Vehicle'),
          _buildHeader('Edition'),
          _buildHeader('Priority Level'),
          _buildHeader('Size'),
          _buildHeader('Media'),
          _buildHeader('Position'),
          _buildHeader('Cost'),
          _buildHeader('Date'),
        ];
      case 'Designing':
        return [
          _buildHeader('Business Type'),
          _buildHeader('Client Name'),
          _buildHeader('Worktype'),
          _buildHeader('Result'),
          _buildHeader('Size'),
          _buildHeader('Date'),
        ];
      case 'Collection':
        return [
          _buildHeader('Business Type'),
          _buildHeader('Client Name'),
          _buildHeader('Call Type'),
          _buildHeader('Result'),
          _buildHeader('Pay Type'),
          _buildHeader('Invoice No'),
          _buildHeader('Issues'),
          _buildHeader('Date'),
        ];
      case 'All':
      default:
        return [
          _buildHeader('Business Type'),
          _buildHeader('Customer'),
          _buildHeader('Call Type'),
          _buildHeader('Activity Type'),
          _buildHeader('Product Category'),
          _buildHeader('Reason'),
          _buildHeader('Medium'),
          _buildHeader('Vehicle'),
          _buildHeader('Edition'),
          _buildHeader('Position'),
          _buildHeader('Size'),
          _buildHeader('Date'),
        ];
    }
  }

  List<DataRow> _getRows(List<DailyActivityModel> activities, String type) {
    return activities.map((activity) {
      switch (type) {
        case 'Business':
          return DataRow(
            cells: [
              _buildCell(activity.businessType),
              _buildCell(activity.customer),
              _buildCell(activity.callType),
              _buildCell(activity.activityType),
              _buildCell(activity.productCategory),
              _buildCell(activity.reason),
              _buildCell(activity.medium),
              _buildCell(activity.media),
              _buildCell(activity.cost),
              _buildCell(activity.medium),
              _buildCell(activity.vehicle),
              _buildCell(activity.edition),
              _buildCell(activity.position),
              _buildCell(activity.size),
              _buildCell(
                '${activity.createdDate.day}/${activity.createdDate.month}/${activity.createdDate.year}',
              ),
            ],
          );
        case 'Designing':
          return DataRow(
            cells: [
              _buildCell(activity.businessType),
              _buildCell(activity.customer),
              _buildCell(activity.callType),
              _buildCell(activity.activityType),
              _buildCell(activity.size),
              _buildCell(
                '${activity.createdDate.day}/${activity.createdDate.month}/${activity.createdDate.year}',
              ),
            ],
          );
        case 'Collection':
          return DataRow(
            cells: [
              _buildCell(activity.businessType),
              _buildCell(activity.customer),
              _buildCell(activity.callType),
              _buildCell(activity.activityType),
              _buildCell(activity.productCategory),
              _buildCell(activity.medium),
              _buildCell(activity.reason),
              _buildCell(
                '${activity.createdDate.day}/${activity.createdDate.month}/${activity.createdDate.year}',
              ),
            ],
          );
        case 'All':
        default:
          return DataRow(
            cells: [
              _buildCell(activity.businessType),
              _buildCell(activity.customer),
              _buildCell(activity.callType),
              _buildCell(activity.activityType),
              _buildCell(activity.productCategory),
              _buildCell(activity.reason),
              _buildCell(activity.medium),
              _buildCell(activity.vehicle),
              _buildCell(activity.edition),
              _buildCell(activity.position),
              _buildCell(activity.size),
              _buildCell(
                '${activity.createdDate.day}/${activity.createdDate.month}/${activity.createdDate.year}',
              ),
            ],
          );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredActivities = _selectedType == 'All'
        ? _activities
        : _activities.where((a) => a.businessType == _selectedType).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Daily Activities Report",
          style: GoogleFonts.dmSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.off(const ActivitySelectionPage());
            },
            icon: const Icon(Icons.add),
            tooltip: "Add Activity",
          ),
        ],
      ),
      body: _activities.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No activities found',
                    style: GoogleFonts.dmSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add your first activity to get started',
                    style: GoogleFonts.dmSans(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: ['All', 'Business', 'Designing', 'Collection'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Activity Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                if (filteredActivities.isEmpty)
                  Center(
                    child: Text(
                      'No activities for selected type',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 3,
                            shadowColor: Colors.black12,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                const Color(0xFFEFF6FF),
                              ),
                              dataRowHeight: 56.h,
                              headingRowHeight: 56.h,
                              horizontalMargin: 16.w,
                              columnSpacing: 24.w,
                              border: TableBorder.symmetric(
                                inside: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 0.5,
                                ),
                                outside: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              columns: _getColumns(_selectedType),
                              rows: _getRows(filteredActivities, _selectedType),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  DataColumn _buildHeader(String title) {
    return DataColumn(
      label: Text(
        title,
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  DataCell _buildCell(String value) {
    return DataCell(
      Text(
        value,
        style: GoogleFonts.dmSans(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF475569),
        ),
      ),
    );
  }
}
