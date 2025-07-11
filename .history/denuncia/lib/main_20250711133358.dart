import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

import 'package:denuncia/models/db.dart';
import 'package:denuncia/models/denuncia.dart';

//funciones especiales
import 'package:denuncia/funciones_especiales/subir_archivos.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

// Agrega estos imports al inicio del archivo
import 'package:video_player/video_player.dart';
import 'package:open_file/open_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Denuncia Ciudadana',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // Cambia el color de las orillas
          seedColor: Color.fromARGB(255, 124, 36, 57),
          onPrimary: Colors.black,
          surface: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),

      home: Scaffold(body: const HomeScreen()),
    );
  }
}

class FormDenuncia extends StatefulWidget {
  const FormDenuncia({super.key});

  @override
  FormDenunciaState createState() {
    return FormDenunciaState();
  }
}

// Removed duplicate StatefulWidget definition of guardadoExitoso

class guardadoExitoso extends StatelessWidget {
  final Denuncia denuncia;

  guardadoExitoso({super.key, required this.denuncia});

  final Color primaryColor = const Color.fromARGB(255, 124, 36, 57);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Denuncia registrada",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Datos del ciudadano',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            if (_esAnonimo())
              _buildCard(_buildDataRow("Usuario", 'Anónimo'))
            else
              _buildCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (denuncia.nombre != 'Anónimo')
                      _buildDataRow("Nombre", denuncia.nombre),
                    if (denuncia.apellidos != 'Anónimo')
                      _buildDataRow("Apellidos", denuncia.apellidos),
                    if (denuncia.telefono != 'Anónimo')
                      _buildDataRow("Teléfono", denuncia.telefono),
                    if (denuncia.direccion != 'Anónimo')
                      _buildDataRow("Dirección", denuncia.direccion),
                    if (denuncia.direccionNumero != 'Anónimo')
                      _buildDataRow("No", denuncia.direccionNumero),
                    if (denuncia.colonia != 'Anónimo')
                      _buildDataRow("Colonia", denuncia.colonia),
                    if (denuncia.correo != 'Anónimo')
                      _buildDataRow("Correo", denuncia.correo),
                    if (denuncia.sexo != 'Anónimo')
                      _buildDataRow("Sexo", denuncia.sexo),
                    if (denuncia.edad != 'Anónimo')
                      _buildDataRow("Edad", denuncia.edad),
                    if (denuncia.nacionalidad != 'Anónimo')
                      _buildDataRow("Nacionalidad", denuncia.nacionalidad),
                    if (denuncia.ocupacion != 'Anónimo')
                      _buildDataRow("Ocupación", denuncia.ocupacion),
                  ],
                ),
              ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Datos del Servidor Público',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataRow("Servidor Público", denuncia.servidorNombre),
                  _buildDataRow("Cargo", denuncia.servidorCargo),
                  _buildDataRow("Dependencia", denuncia.servidorDependencia),
                  _buildDataRow(
                    "Identificación",
                    denuncia.servidorIdentificacionDetalle,
                  ),
                  _buildDataRow("Suceso", denuncia.servidorEcho),
                  _buildDataRow("Distrito", denuncia.servidorDistrito),
                  _buildDataRow(
                    "Dirección del hecho",
                    denuncia.servidorDireccion,
                  ),
                  _buildDataRow(
                    "Entre Calles",
                    denuncia.servidorDireccionCalles,
                  ),
                  _buildDataRow("Colonia del hecho", denuncia.servidorColonia),
                  _buildDataRow("Evidencia", denuncia.servidorEvidencia),
                  _buildDataRow("Motivo", denuncia.servidorMotivo),
                  _buildDataRow(
                    "Fecha de lo ocurrido",
                    denuncia.servidorFechaOcurrido,
                  ),
                  _buildDataRow("Fecha de la denuncia", denuncia.fecha),
                  _buildDataRow("Hora de la denuncia", denuncia.hora),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Evidencias',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              FutureBuilder<List<Evidencia>>(
                future: DatabaseHelper().getEvidenciasPorDenuncia(
                  denuncia.id ?? 0,
                ),

                builder: (context, snapshot) {
                  print('snapshot.data: ${snapshot.data}');
                  print('denuncia.id: ${denuncia.id}');

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text(
                      "No se han adjuntado evidencias.",
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  final evidencias = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (evidencias.isEmpty)
                        const Text(
                          "No se han adjuntado evidencias.",
                          style: TextStyle(color: Colors.red),
                        ),

                      ...evidencias.map(
                        (evidencia) => _buildEvidenciaItem(context, evidencia),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Volver al inicio",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Actualiza el método _buildEvidenciaItem
  Widget _buildEvidenciaItem(BuildContext context, Evidencia evidencia) {
    final esImagen =
        evidencia.tipo.toLowerCase() == 'imagen' ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.jpg') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.jpeg') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.png');

    final esVideo =
        evidencia.tipo.toLowerCase() == 'video' ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.mp4') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.mov');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (evidencia.pathLocal != null)
            InkWell(
              onTap: () => _openFileAccordingToType(context, evidencia),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child:
                    esImagen
                        ? _buildImagePreview(evidencia.pathLocal!)
                        : esVideo
                        ? _buildVideoPreview(evidencia.pathLocal!)
                        : _buildGenericFilePreview(evidencia),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => _openFileAccordingToType(context, evidencia),
                  child: Row(
                    children: [
                      Icon(
                        _getIconForFileType(evidencia.nombreArchivo),
                        size: 20,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          evidencia.nombreArchivo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorPreview(),
      ),
    );
  }

  Widget _buildVideoPreview(String videoPath) {
    return FutureBuilder(
      future: _getVideoThumbnail(videoPath),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Image.file(File(snapshot.data!), fit: BoxFit.cover),
              const Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
            ],
          );
        }
        return _buildLoadingPreview();
      },
    );
  }

  Widget _buildGenericFilePreview(Evidencia evidencia) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForFileType(evidencia.nombreArchivo),
            size: 50,
            color: primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            'Toca para abrir',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPreview() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, size: 50),
          const SizedBox(height: 8),
          Text(
            'No se pudo cargar la vista previa',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPreview() {
    return const Center(child: CircularProgressIndicator());
  }

  IconData _getIconForFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'mp4':
      case 'mov':
        return Icons.videocam;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _openLocalFile(BuildContext context, String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        final result = await OpenFile.open(path);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo abrir el archivo: ${result.message}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El archivo local no existe')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al abrir archivo: $e')));
    }
  }

  bool _esAnonimo() {
    return [
      denuncia.nombre,
      denuncia.apellidos,
      denuncia.telefono,
      denuncia.direccion,
      denuncia.direccionNumero,
      denuncia.colonia,
      denuncia.correo,
      denuncia.sexo,
      denuncia.edad,
      denuncia.nacionalidad,
      denuncia.ocupacion,
    ].every((dato) => dato == 'Anónimo');
  }

  Widget _buildCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor, width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDataRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> _getVideoThumbnail(String videoPath) async {
  // Implementación básica - considera usar el paquete video_thumbnail para mejor calidad
  final directory = await getTemporaryDirectory();
  final thumbnailPath =
      '${directory.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';

  // Aquí deberías generar la miniatura del video
  // Por ahora devolvemos el mismo path como placeholder
  return videoPath;
}

Future<void> _openFileAccordingToType(
  BuildContext context,
  Evidencia evidencia,
) async {
  final file = File(evidencia.pathLocal!);
  final extension = evidencia.nombreArchivo.split('.').last.toLowerCase();

  if (!await file.exists()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('El archivo no existe localmente')),
    );
    return;
  }

  try {
    if (extension == 'mp4' || extension == 'mov') {
      // Reproducir video
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(filePath: file.path),
        ),
      );
    } else {
      // Abrir con aplicación externa
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir el archivo: ${result.message}'),
          ),
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error al abrir el archivo: $e')));
  }
}

// Clase para el reproductor de video
class VideoPlayerScreen extends StatefulWidget {
  final String filePath;

  const VideoPlayerScreen({required this.filePath});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reproductor de video')),
      body: Center(
        child:
            _controller.value.isInitialized
                ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ListaDenunciasScreen extends StatefulWidget {
  @override
  _ListaDenunciasScreenState createState() => _ListaDenunciasScreenState();
}

class _ListaDenunciasScreenState extends State<ListaDenunciasScreen> {
  late Future<List<Denuncia>> _denuncias;

  final Color primaryColor = const Color.fromARGB(255, 124, 36, 57);

  @override
  void initState() {
    super.initState();
    _denuncias = DatabaseHelper().getAllDenuncias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Lista de Denuncias',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Denuncia>>(
        future: _denuncias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar las denuncias'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay denuncias registradas.'));
          } else {
            final denuncias = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: denuncias.length,
              itemBuilder: (context, index) {
                final d = denuncias[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.report, color: primaryColor),
                    title: Text(
                      '${d.servidorNombre ?? ""} ${d.servidorCargo ?? ""}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Motivo: ${d.servidorMotivo ?? ""}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      d.fecha,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => guardadoExitoso(denuncia: d),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Método para manejar la selección del menú

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //crear menu desplegable con la opcion denuncias y informacion
            const SizedBox(height: 20), // Espaciado inicial
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset('assets/logoheroica.png'),
            ), // Espaciado inicial
            const Text(
              "Denuncia Ciudadana",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 124, 36, 57),
              ),
            ),

            const SizedBox(height: 26), // Espaciado inicial
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormDenuncia()),
                );
              },
              child: const Text(
                "Iniciar Denuncia",
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 124, 36, 57),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 124, 36, 57),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: Image.asset('assets/logoheroica_sin_letras.png'),
                    ),
                    Text(
                      'Denuncia Ciudadana',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
              ListTile(
                tileColor: Colors.white,
                title: const Text(
                  'Mis denuncias',
                  style: TextStyle(color: Colors.black),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListaDenunciasScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                tileColor: Colors.white,
                title: const Text('Términos y condiciones'),
                selected: _selectedIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditionsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//CREAR UNA NUEVA INTERFAZ PARA LOS TERMINOS Y CONDICIONES
// Esta clase representa la pantalla de términos y condiciones
class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

// Esta clase representa el estado de la pantalla de términos y condiciones
class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool TerminosyCondicionesValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Términos y Condiciones"),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 124, 36, 57),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Medios de Prueba",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 124, 36, 57),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "En este acto se hace del conocimiento del ciudadano que deberá presentar pruebas fehacientes que acrediten su dicho, de no ser así, la denuncia será archivada.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              const Text(
                "Aviso de Privacidad Simplificado",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 124, 36, 57),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "El Municipio de Juárez a través de la Contraloría Municipal con domicilio en Francisco Villa 950 norte, colonia centro, área de sótano, ala sur de la Unidad Administrativa Lic. Benito Juárez, da a conocer a los usuarios el siguiente aviso de privacidad simplificado, en cumplimiento a lo dispuesto en el artículo 66 de la Ley de Protección de Datos Personales del Estado de Chihuahua. "
                "La finalidad para la cual, serán recabados sus datos personales, es para la presentación de quejas o denuncias contra servidores públicos, los cuales serán tratados para las finalidades antes mencionadas, para lo cual, será necesario que usted otorgue su consentimiento al calce del presente.\n\n"
                "Se hace de su conocimiento que sus datos personales podrán ser proporcionados, si así son requeridos, a cualquier autoridad que, en los términos de ley, tenga atribuciones de investigación (Ministerio Público del Fuero Común o Federal, Órganos Fiscalizadores Locales o Federales, Comisiones de Derechos Humanos, etc.), en asuntos que se llegasen a instaurar en contra de servidores públicos relacionados con las operaciones del Municipio de Juárez, para lo cual, será necesario que otorgue su consentimiento al calce del documento. "
                "El titular de los datos podrá manifestar su negativa al tratamiento y transferencia de sus datos, ante la Unidad de Transparencia o por medio de la Plataforma Nacional de Transparencia http://www.plataformadetransparencia.org.mx.\n\n"
                "El presente aviso de privacidad integral estará disponible en.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // o lo que necesites
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 124, 36, 57),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text("Aceptar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Esta clase representa el estado del formulario de denuncia
class FormDenunciaState extends State<FormDenuncia> {
  final _formkey = GlobalKey<FormState>();
  String dropdownValue = 'Select';
  String civilStatusValue = 'Select';
  String dependenciaStatusValue = '117';
  String echodropdownValue = 'Select';
  String fechaSeleccionada = '';
  bool anonimoValue = false;
  bool visiblefecha = false;
  bool TerminosyCondicionesValue = false;
  Color colorFecha = Colors.black;
  int _currentStep = 0;
  Color colorterminos = Colors.black;

  // Clave global para el widget de carga de archivos
  final GlobalKey<FileUploadSectionState> _uploaderKey =
      GlobalKey<FileUploadSectionState>();

  List<String> _urlsEvidencias = [];

  // 1. Agrega los controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _direccionNumeroController =
      TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _coloniaController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _ocupacionController = TextEditingController();
  final TextEditingController _nacionalidadController = TextEditingController();
  final TextEditingController _servidorNombreController =
      TextEditingController();
  final TextEditingController _servidorCargoController =
      TextEditingController();
  final TextEditingController _servidorDependenciaController =
      TextEditingController();
  final TextEditingController _servidorIdentificacionDetalleController =
      TextEditingController();
  final TextEditingController _servidorEchoController = TextEditingController();
  final TextEditingController _servidorDistritoController =
      TextEditingController();
  final TextEditingController _servidorDireccionController =
      TextEditingController();
  final TextEditingController _servidorDireccionCallesController =
      TextEditingController();
  final TextEditingController _servidorColoniaController =
      TextEditingController();
  final TextEditingController _servidorEvidenciaController =
      TextEditingController();
  final TextEditingController _servidorMotivoController =
      TextEditingController();
  final TextEditingController _servidorFechaOcurridoController =
      TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();

  // 2. Método para crear objeto Denuncia
  Denuncia _crearDenuncia() {
    return Denuncia(
      nombre: _nombreController.text,
      apellidos: _apellidosController.text,
      sexo: _sexoController.text,
      edad: _edadController.text,
      telefono: _telefonoController.text,
      direccion: _direccionController.text,
      direccionNumero: _direccionNumeroController.text,
      colonia: _coloniaController.text,
      correo: _correoController.text,
      ocupacion: _ocupacionController.text,
      nacionalidad: _nacionalidadController.text,
      servidorNombre: _servidorNombreController.text,
      servidorCargo: _servidorCargoController.text,
      servidorDependencia: _servidorDependenciaController.text,
      servidorIdentificacionDetalle:
          _servidorIdentificacionDetalleController.text,
      servidorEcho: _servidorEchoController.text,
      servidorDistrito: _servidorDistritoController.text,
      servidorDireccion: _servidorDireccionController.text,
      servidorDireccionCalles: _servidorDireccionCallesController.text,
      servidorColonia: _servidorColoniaController.text,
      servidorEvidencia: _servidorEvidenciaController.text,
      servidorMotivo: _servidorMotivoController.text,
      servidorFechaOcurrido: _servidorFechaOcurridoController.text,
      fecha: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      hora: DateFormat('HH:mm').format(DateTime.now()),
    );
  }

  // 3. Método para guardar en la BD
  Future<int> _guardarDenuncia() async {
    if (_formkey.currentState!.validate()) {
      try {
        final denuncia = _crearDenuncia();

        int id = await DatabaseHelper().insertDenuncia(denuncia);
        return id;
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));

        return -1; // Indica error al guardar
      }
    }
    return -1; // Default return value if validation fails
  }

  // formulario
  Widget _buildStep() {
    if (_currentStep == 0) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 124, 36, 57), // Color del borde
                  width: 1.5, // Ancho del borde
                ),
                borderRadius: BorderRadius.circular(
                  5,
                ), // Opcional: redondea las esquinas
              ),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / 2,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 124, 36, 57),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text(
              '¿Denunciar de forma anonima?',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            activeTrackColor: const Color.fromARGB(255, 124, 36, 57),
            activeColor: const Color.fromARGB(255, 255, 255, 255),
            inactiveTrackColor: const Color.fromARGB(255, 255, 255, 255),
            inactiveThumbColor: const Color.fromARGB(255, 124, 36, 57),
            trackOutlineColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 124, 36, 57), // Color fijo para el borde
            ),
            value: anonimoValue,
            onChanged: (bool value) {
              setState(() {
                if (value == false) {
                  anonimoValue = false;
                } else {
                  anonimoValue = true;
                  _currentStep = 1;
                }
              });
            },
          ),

          // Datos del ciudadano
          Visibility(
            visible: !anonimoValue,
            child: Column(
              children: [
                //Datos del ciudadano
                const Text(
                  'Datos del ciudadano',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16), // Espaciado inicial

                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre(s)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 3) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido(s)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa tus apellidos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.white, // Color base del gradiente
                        style: TextStyle(color: Colors.black),
                        value: dropdownValue,
                        hint: const Text('Selecciona el sexo'),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            _sexoController.text = newValue;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Mujer',
                            child: Text('Mujer'),
                          ),
                          DropdownMenuItem(
                            value: 'Hombre',
                            child: Text('Hombre'),
                          ),
                          DropdownMenuItem(
                            value: 'Select',
                            child: Text('Selecciona el sexo'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null ||
                              value == 'Select' ||
                              value.isEmpty) {
                            return 'Por favor selecciona tu sexo';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _edadController,
                        decoration: const InputDecoration(
                          labelText: 'Edad',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value == null || value.isEmpty) ||
                              value.length >= 3) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 10) {
                      return 'Por favor escribe tu teléfono correctamente';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _direccionController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value == null || value.isEmpty) ||
                              value.length >= 3) {
                            return 'Por favor escribe tu dirección';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _direccionNumeroController,
                        decoration: const InputDecoration(
                          labelText: 'No.',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value == null || value.isEmpty) ||
                              value.length >= 3) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _coloniaController,
                  decoration: const InputDecoration(
                    labelText: 'Colonia',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 10) {
                      return 'Por favor escribe tu teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _ocupacionController,
                  decoration: const InputDecoration(
                    labelText: 'Ocupación',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa tu ocupación';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nacionalidadController,
                  decoration: const InputDecoration(
                    labelText: 'Nacionalidad',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa tu nacionalidad';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // 👇 Este botón estaba mal ubicado antes
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
            child: const Text("Siguiente"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 124, 36, 57),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              //color de texto
              foregroundColor: Colors.white,
              //textStyle: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      );
    } else if (_currentStep == 1) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Container(
              //navbar apartado
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 124, 36, 57), // Color del borde
                  width: 1.5, // Ancho del borde
                ),
                borderRadius: BorderRadius.circular(
                  5,
                ), // Opcional: redondea las esquinas
              ),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / 2,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 124, 36, 57),
                ),
              ),
            ),
          ),
          //Datos del servidor
          const Text(
            'Datos del servidor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorNombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre del servidor',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 2) {
                return 'Por favor ingresa el nombre del servidor';
              }
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorCargoController,
            decoration: const InputDecoration(
              labelText: 'Cargo del servidor',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 4) {
                return 'Por favor ingresa el cargo del servidor';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            style: TextStyle(color: Colors.black),
            value: dependenciaStatusValue,
            hint: const Text('Selecciona la dependencia'),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                dependenciaStatusValue = newValue!;
                _servidorDependenciaController.text = newValue;
              });
            },
            items: const [
              DropdownMenuItem(
                value: '117',
                child: Text(' SELECCIONA LA DEPENDENCIA'),
              ),
              DropdownMenuItem(
                value: 'Administracion de la ciudad',
                child: Text('Administracion de la ciudad'),
              ),
              DropdownMenuItem(
                value: 'Asociaciones religiosas',
                child: Text('Asociaciones religiosas'),
              ),
              DropdownMenuItem(
                value: 'Comunicación social',
                child: Text('Comunicación social'),
              ),
              DropdownMenuItem(
                value: 'Contraloria municipal',
                child: Text('Contraloria municipal'),
              ),
              DropdownMenuItem(
                value: 'Contraluria municipal',
                child: Text('Contraluria municipal'),
              ),
              DropdownMenuItem(
                value: 'Control de trafico',
                child: Text('Control de trafico'),
              ),
              DropdownMenuItem(
                value: 'Coordinación de atencion ciudadana',
                child: Text('Coordinación de atencion ciudadana'),
              ),
              DropdownMenuItem(
                value: 'Coordinación de contacto social',
                child: Text('Coordinación de contacto social'),
              ),
              DropdownMenuItem(
                value: 'Coordinación de redes sociales',
                child: Text('Coordinación de redes sociales'),
              ),
              DropdownMenuItem(
                value: 'Coordinadora de atencion ciudadana del sur oriente',
                child: Text(
                  'Coordinadora de atencion ciudadana del sur oriente',
                ),
              ),
              DropdownMenuItem(
                value: 'Dirección de alumbrado',
                child: Text('Dirección de alumbrado'),
              ),
              DropdownMenuItem(
                value: 'Dirección de asuntos internos',
                child: Text('Dirección de asuntos internos'),
              ),
              DropdownMenuItem(
                value: 'Dirección de catastro',
                child: Text('Dirección de catastro'),
              ),
              DropdownMenuItem(
                value: 'Dirección de desarrollo rural',
                child: Text('Dirección de desarrollo rural'),
              ),
              DropdownMenuItem(
                value: 'Dirección de ecologia',
                child: Text('Dirección de ecologia'),
              ),
              DropdownMenuItem(
                value: 'Dirección de educación',
                child: Text('Dirección de educación'),
              ),
              DropdownMenuItem(
                value: 'Dirección de gobierno',
                child: Text('Dirección de gobierno'),
              ),
              DropdownMenuItem(
                value: 'Dirección de industrializacion agropecuaria',
                child: Text('Dirección de industrializacion agropecuaria'),
              ),
              DropdownMenuItem(
                value: 'Dirección de ingresos',
                child: Text('Dirección de ingresos'),
              ),
              DropdownMenuItem(
                value: 'Dirección de limpia',
                child: Text('Dirección de limpia'),
              ),
              DropdownMenuItem(
                value: 'Dirección de parques y jardines',
                child: Text('Dirección de parques y jardines'),
              ),
              DropdownMenuItem(
                value: 'Dirección de recursos humanos',
                child: Text('Dirección de recursos humanos'),
              ),
              DropdownMenuItem(
                value: 'Dirección de regularizacion comercial',
                child: Text('Dirección de regularizacion comercial'),
              ),
              DropdownMenuItem(
                value: 'Dirección de responsabilidades',
                child: Text('Dirección de responsabilidades'),
              ),
              DropdownMenuItem(
                value: 'Dirección de salud municipal',
                child: Text('Dirección de salud municipal'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de asentamientos humanos',
                child: Text('Dirección general de asentamientos humanos'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de centros comunitarios',
                child: Text('Dirección general de centros comunitarios'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de desarrollo económico',
                child: Text('Dirección general de desarrollo económico'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de desarrollo social',
                child: Text('Dirección general de desarrollo social'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de desarrollo urbano',
                child: Text('Dirección general de desarrollo urbano'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de informatica y comunicaciones',
                child: Text(
                  'Dirección general de informatica y comunicaciones',
                ),
              ),
              DropdownMenuItem(
                value: 'Dirección general de obras publicas',
                child: Text('Dirección general de obras publicas'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de protección civil',
                child: Text('Dirección general de protección civil'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de servicios publicos',
                child: Text('Dirección general de servicios publicos'),
              ),
              DropdownMenuItem(
                value: 'Dirección general de transito municipal',
                child: Text('Dirección general de transito municipal'),
              ),
              DropdownMenuItem(
                value: 'Dirección juridica',
                child: Text('Dirección juridica'),
              ),
              DropdownMenuItem(
                value:
                    'Instituto municipal de investigacion y planacion (imip)',
                child: Text(
                  'Instituto municipal de investigacion y planacion (imip)',
                ),
              ),
              DropdownMenuItem(
                value: 'Instituto municipal de las mujeres (imm)',
                child: Text('Instituto municipal de las mujeres (imm)'),
              ),
              DropdownMenuItem(
                value:
                    'Instituto municipal del deporte y cultura fisica de juarez',
                child: Text(
                  'Instituto municipal del deporte y cultura fisica de juarez',
                ),
              ),
              DropdownMenuItem(
                value: 'Instituto municipal del juventud de juarez (imjj)',
                child: Text(
                  'Instituto municipal del juventud de juarez (imjj)',
                ),
              ),
              DropdownMenuItem(
                value:
                    'Instituto para la cultura del municipio de juarez (icmj)',
                child: Text(
                  'Instituto para la cultura del municipio de juarez (icmj)',
                ),
              ),
              DropdownMenuItem(
                value: 'Oficialia mayor',
                child: Text('Oficialia mayor'),
              ),
              DropdownMenuItem(
                value:
                    'Operadora municipal de estacionamientos de juarez (omej)',
                child: Text(
                  'Operadora municipal de estacionamientos de juarez (omej)',
                ),
              ),
              DropdownMenuItem(value: 'Otros', child: Text('Otros')),
              DropdownMenuItem(
                value: 'Secretaria de seguridad publica',
                child: Text('Secretaria de seguridad publica'),
              ),
              DropdownMenuItem(
                value: 'Secretaria del ayuntamiento',
                child: Text('Secretaria del ayuntamiento'),
              ),
              DropdownMenuItem(
                value: 'Secretaria particular',
                child: Text('Secretaria particular'),
              ),
              DropdownMenuItem(
                value: 'Secretaria tecnica (070)',
                child: Text('Secretaria tecnica (070)'),
              ),
              DropdownMenuItem(
                value: 'Sindicato unico de trabajadores municipales',
                child: Text('Sindicato unico de trabajadores municipales'),
              ),
              DropdownMenuItem(
                value: 'Sistema de urbanizacion municipal adicional (suma)',
                child: Text(
                  'Sistema de urbanizacion municipal adicional (suma)',
                ),
              ),
              DropdownMenuItem(
                value:
                    'Sistema para el desarrollo integral de la familia (dif)',
                child: Text(
                  'Sistema para el desarrollo integral de la familia (dif)',
                ),
              ),
              DropdownMenuItem(
                value: 'Tesoreria municipal',
                child: Text('Tesoreria municipal'),
              ),
            ],
            validator: (value) {
              if (value == null || value == '117' || value.isEmpty) {
                return 'Por favor selecciona la dependencia';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorIdentificacionDetalleController,
            decoration: const InputDecoration(
              labelText: 'Otros datos para su identificación',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 4) {
                return 'Por favor ingresa mas datos para su identificación';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  value: echodropdownValue,
                  hint: const Text('Lugar del hecho'),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      echodropdownValue = newValue!;
                      _servidorEchoController.text = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Publica',
                      child: Text('En via pública'),
                    ),
                    DropdownMenuItem(
                      value: 'Dependencia',
                      child: Text('En la dependencia'),
                    ),
                    DropdownMenuItem(
                      value: 'Particular',
                      child: Text('En un particular'),
                    ),
                    DropdownMenuItem(
                      value: 'Casa',
                      child: Text('En el domicilio particular'),
                    ),
                    DropdownMenuItem(
                      value: 'Select',
                      child: Text('Lugar del echo'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value == 'Select' || value.isEmpty) {
                      return 'Por favor selecciona el lugar del hecho';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: _servidorDistritoController,
                  decoration: const InputDecoration(
                    labelText: 'Distrito',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty) || value.length <= 1) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorDireccionController,
            decoration: const InputDecoration(
              labelText: 'Dirección del hecho',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 3) {
                return 'Por favor ingresa la dirección del hecho';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorDireccionCallesController,
            decoration: const InputDecoration(
              labelText: 'Entre calles',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if ((value == null || value.isEmpty) || value.length <= 3) {
                return 'Porfavor ingresa entre que calles';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorColoniaController,
            decoration: const InputDecoration(
              labelText: 'Colonia',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 3) {
                return 'Por favor ingresa la colonia';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          FileUploadSection(
            key: _uploaderKey,
            onUrlsObtenidas: (urls) {
              _urlsEvidencias = urls;
            },
            onError: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error)));
            },
          ),

          TextButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2026),
              );

              if (selectedDate != null && selectedDate is DateTime) {
                // Aquí la comparación con DateTime ahora debería funcionar
                setState(() {
                  if (selectedDate.isBefore(DateTime.now()) ||
                      selectedDate.isAtSameMomentAs(DateTime.now())) {
                    visiblefecha = true;
                    fechaSeleccionada = DateFormat(
                      'd/M/yyyy',
                    ).format(selectedDate);
                    _servidorFechaOcurridoController.text = fechaSeleccionada;
                    colorFecha = Colors.black;
                  } else {
                    colorFecha = const Color.fromARGB(255, 212, 47, 47);
                    visiblefecha = false;
                    _servidorFechaOcurridoController.text = '';
                    fechaSeleccionada = '';
                  }
                });
              } else {
                setState(() {
                  visiblefecha = false;
                });
              }
            },
            child: const Text('Selecciona la fecha del hecho'),
            style: TextButton.styleFrom(
              foregroundColor: colorFecha,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),

          Visibility(
            visible: visiblefecha,
            child: Text(
              "$fechaSeleccionada",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorMotivoController,
            decoration: const InputDecoration(
              labelText: 'Señale el motivo y narre los hechos',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  (value.length < 6 || value.length > 150)) {
                return 'Por favor ingresa el motivo y narra los hechos';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          CheckboxListTile(
            // shape: ShapeBorder.colored(
            //   side: const BorderSide(color: Colors.white, width: 2.0),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(4.0),
            //   ),
            // ),
            title: Text(
              'Términos y condiciones',
              style: TextStyle(color: colorterminos),
            ),

            value: TerminosyCondicionesValue,
            tileColor: Colors.white,
            activeColor: const Color.fromARGB(255, 124, 36, 57),
            checkColor: Colors.white,

            //color de texto
            onChanged: (bool? value) {
              setState(() {
                TerminosyCondicionesValue = value ?? false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen(),
                  ),
                );
                colorterminos = Colors.black;
              });
            },
            controlAffinity:
                ListTileControlAffinity
                    .leading, // Coloca la casilla a la izquierda
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                // Resetear colores
                setState(() {
                  colorFecha = Colors.black;
                  colorterminos = Colors.black;
                });

                // Validar campos requeridos
                bool hasErrors = false;

                if (!TerminosyCondicionesValue) {
                  setState(() {
                    colorterminos = const Color.fromARGB(255, 212, 47, 47);
                    hasErrors = true;
                  });
                }

                if (visiblefecha == false) {
                  // Asegúrate que esta lógica es necesaria
                  setState(() {
                    colorFecha = const Color.fromARGB(255, 212, 47, 47);
                    hasErrors = true;
                  });
                }

                setState(() {
                  // comprobar datos si estan vacios del usuario se registren como anonimos
                  if (anonimoValue) {
                    _nombreController.text = 'Anónimo';
                    _apellidosController.text = 'Anónimo';
                    _telefonoController.text = 'Anónimo';
                    _correoController.text = 'Anónimo';
                    _direccionController.text = 'Anónimo';
                    _direccionNumeroController.text = 'Anónimo';
                    _coloniaController.text = 'Anónimo';
                    _edadController.text = 'Anónimo';
                    _sexoController.text = 'Anónimo';
                    _ocupacionController.text = 'Anónimo';
                    _nacionalidadController.text = 'Anónimo';
                  } else {
                    _nombreController.text =
                        _nombreController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _nombreController.text;
                    _apellidosController.text =
                        _apellidosController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _apellidosController.text;
                    _telefonoController.text =
                        _telefonoController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _telefonoController.text;
                    _correoController.text =
                        _correoController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _correoController.text;
                    _direccionController.text =
                        _direccionController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _direccionController.text;
                    _direccionNumeroController.text =
                        _direccionNumeroController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _direccionNumeroController.text;
                    _coloniaController.text =
                        _coloniaController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _coloniaController.text;
                    _edadController.text =
                        _edadController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _edadController.text;
                    _sexoController.text =
                        _sexoController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _sexoController.text;
                    _ocupacionController.text =
                        _ocupacionController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _ocupacionController.text;
                    _nacionalidadController.text =
                        _nacionalidadController.text.trim().isEmpty
                            ? 'Anónimo'
                            : _nacionalidadController.text;
                  }
                });

                // Validar formulario y guardar
                if (_formkey.currentState!.validate() && !hasErrors) {
                  try {
                    // Guardar en base de datos y guardar id de denuncia

                    final archivosSubidos = await _uploaderKey.currentState!
                        .subirArchivos('REF-123');

                    if (!archivosSubidos) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al subir archivos'),
                        ),
                      );
                      return;
                    }

                    final idDenuncia = await _guardarDenuncia();

                    // guardar id de denuncia en el uploader
                    await _uploaderKey.currentState!.guardarEvidenciasLocales(
                      idDenuncia,
                      _urlsEvidencias,
                    );

                    await DatabaseHelper().database;
                    // Esperar un breve momento para asegurar que todo se guardó
                    await Future.delayed(const Duration(milliseconds: 500));
                    final denuncia = _crearDenuncia()..id = idDenuncia;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Guardando denuncia...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => guardadoExitoso(denuncia: denuncia),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al guardar: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor completa todos los campos requeridos',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Registrar Denuncia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 124, 36, 57),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                //color de texto
                foregroundColor: Colors.white,
                //textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      );
    }

    return Container(); // fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 124, 36, 57),
        title: const Text(
          "Denuncia Ciudadana",
          style: TextStyle(color: Colors.white),
        ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              if (_currentStep > 0) {
                _currentStep--; // Disminuye el paso actual
              } else if (_currentStep == 0) {
                Navigator.pop(context); // Regresa a la pantalla anterior
              }
            });
          },
        ),
        elevation: 0, // Quita sombra para que el gradiente se vea limpio
        flexibleSpace: Container(),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_buildStep()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
