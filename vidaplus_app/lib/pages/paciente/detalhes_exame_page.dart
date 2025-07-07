import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vidaplus_app/models/exame.dart';
import 'package:vidaplus_app/services/auth_service.dart';

class DetalhesExamePage extends StatefulWidget {
  final Exame exame;
  const DetalhesExamePage({super.key, required this.exame});

  @override
  State<DetalhesExamePage> createState() => _DetalhesExamePageState();
}

class _DetalhesExamePageState extends State<DetalhesExamePage> {
  final _formKey = GlobalKey<FormState>();
  final _resultadoController = TextEditingController();
  final _apiService = AuthService();
  DateTime? _dataRealizacao;
  PlatformFile? _selectedFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _resultadoController.text = widget.exame.resultado ?? '';
    _dataRealizacao = widget.exame.dataRealizacao;
  }

  @override
  void dispose() {
    _resultadoController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
      withData: true, // Crucial para a web, para carregar os bytes em memória
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _salvarResultado() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataRealizacao == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, selecione a data.')));
      return;
    }
    if (_selectedFile == null || _selectedFile!.bytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, anexe o ficheiro do resultado.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiService.uploadResultadoExame(
        exameId: widget.exame.id,
        resultado: _resultadoController.text,
        dataRealizacao: DateFormat('yyyy-MM-dd').format(_dataRealizacao!),
        fileBytes: _selectedFile!.bytes!, // Usamos os bytes diretamente
        fileName: _selectedFile!.name,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resultado enviado com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.exame.nomeExame)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Solicitado por: Dr(a). ${widget.exame.nomeProfissionalSolicitante}'),
              Text('Data da Solicitação: ${DateFormat('d/MM/y').format(widget.exame.dataSolicitacao)}'),
              const Divider(height: 32),

              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data de Realização do Exame',
                  hintText: _dataRealizacao == null ? 'Selecione uma data' : DateFormat('d/MM/y').format(_dataRealizacao!),
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: _dataRealizacao ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
                  if (picked != null) setState(() => _dataRealizacao = picked);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _resultadoController,
                decoration: const InputDecoration(labelText: 'Resultado / Laudo', border: OutlineInputBorder()),
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                icon: const Icon(Icons.attach_file),
                label: Text(_selectedFile == null ? 'Anexar Ficheiro' : 'Ficheiro Selecionado'),
                onPressed: _pickFile,
              ),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Ficheiro: ${_selectedFile!.name}', style: const TextStyle(color: Colors.grey)),
                ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarResultado,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Enviar Resultado'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}