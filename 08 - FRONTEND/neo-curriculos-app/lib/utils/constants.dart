/// Application-wide constants
class AppConstants {
  // String constants
  static const String appName = 'Neo Currículos';
  static const String appDescription = 'Plataforma de envio de currículos';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeSpacing = 24.0;
  static const double mediumSpacing = 16.0;
  static const double smallSpacing = 8.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // LGPD Messages
  static const String lgpdTitle = 'Consentimento de Dados';
  static const String lgpdMessage = '''
Ao continuar, você concorda com nossa Política de Privacidade e
consente no tratamento de seus dados pessoais conforme estabelecido
pela Lei Geral de Proteção de Dados (LGPD).

Seus dados são utilizados exclusivamente para:
• Processar sua candidatura
• Comunicação sobre oportunidades
• Melhorar nossos serviços

Você pode revogar este consentimento a qualquer momento.
''';

  // Error Messages
  static const String errorGeneric = 'Ocorreu um erro. Tente novamente.';
  static const String errorNetwork = 'Erro de conexão. Verifique sua internet.';
  static const String errorTimeout = 'Conexão expirou. Tente novamente.';
  static const String errorUnauthorized = 'Sessão expirada. Faça login novamente.';
  static const String errorNotFound = 'Recurso não encontrado.';
  static const String errorServerError = 'Erro no servidor. Tente mais tarde.';

  // Success Messages
  static const String successLoginTitle = 'Bem-vindo!';
  static const String successLoginMessage = 'Login realizado com sucesso.';
  static const String successRegisterTitle = 'Conta criada!';
  static const String successRegisterMessage = 'Sua conta foi criada com sucesso.';
  static const String successUploadTitle = 'Currículo enviado!';
  static const String successUploadMessage = 'Seu currículo foi enviado com sucesso.';
  static const String successProfileUpdate = 'Perfil atualizado com sucesso.';
  static const String successLogout = 'Desconectado com sucesso.';

  // Button Labels
  static const String buttonContinue = 'Continuar';
  static const String buttonLogin = 'Entrar';
  static const String buttonRegister = 'Criar Conta';
  static const String buttonSignUp = 'Registrar';
  static const String buttonBack = 'Voltar';
  static const String buttonCancel = 'Cancelar';
  static const String buttonSave = 'Salvar';
  static const String buttonDelete = 'Deletar';
  static const String buttonLogout = 'Sair';
  static const String buttonUpload = 'Enviar CV';
  static const String buttonRetry = 'Tentar Novamente';
  static const String buttonOk = 'OK';
  static const String buttonYes = 'Sim';
  static const String buttonNo = 'Não';
  static const String buttonChooseFile = 'Escolher Arquivo';
  static const String buttonViewProfile = 'Ver Perfil';
  static const String buttonEditProfile = 'Editar Perfil';
  static const String buttonAgree = 'Concordo';
  static const String buttonDisagree = 'Não Concordo';

  // Label Constants
  static const String labelEmail = 'Email';
  static const String labelPassword = 'Senha';
  static const String labelPasswordConfirm = 'Confirmar Senha';
  static const String labelName = 'Nome Completo';
  static const String labelProfile = 'Perfil';
  static const String labelCurriculum = 'Currículo';
  static const String labelHistory = 'Histórico';
  static const String labelSettings = 'Configurações';
  static const String labelAccount = 'Conta';
  static const String labelLogout = 'Sair';
  static const String labelNoAccount = 'Não tem conta?';
  static const String labelHaveAccount = 'Já tem conta?';
  static const String labelRegisterHere = 'Registre-se aqui';
  static const String labelLoginHere = 'Entre aqui';
  static const String labelForgotPassword = 'Esqueceu a senha?';
  static const String labelRememberMe = 'Manter-me conectado';

  // Placeholder Constants
  static const String placeholderEmail = 'seu.email@exemplo.com';
  static const String placeholderName = 'João Silva';
  static const String placeholderPassword = '••••••••';

  // File Upload Constants
  static const String fileMaxSize = '10 MB';
  static const String fileFormat = 'PDF';
  static const List<String> fileExtensions = ['.pdf'];

  // Empty State Messages
  static const String emptyNoCurricula = 'Nenhum currículo enviado ainda';
  static const String emptyNoCurriculaMessage = 'Envie seu primeiro currículo para começar';
  static const String emptyNoData = 'Nenhum dado disponível';

  // Dialog Titles
  static const String dialogConfirmDelete = 'Deletar Currículo?';
  static const String dialogConfirmLogout = 'Desconectar?';
  static const String dialogConfirmDeleteAccount = 'Deletar Conta?';
  static const String dialogDeleteAccountWarning = '''
Esta ação é irreversível. Todos os seus dados serão deletados permanentemente.
Tem certeza que deseja continuar?
''';

  // Regex Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$';
  static const String namePattern = r"^[a-zA-ZáàâãéèêíïóôõöúçñÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ\s]{3,100}$";
}

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= tablet;
}

/// Duration constants for animations and delays
class Durations {
  static const int splashDuration = 2000; // ms
  static const int animationDuration = 300; // ms
  static const int loadingMinDuration = 500; // ms
  static const int debounce = 500; // ms
}
