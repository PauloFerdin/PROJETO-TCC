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

  void _toggleMic() => setState(() => isMicMuted = !isMicMuted);
  void _toggleCamera() => setState(() => isCameraOff = !isCameraOff);
  void _endCall() => context.pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          Center(
            child: Container(
              color: Colors.grey.shade900,
              child: const Center(child: Icon(Icons.person, color: Colors.white54, size: 120)),
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
              child: Center(child: Icon(isCameraOff ? Icons.videocam_off : Icons.videocam, color: Colors.white70, size: 40)),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(heroTag: 'mic', onPressed: _toggleMic, backgroundColor: isMicMuted ? Colors.white : Colors.grey.shade800, child: Icon(isMicMuted ? Icons.mic_off : Icons.mic, color: isMicMuted ? Colors.black : Colors.white)),
                FloatingActionButton(heroTag: 'end', onPressed: _endCall, backgroundColor: Colors.red, child: const Icon(Icons.call_end, color: Colors.white)),
                FloatingActionButton(heroTag: 'cam', onPressed: _toggleCamera, backgroundColor: isCameraOff ? Colors.white : Colors.grey.shade800, child: Icon(isCameraOff ? Icons.videocam_off : Icons.videocam, color: isCameraOff ? Colors.black : Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
