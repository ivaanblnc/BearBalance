import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:tfg_ivandelllanoblanco/controllers/logincontrollador.dart';
import 'package:tfg_ivandelllanoblanco/views/registro.dart';

// Pantalla de inicio de sesión que maneja el proceso de autenticación
class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  // Controlador para gestionar el login
  final LoginControlador controlador = LoginControlador();

  // Controladores de los campos de texto para email y contraseña
  final TextEditingController email_controlador = TextEditingController();
  final TextEditingController contrasena_controlador = TextEditingController();

  // Variables para controlar la animación de Rive
  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  // Focus nodes para los campos de texto, para controlar la animacion
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    //listeners para detectar cuándo el usuario interactúa con los campos de texto
    _emailFocus.addListener(_onEmailFocusChange);
    _passwordFocus.addListener(_onPasswordFocusChange);
  }

  @override
  void dispose() {
    // Eliminamos los  listeners y para recursos al cambiar de vista
    _emailFocus.removeListener(_onEmailFocusChange);
    _passwordFocus.removeListener(_onPasswordFocusChange);
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // Listener para el campo de correo electrónico
  void _onEmailFocusChange() {
    isChecking?.change(_emailFocus.hasFocus);
  }

  // Listener para el campo de contraseña
  void _onPasswordFocusChange() {
    isHandsUp?.change(_passwordFocus.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              "BearBalance",
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset(
                "assets/oso.riv",
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  // Inicializamos el controlador de la animación Rive
                  controller = StateMachineController.fromArtboard(
                    artboard,
                    "Login Machine",
                  );
                  if (controller == null) return;

                  artboard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Campo de texto para el correo electrónico
                  CupertinoTextField(
                    focusNode: _emailFocus,
                    controller: email_controlador,
                    placeholder: "Correo electrónico",
                    placeholderStyle: const TextStyle(color: Colors.black),
                    decoration: BoxDecoration(
                      color: CupertinoColors.extraLightBackgroundGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    style: const TextStyle(color: Colors.black),
                    onChanged: (value) {
                      // Cambiamos la animación según la longitud del texto del email
                      numLook?.change(value.length.toDouble());
                    },
                  ),
                  const SizedBox(height: 8),
                  // Campo de texto para la contraseña
                  CupertinoTextField(
                    focusNode: _passwordFocus,
                    controller: contrasena_controlador,
                    placeholder: "Contraseña",
                    placeholderStyle: const TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: BoxDecoration(
                      color: CupertinoColors.extraLightBackgroundGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 32),
                  // Botón para iniciar sesión
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                      onPressed: () async {
                        _emailFocus.unfocus();
                        _passwordFocus.unfocus();

                        final email = email_controlador.text;
                        final password = contrasena_controlador.text;

                        // Llamamos al controlador para iniciar sesión
                        final loginSuccess = await controlador.iniciarSesion(
                            email, password, context);

                        if (mounted) {
                          // Cambiamos la animación según el resultado del inicio de sesión
                          if (loginSuccess) {
                            trigSuccess?.change(true);
                          } else {
                            trigFail?.change(true);
                          }
                        }
                      },
                      child: const Text("Iniciar Sesión"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "o inicia sesion con:",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  // Botón para iniciar sesión con Google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () => {
                          controlador.loginConGoogle(context),
                          print("Botón de Google presionado")
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/logoGoogle.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Boton para registrar un  nuevo usuario
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => RegistroVista(),
                        ),
                      );
                    },
                    child: const Text("¿Aún no eres usuario? Registrate aquí",
                        style: TextStyle(color: CupertinoColors.link)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
