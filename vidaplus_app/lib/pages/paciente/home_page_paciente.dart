import 'package:flutter/material.dart';
import 'paciente_consulta_page.dart';
import 'paciente_dashboard_page.dart';
import 'paciente_perfil_page.dart';

class HomePagePaciente extends StatefulWidget {
  const HomePagePaciente({super.key});

  @override
  State<HomePagePaciente> createState() => _HomePagePacienteState();
}

class _HomePagePacienteState extends State<HomePagePaciente> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    PacienteDashboardPage(),
    PacienteConsultasPage(),
    PacientePerfilPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Consultas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}