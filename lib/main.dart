import 'package:flutter/cupertino.dart';
import 'package:tfg_ivandelllanoblanco/controllers/logincontrollador.dart';
import 'package:tfg_ivandelllanoblanco/views/inicioDeSesion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tfg_ivandelllanoblanco/controllers/cambiarTema.dart';
import 'package:provider/provider.dart';
import 'package:tfg_ivandelllanoblanco/views/paginaInicio.dart';

// Método main que ejecuta la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Iniciamos la conexión con supabase
  await Supabase.initialize(
    url: 'https://pvqouxcnzzetlnwbnmjo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2cW91eGNuenpldGxud2JubWpvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMxMDYwOTIsImV4cCI6MjA1ODY4MjA5Mn0.Ioe27Ca1q4UHdGhk7oA32W99rp6_J3JZiYd0Lkyzmp4',
  );

  runApp(
    // Envolvemos la app en este listener para que ante cualquier cambio de tema
    // Se actualicen los componentes
    ChangeNotifierProvider(
      create: (context) => CambiarTema(),
      child: MainApp(),
    ),
  );
}

// Clase principal de la app
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Variables
  bool _sesionIniciada = false;
  bool _cargando = true;
  String _nombreUsuario = "";

  @override
  void initState() {
    super.initState();
    _verificarEstadoAutenticacion();
  }

  // Método para verificar si la sesión ya se había iniciado antes
  Future<void> _verificarEstadoAutenticacion() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // Si hay sesión, obtener el nombre de usuario desde la base de datos
      final userId = session.user.id;
      final datosUsuario =
          await LoginControlador().modelo.obtenerNombreUsuario(userId);
      setState(() {
        _nombreUsuario = datosUsuario?['nombre_usuario'] ??
            "Usuario"; // Establecer el nombre de usuario
        _sesionIniciada = true;
      });
    } else {
      setState(() {
        _sesionIniciada = false;
      });
    }

    // Deja de cargar
    setState(() {
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const CupertinoApp(
        home: CupertinoPageScaffold(
          child: Center(child: CupertinoActivityIndicator()),
        ),
      );
    }

    // Pasamos el nombre de usuario real (no el predeterminado) a la página de inicio
    return CupertinoApp(
      home:
          _sesionIniciada ? PaginaInicioVista(_nombreUsuario) : InicioSesion(),
      routes: {
        '/login': (context) => InicioSesion(),
      },
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Provider.of<CambiarTema>(context).modoOscuro
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }
}
