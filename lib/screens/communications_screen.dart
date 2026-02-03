/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class CommunicationsScreen extends StatefulWidget {
  const CommunicationsScreen({super.key});

  @override
  State<CommunicationsScreen> createState() => _CommunicationsScreenState();
}

class _CommunicationsScreenState extends State<CommunicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String? templateText) {
    final message = templateText ?? _messageController.text;
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent: $message'),
          backgroundColor: AppTheme.successColor,
        ),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Contacts'),
            Tab(text: 'Templates'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Contacts Tab
          ListView(
            padding: EdgeInsets.all(isLandscape ? 12 : 16),
            children: [
              ...appProvider.contacts.map((contact) {
                return Padding(
                  padding: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        _showMessageDialog(context, contact.name, appProvider, isLandscape);
                      },
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      child: Padding(
                        padding: EdgeInsets.all(isLandscape ? 12 : 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: isLandscape ? 20 : 24,
                              backgroundColor: AppTheme.primaryLight,
                              child: Text(
                                contact.name[0],
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isLandscape ? 16 : 18,
                                ),
                              ),
                            ),
                            SizedBox(width: isLandscape ? 12 : 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    contact.name,
                                    style: TextStyle(
                                      fontSize: isLandscape ? 14 : 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    contact.role,
                                    style: TextStyle(
                                      fontSize: isLandscape ? 12 : 14,
                                      color: AppTheme.grayMedium,
                                    ),
                                  ),
                                  if (contact.phone != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      contact.phone!,
                                      style: TextStyle(
                                        fontSize: isLandscape ? 11 : 12,
                                        color: AppTheme.grayLight,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppTheme.grayLight,
                              size: isLandscape ? 20 : 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          
          // Templates Tab
          ListView(
            padding: EdgeInsets.all(isLandscape ? 12 : 16),
            children: [
              Text(
                'Quick Message Templates',
                style: TextStyle(
                  fontSize: isLandscape ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.grayMedium,
                ),
              ),
              SizedBox(height: isLandscape ? 8 : 12),
              
              ...appProvider.messageTemplates.map((template) {
                return Padding(
                  padding: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                  child: Card(
                    child: InkWell(
                      onTap: () => _sendMessage(template.text),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      child: Padding(
                        padding: EdgeInsets.all(isLandscape ? 12 : 16),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isLandscape ? 8 : 10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.message_outlined,
                                color: AppTheme.primaryColor,
                                size: isLandscape ? 18 : 20,
                              ),
                            ),
                            SizedBox(width: isLandscape ? 12 : 16),
                            Expanded(
                              child: Text(
                                template.text,
                                style: TextStyle(
                                  fontSize: isLandscape ? 13 : 14,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.send,
                              color: AppTheme.primaryColor,
                              size: isLandscape ? 18 : 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(
    BuildContext context,
    String contactName,
    AppProvider appProvider,
    bool isLandscape,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Message $contactName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                ),
              ),
              SizedBox(height: isLandscape ? 12 : 16),
              
              Text(
                'Or use a template:',
                style: TextStyle(
                  fontSize: isLandscape ? 12 : 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.grayMedium,
                ),
              ),
              SizedBox(height: isLandscape ? 6 : 8),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: appProvider.messageTemplates.map((template) {
                  return ActionChip(
                    label: Text(
                      template.text,
                      style: TextStyle(fontSize: isLandscape ? 11 : 12),
                    ),
                    onPressed: () {
                      _messageController.text = template.text;
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendMessage(null);
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class CommunicationsScreen extends StatefulWidget {
  const CommunicationsScreen({super.key});

  @override
  State<CommunicationsScreen> createState() => _CommunicationsScreenState();
}

class _CommunicationsScreenState extends State<CommunicationsScreen> {
  String? _selectedContactId;
  final TextEditingController _customMessageController = TextEditingController();
  bool _messageSent = false;

  @override
  void dispose() {
    _customMessageController.dispose();
    super.dispose();
  }

  Future<void> _showSentState() async {
    if (!mounted) return;
    setState(() => _messageSent = true);
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _messageSent = false);
  }

  Future<void> _handleQuickSend(String templateText, String contactId) async {
    // Simulate sending
    await _showSentState();
  }

  Future<void> _handleCustomSend() async {
    final msg = _customMessageController.text.trim();
    if (msg.isEmpty || _selectedContactId == null) return;

    // Simulate sending
    _customMessageController.clear();
    await _showSentState();
  }

  void _logMood(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged mood: $label'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final isFavorite = appProvider.favorites.contains('/communications');
    final selectedContact = _selectedContactId == null
        ? null
        : appProvider.contacts.where((c) => c.id == _selectedContactId).cast<dynamic>().toList().isEmpty
        ? null
        : appProvider.contacts.firstWhere((c) => c.id == _selectedContactId);

    if (_messageSent) {
      return Scaffold(
        backgroundColor: AppTheme.grayBg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7), // green-100
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 40,
                          color: Color(0xFF16A34A), // green-600
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Message Sent!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppTheme.grayDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your message has been delivered successfully.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.grayMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        title: const Text('Communications'),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: () => appProvider.toggleFavorite('/communications'),
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 16 : 24,
            vertical: isLandscape ? 16 : 24,
          ),
          children: [
            // Contact Selection
            _SectionCard(
              padding: isLandscape ? 16 : 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Send To',
                    style: TextStyle(
                      fontSize: isLandscape ? 14 : 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.grayDark,
                    ),
                  ),
                  SizedBox(height: isLandscape ? 10 : 12),
                  ...appProvider.contacts.map((contact) {
                    final isSelected = _selectedContactId == contact.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () => setState(() => _selectedContactId = contact.id),
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: isLandscape
                                ? AppTheme.minTouchTargetLandscape
                                : AppTheme.minTouchTarget,
                          ),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF3F4F6), // blue-50 / gray-100
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.grayDark,
                                        fontSize: isLandscape ? 13 : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      contact.role,
                                      style: TextStyle(
                                        color: AppTheme.grayMedium,
                                        fontSize: isLandscape ? 12 : 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick Templates (only if contact selected)
            if (selectedContact != null)
              _SectionCard(
                padding: isLandscape ? 16 : 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Messages',
                      style: TextStyle(
                        fontSize: isLandscape ? 14 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.grayDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap to send instantly',
                      style: TextStyle(
                        fontSize: isLandscape ? 12 : 13,
                        color: AppTheme.grayMedium,
                      ),
                    ),
                    SizedBox(height: isLandscape ? 10 : 12),
                    ...appProvider.messageTemplates.map((template) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GradientActionButton(
                          text: template.text,
                          leftHandMode: appProvider.leftHandMode,
                          onTap: () => _handleQuickSend(template.text, selectedContact.id),
                        ),
                      );
                    }),
                  ],
                ),
              ),

            if (selectedContact != null) const SizedBox(height: 16),

            // Custom Message (only if contact selected)
            if (selectedContact != null)
              _SectionCard(
                padding: isLandscape ? 16 : 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Message',
                      style: TextStyle(
                        fontSize: isLandscape ? 14 : 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.grayDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        TextField(
                          controller: _customMessageController,
                          minLines: 4,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: 'Type your message here...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.fromLTRB(14, 14, 54, 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                              borderSide: const BorderSide(color: AppTheme.grayBorder, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                              borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: IconButton(
                            tooltip: 'Use voice input',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tip: Use your keyboard voice input.')),
                              );
                            },
                            icon: const Icon(Icons.mic, color: AppTheme.grayLight),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tip: Use your device's voice input keyboard for hands-free typing",
                      style: TextStyle(fontSize: 12, color: AppTheme.grayMedium),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: isLandscape ? AppTheme.minTouchTargetLandscape : AppTheme.minTouchTarget,
                      child: ElevatedButton.icon(
                        onPressed: _customMessageController.text.trim().isEmpty ? null : _handleCustomSend,
                        icon: const Icon(
                          Icons.send,
                          size: 18,
                        ),
                        label: const Text('Send Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Empty state (only if no contact selected)
            if (selectedContact == null) ...[
              const SizedBox(height: 16),
              _SectionCard(
                padding: isLandscape ? 18 : 24,
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF), // purple-100
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: 32,
                          color: Color(0xFF7C3AED), // purple-600
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Select a Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.grayDark,
                        fontSize: isLandscape ? 14 : 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Choose who you'd like to message from the list above",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.grayMedium,
                        fontSize: isLandscape ? 12 : 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Wellness Logging (Quick Log)
            _QuickLogCard(
              isLandscape: isLandscape,
              onMoodSelected: _logMood,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    required this.padding,
  });

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        side: const BorderSide(color: AppTheme.grayBorder),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({
    required this.text,
    required this.leftHandMode,
    required this.onTap,
  });

  final String text;
  final bool leftHandMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const leading = Icon(Icons.message_outlined, color: Colors.white, size: 20);
    const trailing = Icon(Icons.send, color: Colors.white, size: 20);

    return Material(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)], // blue-500 -> blue-600
            ),
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                if (leftHandMode) trailing else trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLogCard extends StatelessWidget {
  const _QuickLogCard({
    required this.isLandscape,
    required this.onMoodSelected,
  });

  final bool isLandscape;
  final ValueChanged<String> onMoodSelected;

  @override
  Widget build(BuildContext context) {
    const moods = <({String emoji, String label, Color bg, Color fg})>[
      (
      emoji: '😊',
      label: 'Great',
      bg: Color(0xFFDCFCE7),
      fg: Color(0xFF15803D),
      ),
      (
      emoji: '😌',
      label: 'Good',
      bg: Color(0xFFDBEAFE),
      fg: Color(0xFF1D4ED8),
      ),
      (
      emoji: '😐',
      label: 'Okay',
      bg: Color(0xFFFEF9C3),
      fg: Color(0xFFA16207),
      ),
      (
      emoji: '😔',
      label: 'Not well',
      bg: Color(0xFFFFEDD5),
      fg: Color(0xFFC2410C),
      ),
    ];

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        side: const BorderSide(color: AppTheme.grayBorder),
      ),
      child: Padding(
        padding: EdgeInsets.all(isLandscape ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Log',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: isLandscape ? 14 : 16,
                color: AppTheme.grayDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Log how you're feeling today",
              style: TextStyle(
                fontSize: isLandscape ? 12 : 13,
                color: AppTheme.grayMedium,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isLandscape ? 2.8 : 2.2,
              children: [
                for (final mood in moods)
                  _MoodTile(
                    emoji: mood.emoji,
                    label: mood.label,
                    bg: mood.bg,
                    fg: mood.fg,
                    onTap: () => onMoodSelected(mood.label),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodTile extends StatelessWidget {
  const _MoodTile({
    required this.emoji,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: fg,
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