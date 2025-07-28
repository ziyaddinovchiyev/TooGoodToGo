import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../l10n/app_localizations.dart';
import '../../models/magic_bag_model.dart';
import '../../models/user_model.dart';
import 'widgets/magic_bag_card.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/map_view.dart';
import '../map/map_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<MagicBagModel> _magicBags = [];
  List<MagicBagModel> _filteredMagicBags = [];
  bool _isLoading = true;
  bool _isMapView = false;
  bool _isKeyboardVisible = false;
  FoodCategory? _selectedCategory;
  String _searchQuery = '';
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const MapScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadMagicBags();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _searchFocusNode.hasFocus;
    });
  }

  Future<void> _loadMagicBags() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Fetch magic bags from Firestore
      final QuerySnapshot snapshot = await _firestore
          .collection('magic_bags')
          .where('status', isEqualTo: 'available')
          .get();

      final List<MagicBagModel> magicBags = snapshot.docs
          .map((doc) => MagicBagModel.fromFirestore(doc))
          .where((bag) => !bag.isExpired && bag.availableQuantity > 0) // Filter out expired bags and those with no availability
          .toList();

      setState(() {
        _magicBags = magicBags;
        _filteredMagicBags = magicBags;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading magic bags: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterMagicBags() {
    setState(() {
      _filteredMagicBags = _magicBags.where((bag) {
        // Category filter
        if (_selectedCategory != null && bag.category != _selectedCategory) {
          return false;
        }

        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return bag.title.toLowerCase().contains(query) ||
                 bag.description.toLowerCase().contains(query) ||
                 bag.vendorName.toLowerCase().contains(query) ||
                 bag.foodItems.any((item) => item.toLowerCase().contains(query));
        }

        return true;
      }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedCategory: _selectedCategory,
        onCategoryChanged: (category) {
          setState(() {
            _selectedCategory = category;
          });
          _filterMagicBags();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            activeIcon: const Icon(Icons.map),
            label: l10n.map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_outline),
            activeIcon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<MagicBagModel> _magicBags = [];
  List<MagicBagModel> _filteredMagicBags = [];
  bool _isLoading = true;
  bool _isMapView = false;
  bool _isKeyboardVisible = false;
  FoodCategory? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMagicBags();
    _searchFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _searchFocusNode.hasFocus;
    });
  }

  Future<void> _loadMagicBags() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Fetch magic bags from Firestore
      final QuerySnapshot snapshot = await _firestore
          .collection('magic_bags')
          .where('status', isEqualTo: 'available')
          .get();

      final List<MagicBagModel> magicBags = snapshot.docs
          .map((doc) => MagicBagModel.fromFirestore(doc))
          .where((bag) => !bag.isExpired && bag.availableQuantity > 0) // Filter out expired bags and those with no availability
          .toList();

      setState(() {
        _magicBags = magicBags;
        _filteredMagicBags = magicBags;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading magic bags: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterMagicBags() {
    setState(() {
      _filteredMagicBags = _magicBags.where((bag) {
        // Category filter
        if (_selectedCategory != null && bag.category != _selectedCategory) {
          return false;
        }

        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return bag.title.toLowerCase().contains(query) ||
                 bag.description.toLowerCase().contains(query) ||
                 bag.vendorName.toLowerCase().contains(query) ||
                 bag.foodItems.any((item) => item.toLowerCase().contains(query));
        }

        return true;
      }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        selectedCategory: _selectedCategory,
        onCategoryChanged: (category) {
          setState(() {
            _selectedCategory = category;
          });
          _filterMagicBags();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CustomScrollView(
      slivers: [
        // Sophisticated App Bar
        SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4CAF50),
                    const Color(0xFF45A049),
                    const Color(0xFF388E3C),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with logo and actions
                      Row(
                        children: [
                          // App Logo and Title
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.eco,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.appTitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Save food, save money',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Action Buttons
                          Row(
                            children: [
                              // Notifications
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Profile
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search Bar
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          textAlign: TextAlign.start,
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          decoration: InputDecoration(
                            hintText: l10n.searchMagicBags,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            suffixIcon: _isKeyboardVisible
                                ? Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _searchQuery = '';
                                          _searchController.clear();
                                        });
                                        _filterMagicBags();
                                        FocusScope.of(context).unfocus();
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 24,
                                        minHeight: 24,
                                      ),
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            isDense: false,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                            _filterMagicBags();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Filter Chips Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip(null, l10n.all, _selectedCategory == null),
                  const SizedBox(width: 8),
                  ...FoodCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildCategoryChip(
                        category,
                        _getCategoryName(category, l10n),
                        isSelected,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
        // Content
        _isLoading
            ? const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                ),
              )
            : _filteredMagicBags.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noMagicBagsFound,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.tryAdjustingFilters,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : _isMapView
                    ? SliverToBoxAdapter(
                        child: MapView(magicBags: _filteredMagicBags),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final magicBag = _filteredMagicBags[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: MagicBagCard(
                                  magicBag: magicBag,
                                  onTap: () {
                                    // Navigate to magic bag details
                                    print('Tapped on: ${magicBag.title}');
                                  },
                                ),
                              );
                            },
                            childCount: _filteredMagicBags.length,
                          ),
                        ),
                      ),
      ],
    );
  }

  Widget _buildCategoryChip(FoodCategory? category, String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
        _filterMagicBags();
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF4CAF50),
      checkmarkColor: Colors.white,
      side: BorderSide(
        color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  String _getCategoryName(FoodCategory category, AppLocalizations l10n) {
    switch (category) {
      case FoodCategory.bakery:
        return l10n.bakery;
      case FoodCategory.restaurant:
        return l10n.restaurant;
      case FoodCategory.cafe:
        return l10n.cafe;
      case FoodCategory.grocery:
        return l10n.grocery;
      default:
        return category.name;
    }
  }
} 