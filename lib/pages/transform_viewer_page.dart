import 'dart:io';

import 'package:animated_mesh_gradient/pages/gradient_viewer_page.dart';
import 'package:animated_mesh_gradient/utils/app_utils.dart';
import 'package:animated_mesh_gradient/utils/gradient_utils.dart';
import 'package:animated_mesh_gradient/widgets/animated_box.dart';
import 'package:animated_mesh_gradient/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

const decodeWidth = 4;
const decodeHeight = 3;

class TransformViewerPage extends StatefulWidget {
  const TransformViewerPage({super.key});

  @override
  State<TransformViewerPage> createState() => _TransformViewerPageState();
}

class _TransformViewerPageState extends State<TransformViewerPage> {
  XFile? image;
  String? blurHash;
  List<Color>? meshColors;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedSize(
          alignment: Alignment.topCenter,
          duration: 600.millis,
          curve: Curves.easeInOut,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Animated mesh gradient
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        transitionDuration: 600.millis,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return FadeTransition(
                            opacity: animation,
                            alwaysIncludeSemantics: true,
                            child: GradientViewerPage(
                              image: image!,
                              meshColors: meshColors!,
                            ),
                          );
                        },
                      ),
                    ),
                    child: Hero(
                      tag: 'gradient',
                      child: AnimatedBox(
                        width: 400,
                        height: 240,
                        child: meshColors == null
                            ? null
                            : AnimatedMeshGradient(
                                colors: meshColors!,
                                options: AnimatedMeshGradientOptions(
                                  amplitude: 50,
                                  grain: 0.1,
                                  frequency: 5,
                                  speed: 5,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'image',
                    child: ImageViewer(
                      image: image != null
                          ? Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            )
                          : null,
                      onImage: (image) async {
                        setState(() {
                          this.image = image;
                          this.meshColors = null;
                        });
                        final meshColors = await generateMeshGradientFromImage(
                          Image.file(File(image.path)).image,
                        );
                        setState(() => this.meshColors = meshColors);
                      },
                    ),
                  ),
                ].divide(const SizedBox(height: 16)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
