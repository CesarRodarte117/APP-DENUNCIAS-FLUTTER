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
  String dependenciaStatusValue = 'Select';

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
                    value: 'ADMINISTRACION DE LA CIUDAD',
                    child: Text('ADMINISTRACION DE LA CIUDAD'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value == 'Select' || value.isEmpty) {
                    return 'Por favor selecciona la dependencia';
                  }
                  return null;
                },
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
