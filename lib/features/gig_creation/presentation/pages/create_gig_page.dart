import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/gig_entity.dart';
import '../bloc/gig_creation_bloc.dart';
import '../bloc/gig_creation_event.dart';
import '../bloc/gig_creation_state.dart';

class CreateGigPage extends StatefulWidget {
  const CreateGigPage({super.key});

  @override
  State<CreateGigPage> createState() => _CreateGigPageState();
}

class _CreateGigPageState extends State<CreateGigPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _daysController = TextEditingController();

  String _selectedCategory = 'Mobile Development';
  final List<String> _categories = [
    'Mobile Development',
    'Web Development',
    'UI/UX Design',
    'Backend API',
    'AI Integration'
  ];

  void _submitGig() {
    final gig = GigEntity(
      id: 'new_gig',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0.0,
      deliveryDays: int.tryParse(_daysController.text) ?? 0,
      imageUrl: 'https://i.pravatar.cc/150?img=11', // Placeholder
    );

    context.read<GigCreationBloc>().add(GigSubmitted(gig));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GigCreationBloc, GigCreationState>(
      listener: (context, state) {
        if (state.status == GigCreationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service Published Successfully!')),
          );
          context.pop(); // Go back to dashboard
        } else if (state.status == GigCreationStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Color(0xFF111827)),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Create Service',
            style: AppTypography.headingMedium.copyWith(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Let\'s set up your service',
                    style: AppTypography.headingLarge.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Give details so clients know what you offer.',
                    style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader('1. Photo & Basics'),
                  // Image Upload Placeholder
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), style: BorderStyle.solid, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add_photo_alternate_rounded, size: 32, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        Text('Upload Cover Image', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                        const SizedBox(height: 4),
                        Text('Good photos get more buyers.', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader('2. Service Details'),
                  // Category
                  Text('Category', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text('Choose the best category for your work.', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B7280)),
                        items: _categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Row(
                              children: [
                                const Icon(Icons.category_outlined, size: 18, color: Color(0xFF6B7280)),
                                const SizedBox(width: 12),
                                Text(cat, style: AppTypography.bodyMedium.copyWith(color: Colors.black)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text('Service Title', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text('Keep it short and clear.', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'e.g. I will build a full flutter app',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text('Full Description', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text('Explain exactly what you will do.', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.black),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Describe your work here...',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildSectionHeader('3. Price & Time'),
                  // Price & Delivery Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Price', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 4),
                            Text('How much will you charge?', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _priceController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                                prefixIcon: const Icon(Icons.attach_money_rounded, color: Color(0xFF6B7280)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery Time', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 4),
                            Text('How many days to finish?', style: AppTypography.caption.copyWith(color: const Color(0xFF6B7280))),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _daysController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '7',
                                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                                suffixText: 'Days',
                                suffixStyle: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6B7280)),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Action
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16), // Reduced bottom padding, SafeArea handles it
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -10)),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: BlocBuilder<GigCreationBloc, GigCreationState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        label: 'Publish Service',
                        showIcon: false,
                        isLoading: state.status == GigCreationStatus.loading,
                        onTap: _submitGig,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTypography.headingSmall.copyWith(
          color: const Color(0xFF111827),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
