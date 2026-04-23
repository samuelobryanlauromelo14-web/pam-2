import 'package:flutter/material.dart';
import 'models/produto.dart';

class CarrinhoScreen extends StatelessWidget {
  // Recebe a lista de produtos que foram adicionados ao carrinho
  final List<Produto> carrinho;

  const CarrinhoScreen({super.key, required this.carrinho});

  @override
  Widget build(BuildContext context) {
    // Calcula o total geral somando o subtotal de cada produto
    double total = carrinho.fold(0, (soma, p) => soma + p.subtotal);

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Carrinho 🛒')),
      body: carrinho.isEmpty
          // Se o carrinho estiver vazio mostra mensagem
          ? const Center(
              child: Text(
                'Seu carrinho está vazio!',
                style: TextStyle(fontSize: 18),
              ),
            )
          // Se tiver produtos, mostra a lista
          : Column(
              children: [
                // Lista de produtos no carrinho
                Expanded(
                  child: ListView.builder(
                    itemCount: carrinho.length,
                    itemBuilder: (context, index) {
                      final produto = carrinho[index];
                      return ListTile(
                        // Emoji do produto
                        leading: Text(
                          produto.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                        // Nome do produto
                        title: Text(produto.nome),
                        // Quantidade e preço unitário
                        subtitle: Text(
                          '${produto.quantidade}x R\$ ${produto.preco.toStringAsFixed(2)}',
                        ),
                        // Subtotal do produto
                        trailing: Text(
                          'R\$ ${produto.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Rodapé com o total
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'R\$ ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}