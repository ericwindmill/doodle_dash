class Difficulty {
  final double minDistance;
  final double maxDistance;
  final double jumpSpeed;

  const Difficulty(
      {required this.minDistance,
      required this.maxDistance,
      required this.jumpSpeed});
}

// Configurations for different levels of difficulty,
//the higher level the further away Dash may need to jump. Since
// gravity is constant, jumpSpeed needs to accomodate for further distance.
const Map<int, Difficulty> levels = {
  1: Difficulty(minDistance: 200, maxDistance: 300, jumpSpeed: 600),
  2: Difficulty(minDistance: 200, maxDistance: 400, jumpSpeed: 650),
  3: Difficulty(minDistance: 200, maxDistance: 500, jumpSpeed: 700),
  4: Difficulty(minDistance: 200, maxDistance: 600, jumpSpeed: 750),
  5: Difficulty(minDistance: 200, maxDistance: 700, jumpSpeed: 800),
};
