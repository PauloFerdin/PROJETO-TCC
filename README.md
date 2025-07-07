Sistema de Gestão de Saúde - VidaPlus
📖 Sobre o Projeto

VidaPlus é um protótipo funcional de um Sistema de Gestão de Saúde, desenvolvido como parte do Projeto de Conclusão de Curso em Análise e Desenvolvimento de Sistemas. A aplicação consiste numa API RESTful robusta (Back-end) construída com Spring Boot e uma aplicação cliente (Front-end) desenvolvida em Flutter, demonstrando um ecossistema completo para a gestão de pacientes, profissionais de saúde e operações administrativas.

O sistema foi projetado para ser modular, seguro e escalável, abordando os principais desafios da gestão de informações no setor da saúde.
✨ Funcionalidades Principais

O sistema é dividido em três módulos principais, cada um com um conjunto específico de funcionalidades para diferentes perfis de utilizadores.
👤 Módulo do Paciente

    Gestão de Conta: Cadastro, Login e Recuperação de Senha.

    Agendamento: Marcação e cancelamento de consultas.

    Visualização de Dados: Acesso a um dashboard com a próxima consulta, lista de agendamentos futuros e histórico clínico completo.

    Gestão de Exames: Visualização de exames solicitados e upload de ficheiros de resultados (PDF, Imagens).

    Telemedicina: Interface para participação em teleconsultas.

    Notificações: Sistema para receber alertas e lembretes.

🩺 Módulo do Profissional de Saúde

    Gestão de Conta: Cadastro (associado a uma especialidade), Login e Edição de Perfil.

    Gestão de Agenda: Visualização de próximas consultas de forma organizada.

    Gestão de Pacientes: Acesso à lista de todos os seus pacientes e ao histórico clínico detalhado de cada um.

    Prontuário Eletrónico: Adição e consulta de anotações clínicas por consulta.

    Solicitação de Exames: Capacidade de solicitar novos exames para um paciente.

🏥 Módulo Administrativo

    Controlo de Acesso: Login com perfil de ADMIN.

    Gestão de Leitos: Visualização e atualização em tempo real do status dos leitos (Livre, Ocupado, etc.).

    Gestão de Suprimentos: Sistema de inventário para controlar o estoque de materiais hospitalares.

    Relatórios: Geração de relatórios financeiros com filtros por período, consolidando o faturamento de consultas e exames.

🛠️ Tecnologias Utilizadas
Back-end

    Linguagem: Java 21

    Framework: Spring Boot 3.3.1

    Segurança: Spring Security, JSON Web Tokens (JWT)

    Persistência de Dados: Spring Data JPA, Hibernate

    Base de Dados: MySQL

    Build Tool: Apache Maven

Front-end

    Framework: Flutter

    Gestão de Estado: Provider / ChangeNotifier

    Roteamento: GoRouter

    Comunicação HTTP: Pacote http


👨‍💻 Autor

Paulo Cesar Maximiano Ferdin

    RU: 4291771

    Curso: Análise e Desenvolvimento de Sistemas

Um projeto desenvolvido com dedicação como parte dos requisitos para a conclusão do curso.
