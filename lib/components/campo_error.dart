import 'package:flutter/cupertino.dart';

class CampoError extends StatelessWidget {
  final String? mensaje;

  const CampoError({super.key, this.mensaje});

  @override
  Widget build(BuildContext context) {
    if (mensaje == null || mensaje!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        mensaje!,
        style: const TextStyle(
            color: CupertinoColors.destructiveRed, fontSize: 12.0),
      ),
    );
  }
}
