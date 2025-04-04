import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  var image = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
    Get.back();
  }
}

class ImagePickerScreen extends StatelessWidget {
  final ImagePickerController controller = Get.put(ImagePickerController());

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image, color: Colors.blue, size: 30),
              title: Text("Gallery", style: TextStyle(fontSize: 18)),
              onTap: () => controller.pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.camera, color: Colors.green, size: 30),
              title: Text("Camera", style: TextStyle(fontSize: 18)),
              onTap: () => controller.pickImage(ImageSource.camera),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            return controller.image.value == null
                ? GestureDetector(
                    onTap: () => _showImageSourceDialog(context),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.grey[300], shape: BoxShape.circle),
                      child: Icon(Icons.add, size: 50, color: Colors.black54),
                    ),
                  )
                : Column(
                    children: [
                      Image.file(controller.image.value!,
                          width: 200, height: 200, fit: BoxFit.cover),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => _showImageSourceDialog(context),
                            icon: Icon(Icons.edit),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              Get.snackbar(
                                "Success",
                                "Image uploaded successfully",
                                snackPosition:
                                    SnackPosition.BOTTOM, // Positioning
                                backgroundColor: Colors.green, // Customization
                                colorText: Colors.white, // Text color
                              );
                            },
                            icon: Icon(Icons.check, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  );
          }),
        ],
      ),
    );
  }
}
