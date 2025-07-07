import 'package:flutter/material.dart';
import 'package:vidaplus_app/pages/profissional/perfil_profissional_page.dart';
import '../paciente/pacientes_profissional_page.dart';
import 'agenda_profissional_page.dart';

class HomePageProfissional extends StatefulWidget {
  const HomePageProfissional({super.key});

  @override
  State<HomePageProfissional> createState() => _HomePageProfissionalState();
}

class _HomePageProfissionalState extends State<HomePageProfissional> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    AgendaProfissionalPage(),
    PacientesProfissionalPage(),
    PerfilProfissionalPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}