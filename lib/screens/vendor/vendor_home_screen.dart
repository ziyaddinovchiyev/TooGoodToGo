import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/order_list_item.dart';
import 'create_magic_bag_screen.dart';

class VendorHomeScreen extends ConsumerStatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  ConsumerState<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends ConsumerState<VendorHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<OrderModel> _recentOrders = [];
  bool _isLoading = true;

  // Mock dashboard data
  final Map<String, dynamic> _dashboardData = {
    'totalSales': 1247.50,
    'totalOrders': 45,
    'activeMagicBags': 8,
    'averageRating': 4.6,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement actual data loading from Firebase
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _recentOrders = _getMockOrders();
      _isLoading = false;
    });
  }

  List<OrderModel> _getMockOrders() {
    return [
      OrderModel(
        id: 'order1',
        customerId: 'customer1',
        customerName: 'John Doe',
        vendorId: 'vendor1',
        vendorName: 'Fresh Bakery',
        magicBagId: 'bag1',
        magicBagTitle: 'Surprise Pastry Bag',
        quantity: 1,
        totalAmount: 8.99,
        originalAmount: 25.0,
        discountAmount: 16.01,
        status: OrderStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        pickupStartTime: DateTime.now().add(const Duration(hours: 1)),
        pickupEndTime: DateTime.now().add(const Duration(hours: 3)),
        pickupCode: 'ABC123',
      ),
      OrderModel(
        id: 'order2',
        customerId: 'customer2',
        customerName: 'Jane Smith',
        vendorId: 'vendor1',
        vendorName: 'Fresh Bakery',
        magicBagId: 'bag1',
        magicBagTitle: 'Surprise Pastry Bag',
        quantity: 2,
        totalAmount: 17.98,
        originalAmount: 50.0,
        discountAmount: 32.02,
        status: OrderStatus.ready,
        paymentStatus: PaymentStatus.paid,
        orderDate: DateTime.now().subtract(const Duration(hours: 4)),
        pickupStartTime: DateTime.now().subtract(const Duration(hours: 1)),
        pickupEndTime: DateTime.now().add(const Duration(hours: 1)),
        pickupCode: 'DEF456',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider).value;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Vendor Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (userData?.businessName != null)
              Text(
                userData!.businessName!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dashboard Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Total Sales',
                    value: '\$${_dashboardData['totalSales'].toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'Orders',
                    value: _dashboardData['totalOrders'].toString(),
                    icon: Icons.shopping_bag,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: 'Active Bags',
                    value: _dashboardData['activeMagicBags'].toString(),
                    icon: Icons.inventory,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DashboardCard(
                    title: 'Rating',
                    value: _dashboardData['averageRating'].toString(),
                    icon: Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF4CAF50),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF4CAF50),
              tabs: const [
                Tab(text: 'Orders'),
                Tab(text: 'Magic Bags'),
                Tab(text: 'Analytics'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersTab(),
                _buildMagicBagsTab(),
                _buildAnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateMagicBagScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Magic Bag'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  Widget _buildOrdersTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4CAF50),
        ),
      );
    }

    if (_recentOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create Magic Bags to start receiving orders',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _recentOrders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OrderListItem(
              order: _recentOrders[index],
              onTap: () {
                // TODO: Navigate to order details
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMagicBagsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Magic Bags yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first Magic Bag to start selling',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateMagicBagScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Magic Bag'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Analytics Coming Soon',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Detailed analytics and insights will be available soon',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 