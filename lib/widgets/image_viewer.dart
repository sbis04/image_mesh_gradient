import 'package:animated_mesh_gradient/utils/app_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    super.key,
    required this.image,
    required this.onImage,
    this.disableTap = false,
  });

  final Image? image;
  final Function(XFile) onImage;
  final bool disableTap;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final picker = ImagePicker();

  _selectImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    widget.onImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      key: widget.key,
      child: AnimatedSwitcher(
        duration: 600.millis,
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: widget.image == null
            ? DottedBorder(
                color: Colors.indigo,
                strokeWidth: 2,
                borderType: BorderType.RRect,
                dashPattern: const [8, 4],
                radius: const Radius.circular(12),
                child: InkWell(
                  onTap: _selectImage,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 240,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Select Image',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: widget.disableTap ? null : _selectImage,
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: 600.millis,
                  curve: Curves.easeInOut,
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 240,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.image!.image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
      ),
    );
  }
}
