// ============================================================
// Práctica 2: Conociendo tu IMC
// Alumno: Oscar Manuel Ayala Ortiz
// Grupo: GTID232 · Núm. de control: 1225100756
// Materia: Desarrollo de Aplicaciones Móviles
// Práctica base: «Conociendo a la persona»
// ============================================================

// Widgets de Material Design: Scaffold, AppBar, TextField, etc.
import 'package:flutter/material.dart';
// SystemNavigator (cerrar la app) y FilteringTextInputFormatter (limitar
// lo que se puede teclear en los campos).
import 'package:flutter/services.dart';

// ------------------------------------------------------------
// LÓGICA DEL IMC (funciones sueltas: no dependen de la pantalla)
// ------------------------------------------------------------

// Aplica la fórmula IMC = peso / (estatura en metros)^2.
// Recibe la estatura en centímetros, la convierte a metros y redondea
// el resultado a UN decimal.
double calcularImc(double pesoKg, double estaturaCm) {
  final double estaturaM = estaturaCm / 100; // cm -> m
  final double imc = pesoKg / (estaturaM * estaturaM);
  // toStringAsFixed(1) redondea a un decimal (devuelve String) y
  // double.parse lo vuelve a convertir en número. Así clasificamos
  // el valor YA redondeado (24.96 -> 25.0 -> sobrepeso).
  return double.parse(imc.toStringAsFixed(1));
}

// Clasifica el IMC ya redondeado con los límites 18.5, 25 y 30.
// if / else if / else: se evalúa de arriba hacia abajo y se detiene en
// la primera condición verdadera.
String obtenerCategoria(double imc) {
  if (imc < 18.5) {
    return 'Bajo peso';
  } else if (imc < 25) {
    return 'Peso normal';
  } else if (imc < 30) {
    return 'Sobrepeso';
  } else {
    return 'Obesidad';
  }
}

// Mensaje de recomendación según la categoría.
String obtenerConsejo(String categoria) {
  switch (categoria) {
    case 'Bajo peso':
      return 'Te recomendamos mejorar tu alimentación.';
    case 'Peso normal':
      return '¡Sigue así, vas muy bien!';
    case 'Sobrepeso':
      return 'Te conviene cuidar tu alimentación y actividad física.';
    default:
      return 'Es importante buscar orientación profesional.';
  }
}

// Color asociado a cada categoría (reto opcional: borde de la etiqueta).
MaterialColor obtenerColor(String categoria) {
  switch (categoria) {
    case 'Bajo peso':
      return Colors.blue;
    case 'Peso normal':
      return Colors.green;
    case 'Sobrepeso':
      return Colors.orange;
    default:
      return Colors.red;
  }
}

// main() es el punto de entrada: Dart siempre empieza a ejecutar aquí.
void main() {
  runApp(const MyApp());
}

// MyApp es un widget SIN estado: configura la app completa.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conociendo tu IMC',
      debugShowCheckedModeBanner: false, // quita la cinta "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

// PantallaPrincipal es un widget CON estado porque el texto de la
// etiqueta de resultado cambia mientras la app se usa.
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  // ---------- CONTROLADORES ----------
  // Un controlador por cada TextField: sirve para leer y borrar el texto.
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _pesoCtrl = TextEditingController();
  final TextEditingController _estaturaCtrl = TextEditingController();

  // ---------- VARIABLES DE ESTADO ----------
  // Texto de la etiqueta de resultado (vacío al iniciar).
  String _resultado = '';
  // Color del borde de la etiqueta; cambia según la categoría.
  MaterialColor _colorResultado = Colors.indigo;

  // Libera la memoria de los controladores al destruir la pantalla.
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _pesoCtrl.dispose();
    _estaturaCtrl.dispose();
    super.dispose();
  }

  // Muestra un diálogo con un título y un mensaje (reutilizable).
  void _mostrarDialogo(String titulo, String contenido) {
    showDialog(
      context: context,
      builder: (BuildContext contexto) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(contenido),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(contexto).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Se ejecuta al presionar "Calcular IMC".
  void _calcular() {
    // Oculta el teclado.
    FocusScope.of(context).unfocus();

    // ---------- 1) LEER LOS DATOS ----------
    final String nombre = _nombreCtrl.text.trim();
    // tryParse devuelve null (en lugar de un error) si el texto no es un
    // número válido.
    final double? peso = double.tryParse(_pesoCtrl.text.trim());
    final double? estatura = double.tryParse(_estaturaCtrl.text.trim());

    // ---------- 2) VALIDAR ----------
    // Falta algún dato o no es un número.
    if (nombre.isEmpty || peso == null || estatura == null) {
      _mostrarDialogo(
        'Datos incompletos',
        'Por favor captura tu nombre completo, tu peso (kg) y tu estatura (cm).',
      );
      return; // termina aquí; el resto no se ejecuta
    }
    // Peso o estatura en cero: evita dividir entre cero.
    if (peso <= 0 || estatura <= 0) {
      _mostrarDialogo(
        'Datos no válidos',
        'El peso y la estatura deben ser mayores que cero.',
      );
      return;
    }

    // ---------- 3) CALCULAR Y CLASIFICAR ----------
    final double imc = calcularImc(peso, estatura);
    final String categoria = obtenerCategoria(imc);
    final String consejo = obtenerConsejo(categoria);

    // ---------- 4) ARMAR EL MENSAJE ----------
    // Interpolación: $variable inserta su valor; \n es salto de línea.
    // toStringAsFixed(1) asegura un decimal (25.0 en lugar de 25).
    final String mensaje = 'Hola, $nombre.\n'
        'Tu IMC es ${imc.toStringAsFixed(1)}.\n'
        'Tu estatus actual: $categoria.\n'
        '$consejo';

    // ---------- 5) MOSTRAR EN LA ETIQUETA ----------
    // setState avisa a Flutter que debe redibujar la pantalla.
    setState(() {
      _resultado = mensaje;
      _colorResultado = obtenerColor(categoria);
    });

    // ---------- 6) MOSTRAR EN EL DIÁLOGO ----------
    _mostrarDialogo('Resultado', mensaje);
  }

  // Borra los tres campos y la etiqueta de resultado.
  void _limpiar() {
    _nombreCtrl.clear();
    _pesoCtrl.clear();
    _estaturaCtrl.clear();
    setState(() {
      _resultado = '';
      _colorResultado = Colors.indigo;
    });
  }

  // Pide confirmación y, si el usuario acepta, cierra la app.
  void _salir() {
    showDialog(
      context: context,
      builder: (BuildContext contexto) {
        return AlertDialog(
          title: const Text('¿Deseas salir?'),
          content: const Text('Se cerrará la aplicación.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(contexto).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(contexto).pop();
                // Cierra la app en Android (en web/iOS no tiene efecto).
                SystemNavigator.pop();
              },
              child: const Text('Salir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------- TÍTULO DE LA APP ----------
      appBar: AppBar(
        title: const Text('Conociendo tu IMC'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Captura tus datos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),

            // ---------- CAMPO 1: NOMBRE COMPLETO ----------
            TextField(
              controller: _nombreCtrl,
              keyboardType: TextInputType.name,
              // Cada palabra inicia con mayúscula.
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- CAMPO 2: PESO (kg) ----------
            TextField(
              controller: _pesoCtrl,
              // Teclado decimal: admite un punto.
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              // Dígitos, un punto opcional y máximo dos decimales.
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                prefixIcon: Icon(Icons.monitor_weight),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // ---------- CAMPO 3: ESTATURA (cm) ----------
            TextField(
              controller: _estaturaCtrl,
              keyboardType: TextInputType.number, // teclado numérico
              // Solo dígitos enteros (0-9).
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Estatura (cm)',
                helperText: 'En centímetros, por ejemplo: 165',
                prefixIcon: Icon(Icons.height),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // ---------- BOTÓN 1: CALCULAR IMC ----------
            ElevatedButton.icon(
              onPressed: _calcular, // sin paréntesis: pasamos la referencia
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular IMC'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),

            // ---------- BOTÓN 2: LIMPIAR DATOS ----------
            OutlinedButton.icon(
              onPressed: _limpiar,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Limpiar datos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 12),

            // ---------- BOTÓN 3: SALIR ----------
            TextButton.icon(
              onPressed: _salir,
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Salir'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 24),

            // ---------- ETIQUETA DE RESULTADO ----------
            // El color del borde y del fondo cambia según la categoría.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _colorResultado.shade50,
                border: Border.all(color: _colorResultado, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _resultado.isEmpty ? 'Aquí aparecerá el resultado' : _resultado,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            // Aclaración: el IMC no es un diagnóstico médico.
            const Text(
              'El IMC es una referencia general para personas adultas; '
              'no es un diagnóstico médico.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
