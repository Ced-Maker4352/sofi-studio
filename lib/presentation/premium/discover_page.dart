import 'package:flutter/material.dart';
import 'package:sofi_test_connect/data/theme_presets_data.dart';
import 'package:sofi_test_connect/models/theme_presets.dart';
import 'package:sofi_test_connect/presentation/sofi_studio/sofi_style_presets.dart';

class DiscoverPage extends StatelessWidget {
  final void Function(ThemePreset theme)? onThemeSelected;
  final void Function(Map<String, dynamic> stylePreset)? onStyleSelected;
  
  const DiscoverPage({
    super.key,
    this.onThemeSelected,
    this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final freeThemes = themePresets.where((t) => !t.isPremium).toList();
    final premiumThemes = themePresets.where((t) => t.isPremium).toList();
    final stylePresets = SofiStylePresets.presets;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F4),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            backgroundColor: const Color(0xFFF8F6F4),
            elevation: 0,
            title: const Text(
              'Discover',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {},
              ),
            ],
          ),
          
          // Featured Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: _FeaturedBanner(
                theme: freeThemes.isNotEmpty ? freeThemes.first : null,
                onTap: () {
                  if (freeThemes.isNotEmpty && onThemeSelected != null) {
                    onThemeSelected!(freeThemes.first);
                  }
                },
              ),
            ),
          ),
          
          // Style Presets Section
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Quick Styles',
              subtitle: 'One-tap outfit transformations',
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 110,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: stylePresets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => _StylePresetChip(
                  preset: stylePresets[i],
                  onTap: () => onStyleSelected?.call(stylePresets[i]),
                ),
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          
          // Free Themes Section
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Art Styles',
              subtitle: 'Transform your look',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _ThemeCard(
                  theme: freeThemes[i],
                  onTap: () => onThemeSelected?.call(freeThemes[i]),
                ),
                childCount: freeThemes.length,
              ),
            ),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          
          // Premium Themes Section
          if (premiumThemes.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Premium Collection',
                subtitle: 'Exclusive styles',
                isPremium: true,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ThemeCard(
                    theme: premiumThemes[i],
                    isPremium: true,
                    onTap: () => onThemeSelected?.call(premiumThemes[i]),
                  ),
                  childCount: premiumThemes.length,
                ),
              ),
            ),
          ],
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

/// Featured banner at top
class _FeaturedBanner extends StatelessWidget {
  final ThemePreset? theme;
  final VoidCallback? onTap;
  
  const _FeaturedBanner({this.theme, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8B4E0), Color(0xFFB4D4E8)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
            Positioned(
              right: 40,
              top: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✨ Featured',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    theme?.label ?? 'Explore Styles',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    theme?.description ?? 'Discover new looks',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Try Now →',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header with title and subtitle
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isPremium;
  
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFB700)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Style preset chip (Quick Styles)
class _StylePresetChip extends StatelessWidget {
  final Map<String, dynamic> preset;
  final VoidCallback? onTap;
  
  const _StylePresetChip({required this.preset, this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = preset['icon'] as String? ?? '✨';
    final label = preset['label'] as String? ?? 'Style';
    
    // Generate a color based on label
    final colors = _getColorsForStyle(label);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  
  List<Color> _getColorsForStyle(String label) {
    switch (label.toLowerCase()) {
      case 'clean girl':
        return [const Color(0xFFF5E6D3), const Color(0xFFE8D4C4)];
      case 'y2k style':
        return [const Color(0xFF7DD3FC), const Color(0xFFC4B5FD)];
      case 'street minimal':
        return [const Color(0xFF374151), const Color(0xFF1F2937)];
      case 'soft girl':
        return [const Color(0xFFFBCFE8), const Color(0xFFF9A8D4)];
      case 'academia':
        return [const Color(0xFF92400E), const Color(0xFF78350F)];
      default:
        return [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)];
    }
  }
}

/// Theme card for grid
class _ThemeCard extends StatelessWidget {
  final ThemePreset theme;
  final bool isPremium;
  final VoidCallback? onTap;
  
  const _ThemeCard({
    required this.theme,
    this.isPremium = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (theme.assetPath != null)
                    Image.asset(
                      theme.assetPath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _getColorForTheme(theme.id),
                        child: Icon(
                          _getIconForTheme(theme.id),
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 48,
                        ),
                      ),
                    )
                  else
                    Container(
                      color: _getColorForTheme(theme.id),
                      child: Icon(
                        _getIconForTheme(theme.id),
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 48,
                      ),
                    ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Premium badge
                  if (isPremium)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFB700)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.black),
                            const SizedBox(width: 4),
                            const Text(
                              'PRO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Variants count
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${theme.variants.length} variants',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        theme.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getColorForTheme(String id) {
    switch (id) {
      case 'pixar':
        return const Color(0xFF5D7CE8);
      case 'anime':
        return const Color(0xFFE85D9F);
      case 'comic':
        return const Color(0xFFE8A05D);
      case 'superhero':
        return const Color(0xFF5DE8A0);
      case 'fashion':
        return const Color(0xFFA05DE8);
      case 'fantasy':
        return const Color(0xFF5DC8E8);
      case 'scifi':
        return const Color(0xFF5DE87A);
      case 'realistic':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF9CA3AF);
    }
  }
  
  IconData _getIconForTheme(String id) {
    switch (id) {
      case 'pixar':
        return Icons.movie_creation;
      case 'anime':
        return Icons.face;
      case 'comic':
        return Icons.auto_stories;
      case 'superhero':
        return Icons.flash_on;
      case 'fashion':
        return Icons.checkroom;
      case 'fantasy':
        return Icons.auto_fix_high;
      case 'scifi':
        return Icons.rocket_launch;
      case 'realistic':
        return Icons.photo_camera;
      default:
        return Icons.palette;
    }
  }
}
