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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 80), // Espaciado antes del botón
          // Segundo campo de texto
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
          const SizedBox(height: 16), // Espaciado antes del botón

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Apellido Paterno',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length >= 4) {
                return 'Porfavor ingresa tu apellido paterno';
              }
              return null;
            },
          ),
          const SizedBox(height: 16), // Espaciado antes del botón

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Apellido Materno',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length >= 4) {
                return 'Porfavor ingresa tu apellido materno';
              }
              return null;
            },
          ),
          const SizedBox(height: 16), // Espaciado antes del botón

          DropdownButtonFormField<String>(
            value: dropdownValue,
            hint: const Text('Selecciona el sexo'),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: const [
              DropdownMenuItem<String>(value: 'Mujer', child: Text('Mujer')),
              DropdownMenuItem<String>(value: 'Hombre', child: Text('Hombre')),
              DropdownMenuItem<String>(
                value: 'Select',
                child: Text('Selecciona sexo'),
              ),
            ],
            validator: (value) {
              if (value == null || value == 'Select' || value.isEmpty) {
                return 'Porfavor selecciona tu sexo';
              }
              return null;
            },
          ),

          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Telefono',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length >= 10) {
                return 'Porfavor escribe tu telefono correctamente';
              }
              return null;
            },
          ),
          const SizedBox(height: 16), // Espaciado antes del botón

          Row(
            children: [
              Expanded(
                flex: 3, // Puedes ajustar este valor para darle más espacio
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 10) {
                      return 'Porfavor escribe tu direccion correctamente';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8), // Espaciado entre los campos
              Expanded(
                flex: 1, // Más pequeño para el número
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'No.',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 2) {
                      return 'Porfavor contesta el campo';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Espaciado antes del siguiente elemento

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
    );
  }
}
