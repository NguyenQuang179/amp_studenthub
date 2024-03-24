import 'package:flutter/material.dart';

class JobDetailTab extends StatefulWidget {
  const JobDetailTab({super.key});

  @override
  State<JobDetailTab> createState() => _JobDetailTabState();
}

class _JobDetailTabState extends State<JobDetailTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Text("Job Details Tab"),
      ),
    );
  }
}
