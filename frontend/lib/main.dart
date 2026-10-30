import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'demo-api-key',
      appId: '1:123456789:web:demo',
      messagingSenderId: '123456789',
      projectId: 'demo-sistema-almacen',
    ),
  );

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8081);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirestoreTestPage(),
    );
  }
}

class FirestoreTestPage extends StatefulWidget {
  const FirestoreTestPage({super.key});

  @override
  State<FirestoreTestPage> createState() => _FirestoreTestPageState();
}

class _FirestoreTestPageState extends State<FirestoreTestPage> {
  String resultado = 'Presiona el botón para probar Firestore';
  bool cargando = false;

  Future<void> probarFirestore() async {
    setState(() {
      cargando = true;
      resultado = 'Probando conexión...';
    });

    try {
      final referencia = FirebaseFirestore.instance
          .collection('pruebas')
          .doc('conexion');

      // 1. Guardar un documento
      await referencia.set({
        'mensaje': 'Hola desde Flutter',
        'fecha': FieldValue.serverTimestamp(),
      });

      // 2. Leer el documento
      final documento = await referencia.get();

      setState(() {
        resultado = documento.exists
            ? '¡Conexión exitosa!\n\n'
                  'Dato guardado: ${documento.data()?['mensaje']}'
            : 'No se encontró el documento';
      });
    } catch (error) {
      setState(() {
        resultado = 'Error al conectar:\n$error';
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sistema de Almacén')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storage, size: 65),
              const SizedBox(height: 20),
              const Text(
                'Prueba de conexión con Firestore',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: cargando ? null : probarFirestore,
                child: Text(cargando ? 'Probando...' : 'Probar Firestore'),
              ),
              const SizedBox(height: 25),
              Text(
                resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
