import 'package:flutter/material.dart';
import '../modelos/producto_model.dart';
import '../modelos/dashboard_model.dart';

class DashboardService {
  List<DashboardModel> generarResumen(List<ProductoModel> productos) {
    final agotados = productos.where((p) => p.isAgotado).length;
    final bajoStock = productos.where((p) => p.isStockBajo).length;
    final enStock = productos.where((p) => p.isNormal).length;

    return [
      DashboardModel(
        titulo: 'Agotados',
        cantidad: agotados,
        icono: Icons.cancel,
        color: Colors.red,
      ),
      DashboardModel(
        titulo: 'Stock Bajo',
        cantidad: bajoStock,
        icono: Icons.warning_amber_rounded,
        color: Colors.orange,
      ),
      DashboardModel(
        titulo: 'En Stock',
        cantidad: enStock,
        icono: Icons.inventory_2_rounded,
        color: Colors.green,
      ),
    ];
  }
}