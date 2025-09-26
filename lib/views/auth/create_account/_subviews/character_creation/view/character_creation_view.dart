import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/init/network/vexana_manager.dart';
import '../../../../login/view/login_view.dart';
import '../../../../model/sign_up/sign_up_with_email_model.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../service/auth_service.dart';

class CharacterCreationScreen extends StatefulWidget {
  final String email;
  final String username;
  final String password;

  const CharacterCreationScreen({
    super.key,
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _characterNameController = TextEditingController();

  String _selectedClass = 'warrior';
  String? _errorMessage;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  final Map<String, Map<String, dynamic>> _classData = {
    'warrior': {
      'name': 'Savaşçı',
      'description': 'Güçlü ve dayanıklı. Yakın dövüşte ustadır.',
      'emoji': '⚔️',
      'color': Colors.red,
      'stats': {
        'Sağlık': 120,
        'Mana': 30,
        'Saldırı': 15,
        'Savunma': 10,
        'Hız': 8,
      },
      'abilities': ['Güçlü Darbe', 'Kalkan Savunması', 'Savaş Çığlığı'],
    },
    'mage': {
      'name': 'Büyücü',
      'description':
          'Büyülü güçlere sahiptir. Uzak mesafe saldırılarında etkilidir.',
      'emoji': '🔮',
      'color': Colors.purple,
      'stats': {
        'Sağlık': 80,
        'Mana': 100,
        'Saldırı': 8,
        'Savunma': 5,
        'Hız': 12,
      },
      'abilities': ['Ateş Topu', 'Buzla', 'Mana Kalkanı'],
    },
    'archer': {
      'name': 'Okçu',
      'description': 'Çevik ve hızlıdır. Uzak mesafe saldırılarında ustadır.',
      'emoji': '🏹',
      'color': Colors.green,
      'stats': {
        'Sağlık': 100,
        'Mana': 60,
        'Saldırı': 12,
        'Savunma': 7,
        'Hız': 15,
      },
      'abilities': ['Çoklu Ok', 'Zehirli Ok', 'Kaçış'],
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _characterNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
    });

    final authService = AuthService(VexanaManager.instance.networkManager);

    final result = await authService.signUpWithEmail(
      SignUpWithEmailModel(
        email: widget.email,
        username: widget.username,
        password: widget.password,
        characterName: _characterNameController.text.trim(),
        characterClass: _selectedClass,
      ),
    );

    print('RESULT: ${result?.toJson()}');

    if (mounted) {
      if (result?.isSuccess ?? false) {
        context.go('/home');
      } else {
        setState(() {
          _errorMessage = result?.message;
        });
      }
    }
  }

  Widget _buildClassCard(String classKey) {
    final classInfo = _classData[classKey]!;
    final isSelected = _selectedClass == classKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedClass = classKey;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? classInfo['color'].withOpacity(0.1)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: isSelected ? classInfo['color'] : Colors.grey[600]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: classInfo['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      classInfo['emoji'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classInfo['name'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? classInfo['color'] : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        classInfo['description'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),

                if (isSelected)
                  Icon(Icons.check_circle, color: classInfo['color'], size: 24),
              ],
            ),

            if (isSelected) ...[
              const SizedBox(height: 16),

              Text(
                'İstatistikler:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: classInfo['stats'].entries.map<Widget>((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: classInfo['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: classInfo['color'].withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[300]),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              Text(
                'Özel Yetenekler:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: classInfo['abilities'].map<Widget>((ability) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[600]!),
                    ),
                    child: Text(
                      ability,
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Karakterini Yarat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Kahramanını Yarat! 🎮',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Karakterinin adını belirle ve sınıfını seç',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  TextFormField(
                    controller: _characterNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Karakter Adı',
                      labelStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Karakter adı zorunludur';
                      }
                      if (value.trim().length < 2) {
                        return 'Karakter adı en az 2 karakter olmalıdır';
                      }
                      if (value.trim().length > 20) {
                        return 'Karakter adı en fazla 20 karakter olabilir';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  Text(
                    'Sınıfını Seç:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 16),

                  ..._classData.keys
                      .map((classKey) => _buildClassCard(classKey))
                      .toList(),

                  const SizedBox(height: 30),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return LoadingButton(
                        onPressed: _handleCreateCharacter,
                        isLoading: authProvider.isLoading,
                        text: 'Karakteri Oluştur',
                        color: _classData[_selectedClass]!['color'],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Karakterini oluşturduktan sonra oyuna başlayabilirsin. Sınıfını daha sonra değiştiremezsin!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
