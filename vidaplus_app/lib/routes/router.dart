import 'package:go_router/go_router.dart';
import 'package:vidaplus_app/pages/notificacao_page.dart';
import 'package:vidaplus_app/services/auth_manager.dart';
import '../models/consulta.dart';
import '../models/especialidade.dart';
import '../models/exame.dart';
import '../models/paciente.dart';
import '../models/profissional.dart';
import '../pages/admin/admin_home_page.dart';
import '../pages/admin/gestao_leitos_page.dart';
import '../pages/admin/gestao_suprimentos_page.dart';
import '../pages/admin/relatorios_page.dart';
import '../pages/agendamento_consulta_page.dart';
import '../pages/confirmacao_agendamento_page.dart';
import '../pages/dados_pessoais_page.dart';
import '../pages/editar_dados_page.dart';
import '../pages/forgot_password_page.dart';
import '../pages/paciente/detalhes_consulta_passada_page.dart';
import '../pages/paciente/detalhes_exame_page.dart';
import '../pages/paciente/detalhes_paciente_page.dart';
import '../pages/paciente/historico_clinico_page.dart';
import '../pages/login_page.dart';
import '../pages/paciente/meus_exames.dart';
import '../pages/paciente/minhas_consultas_page.dart';
import '../pages/paciente/teleconsulta_page.dart';
import '../pages/profissional/anotacoes_consulta_page.dart';
import '../pages/profissional/detalhes_cosulta_page.dart';
import '../pages/paciente/selecao_data_hora_page.dart';
import '../pages/paciente/selecao_profissional_page.dart';
import '../pages/profissional/editar_perfil_profissional_page.dart';
import '../pages/profissional/reset_password_page.dart';
import '../pages/splash_page.dart';
import '../pages/register_page.dart';
import '../pages/profissional/home_page_profissional.dart';
import '../pages/paciente/home_page_paciente.dart';
import '../pages/teleconsulta_page.dart';


final router = GoRouter(
  refreshListenable: AuthManager.instance,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home_profissional',
      builder: (context, state) => const HomePageProfissional(),
    ),
    GoRoute(
      path: '/home_paciente',
      builder: (context, state) => const HomePagePaciente(),
    ),
    GoRoute(
      path: '/agendar_consulta',
      builder: (context, state) => const AgendamentoConsultaPage(),
    ),
    GoRoute(
      path: '/historico_clinico',
      builder: (context, state) => const HistoricoClinicoPage(),
    ),
    GoRoute(
      path: '/dados_pessoais',
      builder: (context, state) => const DadosPessoaisPage(),
    ),
    GoRoute(
      path: '/teleconsulta',
      builder: (context, state) => const TeleconsultaPage(),
    ),
    GoRoute(
      path: '/editar_dados',
      builder: (context, state) => const EditarDadosPage(),
    ),
    GoRoute(
      path: '/selecao_profissional',
      builder: (context, state) {
        final especialidade = state.extra as Especialidade;
        return SelecaoProfissionalPage(especialidade: especialidade);
      },
    ),
    GoRoute(
      path: '/selecao_data_hora',
      builder: (context, state) {
        final profissional = state.extra as Profissional;
        return SelecaoDataHoraPage(profissional: profissional);
      },
    ),
    GoRoute(
      path: '/confirmacao_agendamento',
      builder: (context, state) {
        final dados = state.extra as Map<String, dynamic>;
        return ConfirmacaoAgendamentoPage(dados: dados);
      },
    ),
    GoRoute(
      path: '/detalhes_consulta_profissional',
      builder: (context, state) {
        final consulta = state.extra as Consulta;
        return DetalhesConsultaPage(consulta: consulta);
      },
    ),
    GoRoute(
      path: '/teleconsulta_profissional',
      builder: (context, state) => const TeleconsultaPage(),
    ),
    GoRoute(
      path: '/minhas_consultas',
      builder: (context, state) => const MinhasConsultasPage(),
    ),
    GoRoute(
      path: '/teleconsulta_paciente',
      builder: (context, state) => const TeleconsultaPacientePage(),
    ),
    GoRoute(
      path: '/detalhes_paciente',
      builder: (context, state) {
        final paciente = state.extra as Paciente;
        return DetalhesPacientePage(paciente: paciente);
      },
    ),
    GoRoute(
      path: '/anotacoes_consulta',
      builder: (context, state) {
        final consulta = state.extra as Consulta;
        return AnotacoesConsultaPage(consulta: consulta);
      },
    ),
    GoRoute(
      path: '/editar_perfil_profissional',
      builder: (context, state) => const EditarPerfilProfissionalPage(),
    ),
    GoRoute(
      path: '/detalhes_consulta_paciente',
      builder: (context, state) {
        final consulta = state.extra as Consulta;
        return DetalhesConsultaPassadaPage(consulta: consulta);
      },
    ),
    GoRoute(
        path: '/notificacoes',
        builder: (context, state) => const NotificacoesPage(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) {
        final email = state.extra as String;
        return ResetPasswordPage(email: email);
      },
    ),
    GoRoute(
      path: '/meus_exames',
      builder: (context, state) => const MeusExamesPage(),
    ),
    GoRoute(
      path: '/detalhes_exame',
      builder: (context, state) {
        final exame = state.extra as Exame;
        return DetalhesExamePage(exame: exame);
      },
    ),
    GoRoute(
      path: '/home_admin',
      builder: (context, state) => const AdminHomePage(),
    ),
    GoRoute(
      path: '/gestao_leitos',
      builder: (context, state) => const GestaoLeitosPage(),
    ),
    GoRoute(
      path: '/gestao_suprimentos',
      builder: (context, state) => const GestaoSuprimentosPage(),
    ),
    GoRoute(
      path: '/relatorios',
      builder: (context, state) => const RelatoriosPage(),
    ),
  ],
  redirect: (context, state) {
    final authManager = AuthManager.instance;
    final isLoggedIn = authManager.isLoggedIn;
    final location = state.matchedLocation;

    final publicRoutes = ['/login', '/register', '/forgot_password', '/reset_password'];

    // Se o utilizador não está logado e tenta aceder a uma rota que não é pública
    if (!isLoggedIn && !publicRoutes.contains(location)) {
      return '/login'; // Redireciona para o login
    }

    // Se o utilizador está logado e tenta aceder a uma rota pública
    if (isLoggedIn && publicRoutes.contains(location)) {
      // Redireciona para a home correta com base no perfil
      if (authManager.userRole == 'PACIENTE') return '/home_paciente';
      if (authManager.userRole == 'PROFISSIONAL') return '/home_profissional';
      if (authManager.userRole == 'ADMIN') return '/home_admin';
      return '/login'; // Fallback de segurança
    }

    return null; // Nenhuma regra de redirecionamento se aplica, permite a navegação
  },
);