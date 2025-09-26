import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../enum/movement_state_enum.dart';
import '../model/character_avatar.dart';

class CharacterAvatarWidget extends StatefulWidget {
  final CharacterAvatar character;
  final double size;
  final bool showMovementTrail;

  const CharacterAvatarWidget({
    super.key,
    required this.character,
    this.size = 60,
    this.showMovementTrail = false,
  });

  @override
  State<CharacterAvatarWidget> createState() => _CharacterAvatarWidgetState();
}

class _CharacterAvatarWidgetState extends State<CharacterAvatarWidget>
    with TickerProviderStateMixin {
  late AnimationController _walkingController;
  late AnimationController _runningController;
  late AnimationController _idleController;
  late Animation<double> _walkBounce;
  late Animation<double> _runBounce;
  late Animation<double> _idleBob;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Walking animation - moderate bounce
    _walkingController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _walkBounce = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _walkingController, curve: Curves.easeInOut),
    );

    // Running animation - faster bounce
    _runningController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _runBounce = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _runningController, curve: Curves.bounceOut),
    );

    // Idle animation - gentle bob
    _idleController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _idleBob = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _walkingController.dispose();
    _runningController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateAnimation();

    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Movement trail effect
          if (widget.showMovementTrail &&
              widget.character.movement?.state != MovementState.idle)
            _buildMovementTrail(),

          // Character shadow
          _buildCharacterShadow(),

          // Main character avatar
          AnimatedBuilder(
            animation: Listenable.merge([_walkBounce, _runBounce, _idleBob]),
            builder: (context, child) {
              final offset = _getAnimationOffset();
              return Transform.translate(
                offset: Offset(0, offset!),
                child: Transform.rotate(
                  angle:
                      (widget.character.movement?.heading ?? 0) * 3.14159 / 180,
                  child: _buildCharacterBody(),
                ),
              );
            },
          ),

          // Status indicators
          _buildStatusIndicators(),

          // Name label
          if (widget.character.name != null &&
              widget.character.name!.isNotEmpty)
            _buildNameLabel(),
        ],
      ),
    );
  }

  void _updateAnimation() {
    switch (widget.character.movement?.state) {
      case MovementState.idle:
        _walkingController.stop();
        _runningController.stop();
        _idleController.repeat(reverse: true);
        break;
      case MovementState.walking:
        _runningController.stop();
        _idleController.stop();
        _walkingController.repeat(reverse: true);
        break;
      case MovementState.running:
        _walkingController.stop();
        _idleController.stop();
        _runningController.repeat(reverse: true);
        break;
      case MovementState.teleporting:
        _walkingController.stop();
        _runningController.stop();
        _idleController.stop();
        break;
      case null:
        break;
    }
  }

  double? _getAnimationOffset() {
    switch (widget.character.movement?.state) {
      case MovementState.walking:
        return -_walkBounce.value;
      case MovementState.running:
        return -_runBounce.value;
      case MovementState.idle:
        return _idleBob.value;
      case MovementState.teleporting:
        return 0;
      case null:
        return null;
    }
  }

  Widget _buildMovementTrail() {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: MovementTrailPainter(
        movementState: widget.character.movement?.state ?? MovementState.idle,
        heading: widget.character.movement?.heading ?? 0.0,
      ),
    );
  }

  Widget _buildCharacterShadow() {
    return Positioned(
      bottom: 5,
      child: Container(
        width: widget.size * 0.6,
        height: widget.size * 0.2,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(widget.size * 0.6),
            bottom: Radius.circular(widget.size * 0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterBody() {
    return Container(
      width: widget.size * 0.8,
      height: widget.size * 0.8,
      decoration: BoxDecoration(
        color: Color(
          int.parse(
                (widget.character.appearance?.outfitColor ?? '#FFFFFF')
                    .substring(1),
                radix: 16,
              ) +
              0xFF000000,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: (widget.character.isOnline ?? false)
              ? Colors.green
              : Colors.grey,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Character class emoji
          Center(
            child: Text(
              widget.character.appearance?.classEmoji ?? '',
              style: TextStyle(fontSize: widget.size * 0.4),
            ),
          ),

          // Weapon overlay
          if (widget.character.appearance?.weaponType != null &&
              widget.character.appearance!.weaponType!.isNotEmpty)
            _buildWeaponOverlay(),

          // Guild emblem
          if (widget.character.appearance?.guildEmblem != null &&
              widget.character.appearance!.guildEmblem!.isNotEmpty)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: widget.size * 0.25,
                height: widget.size * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: Center(
                  child: Text(
                    widget.character.appearance!.guildEmblem ?? '',
                    style: TextStyle(fontSize: widget.size * 0.15),
                  ),
                ),
              ),
            ),

          // Level indicator
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                widget.character.level.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.size * 0.15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponOverlay() {
    IconData weaponIcon;
    switch (widget.character.appearance?.weaponType) {
      case 'sword':
        weaponIcon = Icons.gesture;
        break;
      case 'staff':
        weaponIcon = Icons.auto_fix_high;
        break;
      case 'bow':
        weaponIcon = Icons.arrow_forward;
        break;
      default:
        weaponIcon = Icons.star;
    }

    return Positioned(
      top: widget.size * 0.1,
      left: widget.size * 0.1,
      child: Icon(weaponIcon, color: Colors.yellow, size: widget.size * 0.2),
    );
  }

  Widget _buildStatusIndicators() {
    return Positioned(
      top: 0,
      left: 0,
      child: Row(
        children: [
          // Movement state indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getMovementColor(
                widget.character.movement?.state ?? MovementState.idle,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
          ),

          // Speed indicator
          if (widget.character.movement?.speed != null &&
              widget.character.movement!.speed! > 1.0)
            Container(
              margin: EdgeInsets.only(left: 2),
              child: Row(
                children: List.generate(
                  _getSpeedBars(widget.character.movement!.speed ?? 0),
                  (index) => Container(
                    width: 2,
                    height: 4 + index * 2,
                    margin: EdgeInsets.only(right: 1),
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNameLabel() {
    return Positioned(
      bottom: -20,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.character.name ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getMovementColor(MovementState state) {
    switch (state) {
      case MovementState.idle:
        return Colors.blue;
      case MovementState.walking:
        return Colors.green;
      case MovementState.running:
        return Colors.orange;
      case MovementState.teleporting:
        return Colors.purple;
    }
  }

  int _getSpeedBars(double speed) {
    if (speed < 2.0) return 1;
    if (speed < 4.0) return 2;
    if (speed < 6.0) return 3;
    return 4;
  }
}

// Custom painter for movement trail
class MovementTrailPainter extends CustomPainter {
  final MovementState movementState;
  final double heading;

  MovementTrailPainter({required this.movementState, required this.heading});

  @override
  void paint(Canvas canvas, Size size) {
    if (movementState == MovementState.idle) return;

    final paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Calculate trail direction (opposite to heading)
    final trailAngle = (heading + 180) * 3.14159 / 180;
    final trailLength = size.width * 0.6;

    switch (movementState) {
      case MovementState.walking:
        paint.color = Colors.green.withOpacity(0.3);
        _drawWalkingTrail(canvas, center, trailAngle, trailLength, paint);
        break;
      case MovementState.running:
        paint.color = Colors.orange.withOpacity(0.4);
        _drawRunningTrail(canvas, center, trailAngle, trailLength, paint);
        break;
      case MovementState.teleporting:
        paint.color = Colors.purple.withOpacity(0.5);
        _drawTeleportTrail(canvas, center, paint);
        break;
      default:
        break;
    }
  }

  void _drawWalkingTrail(
    Canvas canvas,
    Offset center,
    double angle,
    double length,
    Paint paint,
  ) {
    // Simple dotted trail
    for (int i = 1; i <= 3; i++) {
      final trailOffset = Offset(
        center.dx + (length / 3 * i) * -math.cos(angle),
        center.dy + (length / 3 * i) * -math.sin(angle),
      );
      canvas.drawCircle(trailOffset, 2, paint);
    }
  }

  void _drawRunningTrail(
    Canvas canvas,
    Offset center,
    double angle,
    double length,
    Paint paint,
  ) {
    // Longer trail with particles
    for (int i = 1; i <= 5; i++) {
      final trailOffset = Offset(
        center.dx + (length / 5 * i) * -math.cos(angle),
        center.dy + (length / 5 * i) * -math.sin(angle),
      );
      paint.color = paint.color.withOpacity(0.6 / i);
      canvas.drawCircle(trailOffset, 3 - i * 0.4, paint);
    }
  }

  void _drawTeleportTrail(Canvas canvas, Offset center, Paint paint) {
    // Spiral teleport effect
    for (int i = 0; i < 20; i++) {
      final spiralAngle = i * 0.5;
      final spiralRadius = i * 2.0;
      final spiralOffset = Offset(
        center.dx + spiralRadius * math.cos(spiralAngle),
        center.dy + spiralRadius * math.sin(spiralAngle),
      );
      paint.color = paint.color.withOpacity(1.0 - i / 20.0);
      canvas.drawCircle(spiralOffset, 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
