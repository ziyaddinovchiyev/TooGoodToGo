import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _favoriteVendors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteVendors();
  }

  Future<void> _loadFavoriteVendors() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get current user data to access favorite vendors
      final userData = ref.read(currentUserDataProvider).value;
      if (userData?.favoriteVendors == null || userData!.favoriteVendors!.isEmpty) {
        setState(() {
          _favoriteVendors = [];
          _isLoading = false;
        });
        return;
      }

      // Fetch favorite vendors from Firestore
      final List<UserModel> favoriteVendors = [];
      for (String vendorId in userData.favoriteVendors!) {
        try {
          final doc = await _firestore.collection('users').doc(vendorId).get();
          if (doc.exists) {
            final vendorData = UserModel.fromFirestore(doc);
            if (vendorData.userType == UserType.vendor) {
              favoriteVendors.add(vendorData);
            }
          }
        } catch (e) {
          print('Error loading vendor $vendorId: $e');
        }
      }

      setState(() {
        _favoriteVendors = favoriteVendors;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favorite vendors: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.favorites,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.grey[800],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            )
          : _favoriteVendors.isEmpty
              ? Center(
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
                          Icons.favorite_border,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noFavoriteVendorsYet,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.startAddingVendorsToFavorites,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate back to home tab
                          // This will be handled by the parent widget
                        },
                        icon: const Icon(Icons.explore),
                        label: Text(
                          l10n.exploreVendors,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavoriteVendors,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _favoriteVendors.length,
                    itemBuilder: (context, index) {
                      final vendor = _favoriteVendors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildVendorCard(vendor),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildVendorCard(UserModel vendor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to vendor details or vendor's magic bags
          print('Tapped on vendor: ${vendor.businessName ?? vendor.name}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Vendor Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: vendor.profileImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          vendor.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.store,
                              color: Color(0xFF4CAF50),
                              size: 24,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.store,
                        color: Color(0xFF4CAF50),
                        size: 24,
                      ),
              ),
              const SizedBox(width: 16),
              
              // Vendor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.businessName ?? vendor.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (vendor.businessDescription != null)
                      Text(
                        vendor.businessDescription!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (vendor.rating != null) ...[
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vendor.rating!.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (vendor.totalOrders != null)
                          Text(
                            '${vendor.totalOrders} orders',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Favorite Icon
              Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 