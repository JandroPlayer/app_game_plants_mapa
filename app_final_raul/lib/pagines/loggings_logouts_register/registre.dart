import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/usuarisProvider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class Registre extends StatefulWidget {
  const Registre({super.key});

  @override
  _RegistreState createState() => _RegistreState();
}

class _RegistreState extends State<Registre> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController correuController = TextEditingController();
  final TextEditingController contrasenyaController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController nacionalitatController = TextEditingController();
  final TextEditingController codiPostalController = TextEditingController();
  final TextEditingController imatgePerfilController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isPickerActive = false;

  // Cloudinary Config
  static const String cloudName = "dglxd4dbz";
  static const String uploadPreset = "paucasesnoves";
  static const String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UsuarisProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registre', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C4B4),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFF181A20),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Tots els camps són obligatoris',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              _buildTextField(nomController, 'Nom', 'Introdueix el teu nom'),
              _buildTextField(
                  correuController, 'Correu', 'Introdueix el teu correu'),
              _buildTextField(contrasenyaController, 'Contrasenya',
                  'Introdueix la contrasenya'),
              _buildTextField(
                  edadController, 'Edat', 'Introdueix la teva edat'),
              _buildTextField(nacionalitatController, 'Nacionalitat',
                  'Introdueix la teva nacionalitat'),
              _buildTextField(codiPostalController, 'Codi Postal',
                  'Introdueix el teu codi postal'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selecciona la teva imatge de perfil:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isPickerActive ? null : _pickImage,
                          child: const Text('Seleccionar Imatge'),
                        ),
                        const SizedBox(width: 10),
                        _selectedImage != null
                            ? Image.file(_selectedImage!,
                                width: 50, height: 50, fit: BoxFit.cover)
                            : const Text('Cap imatge seleccionada',
                                style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Registrar-me'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    setState(() => _isPickerActive = true);

    await _requestPermission();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));

      // Subir imagen a Cloudinary
      String? imageUrl = await _uploadImageToCloudinary(_selectedImage!);
      if (imageUrl != null) {
        setState(() {
          imatgePerfilController.text = imageUrl;
        });
      }
    }

    setState(() => _isPickerActive = false);
  }

  static const String apiKey = "648868535917264"; // API Key de Cloudinary

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      int timestamp =
          DateTime.now().millisecondsSinceEpoch ~/ 1000; // Generar timestamp

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path,
            filename: "profile.jpg"),
        "upload_preset": uploadPreset,
        "api_key": apiKey, // API Key incluida
        "timestamp": timestamp, // Timestamp para seguridad
      });

      Response response = await Dio().post(cloudinaryUrl, data: formData);

      if (response.statusCode == 200) {
        return response.data["secure_url"];
      } else {
        print(
            "❌ Error al subir la imagen: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("❌ Error al subir la imagen: $e");
      return null;
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permiso de acceso a fotos denegado')),
      );
    }
  }

  void _registerUser() {
    final provider = Provider.of<UsuarisProvider>(context, listen: false);

    String nom = nomController.text;
    String correu = correuController.text;
    String contrasenya = contrasenyaController.text;
    String edad = edadController.text;
    String nacionalitat = nacionalitatController.text;
    String codiPostal = codiPostalController.text;
    String imatgePerfil = imatgePerfilController.text;

    if (nom.isEmpty ||
        correu.isEmpty ||
        contrasenya.isEmpty ||
        edad.isEmpty ||
        nacionalitat.isEmpty ||
        codiPostal.isEmpty ||
        imatgePerfil.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tots els camps són obligatoris')),
      );
      return;
    }

    if (provider.getUsuaris.any((u) => u.correu == correu)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aquest correu ja està registrat')),
      );
      return;
    }

    int newId = (provider.getUsuaris.isNotEmpty
            ? provider.getUsuaris
                .map((u) => u.id)
                .reduce((a, b) => a > b ? a : b)
            : 0) +
        1;
    int edadEntera = int.parse(edad);

    Usuari nouUsuari = Usuari(
      id: newId,
      nom: nom,
      correu: correu,
      contrasenya: contrasenya,
      edat: edadEntera,
      nacionalitat: nacionalitat,
      codiPostal: codiPostal,
      imatgePerfil: imatgePerfil, // URL de Cloudinary
      btc: 0,
    );

    provider.addUsuari(nouUsuari);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuari registrat amb èxit!')),
    );

    Navigator.pop(context);
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
