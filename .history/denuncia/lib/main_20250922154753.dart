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
import 'package:denuncia/funciones_especiales/identificador_dispositivo.dart';
import 'package:denuncia/funciones_especiales/subir_denuncia.dart';

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

  String _formatearFechaCorta(String fechaCompleta) {
    // Usamos un bloque try-catch por si alguna vez la fecha viene en un formato inesperado.
    try {
      // 1. Convierte el texto en un objeto DateTime.
      final DateTime fechaObjeto = DateTime.parse(fechaCompleta);
      // 2. Formatea ese objeto para mostrar solo año, mes y día.
      return DateFormat('yyyy-MM-dd').format(fechaObjeto);
    } catch (e) {
      // Si hay un error, intentamos devolver la primera parte del texto antes del espacio.
      return fechaCompleta.split(' ')[0];
    }
  }

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

                    if (denuncia.apellidoPaterno != 'Anónimo')
                      _buildDataRow(
                        "Apellido Paterno",
                        denuncia.apellidoPaterno,
                      ),

                    if (denuncia.apellidoMaterno != 'Anónimo')
                      _buildDataRow(
                        "Apellido Materno",
                        denuncia.apellidoMaterno,
                      ),
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
                    if (denuncia.numeroIdentificacion != 'Anónimo')
                      _buildDataRow(
                        "No de Identificación",
                        denuncia.numeroIdentificacion,
                      ),
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
                  // _buildDataRow("Evidencia", denuncia.servidorEvidencia),
                  _buildDataRow("Motivo", denuncia.servidorMotivo),
                  _buildDataRow(
                    "Fecha de lo ocurrido",
                    denuncia.servidorFechaOcurrido,
                  ),
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

            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Datos de la denuncia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataRow("Folio", denuncia.clave),
                  _buildDataRow(
                    "Fecha de la denuncia",
                    _formatearFechaCorta(denuncia.fecha),
                  ),
                  _buildDataRow("Hora de la denuncia", denuncia.hora),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Datos de contacto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDataRow(
                    "Calle",
                    'Pino Suárez #100, Zona Centro, ciudad Juárez, Chihuahua.',
                  ),
                  _buildDataRow("Teléfono", '(656)737-0000, extensión 70910'),
                ],
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

  Widget _buildEvidenciaItem(BuildContext context, Evidencia evidencia) {
    final esImagen =
        evidencia.tipo.toLowerCase() == 'imagen' ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.jpg') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.jpeg') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.png');

    final esVideo =
        evidencia.tipo.toLowerCase() == 'mp4' ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.mp4');

    final esAudio =
        evidencia.tipo.toLowerCase() == 'mp3' ||
        evidencia.tipo.toLowerCase() == 'wav' ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.mp3') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.wav');

    final esArchivo =
        evidencia.tipo.toLowerCase() == 'archivo' ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.pdf') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.doc') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.docx') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.xlsx') ||
        evidencia.nombreArchivo.toLowerCase().endsWith('.pptx');
    print(
      '🔴 Evidencia url: ${evidencia.url}, Tipo: ${evidencia.tipo}, Path Local: ${evidencia.pathLocal}',
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((esImagen) && evidencia.pathLocal != null)
            InkWell(
              onTap: () => _openLocalFile(context, evidencia.pathLocal!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(evidencia.pathLocal!),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image, size: 50),
                          const SizedBox(height: 8),
                          Text(
                            'No se pudo cargar la imagen',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          else if ((esArchivo || esVideo || esAudio) &&
              evidencia.pathLocal != null)
            InkWell(
              onTap: () => _openLocalFile(context, evidencia.pathLocal!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: Icon(
                    _getIconForFileType(evidencia.nombreArchivo),
                    size: 50,
                    color: primaryColor,
                  ),
                ),
              ),
            )
          else
            Container(
              height: 180,
              alignment: Alignment.center,
              child: Icon(
                _getIconForFileType(evidencia.nombreArchivo),
                size: 50,
                color: primaryColor,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (evidencia.pathLocal != null)
                  InkWell(
                    onTap: () => _openLocalFile(context, evidencia.pathLocal!),
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
    );
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
        return Icons.videocam;
      case 'mp3':
      case 'wav':
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _openLocalFile(BuildContext context, String path) async {
    try {
      final file = File(path);
      print('🔴 Intentando abrir archivo: $path');
      if (await file.exists()) {
        final result = await OpenFile.open(path);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No se pudo abrir el archivo, se requiere una aplicación compatible para abrirlo.',
              ),
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
      denuncia.apellidoPaterno,
      denuncia.apellidoMaterno,
      denuncia.telefono,
      denuncia.direccion,
      denuncia.direccionNumero,
      denuncia.colonia,
      denuncia.correo,
      denuncia.sexo,
      denuncia.edad,
      denuncia.nacionalidad,
      denuncia.ocupacion,
      denuncia.numeroIdentificacion,
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
          SizedBox(
            width: 150, // 👈 ancho fijo para todas las etiquetas
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
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

class ListaDenunciasScreen extends StatefulWidget {
  @override
  _ListaDenunciasScreenState createState() => _ListaDenunciasScreenState();
}

class _ListaDenunciasScreenState extends State<ListaDenunciasScreen> {
  Future<List<Denuncia>> _cargarYActualizarDenuncias() async {
    final dbHelper = DatabaseHelper();
    try {
      List<Denuncia> denunciasPendientes =
          await dbHelper.getDenunciasPendientes();

      // 2. Si encontramos pendientes, intentamos subirlas una por una.
      if (denunciasPendientes.isNotEmpty) {
        print(
          '🔄 Intentando subir ${denunciasPendientes.length} denuncias pendientes...',
        );
        for (var denunciaPendiente in denunciasPendientes) {
          // 3. Llamamos a la API para subir la denuncia.
          bool seSubio = await ApiService.subirDenuncia(denunciaPendiente);

          // 4. Si se subió con éxito, la API le asigna la clave.
          //    Ahora actualizamos el registro local con la nueva clave.
          if (seSubio) {
            print(
              '✅ Denuncia pendiente subida. Actualizando registro local ID: ${denunciaPendiente.id}',
            );
            await dbHelper.updateDenuncia(denunciaPendiente);
          } else {
            print(
              '⚠️ No se pudo subir la denuncia pendiente con ID local: ${denunciaPendiente.id}',
            );
          }
        }
      }
      String id_unico = await obtenerIdentificadorUnicoDispositivo();

      List<DenunciaResumen> resumenesDesdeApi =
          await ApiService.ObtenerDenunciasPorUsuario(id_unico);

      if (resumenesDesdeApi.isNotEmpty) {
        print(
          "🔄 Actualizando ${resumenesDesdeApi.length} denuncias locales...",
        );
        final dbHelper = DatabaseHelper();
        for (var resumen in resumenesDesdeApi) {
          // Usamos el método que creamos en el paso 1

          await dbHelper.updateDenunciaStatus(resumen.clave, resumen.estatus);
        }
        print("✅ Base de datos local actualizada.");
      } else {
        print("ℹ️ No se recibieron actualizaciones de la API.");
      }

      // 4. Finalmente, obtenemos TODAS las denuncias de la base de datos local (ya actualizadas)
      // y las retornamos para que el FutureBuilder las muestre.
      print("📚 Cargando denuncias desde la base de datos local para mostrar.");
      return DatabaseHelper().getAllDenuncias();
    } catch (e) {
      print("❌ Ocurrió un error en el proceso de carga y actualización: $e");
      // Si algo falla, intentamos cargar los datos locales de todas formas
      // o puedes manejar el error de otra manera.
      return DatabaseHelper().getAllDenuncias();
    }
  }

  // Esta función traduce la letra del estatus a una palabra legible.
  String _obtenerTextoEstatus(String? estatus) {
    switch (estatus) {
      case 'A':
        return 'Activa';
      case 'N':
        return 'En Proceso';
      case 'C':
      case 'CF': // Ambos casos muestran "Cerrada"
        return 'Cerrada';
      case 'CC':
        return 'Cancelada';
      case 'CN':
        return 'Canalizada';
      case 'R':
        return 'Reabierta';
      case 'F':
        return 'Origen: Facebook';
      case 'M':
        return 'Origen: Móvil';
      case 'W':
        return 'Origen: Web';
      default:
        return 'En Revisión';
    }
  }

  // Esta función asigna un color a cada estatus para que sea más visual.
  Color _obtenerColorEstatus(String? estatus) {
    switch (estatus) {
      // --- Estados Positivos ---
      case 'A': // Activa
        return Color(0xFF2E7D32); // Verde oscuro, indica éxito o actividad.

      // --- Estados de Progreso o Alerta ---
      case 'N': // En Proceso
        return Color(
          0xFFFFA000,
        ); // Ámbar, común para estados de advertencia o en proceso.
      case 'CN': // Canalizada
        return Color(
          0xFF0288D1,
        ); // Azul claro, indica un paso informativo o de transición.
      case 'R': // Reabierta
        return Color(
          0xFF512DA8,
        ); // Morado, un color fuerte para destacar una acción importante.

      // --- Estados de Cierre o Finalización (Negativos) ---
      case 'C': // Cerrada
      case 'CF': // Cerrada
        return Color(
          0xFFD32F2F,
        ); // Rojo oscuro, universalmente entendido como finalizado o error.
      case 'CC': // Cancelada
        return Color(
          0xFFC62828,
        ); // Un rojo ligeramente diferente para distinguir de "Cerrada".

      // --- Estados Informativos (Origen de la denuncia) ---
      case 'F': // Facebook
      case 'M': // Móvil
      case 'W': // Web
        return Color(
          0xFF455A64,
        ); // Azul-grisáceo, un color neutro y profesional para información secundaria.

      // --- Estado por Defecto ---
      default: // Revisar o desconocido
        return Color(
          0xFF616161,
        ); // Gris oscuro, para estados indefinidos o pendientes de revisión.
    }
  }

  String _formatearFechaCorta(String fechaCompleta) {
    // Usamos un bloque try-catch por si alguna vez la fecha viene en un formato inesperado.
    try {
      // 1. Convierte el texto en un objeto DateTime.
      final DateTime fechaObjeto = DateTime.parse(fechaCompleta);
      // 2. Formatea ese objeto para mostrar solo año, mes y día.
      return DateFormat('yyyy-MM-dd').format(fechaObjeto);
    } catch (e) {
      // Si hay un error, intentamos devolver la primera parte del texto antes del espacio.
      return fechaCompleta.split(' ')[0];
    }
  }

  late Future<List<Denuncia>> _denuncias;

  final Color primaryColor = const Color.fromARGB(255, 124, 36, 57);

  @override
  void initState() {
    super.initState();
    _denuncias = _cargarYActualizarDenuncias();
  }

  String _recortarTexto(String texto, int maxCaracteres) {
    if (texto.length <= maxCaracteres) {
      // Si tiene menos de 60, lo llenamos con espacios si quieres (opcional)
      return texto.padRight(maxCaracteres);
    } else {
      return texto.substring(0, maxCaracteres).trimRight() + '...';
    }
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
                      'Denuncia del servidor',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre: ${d.servidorNombre ?? ""}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Cargo: ${d.servidorCargo ?? ""}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Motivo: ${_recortarTexto(d.servidorMotivo ?? "", 70)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _obtenerTextoEstatus(
                            d.estatus,
                          ), // Usa la función para el texto
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _obtenerColorEstatus(
                              d.estatus,
                            ), // Usa la función para el color
                          ),
                        ),
                        SizedBox(height: 4), // Espacio entre estatus y fecha
                        Text(
                          _formatearFechaCorta(d.fecha),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ],
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
              "¡Denúncialo! Sistema Anticorrupción Juárez",
              textAlign: TextAlign.center,
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
                title: const Text('Fundamentos legales'),
                selected: _selectedIndex == 1,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FundamentosLegalesScreen(),
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

//CREAR UNA NUEVA INTERFAZ PARA LOS TERMINOS Y CONDICIONES
// Esta clase representa la pantalla de términos y condiciones
class FundamentosLegalesScreen extends StatefulWidget {
  @override
  _FundamentosLegalesScreenState createState() =>
      _FundamentosLegalesScreenState();
}

// Esta clase representa el estado de la pantalla de términos y condiciones
class _FundamentosLegalesScreenState extends State<FundamentosLegalesScreen> {
  bool TerminosyCondicionesValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fundamentos legales"),
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
                "Ley General de Responsabilidades Administrativas",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 124, 36, 57),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                " Artículo 93. La denuncia deberá contener los datos o indicios que permitan advertir la presunta responsabilidad administrativa por la comisión de"
                "Faltas administrativas, y podrán ser presentadas de manera electrónica a través de los mecanismos que para tal efecto establezcan las Autoridades investigadoras, lo anterior sin menoscabo de la plataforma"
                "digital que determine, para tal efecto, el Sistema Nacional Anticorrupción.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 30),
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
  // Removed duplicate declaration of _isCargando
  final _formkey = GlobalKey<FormState>();
  String dropdownValue = 'Select';
  String civilStatusValue = 'Select';
  String? dependenciaStatusValue;
  String? echodropdownValue;
  String fechaSeleccionada = '';
  bool anonimoValue = false;
  bool visiblefecha = false;
  bool TerminosyCondicionesValue = false;
  bool intentar_enviar = false;
  bool intentar_enviar_archivos = false;
  Color colorFecha = Colors.black;
  int _currentStep = 0;
  Color colorterminos = Colors.black;

  // Clave global para el widget de carga de archivos
  final GlobalKey<FileUploadSectionState> _uploaderKey =
      GlobalKey<FileUploadSectionState>();

  List<String> _urlsEvidencias = [];

  // 1. Agrega los controladores de texto
  final TextEditingController _usuarioIdentificadorController =
      TextEditingController();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
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
  final TextEditingController _numeroIdentificacionController =
      TextEditingController();
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

  bool _isCargando = false;
  String cargandoText = 'Cargando...';

  bool visiblefechamensaje = false;
  String fechamensaje = '';
  Color colorfechaBorde = Colors.transparent;

  // 2. Método para crear objeto Denuncia
  Denuncia _crearDenuncia() {
    return Denuncia(
      nombre: _nombreController.text,
      usuarioIdentificador: _usuarioIdentificadorController.text,
      estatus: 'A',
      clave: 'null',
      apellidoPaterno: _apellidoPaternoController.text,
      apellidoMaterno: _apellidoMaternoController.text,
      sexo: _sexoController.text,
      edad: _edadController.text,
      telefono: _telefonoController.text,
      direccion: _direccionController.text,
      direccionNumero: _direccionNumeroController.text,
      colonia: _coloniaController.text,
      correo: _correoController.text,
      ocupacion: _ocupacionController.text,
      nacionalidad: _nacionalidadController.text,
      numeroIdentificacion: _numeroIdentificacionController.text,
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
      fecha: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      hora: DateFormat('HH:mm').format(DateTime.now()),
    );
  }

  Future<void> _mostrarFundamentos(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // evita que se cierre tocando afuera
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Fundamentos legales",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 124, 36, 57),
            ),
          ),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Ley General de Responsabilidades Administrativas",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\n"
                  " Artículo 93. La denuncia deberá contener los datos o indicios que permitan advertir la presunta responsabilidad administrativa por la comisión de"
                  "Faltas administrativas, y podrán ser presentadas de manera electrónica a través de los mecanismos que para tal efecto establezcan las Autoridades investigadoras, lo anterior sin menoscabo de la plataforma"
                  "digital que determine, para tal efecto, el Sistema Nacional Anticorrupción.",
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // cerrar el dialogo
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
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
    // Contenido principal según el paso actual
    Widget stepContent;
    if (_currentStep == 0) {
      stepContent = Column(
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
                      return 'Ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _apellidoPaternoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido Paterno',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Ingresa tus apellido Paterno';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _apellidoMaternoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido Materno',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Ingresa tus apellido Materno';
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
                            return 'Selecciona tu sexo';
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
                        keyboardType: TextInputType.number,
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
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 10) {
                      return 'Ingresa tu teléfono correctamente';
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
                              value.length >= 2) {
                            return 'Ingresa tu dirección';
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
                        keyboardType: TextInputType.number,
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
                      return 'Ingresa tu colonia';
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
                      return 'Ingresa tu correo electrónico';
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
                      return 'Ingresa tu ocupación';
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
                      return 'Ingresa tu nacionalidad';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numeroIdentificacionController,
                  decoration: const InputDecoration(
                    labelText: 'Numero de Identificación',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Ingresa tu numero de identificación';
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
      stepContent = Column(
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
            'Datos del servidor público',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorNombreController,
            decoration: InputDecoration(
              // <-- Solo quita 'const' de aquí
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    // Estilo por defecto para el texto del label
                    fontSize: 16, // ajusta el tamaño si es necesario
                    color: Colors.black54, // color por defecto del label
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' * ', style: TextStyle(color: Colors.red)),
                    TextSpan(text: 'Nombre del servidor'),
                  ],
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 2) {
                return 'Ingrese el nombre del servidor';
              }
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorCargoController,
            decoration: InputDecoration(
              // <-- Solo quita 'const' de aquí
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    // Estilo por defecto para el texto del label
                    fontSize: 16, // ajusta el tamaño si es necesario
                    color: Colors.black54, // color por defecto del label
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' * ', style: TextStyle(color: Colors.red)),
                    TextSpan(text: 'Cargo del servidor'),
                  ],
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 2) {
                return 'Ingrese el cargo del servidor';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            style: TextStyle(color: Colors.black),
            value: dependenciaStatusValue,
            // hint: const Text('Selecciona la dependencia'),
            hint: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.black54, fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text: '* ',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  TextSpan(text: 'Selecciona la dependencia'),
                ],
              ),
            ),
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
                return 'Seleccione la dependencia';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorIdentificacionDetalleController,
            decoration: InputDecoration(
              // <-- Solo quita 'const' de aquí
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    // Estilo por defecto para el texto del label
                    fontSize: 16, // ajusta el tamaño si es necesario
                    color: Colors.black54, // color por defecto del label
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' * ', style: TextStyle(color: Colors.red)),
                    TextSpan(
                      text: 'Otros datos para la identificación del servidor',
                    ),
                  ],
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 2) {
                return 'Ingrese mas datos para la identificación del servidor';
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
                  hint: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: '* ',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        TextSpan(text: 'Lugar del hecho'),
                      ],
                    ),
                  ),

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
                      return 'Seleccione el lugar del hecho';
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
                  //poner el teclado en numerico
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // <-- Solo quita 'const' de aquí
                    label: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          // Estilo por defecto para el texto del label
                          fontSize: 16, // ajusta el tamaño si es necesario
                          color: Colors.black54, // color por defecto del label
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' * ',
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(text: 'Distrito'),
                        ],
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'Ingrese distrito';
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
            decoration: InputDecoration(
              // <-- Solo quita 'const' de aquí
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    // Estilo por defecto para el texto del label
                    fontSize: 16, // ajusta el tamaño si es necesario
                    color: Colors.black54, // color por defecto del label
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' * ', style: TextStyle(color: Colors.red)),
                    TextSpan(text: 'Dirección del hecho'),
                  ],
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 1) {
                return 'Ingrese la dirección del hecho';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorDireccionCallesController,
            decoration: InputDecoration(
              // <-- Solo quita 'const' de aquí
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    // Estilo por defecto para el texto del label
                    fontSize: 16, // ajusta el tamaño si es necesario
                    color: Colors.black54, // color por defecto del label
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' * ', style: TextStyle(color: Colors.red)),
                    TextSpan(text: ' Entre calles'),
                  ],
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if ((value == null || value.isEmpty) || value.length <= 1) {
                return 'Ingrese entre que calles se encuentra el hecho';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorColoniaController,
            decoration: InputDecoration(
              // <-- Solo quita 'const' de aquí
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    // Estilo por defecto para el texto del label
                    fontSize: 16, // ajusta el tamaño si es necesario
                    color: Colors.black54, // color por defecto del label
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' * ', style: TextStyle(color: Colors.red)),
                    TextSpan(text: 'Colonia'),
                  ],
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 1) {
                return 'Ingrese la colonia del hecho';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
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
                    visiblefechamensaje = false;
                    fechaSeleccionada = DateFormat(
                      'yyyy-MM-dd',
                    ).format(selectedDate);
                    _servidorFechaOcurridoController.text = fechaSeleccionada;
                    colorFecha = Colors.black;
                  } else {
                    colorFecha = const Color.fromARGB(255, 212, 47, 47);
                    visiblefecha = false;
                    visiblefechamensaje = true;
                    fechamensaje = 'La fecha no puede ser mayor a la actual';
                    _servidorFechaOcurridoController.text = '';
                    fechaSeleccionada = '';
                  }
                });
              } else {
                setState(() {
                  visiblefecha = false;
                  visiblefechamensaje = true;
                  fechamensaje = 'No se seleccionó una fecha válida';
                });
              }
            },
            child: Text('* Selecciona la fecha de ocurrencia'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26), // Bordes redondeados
                side: BorderSide(
                  color: colorfechaBorde, // Color del borde
                  width: 1.0, // Grosor del borde
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: visiblefechamensaje,
            child: Text(
              "$fechamensaje",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 212, 47, 47),
              ),
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

          FileUploadSection(
            key: _uploaderKey,
            onUrlsObtenidas: (urls) {
              setState(() {
                _urlsEvidencias = urls;
              });
            },
            onSelectionChanged: (files) {
              setState(() {
                intentar_enviar_archivos =
                    files.isEmpty; // ⚡ bandera para mostrar/ocultar mensaje
              });
            },
            onError: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error)));
            },
          ),

          const SizedBox(height: 8),

          if (_urlsEvidencias.isEmpty && intentar_enviar_archivos)
            Text(
              'Debe subir almenos un archivo',
              style: TextStyle(color: const Color.fromARGB(255, 212, 47, 47)),
            ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _servidorMotivoController,
            decoration: InputDecoration(
              // <-- Solo quita 'const' de aquí
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    // Estilo por defecto para el texto del label
                    fontSize: 16, // ajusta el tamaño si es necesario
                    color: Colors.black54, // color por defecto del label
                  ),
                  children: <TextSpan>[
                    TextSpan(text: ' * ', style: TextStyle(color: Colors.red)),
                    TextSpan(text: 'Señale el motivo y narre los hechos'),
                  ],
                ),
              ),
              border: const OutlineInputBorder(),
            ),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese el motivo y narre los hechos';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          CheckboxListTile(
            title: RichText(
              text: const TextSpan(
                // Este es el estilo por defecto para el texto
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ), // Ajusta el tamaño si es necesario
                children: <TextSpan>[
                  TextSpan(
                    text: ' * ', // El asterisco con un espacio antes
                    style: TextStyle(color: Colors.red),
                    // El estilo solo para el asterisco
                  ),
                  TextSpan(text: 'Términos y condiciones'),
                ],
              ),
            ),
            value: TerminosyCondicionesValue,
            tileColor: Colors.white,
            activeColor: const Color.fromARGB(255, 124, 36, 57),
            checkColor: Colors.white,

            //color de texto
            onChanged: (bool? value) {
              setState(() {
                TerminosyCondicionesValue = value ?? false;
                intentar_enviar = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen(),
                  ),
                );
                colorterminos = Colors.black;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          if (!TerminosyCondicionesValue && intentar_enviar)
            Text(
              'Debe aceptar términos y condiciones',
              style: TextStyle(color: const Color.fromARGB(255, 212, 47, 47)),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await Future.delayed(Duration.zero);
                  setState(() {
                    intentar_enviar = true;
                    if (_urlsEvidencias.isEmpty) {
                      intentar_enviar_archivos = true;
                    } else {
                      intentar_enviar_archivos = false;
                    }
                    _isCargando = true;
                    cargandoText = 'Validando datos...';
                  });
                  await Future.delayed(Duration.zero);
                  // Resetear colores
                  setState(() {
                    colorFecha = Colors.black;
                    colorterminos = Colors.black;
                    colorfechaBorde = Colors.transparent;
                  });
                  // Validar campos requeridos
                  bool hasErrors = false;

                  if (!TerminosyCondicionesValue) {
                    setState(() {
                      cargandoText = 'Acepta los términos y condiciones';
                      Duration(seconds: 2);
                      colorterminos = const Color.fromARGB(255, 212, 47, 47);
                      hasErrors = true;
                      _isCargando = false;
                    });
                  }

                  if (visiblefecha == false) {
                    setState(() {
                      visiblefechamensaje = true;
                      fechamensaje = 'Seleccione una fecha';
                      cargandoText = 'Seleccione una fecha';
                      Duration(seconds: 2);
                      colorFecha = const Color.fromARGB(255, 212, 47, 47);
                      hasErrors = true;
                      _isCargando = false;
                    });
                  }
                  setState(() {
                    cargandoText = 'Guardando denuncia...';
                    // comprobar datos si estan vacios del usuario se registren como anonimos
                    if (anonimoValue) {
                      _nombreController.text = 'Anónimo';
                      _apellidoPaternoController.text = 'Anónimo';
                      _apellidoMaternoController.text = 'Anónimo';
                      _telefonoController.text = 'Anónimo';
                      _correoController.text = 'Anónimo';
                      _direccionController.text = 'Anónimo';
                      _direccionNumeroController.text = 'Anónimo';
                      _coloniaController.text = 'Anónimo';
                      _edadController.text = 'Anónimo';
                      _sexoController.text = 'Anónimo';
                      _ocupacionController.text = 'Anónimo';
                      _nacionalidadController.text = 'Anónimo';
                      _numeroIdentificacionController.text = 'Anónimo';
                    } else {
                      _nombreController.text =
                          _nombreController.text.trim().isEmpty
                              ? 'Anónimo'
                              : _nombreController.text;
                      _apellidoPaternoController.text =
                          _apellidoPaternoController.text.trim().isEmpty
                              ? 'Anónimo'
                              : _apellidoPaternoController.text;

                      _apellidoMaternoController.text =
                          _apellidoMaternoController.text.trim().isEmpty
                              ? 'Anónimo'
                              : _apellidoMaternoController.text;

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
                      _numeroIdentificacionController.text =
                          _numeroIdentificacionController.text.trim().isEmpty
                              ? 'Anónimo'
                              : _numeroIdentificacionController.text;
                    }
                  });
                  String id_unico =
                      await obtenerIdentificadorUnicoDispositivo();

                  setState(() {
                    _usuarioIdentificadorController.text = id_unico;
                  });
                  // Validar formulario y guardar
                  if (_formkey.currentState!.validate() && !hasErrors) {
                    setState(() {
                      _isCargando = true;
                      cargandoText = 'Subiendo archivos...';
                    });
                    try {
                      final idDenuncia = await _guardarDenuncia();

                      setState(() {
                        _isCargando = true;
                        cargandoText = 'Denuncia guardada con éxito';
                      });
                      await Future.delayed(const Duration(milliseconds: 500));

                      final denuncia = _crearDenuncia()..id = idDenuncia;

                      // 3. LLAMA A LA FUNCIÓN Y ESPERA EL RESULTADO
                      bool seSubioCorrectamente =
                          await ApiService.subirDenuncia(denuncia);

                      // 4. MUESTRA UN MENSAJE AL USUARIO BASADO EN EL RESULTADO
                      if (seSubioCorrectamente) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ ¡Denuncia guardada con éxito!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        await DatabaseHelper().updateDenuncia(denuncia);

                        final archivosSubidos = await _uploaderKey.currentState!
                            .subirArchivos(denuncia.clave ?? id_unico);
                        setState(() {
                          _isCargando = true;
                          cargandoText = 'Ya casi terminamos...';
                        });
                        if (!archivosSubidos) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error al subir archivos'),
                            ),
                          );
                          setState(() {
                            _isCargando = false;

                            intentar_enviar_archivos = false;
                          });
                          return;
                        }

                        setState(() {
                          intentar_enviar_archivos = false;
                          _isCargando = true;
                          cargandoText = 'Guardando evidencias...';
                        });

                        // guardar id de denuncia en el uploader
                        await _uploaderKey.currentState!
                            .guardarEvidenciasLocales(
                              idDenuncia,
                              _urlsEvidencias,
                            );

                        await DatabaseHelper().database;
                        // Esperar un breve momento para asegurar que todo se guardó
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '❌ Error al enviar la denuncia. Inténtalo de nuevo.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );

                        await DatabaseHelper().eliminarDenuncia(idDenuncia);
                        bool seEliminoCorrectamente =
                            await ApiService.eliminarEvidenciaServidor(
                              denuncia.clave ?? '0',
                            );

                        setState(() {
                          intentar_enviar_archivos = false;
                          _isCargando = false;
                        });
                        return;

                        //eliminar denuncia
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ ¡Denuncia guardada con éxito!'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      await _mostrarFundamentos(context);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => guardadoExitoso(denuncia: denuncia),
                        ),
                      );

                      setState(() {
                        _isCargando = false;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      setState(() {
                        _isCargando = false;
                      });
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
                    setState(() {
                      _isCargando = false;
                    });
                  }
                } catch (e) {
                  setState(() {
                    _isCargando = false;
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                } finally {
                  setState(() => _isCargando = false);
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
    } else {
      stepContent = Container();
    }

    return Stack(children: [SingleChildScrollView(child: stepContent)]);
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
              if (_isCargando) {
                return; // No permitir retroceso si está cargando
              }
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
      body: Stack(
        children: [
          Container(
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
          if (_isCargando)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 24),
                      Text(
                        cargandoText,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
