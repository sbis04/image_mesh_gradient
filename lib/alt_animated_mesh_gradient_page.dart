import 'dart:math';
import 'dart:typed_data';

import 'package:blurhash/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class AltAnimatedMeshGradientPage extends StatefulWidget {
  const AltAnimatedMeshGradientPage({super.key});

  @override
  State<AltAnimatedMeshGradientPage> createState() =>
      _AltAnimatedMeshGradientPageState();
}

class _AltAnimatedMeshGradientPageState
    extends State<AltAnimatedMeshGradientPage> with TickerProviderStateMixin {
  late MeshGradientController _controller;
  // Adjust these dimensions to improve representation
  int decodeWidth = 10;
  int decodeHeight = 10;

  Future<void> _initializeGradient() async {
    final imageDataBytes = await BlurHash.decode(
      "rEHLh[WB2yk8\$NxujFNGt6pyoJadR*=ss:I[R%of.7kCMdnjx]S2NHs:i_S#M|%1%2ENRis9a\$%1Sis.slNHW:WBxZ%2NbogaekBW;ofo0NHS4j?",
      decodeWidth,
      decodeHeight,
    );
    if (imageDataBytes == null) return;
    print(imageDataBytes);
    print(imageDataBytes.length);
    final points =
        _generateMeshGradientPoints(imageDataBytes, decodeWidth, decodeHeight);

    _controller = MeshGradientController(
      points: points,
      vsync: this,
    );
    setState(() {});
  }

  List<MeshGradientPoint> _generateMeshGradientPoints(
    Uint8List imageDataBytes,
    int width,
    int height,
  ) {
    List<MeshGradientPoint> points = [];
    List<Offset> positions = const [
      Offset(-1, -1), // Top-left
      Offset(1, -1), // Top-right
      Offset(-1, 1), // Bottom-left
      Offset(1, 1), // Bottom-right
      Offset(0, 0), // Center
      Offset(0, 1), // Bottom-center
    ];

    // Select corresponding colors from the image data
    List<int> indices = [
      0, // Top-left
      width - 1, // Top-right
      (height - 1) * width, // Bottom-left
      height * width - 1, // Bottom-right
      (height ~/ 2) * width + (width ~/ 2), // Center
      (height - 1) * width + (width ~/ 2), // Bottom-center
    ];

    for (var index in indices) {
      if (index * 4 + 3 >= imageDataBytes.length) continue;

      final int r = imageDataBytes[index * 4];
      final int g = imageDataBytes[index * 4 + 1];
      final int b = imageDataBytes[index * 4 + 2];
      final int a = imageDataBytes[index * 4 + 3];

      final color = Color.fromARGB(a, r, g, b);
      final position = positions[points.length % positions.length];

      points.add(MeshGradientPoint(
        position: position,
        color: color,
      ));
    }

    return points;
  }

  @override
  void initState() {
    super.initState();
    _controller = MeshGradientController(
      points: [
        MeshGradientPoint(
          position: const Offset(
            -1,
            0.2,
          ),
          color: const Color.fromARGB(255, 251, 0, 105),
        ),
        MeshGradientPoint(
          position: const Offset(
            -2,
            0.1,
          ),
          color: const Color.fromARGB(255, 251, 0, 105),
        ),
      ],
      vsync: this,
    );
    _initializeGradient();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mesh_gradient example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 200,
                  width: 200 * decodeWidth / decodeHeight,
                  child: MeshGradient(
                    controller: _controller,
                    options: MeshGradientOptions(
                      blend: 3.5,
                      noiseIntensity: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // MeshGradientController functions are async, so you can await them
                  await _controller.animateSequence(
                    duration: const Duration(seconds: 4),
                    sequences: _controller.points.value.map((point) {
                      return AnimationSequence(
                        pointIndex: _controller.points.value.indexOf(point),
                        newPoint: MeshGradientPoint(
                          position: Offset(
                            Random().nextDouble() * 2 - 0.5,
                            Random().nextDouble() * 2 - 0.5,
                          ),
                          color: point.color,
                        ),
                        interval: const Interval(
                          0,
                          1,
                          curve: Curves.easeInOut,
                        ),
                      );
                    }).toList(),
                  );
                },
                child: const Text("Animate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
