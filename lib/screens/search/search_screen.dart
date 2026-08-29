
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../product/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final suggestions = provider.search(_query);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Search here', border: InputBorder.none),
          onChanged: (value) => setState(() => _query = value),
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text('Enter the product name...'))
          : suggestions.isEmpty
          ? const Center(child: Text('No results'))
          : ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, i) {
          final p = suggestions[i];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(p.imageUrl, width: 45, height: 45, fit: BoxFit.cover),
            ),
            title: Text(p.name),
            subtitle: Text('\$${p.price.toStringAsFixed(0)}'),
            onTap: () {
              setState(() {
                _controller.text = p.name;
                _query = p.name;
              });
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)));
            },
          );
        },
      ),
    );
  }
}