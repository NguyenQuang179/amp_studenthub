import 'package:flutter/material.dart';

class HiredTab extends StatefulWidget {
  const HiredTab({super.key});

  @override
  State<HiredTab> createState() => _HiredTabState();
}

class _HiredTabState extends State<HiredTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Text("Hired Tab"),
      ),
    );
  }
}
