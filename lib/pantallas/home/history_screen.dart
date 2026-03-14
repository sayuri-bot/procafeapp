import 'package:flutter/material.dart';
import 'package:procafes/modelos/historial_model.dart';
import 'package:procafes/servicios/historial_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistorialAlertasScreen extends StatefulWidget {
  final String token;

  const HistorialAlertasScreen({super.key, required this.token});

  @override
  State<HistorialAlertasScreen> createState() => _HistorialAlertasScreenState();
}

class _HistorialAlertasScreenState extends State<HistorialAlertasScreen> {
  late HistorialService historialService;

  List<HistorialModel> alertas = [];
  List<HistorialModel> alertasFiltradas = [];

  String filtro = "todos";
  String busqueda = "";

  DateTime? fechaInicio;
  DateTime? fechaFin;

  bool cargando = true;
  bool localesListos = false;

  @override
  void initState() {
    super.initState();
    historialService = HistorialService(token: widget.token);

    // Inicializar locales
    _initLocales();

    // Cargar alertas
    cargarAlertas();
  }

  Future<void> _initLocales() async {
    await initializeDateFormatting('es_ES', null);
    if (!mounted) return;
    setState(() {
      localesListos = true;
    });
  }

  Future<void> cargarAlertas() async {
    try {
      final data = await historialService.getHistorial();

      if (!mounted) return;
      setState(() {
        alertas = data;
        aplicarFiltros();
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando historial: $e")),
      );
    }
  }

  void aplicarFiltros() {
    List<HistorialModel> lista = List.from(alertas);

    // Filtro por texto
    if (busqueda.isNotEmpty) {
      lista = lista
          .where((a) => a.name.toLowerCase().contains(busqueda.toLowerCase()))
          .toList();
    }

    // Filtro tipo alerta
    if (filtro == "agotados") {
      lista = lista.where((a) => a.stockDetectado <= 0).toList();
    } else if (filtro == "bajo") {
      lista = lista.where((a) => a.stockDetectado > 0).toList();
    }

    // actualizacion de Filtro por rango de fechas
    if (fechaInicio != null && fechaFin != null) {
      final inicio = DateTime(fechaInicio!.year, fechaInicio!.month, fechaInicio!.day);
      final fin = DateTime(fechaFin!.year, fechaFin!.month, fechaFin!.day, 23, 59, 59);
      lista = lista.where((a) {
        final fecha = DateTime.parse(a.fecha);
        return  fecha.isAtSameMomentAs(inicio) ||
                fecha.isAtSameMomentAs(fin)     ||
                (fecha.isAfter(inicio) && fecha.isBefore(fin));
      }).toList();
    }

    alertasFiltradas = lista;
  }

  /// Agrupa por fecha y devuelve solo la última alerta de cada producto
  Map<String, List<HistorialModel>> agruparPorFechaUltimaAlerta() {
    Map<String, List<HistorialModel>> mapa = {};

    for (var alerta in alertasFiltradas) {
      final fechaKey = DateFormat('yyyy-MM-dd').format(DateTime.parse(alerta.fecha));

      if (!mapa.containsKey(fechaKey)) {
        mapa[fechaKey] = [];
      }

      final indexExistente =
          mapa[fechaKey]!.indexWhere((a) => a.productId == alerta.productId);

      if (indexExistente == -1) {
        mapa[fechaKey]!.add(alerta);
      } else {
        final existente = mapa[fechaKey]![indexExistente];
        if (DateTime.parse(alerta.fecha).isAfter(DateTime.parse(existente.fecha))) {
          mapa[fechaKey]![indexExistente] = alerta;
        }
      }
    }

    return mapa;
  }

  Future<void> seleccionarFecha(bool inicio) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      if (!mounted) return;
      setState(() {
        if (inicio) {
          fechaInicio = fecha;
        } else {
          fechaFin = fecha;
        }
        aplicarFiltros();
      });
    }
  }

  Widget chipFiltro(String texto, String valor) {
    final activo = filtro == valor;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(texto),
        selected: activo,
        onSelected: (v) {
          if (!mounted) return;
          setState(() {
            filtro = valor;
            aplicarFiltros();
          });
        },
      ),
    );
  }

  Widget itemAlerta(HistorialModel alerta) {
    final esAgotado = alerta.stockDetectado <= 0;
    final icon = esAgotado ? Icons.cancel : Icons.warning_amber_rounded;
    final color = esAgotado ? Colors.red : Colors.orange;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(alerta.name),
      subtitle: Text(alerta.mensaje),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!localesListos) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final agrupadas = agruparPorFechaUltimaAlerta();

    return Scaffold(
      appBar: AppBar(
        title: const Text("HISTORIAL DE ALERTAS"),
        centerTitle: true,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Rango de fechas
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(fechaInicio == null
                              ? "Inicio"
                              : DateFormat('dd/MM/yyyy').format(fechaInicio!)),
                          onPressed: () => seleccionarFecha(true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: Text(fechaFin == null
                              ? "Fin"
                              : DateFormat('dd/MM/yyyy').format(fechaFin!)),
                          onPressed: () => seleccionarFecha(false),
                        ),
                      ),
                    ],
                  ),
                ),
                // Buscador
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar productos",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onChanged: (v) {
                      if (!mounted) return;
                      setState(() {
                        busqueda = v;
                        aplicarFiltros();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Filtros
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      chipFiltro("Todos", "todos"),
                      chipFiltro("Bajo stock", "bajo"),
                      chipFiltro("Agotados", "agotados"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Lista de alertas
                Expanded(
                  child: ListView(
                    children: agrupadas.entries.map((entry) {
                      final fecha = DateFormat('d MMMM yyyy', 'es_ES')
                          .format(DateTime.parse(entry.key));
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              fecha,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...entry.value.map(itemAlerta), // <- sin toList()
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}