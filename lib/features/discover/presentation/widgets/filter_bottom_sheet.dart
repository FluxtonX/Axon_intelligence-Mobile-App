import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/discover_bloc.dart';
import '../bloc/discover_event.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<DiscoverBloc>(),
        child: const FilterBottomSheet(),
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedCategory;
  double? _minRating;
  double? _maxBudget;

  final List<String> _categories = [
    'Design',
    'Engineering',
    'Marketing',
    'Writing',
    'Video & Animation',
    'AI Services',
  ];

  final List<double> _ratings = [4.0, 4.5, 4.8, 5.0];

  @override
  void initState() {
    super.initState();
    final state = context.read<DiscoverBloc>().state;
    _selectedCategory = state.selectedCategory;
    _minRating = state.minRating;
    _maxBudget = state.maxBudget ?? 150.0;
  }

  void _applyFilters() {
    context.read<DiscoverBloc>().add(
          DiscoverFiltersUpdated(
            selectedCategory: _selectedCategory,
            minRating: _minRating,
            maxBudget: _maxBudget,
          ),
        );
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _minRating = null;
      _maxBudget = 150.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Category Section
          Text(
            'Category',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                selectedColor: AppColors.primary,
                backgroundColor: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                ),
                showCheckmark: false,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),

          // Budget Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Max Hourly Rate',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '\$${_maxBudget?.toInt() ?? 150}/hr',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: Colors.white,
              overlayColor: AppColors.primary.withValues(alpha: 0.1),
              trackHeight: 4,
            ),
            child: Slider(
              value: _maxBudget ?? 150.0,
              min: 10,
              max: 300,
              divisions: 29,
              onChanged: (value) {
                setState(() {
                  _maxBudget = value;
                });
              },
            ),
          ),

          const SizedBox(height: 24),

          // Rating Section
          Text(
            'Minimum Rating',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _ratings.map((rating) {
              final isSelected = _minRating == rating;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 4),
                    Text('$rating+'),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _minRating = selected ? rating : null;
                  });
                },
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                selectedColor: AppColors.primary,
                backgroundColor: const Color(0xFFF3F4F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                ),
                showCheckmark: false,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 40),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Apply Filters',
                  onTap: _applyFilters,
                  showIcon: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
