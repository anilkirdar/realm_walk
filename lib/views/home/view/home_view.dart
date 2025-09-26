import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../_main/model/character_model.dart';
import '../../_main/model/nearby_character_model.dart';
import '../../_main/provider/location_provider.dart';
import '../../auth/provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // App lifecycle management
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final locationProvider = context.read<LocationProvider>();

    switch (state) {
      case AppLifecycleState.resumed:
        // Start location tracking when app becomes active
        locationProvider.startLocationTracking();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Stop location tracking to save battery
        locationProvider.stopLocationTracking();
        break;
      default:
        break;
    }
  }

  Future<void> _initializeLocation() async {
    final locationProvider = context.read<LocationProvider>();
    await locationProvider.initialize();

    if (locationProvider.isLocationEnabled) {
      locationProvider.startLocationTracking();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final character = authProvider.character;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'AR MMORPG',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Consumer<LocationProvider>(
              builder: (context, locationProvider, child) {
                if (locationProvider.isTracking) {
                  return Icon(Icons.gps_fixed, color: Colors.green, size: 16);
                } else if (locationProvider.locationError != null) {
                  return Icon(Icons.gps_off, color: Colors.red, size: 16);
                } else {
                  return Icon(
                    Icons.gps_not_fixed,
                    color: Colors.grey,
                    size: 16,
                  );
                }
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              // Stop location tracking before logout
              context.read<LocationProvider>().stopLocationTracking();

              await authProvider.signOut();
              if (context.mounted) {
                context.go('/auth/login');
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(user, character),
          _buildExploreTab(),
          _buildInventoryTab(),
          _buildSocialTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF16213E),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Keşfet'),
          BottomNavigationBarItem(
            icon: Icon(Icons.backpack),
            label: 'Envanter',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sosyal'),
        ],
      ),
    );
  }

  Widget _buildHomeTab(user, character) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Hoş geldin, ${user?.username ?? "Oyuncu"}!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            if (character != null) ...[
              // Character info card
              _buildCharacterCard(character),
              const SizedBox(height: 20),
            ],

            // Location status card
            _buildLocationStatusCard(),
            const SizedBox(height: 20),

            // Quick actions
            _buildQuickActions(),
            const SizedBox(height: 20),

            // Nearby players
            _buildNearbyPlayersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCard(character) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(character.classEmoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${character.classDisplayName} • Seviye ${character.level}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Health Bar
          _buildStatBar(
            'Sağlık',
            character.stats.health.current,
            character.stats.health.max,
            Colors.red,
          ),
          const SizedBox(height: 12),

          // Mana Bar
          _buildStatBar(
            'Mana',
            character.stats.mana.current,
            character.stats.mana.max,
            Colors.blue,
          ),
          const SizedBox(height: 12),

          // Experience Bar
          _buildExperienceBar(character),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, int current, int max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
            Text(
              '$current/$max',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: current / max,
          backgroundColor: Colors.grey[600],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildExperienceBar(CharacterModel character) {
    final currentLevelXP = (character.experience ?? 0) % 100;
    final nextLevelXP = 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Deneyim',
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
            Text(
              '$currentLevelXP/$nextLevelXP XP',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: currentLevelXP / nextLevelXP,
          backgroundColor: Colors.grey[600],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      ],
    );
  }

  Widget _buildLocationStatusCard() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: locationProvider.isLocationEnabled
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: locationProvider.isLocationEnabled
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    locationProvider.isLocationEnabled
                        ? Icons.location_on
                        : Icons.location_off,
                    color: locationProvider.isLocationEnabled
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    locationProvider.isLocationEnabled
                        ? 'Konum Aktif'
                        : 'Konum Kapalı',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: locationProvider.isLocationEnabled
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (locationProvider.currentPosition != null) ...[
                Text(
                  'Enlem: ${locationProvider.currentPosition!.latitude.toStringAsFixed(4)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text(
                  'Boylam: ${locationProvider.currentPosition!.longitude.toStringAsFixed(4)}',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                if (locationProvider.lastUpdate != null)
                  Text(
                    'Son güncelleme: ${_formatDateTime(locationProvider.lastUpdate!)}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
              ],

              if (locationProvider.locationError != null) ...[
                Text(
                  locationProvider.locationError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => locationProvider.requestLocationPermission(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: const Text('Konumu Etkinleştir'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Eylemler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.camera_alt,
                label: 'AR Kamera',
                onTap: () {
                  context.go('/home/ar-camera');
                },
              ),
            ),
            Expanded(
              child: _buildActionButton(
                icon: Icons.refresh,
                label: 'Yenile',
                onTap: () async {
                  final locationProvider = context.read<LocationProvider>();
                  await locationProvider.refreshNearbyCharacters();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.sports_martial_arts,
                label: 'Antrenman',
                onTap: () {
                  context.go('/home/combat-training');
                },
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.explore,
                label: 'Keşfet',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.backpack,
                label: 'Envanter',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[600]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyPlayersSection() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Yakındaki Oyuncular',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${locationProvider.nearbyCharacters.length} oyuncu',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (locationProvider.nearbyCharacters.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Yakınınızda oyuncu bulunamadı',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daha fazla keşfet veya farklı bir konuma git!',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: locationProvider.nearbyCharacters.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final character = locationProvider.nearbyCharacters[index];
                  return _buildNearbyPlayerCard(character);
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNearbyPlayerCard(NearbyCharacter character) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[600]!),
      ),
      child: Row(
        children: [
          // Character class emoji
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                character.classEmoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Character info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${character.classDisplayName} • Seviye ${character.level}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                if (character.username != null)
                  Text(
                    '@${character.username}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
              ],
            ),
          ),

          // Distance and actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  character.distanceFormatted ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      // Challenge to battle
                      _showChallengeDialog(character);
                    },
                    icon: const Icon(
                      Icons.sports_kabaddi,
                      color: Colors.orange,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {
                      // Send friend request / message
                      _showSocialDialog(character);
                    },
                    icon: const Icon(
                      Icons.person_add,
                      color: Colors.blue,
                      size: 20,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreTab() {
    return const Center(
      child: Text(
        'Keşfet Sekmesi\n(AR ve Harita Özellikleri)',
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInventoryTab() {
    return const Center(
      child: Text(
        'Envanter Sekmesi\n(Eşyalar ve Crafting)',
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSocialTab() {
    return const Center(
      child: Text(
        'Sosyal Sekmesi\n(Arkadaşlar ve Guild)',
        style: TextStyle(color: Colors.white, fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Az önce';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} saat önce';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showChallengeDialog(NearbyCharacter character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Düello Daveti', style: TextStyle(color: Colors.white)),
        content: Text(
          '${character.name} ile düello yapmak istiyor musun?',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              // TODO: Implement battle challenge
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Düello sistemi yakında!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text(
              'Düello Et',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSocialDialog(NearbyCharacter character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text('Sosyal Eylemler', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.blue),
              title: Text(
                'Arkadaş Ekle',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Arkadaş sistemi yakında!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.green),
              title: Text(
                'Mesaj Gönder',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mesajlaşma sistemi yakında!')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
