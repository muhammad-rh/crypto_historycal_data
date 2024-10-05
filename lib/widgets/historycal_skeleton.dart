import 'package:code_challenge/config/app_assets.dart';
import 'package:code_challenge/config/app_colors.dart';
import 'package:code_challenge/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class HistorycalSkeleton extends StatelessWidget {
  const HistorycalSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppShimmer(
        children: [
          _buildHeader(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.black700,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            height: 400,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.black700,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              margin: const EdgeInsets.only(top: 12),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.appLogo,
                width: 36,
                height: 36,
              ),
              const SizedBox(width: 8),
              const Text(
                'NexGen Crypto',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Analytics',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            children: [
              ...List.generate(
                2,
                (x) => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.black500,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  height: 36,
                  width: 110,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
