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

var _currencies = [
  "Food",
  "Transport",
  "Personal",
  "Shopping",
  "Medical",
  "Rent",
  "Movie",
  "Salary",
];

class FormDenunciaState extends State<FormDenuncia> {
  final _formkey = GlobalKey<FormState>();

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
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una descripción';
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
              if (value == null || value.isEmpty) {
                return 'Porfavor contesta el campo';
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
              if (value == null || value.isEmpty) {
                return 'Porfavor contesta el campo';
              }
              return null;
            },
          ),
          const SizedBox(height: 16), // Espaciado antes del botón

          DropdownButton(
            value: _currencies,
            isDense: true,
            onChanged: (String newValue) {
              setState(() {
                _currencies = newValue;
                state.didChange(newValue);
              });
            },

            items:
                _currencies.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
          ),

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
