class Produto {
  final String nome;      // Nome do produto
  final double preco;     // Preço do produto
  final String emoji;     // Emoji pra deixar bonitinho 😄
  int quantidade;         // Quantidade no carrinho

  Produto({
    required this.nome,
    required this.preco,
    required this.emoji,
    this.quantidade = 0,  // Começa com zero no carrinho
  });

  // Calcula o subtotal desse produto (preço x quantidade)
  double get subtotal => preco * quantidade;
}