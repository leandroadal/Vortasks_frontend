class Level {
  int currentLevel = 1;
  int xp = 0; // XP acumulada
  int xpToNextLevel = 1000;

  void addXP(int gainedXP) {
    xp += gainedXP; // Adiciona a XP ganha

    // Verifica se a XP acumulada é suficiente para passar de nível
    if (xp >= xpToNextLevel) {
      levelUp();
    }
  }

  void levelUp() {
    currentLevel++; // Incrementa o nível
    xp = 0;
    xpToNextLevel += 500;
  }
}
