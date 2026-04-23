import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_screen.dart';

// O main agora é async porque precisa ler a memória ANTES de abrir o app
void main() async {
  // Garante que a "ponte" entre Flutter e o celular está pronta
  // Necessário sempre que usamos plugins nativos antes do runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Abre o "caderninho" de memória do celular
  final prefs = await SharedPreferences.getInstance();

  // Tenta ler o token que foi salvo no login
  final String? token = prefs.getString('meu_token_seguro');

  // Inicia o app passando true se já tem token, false se não tem
  runApp(MyApp(estaLogado: token != null));
}

class MyApp extends StatelessWidget {
  // Recebe a informação se o usuário já está logado ou não
  final bool estaLogado;
  const MyApp({super.key, required this.estaLogado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      // Se estiver logado vai pra Home, se não vai pro Login
      // Isso é a Persistência de Sessão!
      home: estaLogado ? const HomeScreen() : const LoginScreen(),
    );
  }
}