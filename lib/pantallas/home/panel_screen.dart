import 'dart:async';
import 'package:flutter/material.dart';
import 'package:procafes/modelos/producto_model.dart';
import 'package:procafes/servicios/producto_service.dart';
import 'package:procafes/servicios/dashboard_service.dart';

class PanelScreen extends StatefulWidget {
  final String token;

  const PanelScreen({super.key, required this.token});

  @override
  State<PanelScreen> createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {

  late final ProductService _productService;
  final DashboardService _dashboardService = DashboardService();

  Future<List<ProductoModel>>? _futureProductos;
  Future<List<ProductoModel>>? _futureAlertas;

  String _busqueda = '';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    _productService = ProductService(token: widget.token);

    _cargarDatos();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _cargarDatos(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _cargarDatos() {
    setState(() {
      _futureProductos = _productService.getProductos();
      _futureAlertas = _productService.getAlertasActuales();
    });
  }

  String _normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ProductoModel>>(
      future: _futureProductos,
      builder: (context, snapshotProductos) {

        if (snapshotProductos.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshotProductos.hasError) {
          return Center(child: Text("Error: ${snapshotProductos.error}"));
        }

        final productos = snapshotProductos.data ?? [];
        final resumenCards = _dashboardService.generarResumen(productos);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: resumenCards.map((item) {

                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 22,
                    child: _CardResumen(
                      titulo: item.titulo,
                      cantidad: item.cantidad,
                      icono: item.icono,
                      color: item.color,
                    ),
                  );

                }).toList(),
              ),

              const SizedBox(height: 32),

              const Text(
                'Productos con alerta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _busqueda = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: FutureBuilder<List<ProductoModel>>(
                  future: _futureAlertas,
                  builder: (context, snapshotAlertas) {

                    if (snapshotAlertas.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (snapshotAlertas.hasError) {
                      return Center(
                          child: Text(
                              "Error cargando alertas: ${snapshotAlertas.error}"));
                    }

                    final alertas = snapshotAlertas.data ?? [];

                    final filtrados = alertas.where((p) {

                      final nombre = _normalizar(p.name);
                      final busqueda = _normalizar(_busqueda);

                      return nombre.contains(busqueda);

                    }).toList();

                    if (filtrados.isEmpty) {
                      return const Center(
                        child: Text("No hay productos con alerta"),
                      );
                    }

                    return ListView.builder(
                      itemCount: filtrados.length,
                      itemBuilder: (_, index) {

                        final producto = filtrados[index];

                        Color estadoColor;
                        IconData estadoIcono;

                        if (producto.isAgotado) {
                          estadoColor = Colors.red;
                          estadoIcono = Icons.cancel;
                        } else {
                          estadoColor = Colors.orange;
                          estadoIcono = Icons.warning_amber_rounded;
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(

                            leading: SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: producto.imageUrl != null &&
                                        producto.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        producto.imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image_not_supported),
                              ),
                            ),

                            title: Text(
                              producto.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),

                            subtitle: Text(
                              "Stock: ${producto.stock} | Mínimo: ${producto.stockMinimo}\n${producto.mensajeAlerta}",
                              style: TextStyle(color: estadoColor),
                            ),

                            trailing: Icon(
                              estadoIcono,
                              color: estadoColor,
                              size: 28,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardResumen extends StatelessWidget {

  final String titulo;
  final int cantidad;
  final IconData icono;
  final Color color;

  const _CardResumen({
    required this.titulo,
    required this.cantidad,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            titulo,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                '$cantidad',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),

              Icon(icono, size: 28, color: color),

            ],
          ),
        ],
      ),
    );
  }
}