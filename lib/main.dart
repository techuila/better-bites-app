// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously, unnecessary_to_list_in_spreads, unused_field, prefer_final_fields, prefer_const_constructors, use_full_hex_values_for_flutter_colors, unused_element, non_constant_identifier_names, unused_import
import 'package:betterbitees/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: HomePage(), debugShowCheckedModeBanner: false);
  }
}
