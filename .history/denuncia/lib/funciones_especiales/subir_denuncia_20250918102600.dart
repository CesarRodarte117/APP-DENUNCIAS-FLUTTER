import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:denuncia/models/denuncia.dart';
import 'package:denuncia/models/db.dart';

class cargar_denuncia extends StatefulWidget {
  const cargar_denuncia({super.key});

  @override
  State<cargar_denuncia> createState() => _cargar_denunciaState();
}

class _cargar_denunciaState extends State<cargar_denuncia> {
  final Color primaryColor = const Color.fromARGB(255, 124, 36, 57);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
