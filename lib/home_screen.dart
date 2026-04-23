import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'carrinho_screen.dart';
import 'models/produto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de produtos disponíveis na loja
  final List<Produto> _produtos = [
    Produto(nome: 'Pizza', preco: 45.90, emoji: '🍕'),
    Produto(nome: 'Hamburguer', preco: 32.50, emoji: '🍔'),
    Produto(nome: 'Sushi', preco: 59.90, emoji: '🍣'),
    Produto(nome: 'Sorvete', preco: 15.00, emoji: '🍦'),
    Produto(nome: 'Refrigerante', preco: 8.00, emoji: '🥤'),
    Produto(nome: 'Batata Frita', preco: 18.00, emoji: '🍟'),
  ];

  // Logout - apaga o token e volta pro login
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('meu_token_seguro');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Adiciona produto ao carrinho
  void _adicionarAoCarrinho(Produto produto) {
    setState(() => produto.quantidade++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${produto.emoji} ${produto.nome} adicionado!')),
    );
  }

  // Remove produto do carrinho
  void _removerDoCarrinho(Produto produto) {
    if (produto.quantidade > 0) {
      setState(() => produto.quantidade--);
    }
  }

  // Pega só os produtos que foram adicionados ao carrinho
  List<Produto> get _carrinho =>
      _produtos.where((p) => p.quantidade > 0).toList();

  // Conta quantos itens tem no carrinho no total
  int get _totalItens =>
      _produtos.fold(0, (soma, p) => soma + p.quantidade);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Produtos'),
        actions: [
          // Botão do carrinho com contador
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarrinhoScreen(carrinho: _carrinho),
                    ),
                  );
                },
              ),
              // Bolinha vermelha com a quantidade
              if (_totalItens > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_totalItens',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Botão de logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final produto = _produtos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              // Emoji do produto
              leading: Text(
                produto.emoji,
                style: const TextStyle(fontSize: 36),
              ),
              // Nome do produto
              title: Text(
                produto.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // Preço
              subtitle: Text(
                'R\$ ${produto.preco.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
              // Controles de quantidade
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _removerDoCarrinho(produto),
                  ),
                  Text(
                    '${produto.quantidade}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _adicionarAoCarrinho(produto),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}