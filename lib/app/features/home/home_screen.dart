import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../di/di.dart';
import '../../../domain/domain.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import '../favorites/bloc/bloc.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _home = getIt<HomeBloc>();
  final _favorites = getIt<FavoriteBloc>();

  void loadHome() => _home.add(HomeLoad());

  @override
  void initState() {
    loadHome();
    _favorites.add(const FavoriteStarted());
    super.initState();
  }

  @override
  void dispose() {
    _favorites.close();
    super.dispose();
  }

  void _showFavoriteError(BuildContext context, String? error) {
    if (error == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error)));
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
        if (state is FavoriteLoadSuccess) {
          _showFavoriteError(context, state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Игры'),
          actions: [
            IconButton(
              tooltip: 'Избранное',
              onPressed: () => context.push('/favorites'),
              icon: const Icon(Icons.favorite),
            ),
            const AccountMenu(),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          bloc: _home,
          builder: (context, state) {
            return switch (state) {
              HomeInitial() => _buildHomeInitial(),
              HomeLoadInProgress() => _buildHomeLoadInProgress(),
              HomeLoadSuccess() => _buildHomeLoadSuccess(state),
              HomeLoadFailure() => _buildHomeLoadFailure(state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildHomeInitial() => const SizedBox.shrink();

  Widget _buildHomeLoadInProgress() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildHomeLoadSuccess(HomeLoadSuccess state) {
    final content = state.content;

    return Column(
      children: [
        16.ph,
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
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
            bloc: _favorites,
            builder: (context, favoriteState) {
              final favorites = favoriteState is FavoriteLoadSuccess
                  ? favoriteState.favorites
                  : const <FavoriteGame>[];
              final favoriteIds = favorites
                  .map((favorite) => favorite.id)
                  .toSet();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: content.length,
                separatorBuilder: (_, _) => 16.ph,
                itemBuilder: (context, index) {
                  final item = content[index];
                  final isFavorite = favoriteIds.contains(item.id);

                  return ContentCard(
                    content: item,
                    isFavorite: isFavorite,
                    onFavoriteTap: () => _favorites.add(
                      FavoriteToggled(
                        contentId: item.id,
                        title: item.title,
                        image: item.image,
                        isFavorite: isFavorite,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHomeLoadFailure(HomeLoadFailure state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
            16.ph,
            const Text(
              'Не удалось загрузить список игр',
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
              onPressed: loadHome,
              child: const Text('Повторить попытку'),
            ),
          ],
        ),
      ),
    );
  }
}
