import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../modelos/producto_model.dart';
import '../../servicios/producto_service.dart';

class DetalleProductoScreen extends StatefulWidget {
  final ProductoModel producto;
  final String token; // nuevo

  const DetalleProductoScreen({
    super.key,
    required this.producto,
    required this.token,
  });

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  late TextEditingController stockActualController;
  bool cargando = false;
  late ProductService productService;

  @override
  void initState() {
    super.initState();
    stockActualController =
        TextEditingController(text: widget.producto.stock.toString());
    productService = ProductService(token: widget.token); // inicializamos con token
  }

  @override
  void dispose() {
    stockActualController.dispose();
    super.dispose();
  }

  int get stockActual => int.tryParse(stockActualController.text) ?? 0;
  int get stockMinimo => widget.producto.stockMinimo;

  bool get esAgotado => stockActual <= 0;
  bool get esStockBajo => stockActual > 0 && stockActual <= stockMinimo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("DETALLE DEL PRODUCTO"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.producto.imageUrl ?? "https://via.placeholder.com/160",
                  height: 160,
                  width: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.image, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.producto.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "INVENTARIO",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _boxStockEditable("STOCK ACTUAL", stockActualController),
                          _boxStockNoEditable("STOCK MÍNIMO", stockMinimo),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (esAgotado || esStockBajo)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.producto.mensajeAlerta,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: cargando
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Guardar y regresar"),
                  onPressed: cargando ? null : _guardarStock,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _boxStockEditable(String titulo, TextEditingController controller) {
    return Column(
      children: [
        Text(titulo, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _boxStockNoEditable(String titulo, int valor) {
    return Column(
      children: [
        Text(titulo, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
          child: Text(valor.toString(), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Future<void> _guardarStock() async {
    final stockActualValue = int.tryParse(stockActualController.text) ?? 0;
    if (stockActualValue < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El stock no puede ser negativo"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      await productService.actualizarStock(
        widget.producto.id,
        stockActualValue,
        stockMinimo: stockMinimo,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stock actualizado correctamente"), backgroundColor: Colors.green),
      );

      Navigator.pop(context, true); // regresamos indicando cambios
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el stock: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }
}