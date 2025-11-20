import 'package:flutter/material.dart';

enum ItemType {
  attackBoost('Aumento de Ataque', Icons.arrow_upward, Colors.red),
  hpBoost('Aumento de HP', Icons.favorite, Colors.green),
  coinMultiplier('Multiplicador de Moedas', Icons.monetization_on, Colors.amber);

  final String name;
  final IconData icon;
  final Color color;

  const ItemType(this.name, this.icon, this.color);
}

class Item {
  final String id;
  final ItemType type;
  final String name;
  final String description;
  final int price;
  final int value; 
  final Color color;
  final IconData icon;
  final bool purchased;

  Item({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.price,
    required this.value,
    required this.color,
    required this.icon,
    this.purchased = false,
  });

  Item copyWith({bool? purchased}) {
    return Item(
      id: id,
      type: type,
      name: name,
      description: description,
      price: price,
      value: value,
      color: color,
      icon: icon,
      purchased: purchased ?? this.purchased,
    );
  }
}

class ShopItems {
  static List<Item> get catalog => [
    Item(
      id: 'attack_boost_1',
      type: ItemType.attackBoost,
      name: 'Espada Ferro',
      description: '+1 de Ataque',
      price: 10,
      value: 1,
      color: ItemType.attackBoost.color,
      icon: ItemType.attackBoost.icon,
    ),
    Item(
      id: 'attack_boost_2',
      type: ItemType.attackBoost,
      name: 'Espada Aço',
      description: '+2 de Ataque',
      price: 30,
      value: 2,
      color: ItemType.attackBoost.color,
      icon:  ItemType.attackBoost.icon,
    ),
    Item(
      id: 'attack_boost_3',
      type: ItemType.attackBoost,
      name: 'Espada Mítica',
      description: '+3 de Ataque',
      price: 70,
      value: 3,
      color: ItemType.attackBoost.color,
      icon:  ItemType.attackBoost.icon,
    ),
    Item(
      id: 'hp_boost_1',
      type: ItemType.hpBoost,
      name: 'Poção Vitalidade',
      description: '+5 de HP',
      price: 10,
      value: 5,
      color: ItemType.hpBoost.color,
      icon: ItemType.hpBoost.icon,
    ),
    Item(
      id: 'hp_boost_2',
      type: ItemType.hpBoost,
      name: 'Elixir Vida',
      description: '+10 de HP',
      price: 30,
      value: 10,
      color: ItemType.hpBoost.color,
      icon: ItemType.hpBoost.icon,
    ),
    Item(
      id: 'hp_boost_3',
      type: ItemType.hpBoost,
      name: 'Essência Imortal',
      description: '+20 de HP',
      price: 70,
      value: 20,
      color: ItemType.hpBoost.color,
      icon: ItemType.hpBoost.icon,
    ),
    Item(
      id: 'coin_multiplier_2x',
      type: ItemType.coinMultiplier,
      name: 'Amuleto Dourado',
      description: 'Dobra moedas ganhas',
      price: 50,
      value: 2,
      color: ItemType.coinMultiplier.color,
      icon: ItemType.coinMultiplier.icon,
    ),
  ];
}

