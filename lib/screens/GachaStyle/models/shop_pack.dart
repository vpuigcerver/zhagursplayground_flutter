class ShopPack {
  final String title;
  final String image;
  final int coins;
  final int tickets;
  final int price; // en monedas reales del juego (coins gastables)

  ShopPack({
    required this.title,
    required this.image,
    this.coins = 0,
    this.tickets = 0,
    required this.price,
  });
}

final List<ShopPack> shopPacks = [
  ShopPack(
    title: "Paquete de inicio",
    image: "assets/images/gacha/shop/starter.png",
    coins: 500,
    tickets: 1,
    price: 0, // gratis o regalo diario
  ),
  ShopPack(
    title: "Pack de 5 Tickets",
    image: "assets/images/gacha/shop/tickets.png",
    tickets: 5,
    price: 500,
  ),
  ShopPack(
    title: "Mega Pack",
    image: "assets/images/gacha/shop/mega.png",
    coins: 1000,
    tickets: 10,
    price: 1200,
  ),
];