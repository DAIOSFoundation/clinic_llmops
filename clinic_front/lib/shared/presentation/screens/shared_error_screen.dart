import 'package:flutter/material.dart';

class SharedErrorScreen extends StatelessWidget {
  const SharedErrorScreen({super.key});
  static const String routeName = 'SharedErrorScreen';
  static const String routePath = '/shared/error';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Text('Error'));
  }
}
