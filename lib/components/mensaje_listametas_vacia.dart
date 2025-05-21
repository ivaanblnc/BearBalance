import 'package:flutter/material.dart';

class MensajeVacioMetas extends StatelessWidget {
  final VoidCallback? onAniadirMeta;
  final bool mostrarIcono;
  final bool mostrarTextoPrincipal;
  final bool mostrarTextoSecundario;
  final bool mostrarBoton;

  const MensajeVacioMetas({
    super.key,
    this.onAniadirMeta,
    this.mostrarIcono = true,
    this.mostrarTextoPrincipal = true,
    this.mostrarTextoSecundario = true,
    this.mostrarBoton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (mostrarIcono) ...[
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigoAccent,
              child: Icon(Icons.notification_important,
                  size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
          ],
          if (mostrarTextoPrincipal) ...[
            const Text(
              "¡Todavía no tienes metas!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigoAccent),
            ),
            const SizedBox(height: 20),
          ],
          if (mostrarTextoSecundario) ...[
            const Text(
              "Empieza añadiendo una para alcanzar tus metas financieras haciendo clic en el botón inferior",
              style: TextStyle(fontSize: 15, color: Colors.indigoAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
          if (mostrarBoton && onAniadirMeta != null) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onAniadirMeta,
              child: const Text("Añadir Meta"),
            ),
          ],
        ],
      ),
    );
  }
}
