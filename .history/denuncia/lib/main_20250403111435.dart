import 'package:flutter/material.dart';

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
      ),

      home: Scaffold(body: const FormDenuncia()),
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

class FormDenunciaState extends State<FormDenuncia> {
  final _formkey = GlobalKey<FormState>();
  String dropdownValue = 'Select';
  String civilStatusValue = 'Select';
  String dependenciaStatusValue = '117';
  String echodropdownValue = 'Select';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80), // Espaciado inicial
              TextFormField(
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
                decoration: const InputDecoration(
                  labelText: 'Apellido Paterno',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length >= 4) {
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
                  if (value == null || value.isEmpty || value.length >= 4) {
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
                      value: dropdownValue,
                      hint: const Text('Selecciona el sexo'),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'Mujer', child: Text('Mujer')),
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
                value: civilStatusValue,
                hint: const Text('Selecciona estado civil'),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    civilStatusValue = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'Solter@', child: Text('Solter@')),
                  DropdownMenuItem(value: 'Casad@', child: Text('Casad@')),
                  DropdownMenuItem(value: 'Viud@', child: Text('Viud@')),
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
                  if (value == null || value == 'Select' || value.isEmpty) {
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
                  if (value == null || value.isEmpty || value.length >= 10) {
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
                  if (value == null || value.isEmpty || value.length >= 4) {
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
                  if (value == null || value.isEmpty || value.length >= 4) {
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
                  if (value == null || value.isEmpty || value.length >= 4) {
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
                  if (value == null || value.isEmpty || value.length >= 4) {
                    return 'Por favor ingresa tu nacionalidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

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
                    child: Text('DIRECCIÓN DE INDUSTRIALIZACION AGROPECUARIA'),
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
                    child: Text('SINDICATO UNICO DE TRABAJADORES MUNICIPALES'),
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
                    flex: 3,
                    child: DropdownButtonFormField<String>(
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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Procesando...')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
