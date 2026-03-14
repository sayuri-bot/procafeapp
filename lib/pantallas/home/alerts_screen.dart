import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modelos/producto_model.dart';
import '../../servicios/producto_service.dart';
import '../../servicios/pdf_alerta_service.dart';

class AlertasScreen extends StatefulWidget {
  final String token; // nuevo

  const AlertasScreen({super.key, required this.token});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  String filtro = "todos";
  String busqueda = "";

  List<ProductoModel> _alertas = [];
  bool _isLoading = true;
  bool _descargando = false;
  String? _error;

  Timer? _debounce;
  Timer? _timer;

  late ProductService productService;

  @override
  void initState() {
    super.initState();
    productService = ProductService(token: widget.token);
    _cargarAlertas();

    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _cargarAlertas());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _cargarAlertas() async {
    setState(() => _isLoading = true);
    try {
      final productos = await productService.getAlertasActuales();
      if (!mounted) return;
      setState(() {
        _alertas = productos;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Error al cargar alertas";
        _isLoading = false;
      });
    }
  }

  void _onBuscarChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => busqueda = value);
    });
  }

  List<ProductoModel> _filtrar() {
    return _alertas.where((p) {
      final matchBusqueda = p.name.toLowerCase().contains(busqueda.toLowerCase());
      if (filtro == "agotado") return p.isAgotado && matchBusqueda;
      if (filtro == "bajo") return p.isStockBajo && matchBusqueda;
      return matchBusqueda;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final alertasFiltradas = _filtrar();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("ALERTA DE PRODUCTOS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            _buscador(),
            const SizedBox(height: 10),
            _filtros(),
            const SizedBox(height: 15),
            Expanded(child: _contenido(alertasFiltradas)),
            const SizedBox(height: 10),
            _botonDescargar(alertasFiltradas),
          ],
        ),
      ),
    );
  }

  Widget _contenido(List<ProductoModel> alertas) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (alertas.isEmpty) return const Center(child: Text("No hay alertas disponibles"));

    return ListView.builder(
      itemCount: alertas.length,
      itemBuilder: (_, index) => _cardProducto(alertas[index]),
    );
  }

  Widget _buscador() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Buscar productos",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onChanged: _onBuscarChanged,
    );
  }

  Widget _filtros() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _chip("todos", "Todos"),
        _chip("bajo", "Bajo stock"),
        _chip("agotado", "Agotados"),
      ],
    );
  }

  Widget _chip(String value, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: filtro == value,
      onSelected: (_) => setState(() => filtro = value),
    );
  }

  Widget _cardProducto(ProductoModel producto) {
    final esAgotado = producto.isAgotado;
    final colorEstado = esAgotado ? Colors.red : (producto.isStockBajo ? Colors.orange : Colors.green);
    final iconoEstado = esAgotado ? Icons.cancel : (producto.isStockBajo ? Icons.warning : Icons.check_circle);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                producto.imageUrl ?? "https://via.placeholder.com/60",
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.image, size: 60),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Stock: ${producto.stock} / ${producto.stockMinimo}"),
                  const SizedBox(height: 8),
                  Text(producto.mensajeAlerta, style: TextStyle(color: colorEstado, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: colorEstado, minimumSize: const Size(100, 30)),
                    onPressed: () async {
                      final result = await context.push(
                        '/detalleproducto/${producto.id}',
                        extra: {'producto': producto, 'token': widget.token},
                      );
                      if (result == true) await _cargarAlertas();
                    },
                    child: const Text("Ver detalles", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            Icon(iconoEstado, color: colorEstado),
          ],
        ),
      ),
    );
  }

  Widget _botonDescargar(List<ProductoModel> alertas) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading || _descargando
            ? null
            : () async {
                setState(() => _descargando = true);
                try {
                  await PdfAlertService.generarPdf(alertas);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("PDF descargado correctamente"), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al descargar PDF: $e"), backgroundColor: Colors.red),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _descargando = false);
                }
              },
        child: Text(_descargando ? "GENERANDO PDF..." : "DESCARGAR LISTA"),
      ),
    );
  }
}