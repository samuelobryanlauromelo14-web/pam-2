class AuthService {
  // Email e senha fixos no código
  Future<String?> login(String email, String senha) async {
    // Simula 2 segundos de espera (como se fosse internet de verdade)
    await Future.delayed(const Duration(seconds: 2));

    // Verifica se email e senha estão certos
    if (email == "samuel@gmail.com" && senha == "123456") {
      return "Login feito com sucesso"; // Retorna o token
    }

    return null; // Login errado
  }
}