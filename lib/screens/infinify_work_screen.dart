import 'package:flutter/material.dart';

class InfinityWork extends StatefulWidget {
  const InfinityWork({super.key});

  @override
  State<InfinityWork> createState() => _InfinityWorkState();
}

class _InfinityWorkState extends State<InfinityWork> {
  final assetImage = 'assets/images/roadmap.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinity Work'),
      ),
      body:  Center(
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20), // Margin around the child to keep within the viewport
          minScale: 0.1, // Minimum scale (zoom out)
          maxScale: 4.0, // Maximum scale (zoom in)
          child: Image.asset(
            assetImage,
            fit: BoxFit.contain, // Ensure the image fits within the viewport
          ),
        ),
      ),
    );
  }
}
