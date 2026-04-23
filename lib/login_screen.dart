import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'home_screen.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instancia o serviço que criamos (o que finge ser o servidor)
  final _authService = AuthService();

  // Controllers para pegar o texto digitado
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Variável que controla se mostra o círculo girando ou o botão
  bool _carregando = false;

  // Variável que controla se a senha está visível ou não
  bool _verSenha = false;

  // Função chamada ao clicar em "Entrar"
  void _executarLogin() async {
    // 1. Liga o círculo girando (redesenha a tela)
    setState(() => _carregando = true);

    // 2. Chama o serviço e espera a resposta (2 segundos simulados)
    String? token = await _authService.login(
      _emailController.text,
      _senhaController.text,
    );

    // 3. Desliga o círculo girando (redesenha a tela)
    setState(() => _carregando = false);

    if (token != null) {
      // LOGIN CERTO: salva o token e vai pra Home
      await _salvarSessao(token);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // LOGIN ERRADO: mostra mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos')),
      );
    }
  }

  // Função que grava o token no "caderninho" do celular
  Future<void> _salvarSessao(String token) async {
    // Abre a memória permanente do celular
    final prefs = await SharedPreferences.getInstance();
    // Salva o token com a chave 'meu_token_seguro'
    await prefs.setString('meu_token_seguro', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de e-mail
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de senha com olhinho
            TextField(
              controller: _senhaController,
              obscureText: !_verSenha, // Se _verSenha for true, mostra a senha
              decoration: InputDecoration(
                labelText: 'Senha',
                border: const OutlineInputBorder(),
                // Ícone do olhinho no final do campo
                suffixIcon: IconButton(
                  icon: Icon(
                    _verSenha ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    // Alterna entre mostrar e esconder a senha
                    setState(() => _verSenha = !_verSenha);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão de entrar - muda entre círculo girando e texto
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _carregando ? null : _executarLogin,
                child: _carregando
                    // Se estiver carregando, mostra o círculo
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    // Se não, mostra o texto normal
                    : const Text('Entrar'),
              ),
            ),
            const SizedBox(height: 16),

            // Link para ir para o cadastro
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CadastroScreen()),
                );
              },
              child: const Text('Não tem conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}