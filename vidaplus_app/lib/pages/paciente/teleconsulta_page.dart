import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeleconsultaPacientePage extends StatefulWidget {
  const TeleconsultaPacientePage({super.key});

  @override
  State<TeleconsultaPacientePage> createState() => _TeleconsultaPacientePageState();
}

class _TeleconsultaPacientePageState extends State<TeleconsultaPacientePage> {
  bool isMicMuted = false;
  bool isCameraOff = false;

  void _toggleMic() {
    setState(() {
      isMicMuted = !isMicMuted;
    });
  }

  void _toggleCamera() {
    setState(() {
      isCameraOff = !isCameraOff;
    });
  }

  void _endCall() {
    // Volta para a tela anterior
    if (context.canPop()) {
      context.pop();
    } else {
      // Se não houver tela anterior, volta para a home
      context.go('/home_paciente');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Colors.grey.shade900,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, color: Colors.white54, size: 120),
                    SizedBox(height: 8),
                    Text(
                      'A aguardar pelo profissional...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 50,
            right: 20,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white30, width: 2),
              ),
              child: Center(
                child: Icon(
                  isCameraOff ? Icons.videocam_off : Icons.videocam,
                  color: Colors.white70,
                  size: 40,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'mic_button_paciente',
                  onPressed: _toggleMic,
                  backgroundColor: isMicMuted ? Colors.white : Colors.grey.shade800,
                  child: Icon(
                    isMicMuted ? Icons.mic_off : Icons.mic,
                    color: isMicMuted ? Colors.black : Colors.white,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'end_call_button_paciente',
                  onPressed: _endCall,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
                FloatingActionButton(
                  heroTag: 'camera_button_paciente',
                  onPressed: _toggleCamera,
                  backgroundColor: isCameraOff ? Colors.white : Colors.grey.shade800,
                  child: Icon(
                    isCameraOff ? Icons.videocam_off : Icons.videocam,
                    color: isCameraOff ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}