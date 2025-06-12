import 'package:flutter/material.dart';
import 'package:tfg_ivandelllanoblanco/controllers/logincontrollador.dart';
import 'package:tfg_ivandelllanoblanco/views/inicioDeSesion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/views/paginaInicio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tfg_ivandelllanoblanco/my_custom_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  // Inicializamos el formato de fecha para español
  await initializeDateFormatting('es_ES', null);

  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
  runApp(
    ChangeNotifierProvider(
      create: (context) => CambiarTema(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _sesionIniciada = false;
  bool _cargando = true;
  String _nombreUsuario = "";

  @override
  void initState() {
    super.initState();
    _verificarEstadoAutenticacion();
  }

  Future<void> _verificarEstadoAutenticacion() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      final userId = session.user.id;
      final datosUsuario =
          await LoginControlador().modelo.obtenerNombreUsuario(userId);
      setState(() {
        _nombreUsuario = datosUsuario?['nombre_usuario'] ?? "Usuario";
        _sesionIniciada = true;
      });
    } else {
      setState(() {
        _sesionIniciada = false;
      });
    }

    setState(() {
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        home: Scaffold(
          body: Center(
            child: SpinKitFadingCube(
              color: Theme.of(context).colorScheme.primary,
              size: 50.0,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      home:
          _sesionIniciada ? PaginaInicioVista(_nombreUsuario) : InicioSesion(),
      routes: {
        '/login': (context) => InicioSesion(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007AFF),
          brightness: Provider.of<CambiarTema>(context).modoOscuro
              ? Brightness.dark
              : Brightness.light,
        ),
        brightness: Provider.of<CambiarTema>(context).modoOscuro
            ? Brightness.dark
            : Brightness.light,
        useMaterial3: true,
      ),
    );
  }
}
