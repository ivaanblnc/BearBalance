import 'package:flutter/material.dart';
import '../controllers/metascontrollador.dart';
import '../entidades/informacionMetas.dart';

class ListaMetas extends StatelessWidget {
  final List<Map<String, dynamic>> metas;
  final MetasControlador controlador;
  final Function(Map<String, dynamic>)? onMetaTap;
  final bool isNested;

  const ListaMetas({
    super.key,
    required this.metas,
    required this.controlador,
    this.onMetaTap,
    this.isNested = false,
  });

  @override
  Widget build(BuildContext context) {
    if (metas.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          "Aún no has definido ninguna meta. ¡Empieza a planificar tus ahorros!", 
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey)
          ),
      ));
    }

    return ListView.builder(
      shrinkWrap: isNested, // Use the new parameter
      physics: isNested ? const NeverScrollableScrollPhysics() : null, // Conditionally apply physics
      itemCount: metas.length,
      itemBuilder: (context, index) {
        final metaMap = metas[index];
        final metaInfo = controlador.convertirMapaAMeta(metaMap);
        
        return GestureDetector(
          onTap: onMetaTap != null ? () => onMetaTap!(metaMap) : null,
          child: _crearItemMeta(context, metaInfo),
        );
      },
    );
  }

  Widget _crearItemMeta(BuildContext context, Informacionmetas? meta) {
    final theme = Theme.of(context);

    double progreso = 0.0;
    if (meta != null && meta.cantidadObjetivo > 0) {
      progreso = (meta.cantidadAhorrada) / (meta.cantidadObjetivo);
    }
    progreso = progreso.clamp(0.0, 1.0); // Asegurar que esté entre 0 y 1

    final String cantidadAhorradaStr = meta?.cantidadAhorrada.toStringAsFixed(2) ?? '0.00';
    final String cantidadObjetivoStr = meta?.cantidadObjetivo.toStringAsFixed(2) ?? '0.00';
    final String porcentajeStr = (progreso * 100).toStringAsFixed(0);

    return Card(
      elevation: 1.5, // Un poco menos de elevación para un look más sutil
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0), // Margen reducido
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), // Bordes un poco menos redondeados
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Padding interno reducido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meta?.nombre ?? 'Meta sin nombre',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface), // titleMedium en vez de titleLarge
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10.0), // SizedBox reducido
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: LinearProgressIndicator(
                value: progreso,
                minHeight: 8, // Altura de barra reducida
                backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), // Color Cupertino Azul
              ),
            ),
            const SizedBox(height: 8.0), // SizedBox reducido
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '$cantidadAhorradaStr€ / $cantidadObjetivoStr€',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$porcentajeStr%',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary, // Color Cupertino Azul para el porcentaje también
                  ),
                ),
              ],
            ),
            if (meta?.fecha != null && meta!.fecha.isNotEmpty) ...[
              const SizedBox(height: 8.0), // SizedBox reducido
              Divider(color: theme.dividerColor.withOpacity(0.4), height: 1, thickness: 0.5),
              const SizedBox(height: 8.0), // SizedBox reducido
              Row(
                children: [
                  Icon(Icons.flag_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    "Fecha objetivo: ${meta.fecha}", // Asumiendo que meta.fecha es un String formateado
                    style: theme.textTheme.bodySmall?.copyWith(
                       color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
