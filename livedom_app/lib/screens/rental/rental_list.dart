import 'package:flutter/material.dart';

class RentalListScreen extends StatefulWidget {
  const RentalListScreen({super.key});

  @override
  State<RentalListScreen> createState() => _RentalListScreenState();
}

class _RentalListScreenState extends State<RentalListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공연장 대관'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("home"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
              elevation: 5
            ),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
      ),
    );;
  }
}