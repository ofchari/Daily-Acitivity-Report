import 'package:daily_activity_report/services/cutting_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cutting extends StatefulWidget {
  const Cutting({super.key});

  @override
  State<Cutting> createState() => _CuttingState();
}

class _CuttingState extends State<Cutting> {
  late double height;
  late double width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCutting();
  }

  @override
  Widget build(BuildContext context) {
    /// Define Sizes //
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SizedBox(
        width: width.w,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            FutureBuilder(
              future: fetchCutting(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  final cutData = snapshot.data!;
                  return Column(
                    children: [
                      Text(cutData.creation.toString()),
                      Text(cutData.modified.toString()),
                      Text(cutData.name.toString()),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
