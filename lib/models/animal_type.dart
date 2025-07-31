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
}
