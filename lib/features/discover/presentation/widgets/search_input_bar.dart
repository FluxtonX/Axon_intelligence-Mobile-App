import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class SearchInputBar extends StatefulWidget {
  const SearchInputBar({
    super.key,
    required this.initialQuery,
    required this.onSearch,
    required this.onClear,
    this.onFilter,
  });

  final String initialQuery;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final VoidCallback? onFilter;

  @override
  State<SearchInputBar> createState() => _SearchInputBarState();
}

class _SearchInputBarState extends State<SearchInputBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _hasText = widget.initialQuery.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Premium light gray background
        borderRadius: BorderRadius.circular(16), // Smooth modern radius
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            const SizedBox(width: 20),
            const Icon(
              Icons.search_rounded,
              color: Color(0xFF9CA3AF), // Subtle icon color
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: widget.onSearch,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search for talent, skills...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xFF111827),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            if (_hasText)
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF9CA3AF)),
                onPressed: () {
                  _controller.clear();
                  widget.onClear();
                },
              ),
            if (widget.onFilter != null && !_hasText) ...[
              const SizedBox(width: 8),
              Container(
                height: 32,
                width: 1,
                color: const Color(0xFFE5E7EB),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: widget.onFilter,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.tune_rounded, size: 22, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
            ] else if (!_hasText) ...[
              const SizedBox(width: 20),
            ]
          ],
        ),
      ),
    );
  }
}
