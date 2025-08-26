import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class UploadFormWidget extends StatefulWidget {
  final void Function(File?) onImageSelected;

  const UploadFormWidget({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  _UploadFormWidgetState createState() => _UploadFormWidgetState();
}

class _UploadFormWidgetState extends State<UploadFormWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: await _showSourceDialog(),
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      // نرجع الصورة للأب
      widget.onImageSelected(_selectedImage);
    }

  }

  Future<ImageSource> _showSourceDialog() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArabic ? 'اختر المصدر' : 'Choose Source',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Graphik Arabic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.camera_alt_rounded,
                    label: isArabic ? 'الكاميرا' : 'Camera',
                    color: Colors.blue,
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  _buildOptionButton(
                    icon: Icons.photo_library_rounded,
                    label: isArabic ? 'المعرض' : 'Gallery',
                    color: Colors.green,
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? ImageSource.gallery;
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30.w),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      height: 140.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFEAEAEA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: GestureDetector(
        onTap: _pickImage,
        child: DottedBorder(
          color: Colors.grey,
          strokeWidth: 1,
          dashPattern: [6, 3],
          borderType: BorderType.RRect,
          radius: Radius.circular(8.r),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Center(
            child: _selectedImage == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/ep_upload.png',
                  height: 50,
                  width: 65,
                ),
                SizedBox(height: 8.h),
                Text(
                  isArabic
                      ? 'يمكنك إضافة استمارة السيارة بالضغط هنا'
                      : 'You can upload car registration here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 13.sp,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
