import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/consulta.dart';
import '../models/especialidade.dart';
import '../models/exame.dart';
import '../models/leito.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/notificacao.dart';
import '../models/paciente.dart';
import '../models/profissional.dart';
import '../models/register_request.dart';
import '../models/relatorio_financeiro.dart';
import '../models/status_leito.dart';
import '../models/suprimento.dart';
import 'auth_manager.dart';



const bool usandoEmuladorAndroid = false;

class AuthService {
  final String baseUrl = usandoEmuladorAndroid
      ? 'http://10.0.2.2:8080'
      : 'http://192.168.0.93:8080';

  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Falha no login (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Não foi possível conectar ao servidor. Verifique sua conexão.');
    }
  }

  Future<Paciente> atualizarDadosPaciente(String pacienteId,
      String token,
      Map<String, String> dados,) async {
    final url = Uri.parse('$baseUrl/api/pacientes/update/$pacienteId');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dados),
      );

      if (response.statusCode == 200) {
        return Paciente.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception(
            'Falha ao atualizar dados (${response.statusCode}): ${response
                .body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao atualizar dados: $e');
    }
  }

  Future<void> register(RegisterRequest request) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Falha no registro (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao registrar: $e');
    }
  }

  Future<List<Especialidade>> getEspecialidades() async {
    final url = Uri.parse('$baseUrl/api/especialidades');
    try {
      final response = await http.get(url); // Não envia token
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Especialidade.fromJson(json)).toList();
      } else {
        throw Exception(
            'Falha ao buscar especialidades (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar especialidades: $e');
    }
  }

  Map<String, String> _getAuthHeaders() {
    final token = AuthManager.instance.token;

    print("--- DEBUG FLUTTER: AuthService tentando obter token ---");
    print("Valor do token encontrado: $token");
    print("-----------------------------------------------------");

    if (token == null) {
      throw Exception('Usuário não autenticado. Token não encontrado.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Profissional>> getProfissionaisPorEspecialidade(
      String especialidadeId) async {
    final url = Uri.parse(
        '$baseUrl/api/profissionais?especialidadeId=$especialidadeId');
    // ------------------------------------

    try {
      final response = await http.get(url, headers: _getAuthHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Profissional.fromJson(json)).toList();
      } else {
        throw Exception(
            'Falha ao buscar profissionais (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar profissionais: $e');
    }
  }

  Future<List<String>> getHorariosDisponiveis(String profissionalId,
      String data) async {
    final url = Uri.parse(
        '$baseUrl/api/agendas/horarios-disponiveis?profissionalId=$profissionalId&data=$data');
    try {
      final response = await http.get(url, headers: _getAuthHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.cast<String>();
      } else {
        throw Exception('Falha ao buscar horários (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar horários: $e');
    }
  }

  Future<List<Paciente>> getMeusPacientes() async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/profissionais/meus-pacientes');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Paciente.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar pacientes (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar pacientes: $e');
    }
  }

  Future<void> agendarConsulta({
    required String pacienteId,
    required String profissionalId,
    required String data,
    required String hora,
  }) async {
    final token = AuthManager.instance.token;

    if (token == null) {
      throw Exception('Token não encontrado para agendar consulta.');
    }

    final url = Uri.parse('$baseUrl/api/consultas');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };


    print("--- DEBUG FLUTTER: PREPARANDO REQUISIÇÃO ---");
    print("URL: $url");
    print("HEADERS: $headers");
    print("-----------------------------------------");


    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'pacienteId': pacienteId,
          'profissionalId': profissionalId,
          'dataConsulta': data,
          'horaConsulta': hora,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Falha ao agendar consulta (${response.statusCode}): ${response
                .body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Consulta>> getMinhasConsultas() async {
    final token = AuthManager.instance.token;
    if (token == null) {
      throw Exception('Usuário não autenticado.');
    }

    final url = Uri.parse('$baseUrl/api/consultas/minhas-consultas');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Consulta.fromJson(json)).toList();
      } else {
        throw Exception(
            'Falha ao buscar minhas consultas (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar minhas consultas: $e');
    }
  }

  Future<List<Consulta>> getMinhaAgenda(String data) async {
    final url = Uri.parse('$baseUrl/api/agendas/minha-agenda?data=$data');
    try {
      final response = await http.get(url, headers: _getAuthHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Consulta.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar a agenda (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar a agenda: $e');
    }
  }

  Future<List<Consulta>> getConsultasDoPaciente(String pacienteId) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/consultas/por-paciente/$pacienteId');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Consulta.fromJson(json)).toList();
      } else {
        throw Exception(
            'Falha ao buscar histórico do paciente (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar histórico: $e');
    }
  }

  Future<Consulta> salvarAnotacoes(String consultaId, String anotacoes) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/consultas/$consultaId/anotacoes');

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({'anotacoes': anotacoes}),
      );

      if (response.statusCode == 200) {
        return Consulta.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Falha ao salvar anotações (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao salvar anotações: $e');
    }
  }

  Future<Consulta> cancelarConsulta(String consultaId) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/consultas/$consultaId/cancelar');

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return Consulta.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception(
            'Falha ao cancelar a consulta (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao cancelar a consulta: $e');
    }
  }

  Future<Profissional> atualizarPerfilProfissional(
      {required String registro}) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/profissionais/meu-perfil');

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({'registro': registro}),
      );

      if (response.statusCode == 200) {
        return Profissional.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Falha ao atualizar perfil (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao atualizar perfil: $e');
    }
  }

  Future<List<Notificacao>> getMinhasNotificacoes() async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/notificacoes/minhas');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(
            utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Notificacao.fromJson(json)).toList();
      } else {
        throw Exception(
            'Falha ao buscar notificações (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar notificações: $e');
    }
  }

  Future<void> marcarNotificacaoComoLida(String notificacaoId) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse(
        '$baseUrl/api/notificacoes/$notificacaoId/marcar-como-lida');

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode != 200) {
        throw Exception(
            'Falha ao marcar notificação como lida (${response.statusCode})');
      }
      // Se a resposta for 200 OK, a operação foi bem-sucedida.
    } catch (e) {
      throw Exception('Erro de conexão ao marcar notificação: $e');
    }
  }

    Future<void> forgotPassword(String email) async {
      final url = Uri.parse('$baseUrl/api/auth/forgot-password');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        );
        // O backend sempre retorna 200 OK para não revelar se um email existe.
        // A lógica de erro, se necessária, seria tratada de outra forma.
        if (response.statusCode != 200) {
          throw Exception('Falha ao solicitar o código de redefinição.');
        }
      } catch (e) {
        throw Exception('Erro de conexão: $e');
      }
    }

  Future<void> resetPassword(String token, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'password': password}),
      );

      if (response.statusCode != 200) {
        // O backend retorna uma mensagem de erro no corpo em caso de falha
        throw Exception('Falha ao redefinir a senha: ${response.body}');
      }
      // Se chegou aqui, a senha foi redefinida com sucesso.
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<List<Exame>> getMeusExames() async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/exames/meus-exames');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Exame.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar exames (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar exames: $e');
    }
  }

  Future<void> solicitarExame({
    required String nomeExame,
    required String pacienteId,
  }) async {
    // Pega os cabeçalhos com o token
    final headers = _getAuthHeaders();

    // GARANTA QUE ESTA URL ESTÁ EXATAMENTE ASSIM:
    final url = Uri.parse('$baseUrl/api/exames');

    try {
      // Garanta que o método é http.post
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'nomeExame': nomeExame,
          'pacienteId': pacienteId,
        }),
      );

      // O status de sucesso para criação é 201
      if (response.statusCode != 201) {
        throw Exception('Falha ao solicitar exame (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      // Retransmite o erro para a UI poder mostrá-lo
      rethrow;
    }
  }

  Future<Exame> adicionarResultadoExame({
    required String exameId,
    required String resultado,
    String? urlAnexo, // Opcional
    required String dataRealizacao, // "YYYY-MM-DD"
  }) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/exames/$exameId/resultado');

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({
          'resultado': resultado,
          'urlAnexo': urlAnexo,
          'dataRealizacao': dataRealizacao,
        }),
      );

      if (response.statusCode == 200) {
        return Exame.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Falha ao adicionar resultado (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao adicionar resultado: $e');
    }
  }

  Future<List<Leito>> getLeitos() async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/leitos');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Leito.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar leitos (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar leitos: $e');
    }
  }

  Future<List<Suprimento>> getSuprimentos() async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/suprimentos');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Suprimento.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar suprimentos (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar suprimentos: $e');
    }
  }

  Future<RelatorioFinanceiro> getRelatorioFinanceiro(String dataInicio, String dataFim) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/relatorios/financeiro?dataInicio=$dataInicio&dataFim=$dataFim');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return RelatorioFinanceiro.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Falha ao buscar relatório financeiro (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar relatório: $e');
    }
  }

  Future<List<Consulta>> getProximasConsultasProfissional() async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/consultas/minha-agenda/proximas');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => Consulta.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar próximas consultas (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao buscar próximas consultas: $e');
    }
  }

  Future<Suprimento> criarSuprimento({
    required String nome,
    required String descricao,
    required int quantidadeInicial,
  }) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/suprimentos');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'nome': nome,
          'descricao': descricao,
          'quantidadeInicial': quantidadeInicial,
        }),
      );
      if (response.statusCode == 201) {
        return Suprimento.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Falha ao criar suprimento (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao criar suprimento: $e');
    }
  }

  Future<Suprimento> atualizarEstoque(String suprimentoId, int quantidade) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/suprimentos/$suprimentoId/estoque');

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({'quantidade': quantidade}),
      );
      if (response.statusCode == 200) {
        return Suprimento.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Falha ao atualizar estoque (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao atualizar estoque: $e');
    }
  }


  Future<Leito> atualizarStatusLeito(String leitoId, StatusLeito novoStatus) async {
    final headers = _getAuthHeaders();
    final url = Uri.parse('$baseUrl/api/leitos/$leitoId/status');

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({'status': novoStatus.name}),
      );
      if (response.statusCode == 200) {
        return Leito.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Falha ao atualizar status do leito (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao atualizar status: $e');
    }
  }

  Future<void> uploadResultadoExame({
    required String exameId,
    required String resultado,
    required Uint8List fileBytes,
    required String dataRealizacao, // "YYYY-MM-DD"

    required String fileName,
  }) async {
    final token = AuthManager.instance.token;
    if (token == null) throw Exception('Utilizador não autenticado.');

    final url = Uri.parse('$baseUrl/api/exames/$exameId/upload-resultado');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['resultado'] = resultado;
    request.fields['dataRealizacao'] = dataRealizacao;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
        contentType: MediaType('application', 'octet-stream'),
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode != 200) {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Falha ao fazer upload do resultado (${response.statusCode}): $responseBody');
      }
    } catch (e) {
      throw Exception('Erro de conexão ao fazer upload: $e');
    }
  }


  Future<Consulta?> getProximaConsulta() async {
        final headers = _getAuthHeaders();
        final url = Uri.parse('$baseUrl/api/consultas/proxima');

        try {
          final response = await http.get(url, headers: headers);
          if (response.statusCode == 200) {
            return Consulta.fromJson(
                jsonDecode(utf8.decode(response.bodyBytes)));
          }
          else if (response.statusCode == 404) {
            return null;
          }
          else {
            throw Exception(
                'Falha ao buscar próxima consulta (${response.statusCode})');
          }
        } catch (e) {
          throw Exception('Erro de conexão ao buscar próxima consulta: $e');
        }
      }
    }