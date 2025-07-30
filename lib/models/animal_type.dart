enum AnimalType {
  elephant,
  lion,
  tiger,
  leopard,
  wolf,
  dog,
  cat,
  rat;

  /// Returns the rank of the animal (1 = strongest, 8 = weakest)
  int get rank {
    switch (this) {
      case AnimalType.elephant:
        return 1;
      case AnimalType.lion:
        return 2;
      case AnimalType.tiger:
        return 3;
      case AnimalType.leopard:
        return 4;
      case AnimalType.wolf:
        return 5;
      case AnimalType.dog:
        return 6;
      case AnimalType.cat:
        return 7;
      case AnimalType.rat:
        return 8;
    }
  }

  /// Returns the name of the animal in Chinese
  String get chineseName {
    switch (this) {
      case AnimalType.elephant:
        return '象';
      case AnimalType.lion:
        return '獅';
      case AnimalType.tiger:
        return '虎';
      case AnimalType.leopard:
        return '豹';
      case AnimalType.wolf:
        return '狼';
      case AnimalType.dog:
        return '狗';
      case AnimalType.cat:
        return '貓';
      case AnimalType.rat:
        return '鼠';
    }
  }

  /// Returns the name of the animal in English
  String get englishName {
    switch (this) {
      case AnimalType.elephant:
        return 'Elephant';
      case AnimalType.lion:
        return 'Lion';
      case AnimalType.tiger:
        return 'Tiger';
      case AnimalType.leopard:
        return 'Leopard';
      case AnimalType.wolf:
        return 'Wolf';
      case AnimalType.dog:
        return 'Dog';
      case AnimalType.cat:
        return 'Cat';
      case AnimalType.rat:
        return 'Rat';
    }
  }
}
