import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_icon.dart';

class BookFilterData {
  const BookFilterData({
    required this.minPrice,
    required this.maxPrice,
    required this.selectedCategories,
    required this.minimumRating,
  });

  final double minPrice;
  final double maxPrice;
  final Set<String> selectedCategories;
  final double minimumRating;

  BookFilterData copyWith({
    double? minPrice,
    double? maxPrice,
    Set<String>? selectedCategories,
    double? minimumRating,
  }) {
    return BookFilterData(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minimumRating: minimumRating ?? this.minimumRating,
    );
  }
}

Future<BookFilterData?> showBookFilterBottomSheet({
  required BuildContext context,
  required List<String> categories,
  required BookFilterData initialData,
  double minAvailablePrice = 0,
  double maxAvailablePrice = 100,
}) {
  return showModalBottomSheet<BookFilterData>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BookFilterBottomSheet(
        categories: categories,
        initialData: initialData,
        minAvailablePrice: minAvailablePrice,
        maxAvailablePrice: maxAvailablePrice,
      );
    },
  );
}

class BookFilterBottomSheet extends StatefulWidget {
  const BookFilterBottomSheet({
    super.key,
    required this.categories,
    required this.initialData,
    required this.minAvailablePrice,
    required this.maxAvailablePrice,
  });

  final List<String> categories;
  final BookFilterData initialData;
  final double minAvailablePrice;
  final double maxAvailablePrice;

  @override
  State<BookFilterBottomSheet> createState() => _BookFilterBottomSheetState();
}

class _BookFilterBottomSheetState extends State<BookFilterBottomSheet> {
  late RangeValues _priceRange;
  late Set<String> _selectedCategories;
  late double _minimumRating;

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.initialData.minPrice,
      widget.initialData.maxPrice,
    );
    _selectedCategories = {...widget.initialData.selectedCategories};
    _minimumRating = widget.initialData.minimumRating;
  }

  void _resetFilters() {
    setState(() {
      _priceRange = RangeValues(
        widget.minAvailablePrice,
        widget.maxAvailablePrice,
      );
      _selectedCategories = <String>{};
      _minimumRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
          top: AppSpacing.xl,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    ),
                  ),
                ),
                AppSpacing.gapLg,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter Books',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ),
                    TextButton(
                      onPressed: _resetFilters,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                AppSpacing.gapMd,
                Text(
                  'Price Range',
                  style: theme.textTheme.titleMedium,
                ),
                AppSpacing.gapSm,
                Row(
                  children: [
                    _PricePill(label: '\$${_priceRange.start.round()}'),
                    const Spacer(),
                    _PricePill(label: '\$${_priceRange.end.round()}'),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: widget.minAvailablePrice,
                  max: widget.maxAvailablePrice,
                  divisions: (widget.maxAvailablePrice - widget.minAvailablePrice)
                      .clamp(1, 100)
                      .round(),
                  labels: RangeLabels(
                    '\$${_priceRange.start.round()}',
                    '\$${_priceRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setState(() => _priceRange = values);
                  },
                ),
                AppSpacing.gapMd,
                Text(
                  'Categories',
                  style: theme.textTheme.titleMedium,
                ),
                AppSpacing.gapSm,
                Container(
                  constraints: const BoxConstraints(maxHeight: 220),
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: widget.categories.map((category) {
                        final isSelected = _selectedCategories.contains(category);

                        return CheckboxListTile(
                          value: isSelected,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            category,
                            style: theme.textTheme.bodyLarge,
                          ),
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              if (value ?? false) {
                                _selectedCategories.add(category);
                              } else {
                                _selectedCategories.remove(category);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                AppSpacing.gapMd,
                Text(
                  'Minimum Rating',
                  style: theme.textTheme.titleMedium,
                ),
                AppSpacing.gapSm,
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [0, 3, 4, 4.5].map((rating) {
                    final value = rating.toDouble();
                    final isSelected = _minimumRating == value;

                    return ChoiceChip(
                      label: Text(
                        value == 0 ? 'All ratings' : '$value+',
                      ),
                      avatar: value == 0
                          ? null
                          : const AppIcon(
                              HugeIcons.strokeRoundedStar,
                              size: 16,
                              color: AppColors.warning,
                            ),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _minimumRating = value);
                      },
                    );
                  }).toList(),
                ),
                AppSpacing.gapXl,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    AppSpacing.gapWsm,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                            BookFilterData(
                              minPrice: _priceRange.start,
                              maxPrice: _priceRange.end,
                              selectedCategories: _selectedCategories,
                              minimumRating: _minimumRating,
                            ),
                          );
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
