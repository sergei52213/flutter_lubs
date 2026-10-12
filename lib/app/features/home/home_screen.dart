import 'package:flutter/material.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import 'content_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Игры')),
      body: Column(
        children: [
          16.ph,
          // Поисковая строка (заглушка из макета)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          16.ph,
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: contentItems.length,
              separatorBuilder: (_, _) => 16.ph,
              itemBuilder: (context, index) => ContentCard(
                content: contentItems[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}