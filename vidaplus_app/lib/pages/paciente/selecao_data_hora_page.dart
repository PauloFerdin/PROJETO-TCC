import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vidaplus_app/models/profissional.dart';
import 'package:vidaplus_app/services/auth_manager.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class SelecaoDataHoraPage extends StatefulWidget {
  final Profissional profissional;
  const SelecaoDataHoraPage({super.key, required this.profissional});

  @override
  State<SelecaoDataHoraPage> createState() => _SelecaoDataHoraPageState();
}

class _SelecaoDataHoraPageState extends State<SelecaoDataHoraPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;

  bool _isLoadingTimes = false;
  List<String> _availableTimes = [];
  final _apiService = AuthService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _buscarHorarios(_selectedDay!);
  }

  void _buscarHorarios(DateTime dia) {
    setState(() {
      _isLoadingTimes = true;
      _availableTimes = [];
      _selectedTime = null;
    });

    final token = AuthManager.instance.token;
    if (token == null) return;

    final dataFormatada = DateFormat('yyyy-MM-dd').format(dia);

    _apiService
        .getHorariosDisponiveis(widget.profissional.id, dataFormatada)
        .then((horarios) {
      if (mounted) {
        setState(() {
          _availableTimes = horarios;
          _isLoadingTimes = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          _isLoadingTimes = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar horários: $error')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr(a). ${widget.profissional.nome}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. Selecione a data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: TableCalendar(
                locale: 'pt_BR',
                focusedDay: _focusedDay,
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _buscarHorarios(selectedDay);
                },
                calendarFormat: CalendarFormat.month,
                headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
              ),
            ),
            const SizedBox(height: 24),
            const Text('2. Selecione o horário', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildHorariosGrid(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: (_selectedDay != null && _selectedTime != null)
              ? () {
            final dadosAgendamento = {
              'profissional': widget.profissional,
              'data': _selectedDay!,
              'hora': _selectedTime!,
            };
            context.push('/confirmacao_agendamento', extra: dadosAgendamento);
          }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Avançar para Confirmação'),
        ),
      ),
    );
  }

  Widget _buildHorariosGrid() {
    if (_isLoadingTimes) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_availableTimes.isEmpty) {
      return const Center(child: Text('Nenhum horário disponível para este dia.'));
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _availableTimes.map((time) {
        final isSelected = _selectedTime == time;
        return ChoiceChip(
          label: Text(time),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedTime = selected ? time : null;
            });
          },
        );
      }).toList(),
    );
  }
}