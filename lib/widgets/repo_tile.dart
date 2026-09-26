import 'package:flutter/material.dart';
import '../models/github_repo.dart';
import '../theme/app_theme.dart';

class RepoTile extends StatelessWidget {
  final GitHubRepo repo;

  const RepoTile({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.book_rounded,
                size: 16,
                color: AppTheme.primaryCyan,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  repo.name,
                  style: const TextStyle(
                    color: AppTheme.primaryCyan,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (repo.isFork)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Text(
                    'Fork',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
                  ),
                ),
            ],
          ),
          if (repo.description != null && repo.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              repo.description!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              if (repo.language != null && repo.language!.isNotEmpty) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.accentGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  repo.language!,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              const Icon(
                Icons.star_rounded,
                size: 15,
                color: AppTheme.accentAmber,
              ),
              const SizedBox(width: 4),
              Text(
                '${repo.stargazersCount}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.call_split_rounded,
                size: 14,
                color: AppTheme.primaryViolet,
              ),
              const SizedBox(width: 4),
              Text(
                '${repo.forksCount}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
