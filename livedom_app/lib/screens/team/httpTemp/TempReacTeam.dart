import 'package:flutter/material.dart';

class TempReacTeam extends StatefulWidget {
  const TempReacTeam({super.key});

  @override
  State<TempReacTeam> createState() => _TempReacTeamState();
}

class _TempReacTeamState extends State<TempReacTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('조회화면입니다.'),
      ),
    );
  }
}