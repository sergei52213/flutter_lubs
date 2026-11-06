import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../di/di.dart';
import '../../../domain/domain.dart';
import '../../extensions/extensions.dart';
import '../../utils/image_url.dart';
import '../favorites/bloc/bloc.dart';
import 'bloc/detail_bloc.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id});

  final int id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final DetailBloc _detail;
  late final FavoriteBloc _favorites;

  @override
  void initState() {
    _detail = getIt<DetailBloc>();
    _detail.add(DetailLoad(id: widget.id));
    _favorites = getIt<FavoriteBloc>();
    _favorites.add(const FavoriteStarted());
    super.initState();
  }

  @override
  void dispose() {
    _favorites.close();
    _detail.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteBloc, FavoriteState>(
      bloc: _favorites,
      listenWhen: (previous, current) {
        return current is FavoriteLoadSuccess &&
            current.error != null &&
            (previous is! FavoriteLoadSuccess ||
                previous.error != current.error);
      },
      listener: (context, state) {
        if (state is FavoriteLoadSuccess && state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: BlocBuilder<DetailBloc, DetailState>(
        bloc: _detail,
        builder: (context, state) {
          return switch (state) {
            DetailInitial() => _buildLoading('Игра'),
            DetailLoadInProgress() => _buildLoading('Игра'),
            DetailLoadSuccess() => _buildSuccess(state),
            DetailLoadFailure() => _buildFailure(state),
          };
        },
      ),
    );
  }

  Widget _favoriteAction(ContentDetail item) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      bloc: _favorites,
      builder: (context, state) {
        final isFavorite =
            state is FavoriteLoadSuccess && state.contains(item.id);

        return IconButton(
          tooltip: isFavorite
              ? 'Удалить из избранного'
              : 'Добавить в избранное',
          onPressed: () => _favorites.add(
            FavoriteToggled(
              contentId: item.id,
              title: item.title,
              image: item.image,
              isFavorite: isFavorite,
            ),
          ),
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.redAccent : Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildLoading(String title) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(title),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSuccess(DetailLoadSuccess state) {
    final item = state.content;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(item.title),
        actions: [_favoriteAction(item)],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              resolveImageUrl(item.image),
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: double.infinity,
                height: 240,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;

                return Container(
                  width: double.infinity,
                  height: 240,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.ph,
                  _InfoRow(label: 'Жанр', value: item.genre),
                  _InfoRow(label: 'Разработчик', value: item.developer),
                  _InfoRow(label: 'Издатель', value: item.publisher),
                  _InfoRow(label: 'Платформа', value: item.platform),
                  _InfoRow(label: 'Год выпуска', value: '${item.releaseYear}'),
                  _InfoRow(label: 'Статус', value: item.status),
                  16.ph,
                  Text(
                    item.description.isEmpty
                        ? item.shortDescription
                        : item.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.grey[800],
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

  Widget _buildFailure(DetailLoadFailure state) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Игра'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
              16.ph,
              const Text(
                'Не удалось загрузить информацию об игре',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              8.ph,
              Text(
                state.exception.toString(),
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              16.ph,
              ElevatedButton(
                onPressed: () => _detail.add(DetailLoad(id: widget.id)),
                child: const Text('Повторить попытку'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
