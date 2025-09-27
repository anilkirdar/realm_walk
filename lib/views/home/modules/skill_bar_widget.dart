import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../_main/model/skill_models.dart';
import '../../_main/provider/combat_provider.dart';

class SkillBarWidget extends StatefulWidget {
  final bool isVertical;
  final double size;

  const SkillBarWidget({super.key, this.isVertical = false, this.size = 60});

  @override
  State<SkillBarWidget> createState() => _SkillBarWidgetState();
}

class _SkillBarWidgetState extends State<SkillBarWidget>
    with TickerProviderStateMixin {
  final Map<String, AnimationController> _cooldownAnimations = {};
  final Map<String, Timer> _cooldownTimers = {};

  @override
  void dispose() {
    _cooldownAnimations.values.forEach((controller) => controller.dispose());
    _cooldownTimers.values.forEach((timer) => timer.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CombatProvider>(
      builder: (context, combatProvider, child) {
        final skills = combatProvider.playerSkills;

        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(widget.isVertical ? 30 : 16),
            border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 2),
          ),
          child: widget.isVertical
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: skills
                      .map((skill) => _buildSkillButton(skill))
                      .toList(),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: skills
                      .map((skill) => _buildSkillButton(skill))
                      .toList(),
                ),
        );
      },
    );
  }

  Widget _buildSkillButton(PlayerSkill skill) {
    final isOnCooldown = _cooldownTimers.containsKey(skill.id);
    final animation = _cooldownAnimations[skill.id];

    return Padding(
      padding: EdgeInsets.all(4),
      child: GestureDetector(
        onTap: isOnCooldown ? null : () => _useSkill(skill),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: _getSkillColor(skill.type),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isOnCooldown ? Colors.grey : Colors.white,
                  width: 2,
                ),
                boxShadow: isOnCooldown
                    ? []
                    : [
                        BoxShadow(
                          color: _getSkillColor(skill.type).withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getSkillIcon(skill.type),
                    color: isOnCooldown ? Colors.grey : Colors.white,
                    size: widget.size * 0.4,
                  ),
                  if (skill.level > 1)
                    Text(
                      '${skill.level}',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: widget.size * 0.15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            // Cooldown overlay
            if (animation != null)
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return CircularProgressIndicator(
                    value: animation.value,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.red.withOpacity(0.7),
                    ),
                    strokeWidth: 4,
                  );
                },
              ),

            // Mana cost
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${skill.manaCost}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.size * 0.15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSkillColor(SkillType type) {
    switch (type) {
      case SkillType.attack:
        return Colors.red[700]!;
      case SkillType.defense:
        return Colors.blue[700]!;
      case SkillType.magic:
        return Colors.purple[700]!;
      case SkillType.heal:
        return Colors.green[700]!;
      case SkillType.special:
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  IconData _getSkillIcon(SkillType type) {
    switch (type) {
      case SkillType.attack:
        return Icons.handyman;
      case SkillType.defense:
        return Icons.shield;
      case SkillType.magic:
        return Icons.auto_fix_high;
      case SkillType.heal:
        return Icons.healing;
      case SkillType.special:
        return Icons.flash_on;
      default:
        return Icons.help;
    }
  }

  void _useSkill(PlayerSkill skill) {
    final combatProvider = context.read<CombatProvider>();

    // Check mana
    if ((combatProvider.playerStats.mana ?? 0) < skill.manaCost) {
      _showInsufficientManaMessage();
      return;
    }

    // Use skill
    combatProvider.useSkill(skill);

    // Start cooldown animation
    _startCooldown(skill);

    // Visual feedback
    _showSkillEffect(skill);
  }

  void _startCooldown(PlayerSkill skill) {
    final controller = AnimationController(
      duration: Duration(milliseconds: skill.cooldown),
      vsync: this,
    );

    controller.addListener(() => setState(() {}));
    _cooldownAnimations[skill.id] = controller;

    controller.forward();

    _cooldownTimers[skill.id] = Timer(
      Duration(milliseconds: skill.cooldown),
      () {
        _cooldownAnimations.remove(skill.id);
        _cooldownTimers.remove(skill.id);
        controller.dispose();
        setState(() {});
      },
    );
  }

  void _showInsufficientManaMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚡ Not enough mana!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showSkillEffect(PlayerSkill skill) {
    // Add visual effect for skill usage
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) => Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: _getSkillColor(skill.type).withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _getSkillColor(skill.type),
                blurRadius: 20,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Icon(_getSkillIcon(skill.type), color: Colors.white, size: 50),
        ),
      ),
    );

    Timer(Duration(milliseconds: 500), () {
      if (mounted) Navigator.of(context).pop();
    });
  }
}
