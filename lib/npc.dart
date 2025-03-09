import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class NPC extends BodyComponent {
  Vector2 startPosition;
  late SpriteComponent sprite;
  double speed = 100.0;

  NPC({required this.startPosition});

  @override
  Future<void> onLoad() async {
    sprite = SpriteComponent()
      ..sprite = await gameRef.loadSprite('npc_character.png')
      ..size = Vector2(50, 50)
      ..position = startPosition;
    add(sprite);
  }

  void moveTo(Vector2 target) {
    final direction = (target - position).normalized();
    position.add(direction * speed * 0.1);
  }
}
