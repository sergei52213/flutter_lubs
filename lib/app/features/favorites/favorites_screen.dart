import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../di/di.dart';
import '../../../domain/domain.dart';
import '../../extensions/extensions.dart';
import '../../utils/image_url.dart';
import '../../widgets/account_menu.dart';
import 'bloc/bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favorites = getIt<FavoriteBloc>();

  @override
  void initState() {
    _favorites.add(const FavoriteStarted());
    super.initState();
  }

  @override
  void dispose() {
    _favorites.close();
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
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
          title: const Text('Избранное'),
          actions: const [AccountMenu()],
        ),
        body: BlocBuilder<FavoriteBloc, FavoriteState>(
          bloc: _favorites,
          builder: (context, state) {
            return switch (state) {
              FavoriteInitial() => _buildLoading(),
              FavoriteLoadInProgress() => _buildLoading(),
              FavoriteLoadSuccess() => _buildFavorites(state),
              FavoriteLoadFailure() => _buildFailure(state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildFavorites(FavoriteLoadSuccess state) {
    if (state.favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border, size: 72, color: Colors.grey[400]),
              16.ph,
              const Text(
                'В избранном пока пусто',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              8.ph,
              Text(
                'Нажмите на сердечко в списке игр, '
                'чтобы сохранить игру в Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.favorites.length,
      separatorBuilder: (_, _) => 12.ph,
      itemBuilder: (context, index) {
        final favorite = state.favorites[index];

        return _FavoriteCard(
          favorite: favorite,
          onTap: () => context.push('/detail/${favorite.id}'),
          onRemove: () => _favorites.add(FavoriteRemoved(favorite.id)),
        );
      },
    );
  }

  Widget _buildFailure(FavoriteLoadFailure state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
            16.ph,
            const Text(
              'Не удалось загрузить избранное',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            8.ph,
            Text(
              state.exception.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            16.ph,
            ElevatedButton(
              onPressed: () => _favorites.add(const FavoriteStarted()),
              child: const Text('Повторить попытку'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.favorite,
    required this.onTap,
    required this.onRemove,
  });

  final FavoriteGame favorite;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 92,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                resolveImageUrl(favorite.image),
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 76,
                  height: 76,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    favorite.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  6.ph,
                  Text(
                    'Сохранено в Cloud Firestore',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Удалить из избранного',
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}
