import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PetProfilePicture extends StatefulWidget {
  final Function(String url) onPictureSelected;

  const PetProfilePicture({Key? key, required this.onPictureSelected}) : super(key: key);

  @override
  _PetProfilePictureState createState() => _PetProfilePictureState();
}

class _PetProfilePictureState extends State<PetProfilePicture> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _uploadedImageUrl;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage(); // Automatically upload the image after picking
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('pet_profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(_image!);

      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = downloadUrl;
        _isUploading = false;
      });

      widget.onPictureSelected(downloadUrl); // Notify parent widget

      print('Pet profile picture uploaded: $downloadUrl');
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading pet profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : _uploadedImageUrl != null
                ? NetworkImage(_uploadedImageUrl!) as ImageProvider
                : const AssetImage(''),
            child: _image == null && _uploadedImageUrl == null
                ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 10),
        if (_isUploading) const CircularProgressIndicator(),
      ],
    );
  }
}
