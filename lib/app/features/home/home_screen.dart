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
  final List<ContentItem> _items = const [
    ContentItem(
      id: 1,
      title: 'Заголовок 1',
      description: 'Описание первого элемента списка. Здесь может быть любой текст.',
      image: 'assets/images/test_image.jpg',
    ),
    ContentItem(
      id: 2,
      title: 'Заголовок 2',
      description: 'Описание второго элемента списка. Здесь может быть любой текст.',
      image: 'assets/images/test_image2.jpg',
    ),
    ContentItem(
      id: 3,
      title: 'Заголовок 3',
      description: 'Описание третьего элемента списка. Здесь может быть любой текст.',
      image: 'assets/images/test_image.jpg',
    ),
    ContentItem(
      id: 4,
      title: 'Заголовок 4',
      description: 'Описание четвёртого элемента списка. Здесь может быть любой текст.',
      image: 'assets/images/test_image2.jpg',
    ),
    ContentItem(
      id: 5,
      title: 'Заголовок 5',
      description: 'Описание пятого элемента списка. Здесь может быть любой текст.',
      image: 'assets/images/test_image.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
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
              itemCount: _items.length,
              separatorBuilder: (_, __) => 16.ph,
              itemBuilder: (context, index) => ContentCard(
                content: _items[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}