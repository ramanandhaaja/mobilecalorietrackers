import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement logout logic
          print('Log Out Tapped');
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.red,
          backgroundColor: Colors.red[50],
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: const Text('Log Out'),
      ),
    );
  }
}
