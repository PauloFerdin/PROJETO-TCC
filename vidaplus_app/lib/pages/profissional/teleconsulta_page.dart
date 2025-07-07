import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeleconsultaPage extends StatefulWidget {
  const TeleconsultaPage({super.key});

  @override
  State<TeleconsultaPage> createState() => _TeleconsultaPageState();
}

class _TeleconsultaPageState extends State<TeleconsultaPage> {
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
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          // Placeholder para o vídeo da outra pessoa (ecrã inteiro)
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
                      'Aguardando conexão...',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Placeholder para o vídeo local (canto superior direito)
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

          // Barra de controlos na parte inferior
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão do Microfone
                FloatingActionButton(
                  heroTag: 'mic_button',
                  onPressed: _toggleMic,
                  backgroundColor: isMicMuted ? Colors.white : Colors.grey.shade800,
                  child: Icon(
                    isMicMuted ? Icons.mic_off : Icons.mic,
                    color: isMicMuted ? Colors.black : Colors.white,
                  ),
                ),
                // Botão de Terminar Chamada
                FloatingActionButton(
                  heroTag: 'end_call_button',
                  onPressed: _endCall,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
                // Botão da Câmara
                FloatingActionButton(
                  heroTag: 'camera_button',
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