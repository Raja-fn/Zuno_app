import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/design/zuno_app_bar.dart';
import '../../services/post_service.dart';
import '../../services/image_upload_service.dart';
import '../../models/post_data.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  String _selectedCommunity = 'city';
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked =
    await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submitPost() async {
    if (_selectedImage == null ||
        captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select image & caption")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final imageUrl = await ImageUploadService()
          .uploadPostImage(_selectedImage!);

      await PostService().createPost(
        imageUrl: imageUrl,
        username: 'Raja',
      );


      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: zunoAppBar(title: "Create Post"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// IMAGE PICKER
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                alignment: Alignment.center,
                child: _selectedImage == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo,
                        size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("Tap to select image"),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// CAPTION
            TextField(
              controller: captionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write a caption...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// COMMUNITY DROPDOWN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCommunity,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'city',
                      child: Text("📍 City"),
                    ),
                    DropdownMenuItem(
                      value: 'college',
                      child: Text("🎓 College"),
                    ),
                    DropdownMenuItem(
                      value: 'festival',
                      child: Text("🎉 Festival"),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCommunity = value);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// POST BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _loading ? null : _submitPost,
                child: _loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Post",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
