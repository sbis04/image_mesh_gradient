import 'dart:io';

import 'package:animated_mesh_gradient/widgets/animated_box.dart';
import 'package:animated_mesh_gradient/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

const decodeWidth = 4;
const decodeHeight = 3;

class GradientViewerPage extends StatefulWidget {
  const GradientViewerPage({
    super.key,
    required this.image,
    required this.meshColors,
  });

  final XFile image;
  final List<Color> meshColors;

  @override
  State<GradientViewerPage> createState() => _GradientViewerPageState();
}

class _GradientViewerPageState extends State<GradientViewerPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Hero(
            tag: 'gradient',
            transitionOnUserGestures: true,
            child: AnimatedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: AnimatedMeshGradient(
                colors: widget.meshColors,
                options: AnimatedMeshGradientOptions(
                  amplitude: 30,
                  grain: 0.4,
                  frequency: 5,
                  speed: 2,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Hero(
              tag: 'image',
              transitionOnUserGestures: true,
              child: ImageViewer(
                disableTap: true,
                image: Image.file(
                  File(widget.image.path),
                  fit: BoxFit.cover,
                ),
                onImage: (image) async {
                  // setState(() {
                  //   this.image = image;
                  //   this.meshColors = null;
                  // });
                  // final meshColors = await generateMeshGradientFromImage(
                  //   Image.file(File(image.path)).image,
                  // );
                  // setState(() => this.meshColors = meshColors);
                },
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   // add a linear gradient
          //   child: Container(
          //     height: 80,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         stops: [-2, 1],
          //         begin: Alignment.bottomCenter,
          //         end: Alignment.topCenter,
          //         colors: [
          //           Colors.white,
          //           Colors.white.withOpacity(0),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: AnimatedContainer(
          //     duration: 600.millis,
          //     curve: Curves.easeInOut,
          //     height: 140,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.bottomCenter,
          //         end: Alignment.topCenter,
          //         colors: [
          //           Colors.white.withOpacity(0),
          //           Colors.white,
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          const SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: BackButton(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      // body: Center(
      //   child: AnimatedSize(
      //     alignment: Alignment.topCenter,
      //     duration: 600.millis,
      //     curve: Curves.easeInOut,
      //     child: SizedBox(
      //       width: double.infinity,
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             ImageViewer(
      //               image: Image.file(
      //                 File(widget.image.path),
      //                 fit: BoxFit.cover,
      //               ),
      //               onImage: (image) async {
      //                 // setState(() {
      //                 //   this.image = image;
      //                 //   this.meshColors = null;
      //                 // });
      //                 // final meshColors = await generateMeshGradientFromImage(
      //                 //   Image.file(File(image.path)).image,
      //                 // );
      //                 // setState(() => this.meshColors = meshColors);
      //               },
      //             ),
      //             // Animated mesh gradient
      //             AnimatedBox(
      //               width: 400,
      //               height: 240,
      //               child: AnimatedMeshGradient(
      //                 colors: widget.meshColors,
      //                 options: AnimatedMeshGradientOptions(
      //                   amplitude: 50,
      //                   grain: 0.1,
      //                   frequency: 5,
      //                   speed: 5,
      //                 ),
      //               ),
      //             ),
      //           ].divide(const SizedBox(height: 16)),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
