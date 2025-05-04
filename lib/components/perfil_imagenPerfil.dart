import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PerfilImagen extends StatelessWidget {
  final String? imageUrl;
  final ValueChanged<String?> onImageUpdated;
  final Future<void> Function(BuildContext context) onImageUpload;
  final double size;
  final String defaultAssetImage;

  const PerfilImagen({
    super.key,
    required this.imageUrl,
    required this.onImageUpdated,
    required this.onImageUpload,
    this.size = 120.0,
    this.defaultAssetImage = 'assets/imagendefecto.png',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: imageUrl != null
              ? kIsWeb
                  ? Image.network(
                      imageUrl!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        defaultAssetImage,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CachedNetworkImage(
                      key: ValueKey<String>(imageUrl!),
                      imageUrl: imageUrl!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CupertinoActivityIndicator(
                          radius: size / 4,
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        defaultAssetImage,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
                    )
              : Image.asset(
                  defaultAssetImage,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 20),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () =>
              kIsWeb ? _showWebMessage(context) : onImageUpload(context),
          child: const Text(
            "Actualizar Foto de Perfil",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _showWebMessage(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Función no disponible"),
        content: const Text(
          "Para cambiar tu foto de perfil, usa la versión móvil de la aplicación.",
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
