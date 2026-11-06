import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/di.dart';
import '../features/auth/bloc/bloc.dart';

class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = getIt<AuthBloc>();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state is! AuthAuthenticated) return const SizedBox.shrink();

        final user = state.user;
        final label = (user.displayName?.trim().isNotEmpty ?? false)
            ? user.displayName!.trim()
            : user.email ?? 'Профиль';
        final initial = label.substring(0, 1).toUpperCase();

        return PopupMenuButton<String>(
          tooltip: 'Профиль',
          offset: const Offset(0, 44),
          onSelected: (value) {
            if (value == 'logout') {
              authBloc.add(const AuthSignOutRequested());
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (user.email != null)
                    Text(
                      user.email!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 18),
                  SizedBox(width: 10),
                  Text('Выйти'),
                ],
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
