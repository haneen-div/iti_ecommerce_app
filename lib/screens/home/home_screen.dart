
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/product_card.dart';
import '../../widgets/skeleton_loader.dart';
import '../product/product_detail_screen.dart';
import '../product/see_all_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final userName = context.watch<AuthProvider>().user?.displayName ?? 'User';

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: productProvider.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hello!', style: TextStyle(color: Colors.grey)),
                      Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.notifications_none, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const BannerCarousel(),
              const SizedBox(height: 20),
              _sectionHeader(context, 'Featured', 'featured'),
              const SizedBox(height: 10),
              SizedBox(
                height: 190,
                child: productProvider.isLoading
                    ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, __) => const ProductCardSkeleton(),
                )
                    : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.featured.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final p = productProvider.featured[i];
                    return ProductCard(
                      product: p,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeader(context, 'Most Popular', 'popular'),
              const SizedBox(height: 10),
              SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.popular.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final p = productProvider.popular[i];
                    return ProductCard(
                      product: p,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => SeeAllScreen(type: type)),
          ),
          child: const Text('See All', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}