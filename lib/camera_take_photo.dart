import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum ImageType {
  idCardFront,
  idCardBack,
  licenseFront,
  licenseBack,
}

class TakePictureMaterialPage extends StatefulWidget {
  const TakePictureMaterialPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TakePictureMaterialPageState createState() =>
      _TakePictureMaterialPageState();
}

class _TakePictureMaterialPageState extends State<TakePictureMaterialPage> {
  File? idCardFrontImage;
  File? idCardBackImage;
  File? licenseFrontImage;
  File? licenseBackImage;

  Future<void> _takePhoto(ImageType imageType) async {
    final imagePicker = ImagePicker();
    final XFile? imageFile =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (imageFile == null) {
      return;
    }

    final File savedImage = File(imageFile.path);

    setState(() {
      // 根據 imageType 更新對應的圖片檔案變數
      switch (imageType) {
        case ImageType.idCardFront:
          idCardFrontImage = savedImage;
          break;
        case ImageType.idCardBack:
          idCardBackImage = savedImage;
          break;
        case ImageType.licenseFront:
          licenseFrontImage = savedImage;
          break;
        case ImageType.licenseBack:
          licenseBackImage = savedImage;
          break;
      }
    });
  }

  Future<void> _selectFile(ImageType imageType) async {
    final imagePicker = ImagePicker();
    final XFile? imageFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      return;
    }

    final File selectedImage = File(imageFile.path);

    setState(() {
      // 根據 imageType 更新對應的圖片檔案變數
      switch (imageType) {
        case ImageType.idCardFront:
          idCardFrontImage = selectedImage;
          break;
        case ImageType.idCardBack:
          idCardBackImage = selectedImage;
          break;
        case ImageType.licenseFront:
          licenseFrontImage = selectedImage;
          break;
        case ImageType.licenseBack:
          licenseBackImage = selectedImage;
          break;
      }
    });
  }

  void _showSelectedImagesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('已選擇的圖片'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (idCardFrontImage != null) Image.file(idCardFrontImage!),
              if (idCardBackImage != null) Image.file(idCardBackImage!),
              if (licenseFrontImage != null) Image.file(licenseFrontImage!),
              if (licenseBackImage != null) Image.file(licenseBackImage!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('上傳資料'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildImageSelectionSection(
            '身分證正面',
            idCardFrontImage,
            ImageType.idCardFront,
          ),
          const SizedBox(height: 16.0),
          _buildImageSelectionSection(
            '身分證背面',
            idCardBackImage,
            ImageType.idCardBack,
          ),
          const SizedBox(height: 16.0),
          _buildImageSelectionSection(
            '行照正面',
            licenseFrontImage,
            ImageType.licenseFront,
          ),
          const SizedBox(height: 16.0),
          _buildImageSelectionSection(
            '行照背面',
            licenseBackImage,
            ImageType.licenseBack,
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              _showSelectedImagesDialog();
            },
            child: const Text('上傳資料'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelectionSection(
    String title,
    File? imageFile,
    ImageType imageType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        if (imageFile == null)
          ElevatedButton.icon(
            onPressed: () {
              _showImageSelectionDialog(imageType);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('拍照或選檔案'),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(imageFile),
              const SizedBox(height: 8.0),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    // 清除對應的圖片檔案
                    switch (imageType) {
                      case ImageType.idCardFront:
                        idCardFrontImage = null;
                        break;
                      case ImageType.idCardBack:
                        idCardBackImage = null;
                        break;
                      case ImageType.licenseFront:
                        licenseFrontImage = null;
                        break;
                      case ImageType.licenseBack:
                        licenseBackImage = null;
                        break;
                    }
                  });
                },
                icon: const Icon(Icons.delete),
                label: const Text('刪除'),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _showImageSelectionDialog(ImageType imageType) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('選擇圖片'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(imageType);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('選檔案'),
              onTap: () {
                Navigator.pop(context);
                _selectFile(imageType);
              },
            ),
          ],
        ),
      ),
    );
  }
}
