import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            const SizedBox(height: 16), // Espaciado inicial
          ],
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
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 124, 36, 57),
        ),
        foregroundColor: Color.fromARGB(255, 124, 36, 57),
      ),
      body: SingleChildScrollView(
        // Usamos SingleChildScrollView para que el contenido sea desplazable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Medios de Prueba\n"
            "En este acto se hace del conocimiento del ciudadano que deberá presentar pruebas fehacientes que acrediten su dicho, de no ser así, la denuncia será archivada.\n\n"
            "AVISO DE PRIVACIDAD SIMPLIFICADO\n\n"
            "El Municipio de Juárez a través de la Contraloría Municipal con domicilio en Francisco Villa 950 norte, colonia centro, área de sótano, ala sur de la Unidad Administrativa "
            "Lic. Benito Juárez, da a conocer a los usuarios el siguiente aviso de privacidad simplificado, en cumplimiento a lo dispuesto en el artículo 66 de la Ley de Protección de "
            "Datos Personales del Estado de Chihuahua. La finalidad para la cual, serán recabados sus datos personales, es para la presentación de quejas o denuncias contra servidores "
            "públicos, los cuales serán tratados para las finalidades antes mencionadas, para lo cual, será necesario que usted otorgue su consentimiento al calce del presente.\n\n"
            "Se hace de su conocimiento que sus datos personales podrán ser proporcionados, si así son requeridos, a cualquier autoridad que, en los términos de ley, "
            "tenga atribuciones de investigación (Ministerio Público del Fuero Común o Federal Órganos Fiscalizadores Locales o Federales Comisiones de Derechos Humanos etc.), "
            "en asuntos que se llegasen a instaurar en contra de servidores públicos relacionados con las operaciones del Municipio de Juárez, "
            "para lo cual, será necesario que otorgue su consentimiento al calce del documento. El titular de los datos podrá manifestar su negativa al tratamiento y transferencia "
            "de sus datos, ante la Unidad de Transparencia o por medio de la Plataforma Nacional de Transparencia http://www.plataformadetransparencia.org.mx.\n\n"
            "El presente aviso de privacidad integral estará disponible en. ",
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 124, 36, 57),
            ), // Ajusta el tamaño de texto según sea necesario
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
  String evidenciaStatusValue = 'Select';
  String fechaSeleccionada = '';
  bool anonimoValue = false;
  bool visiblefecha = false;
  bool TerminosyCondicionesValue = false;
  Color colorFecha = Colors.white;
  int _currentStep = 0;

  // 👇 Aquí colocas el método
  Widget _buildStep() {
    if (_currentStep == 0) {
      return Column(
        children: [
          const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text(
                      '¿Denunciar de forma anonima?',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeTrackColor: const Color.fromARGB(146, 255, 255, 255),
                    inactiveTrackColor: const Color.fromARGB(
                      146,
                      255,
                      255,
                      255,
                    ),
                    value: anonimoValue,
                    onChanged: (bool value) {
                      setState(() {
                        if (value == false) {
                          anonimoValue = false;
                        } else {
                          anonimoValue = true;
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
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16), // Espaciado inicial

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nombre(s)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 3) {
                              return 'Por favor ingresa tu nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Apellido(s)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 4) {
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
                                dropdownColor: Color.fromRGBO(
                                  128,
                                  107,
                                  148,
                                  1,
                                ), // Color base del gradiente
                                style: TextStyle(color: Colors.white),
                                value: dropdownValue,
                                hint: const Text('Selecciona el sexo'),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
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
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 10) {
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
                          decoration: const InputDecoration(
                            labelText: 'Colonia',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 10) {
                              return 'Por favor escribe tu teléfono';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 4) {
                              return 'Por favor ingresa tu correo electrónico';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Ocupación',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 4) {
                              return 'Por favor ingresa tu ocupación';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nacionalidad',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length >= 4) {
                              return 'Por favor ingresa tu nacionalidad';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
          ),
                      child: const Text("Siguiente"),
        ],
      );
    } else if (_currentStep == 1) {
      return Column(
        children: [
          const Text(
            "Paso 2 del formulario",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 0;
              });
            },
            child: const Text("Regresar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                // Aquí va lo que hagas al enviar el formulario
              }
            },
            child: const Text("Enviar"),
          ),
        ],
      );
    }

    return Container(); // fallback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Denuncia Ciudadana"),
        backgroundColor: Colors.transparent, // Esto es importante
        elevation: 0, // Quita sombra para que el gradiente se vea limpio
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(190, 69, 117, .8), // Rosa
                Color.fromRGBO(152, 127, 175, .8), // Morado
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(190, 69, 117, 1),
              //Color.fromRGBO(83, 89, 103, 1),
              Color.fromRGBO(152, 127, 175, 1),
            ], // Cambia los colores aquí
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

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
