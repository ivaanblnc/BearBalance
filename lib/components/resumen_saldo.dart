import 'package:flutter/material.dart';

class SaldoResumen extends StatefulWidget {
  const SaldoResumen({
    super.key,
    required this.totalIngresos,
    required this.totalGastos,
    this.ingresosMesActual,
    this.gastosMesActual,
  });

  final double totalIngresos;
  final double totalGastos;
  final double? ingresosMesActual;
  final double? gastosMesActual;

  @override
  State<SaldoResumen> createState() => _SaldoResumenState();
}

class _SaldoResumenState extends State<SaldoResumen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasMonthlyData = widget.ingresosMesActual != null && widget.gastosMesActual != null;

    final positiveColor = Colors.greenAccent[400]!;
    final negativeColor = Colors.redAccent[400]!;

    List<Widget> pages = [];
    if (hasMonthlyData) {
      pages.add(_buildPageWithTitle(
        context: context,
        title: "Este mes:",
        child: _buildSection(
          context: context,
          ingresos: widget.ingresosMesActual!,
          gastos: widget.gastosMesActual!,
          positiveColor: positiveColor,
          negativeColor: negativeColor,
        ),
      ));
    }
    pages.add(_buildPageWithTitle(
      context: context,
      title: "Histórico:",
      child: _buildSection(
        context: context,
        ingresos: widget.totalIngresos,
        gastos: widget.totalGastos,
        positiveColor: positiveColor,
        negativeColor: negativeColor,
      ),
    ));

    if (_currentPage == 0 && !hasMonthlyData && pages.length == 1) {
    } else if (_currentPage >= pages.length) {
      _currentPage = pages.length -1; 
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded( 
              child: PageView(
                controller: _pageController,
                children: pages,
              ),
            ),

            if (pages.length > 1) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return Container(
                    width: 7.0,
                    height: 7.0,
                    margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.4),
                    ),
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPageWithTitle({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required double ingresos,
    required double gastos,
    required Color positiveColor, 
    required Color negativeColor,
  }) {
    final theme = Theme.of(context);

    return Padding( 
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, 
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ingresos:",
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(
                "${ingresos.toStringAsFixed(2)} €",
                style: theme.textTheme.bodyLarge?.copyWith(color: positiveColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gastos:",
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(
                "${gastos.toStringAsFixed(2)} €",
                style: theme.textTheme.bodyLarge?.copyWith(color: negativeColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
