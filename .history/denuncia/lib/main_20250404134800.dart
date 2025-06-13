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
      appBar: AppBar(title: const Text("Denuncia Ciudadana")),
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

            const SizedBox(height: 16), // Espaciado inicial

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormDenuncia()),
                );
              },
              child: const Text("Iniciar Denuncia"),
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
      appBar: AppBar(title: const Text("Términos y Condiciones")),
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
              children: [
                SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset('assets/logoheroica.png'),
                ), // Espaciado inicial

                const Text(
                  'Denuncia Ciudadana',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16), // Espaciado inicial

                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text(
                    '¿Denunciar de forma anonima?',
                    style: TextStyle(color: Colors.white),
                  ),
                  activeTrackColor: const Color.fromARGB(146, 255, 255, 255),
                  inactiveTrackColor: const Color.fromARGB(146, 255, 255, 255),
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
                          labelText: 'Apellido Paterno',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length >= 4) {
                            return 'Por favor ingresa tu apellido paterno';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Apellido Materno',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length >= 4) {
                            return 'Por favor ingresa tu apellido materno';
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

                      DropdownButtonFormField<String>(
                        dropdownColor: Color.fromRGBO(128, 107, 148, 1),
                        style: TextStyle(color: Colors.white),
                        value: civilStatusValue,
                        hint: const Text('Selecciona estado civil'),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            civilStatusValue = newValue!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Solter@',
                            child: Text('Solter@'),
                          ),
                          DropdownMenuItem(
                            value: 'Casad@',
                            child: Text('Casad@'),
                          ),
                          DropdownMenuItem(
                            value: 'Viud@',
                            child: Text('Viud@'),
                          ),
                          DropdownMenuItem(
                            value: 'Divorciad@',
                            child: Text('Divorciad@'),
                          ),
                          DropdownMenuItem(
                            value: 'union libre',
                            child: Text('Union libre'),
                          ),
                          DropdownMenuItem(
                            value: 'Select',
                            child: Text('Selecciona estado civil'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null ||
                              value == 'Select' ||
                              value.isEmpty) {
                            return 'Por favor selecciona tu estado civil';
                          }
                          return null;
                        },
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
                          labelText: 'No. ID de Ciudadano',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length >= 4) {
                            return 'Por favor ingresa tu ID';
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

                //Datos del servidor
                const Text(
                  'Datos del servidor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre del servidor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa el nombre del servidor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Cargo del servidor',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa el cargo del servidor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  dropdownColor: Color.fromRGBO(128, 107, 148, 1),
                  style: TextStyle(color: Colors.white),
                  value: dependenciaStatusValue,
                  hint: const Text('Selecciona la dependencia'),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      dependenciaStatusValue = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: '117',
                      child: Text(' SELECCIONA LA DEPENDENCIA'),
                    ),
                    DropdownMenuItem(
                      value: '95',
                      child: Text('ADMINISTRACION DE LA CIUDAD'),
                    ),
                    DropdownMenuItem(
                      value: '80',
                      child: Text('ASOCIACIONES RELIGIOSAS'),
                    ),
                    DropdownMenuItem(
                      value: '108',
                      child: Text('COMUNICACIÓN SOCIAL'),
                    ),
                    DropdownMenuItem(
                      value: '6',
                      child: Text('CONTRALORIA MUNICIPAL'),
                    ),
                    DropdownMenuItem(
                      value: '0',
                      child: Text('CONTRALURIA MUNICIPAL'),
                    ),
                    DropdownMenuItem(
                      value: '12',
                      child: Text('CONTROL DE TRAFICO'),
                    ),
                    DropdownMenuItem(
                      value: '44',
                      child: Text('COORDINACIÓN DE ATENCION CIUDADANA'),
                    ),
                    DropdownMenuItem(
                      value: '96',
                      child: Text('COORDINACIÓN DE CONTACTO SOCIAL'),
                    ),
                    DropdownMenuItem(
                      value: '97',
                      child: Text('COORDINACIÓN DE REDES SOCIALES'),
                    ),
                    DropdownMenuItem(
                      value: '10',
                      child: Text(
                        'COORDINADORA DE ATENCION CIUDADANA DEL SUR ORIENTE',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '42',
                      child: Text('DIRECCIÓN DE ALUMBRADO'),
                    ),
                    DropdownMenuItem(
                      value: '84',
                      child: Text('DIRECCIÓN DE ASUNTOS INTERNOS'),
                    ),
                    DropdownMenuItem(
                      value: '76',
                      child: Text('DIRECCIÓN DE CATASTRO'),
                    ),
                    DropdownMenuItem(
                      value: '100',
                      child: Text('DIRECCIÓN DE DESARROLLO RURAL'),
                    ),
                    DropdownMenuItem(
                      value: '46',
                      child: Text('DIRECCIÓN DE ECOLOGIA'),
                    ),
                    DropdownMenuItem(
                      value: '16',
                      child: Text('DIRECCIÓN DE EDUCACIÓN'),
                    ),
                    DropdownMenuItem(
                      value: '73',
                      child: Text('DIRECCIÓN DE GOBIERNO'),
                    ),
                    DropdownMenuItem(
                      value: '87',
                      child: Text(
                        'DIRECCIÓN DE INDUSTRIALIZACION AGROPECUARIA',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '75',
                      child: Text('DIRECCIÓN DE INGRESOS'),
                    ),
                    DropdownMenuItem(
                      value: '14',
                      child: Text('DIRECCIÓN DE LIMPIA'),
                    ),
                    DropdownMenuItem(
                      value: '43',
                      child: Text('DIRECCIÓN DE PARQUES Y JARDINES'),
                    ),
                    DropdownMenuItem(
                      value: '111',
                      child: Text('DIRECCIÓN DE RECURSOS HUMANOS'),
                    ),
                    DropdownMenuItem(
                      value: '41',
                      child: Text('DIRECCIÓN DE REGULARIZACION COMERCIAL'),
                    ),
                    DropdownMenuItem(
                      value: '106',
                      child: Text('DIRECCIÓN DE RESPONSABILIDADES'),
                    ),
                    DropdownMenuItem(
                      value: '22',
                      child: Text('DIRECCIÓN DE SALUD MUNICIPAL'),
                    ),
                    DropdownMenuItem(
                      value: '20',
                      child: Text('DIRECCIÓN GENERAL DE ASENTAMIENTOS HUMANOS'),
                    ),
                    DropdownMenuItem(
                      value: '21',
                      child: Text('DIRECCIÓN GENERAL DE CENTROS COMUNITARIOS'),
                    ),
                    DropdownMenuItem(
                      value: '18',
                      child: Text('DIRECCIÓN GENERAL DE DESARROLLO ECONÓMICO'),
                    ),
                    DropdownMenuItem(
                      value: '15',
                      child: Text('DIRECCIÓN GENERAL DE DESARROLLO SOCIAL'),
                    ),
                    DropdownMenuItem(
                      value: '5',
                      child: Text('DIRECCIÓN GENERAL DE DESARROLLO URBANO'),
                    ),
                    DropdownMenuItem(
                      value: '71',
                      child: Text(
                        'DIRECCIÓN GENERAL DE INFORMATICA Y COMUNICACIONES',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '4',
                      child: Text('DIRECCIÓN GENERAL DE OBRAS PUBLICAS'),
                    ),
                    DropdownMenuItem(
                      value: '19',
                      child: Text('DIRECCIÓN GENERAL DE PROTECCIÓN CIVIL'),
                    ),
                    DropdownMenuItem(
                      value: '99',
                      child: Text('DIRECCIÓN GENERAL DE SERVICIOS PUBLICOS'),
                    ),
                    DropdownMenuItem(
                      value: '98',
                      child: Text('DIRECCIÓN GENERAL DE TRANSITO MUNICIPAL'),
                    ),
                    DropdownMenuItem(
                      value: '102',
                      child: Text('DIRECCIÓN JURIDICA'),
                    ),
                    DropdownMenuItem(
                      value: '27',
                      child: Text(
                        'INSTITUTO MUNICIPAL DE INVESTIGACION Y PLANACION (IMIP)',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '104',
                      child: Text('INSTITUTO MUNICIPAL DE LAS MUJERES (IMM)'),
                    ),
                    DropdownMenuItem(
                      value: '17',
                      child: Text(
                        'INSTITUTO MUNICIPAL DEL DEPORTE Y CULTURA FISICA DE JUAREZ',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '105',
                      child: Text(
                        'INSTITUTO MUNICIPAL DEL JUVENTUD DE JUAREZ (IMJJ)',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '103',
                      child: Text(
                        'INSTITUTO PARA LA CULTURA DEL MUNICIPIO DE JUAREZ (ICMJ)',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '109',
                      child: Text('OFICIALIA MAYOR'),
                    ),
                    DropdownMenuItem(
                      value: '25',
                      child: Text(
                        'OPERADORA MUNICIPAL DE ESTACIONAMIENTOS DE JUAREZ (OMEJ)',
                      ),
                    ),
                    DropdownMenuItem(value: '110', child: Text('OTROS')),
                    DropdownMenuItem(
                      value: '11',
                      child: Text('SECRETARIA DE SEGURIDAD PUBLICA'),
                    ),
                    DropdownMenuItem(
                      value: '1',
                      child: Text('SECRETARIA DEL AYUNTAMIENTO'),
                    ),
                    DropdownMenuItem(
                      value: '23',
                      child: Text('SECRETARIA PARTICULAR'),
                    ),
                    DropdownMenuItem(
                      value: '94',
                      child: Text('SECRETARIA TECNICA (070)'),
                    ),
                    DropdownMenuItem(
                      value: '107',
                      child: Text(
                        'SINDICATO UNICO DE TRABAJADORES MUNICIPALES',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '26',
                      child: Text(
                        'SISTEMA DE URBANIZACION MUNICIPAL ADICIONAL (SUMA)',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '24',
                      child: Text(
                        'SISTEMA PARA EL DESARROLLO INTEGRAL DE LA FAMILIA (DIF)',
                      ),
                    ),
                    DropdownMenuItem(
                      value: '8',
                      child: Text('TESORERIA MUNICIPAL'),
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
                  decoration: const InputDecoration(
                    labelText: 'Otros datos para su identificación',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
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
                        dropdownColor: Color.fromRGBO(128, 107, 148, 1),
                        style: TextStyle(color: Colors.white),
                        value: echodropdownValue,
                        hint: const Text('Lugar del hecho'),
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            echodropdownValue = newValue!;
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
                          if (value == null ||
                              value == 'Select' ||
                              value.isEmpty) {
                            return 'Por favor selecciona tu sexo';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Distrito',
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
                    labelText: 'Dirección del hecho',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa la dirección del hecho';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Entre calles',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if ((value == null || value.isEmpty) || value.length >= 3) {
                      return 'Porfavor ingresa entre que calles';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Colonia',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 4) {
                      return 'Por favor ingresa la colonia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  dropdownColor: Color.fromRGBO(128, 107, 148, 1),
                  style: TextStyle(color: Colors.white),
                  value: evidenciaStatusValue,
                  hint: const Text('Selecciona estado civil'),
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      evidenciaStatusValue = newValue!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Imagenes',
                      child: Text('Imagene(s)'),
                    ),
                    DropdownMenuItem(value: 'Videos', child: Text('Video(s)')),
                    DropdownMenuItem(
                      value: 'Documentos',
                      child: Text('Documento(s)'),
                    ),
                    DropdownMenuItem(
                      value: 'Select',
                      child: Text('Selecciona la evidencia'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value == 'Select' || value.isEmpty) {
                      return 'Por favor selecciona la evidencia';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2026),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        visiblefecha = true;
                        // Do something with the selected date
                        fechaSeleccionada = DateFormat(
                          'd/M/yyyy',
                        ).format(selectedDate);

                        colorFecha = Colors.white;
                      });
                    } else {
                      setState(() {
                        visiblefecha = false;
                      });
                    }
                  },
                  child: const Text('Selecciona la fecha del hecho'),
                  style: TextButton.styleFrom(foregroundColor: colorFecha),
                ),

                Visibility(
                  visible: visiblefecha,
                  child: Text(
                    "Fecha seleccionada: $fechaSeleccionada",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Señale el motivo y narre los hechos',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 150) {
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
                  title: const Text(
                    'Términos y condiciones',
                    style: TextStyle(color: Colors.white),
                  ),

                  value: TerminosyCondicionesValue,
                  tileColor: Colors.white,
                  activeColor: const Color.fromRGBO(128, 107, 148, 1),
                  onChanged: (bool? value) {
                    setState(() {
                      TerminosyCondicionesValue = value ?? false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsAndConditionsScreen(),
                        ),
                      );
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity
                          .leading, // Coloca la casilla a la izquierda
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (visiblefecha == false) {
                        setState(() {
                          colorFecha = Colors.red;
                        });
                      }
                      if (_formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Procesando...')),
                        );
                      }
                    },
                    child: const Text('Registrar Denuncia'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
