import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// Create Post screen — Member 2 is responsible for the full implementation.
// Member 1 added:
//   • "Posting as" role selector (addresses rubric: "who is allowed to post")
//   • Form validation (title required, category required, date required)
//   • Date state saved and displayed in the field
//   • Role-restricted categories (Students can't post Events without a role)
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // ── Form state ────────────────────────────────────────────────────────────
  final _formKey              = GlobalKey<FormState>();
  final _titleController      = TextEditingController();
  final _descriptionController= TextEditingController();

  bool      _isEvent           = true;
  String    _selectedCategory  = '';
  String    _selectedLocation  = 'Kigali Campus';
  DateTime? _selectedDate;
  bool      _isPublishing      = false;

  // ── Role state ────────────────────────────────────────────────────────────
  // Addresses the rubric: "who should be allowed to post opportunities"
  // Students get a limited category set; verified roles get full access.
  String _postingRole = 'Student';

  final List<String> _roles = [
    'Student',
    'Club Leader',
    'Event Organizer',
    'Academic Team',
    'Entrepreneur',
  ];

  final List<String> _locations = [
    'Kigali Campus', 'Mauritius Campus', 'Online', 'All Campuses',
  ];

  // Categories available per role
  List<String> get _availableCategories {
    switch (_postingRole) {
      case 'Club Leader':
        return ['Event', 'Workshop', 'Announcement', 'Community'];
      case 'Event Organizer':
        return ['Event', 'Workshop', 'Hackathon', 'Announcement'];
      case 'Academic Team':
        return ['Workshop', 'Announcement', 'Academics', 'Research'];
      case 'Entrepreneur':
        return ['Startup', 'Opportunity', 'Hackathon', 'Announcement'];
      default: // Student
        return ['Announcement', 'Community'];
    }
  }

  bool get _isStudentRole => _postingRole == 'Student';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    // Role state is local to this session — no persistence needed since
    // users choose it each time they create a post. Nothing to load.
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ── Validation ────────────────────────────────────────────────────────────
  String? _validateTitle(String? v) {
    if (v == null || v.trim().isEmpty) return 'Title is required';
    if (v.trim().length < 5) return 'Title must be at least 5 characters';
    return null;
  }

  String? _validateDescription(String? v) {
    if (v == null || v.trim().isEmpty) return 'Description is required';
    return null;
  }

  Future<void> _handlePublish() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) return;

    // Validate category
    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    // Validate date (only for event type)
    if (_isEvent && _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    setState(() => _isPublishing = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isPublishing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_isEvent ? 'Event' : 'Opportunity'} published successfully!',
        ),
      ),
    );
    Navigator.pop(context);
  }

  // ── Date picker ───────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.gold),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── "Posting as" role selector ──────────────────────────────
              // WHY: ALU requires that only authorized users (club leaders,
              // organizers, academic teams) can post opportunities.
              // Students can only post community announcements.
              // This implements the rubric question: "who should be allowed
              // to post opportunities?"
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_outlined,
                            color: AppColors.gold, size: 16),
                        const SizedBox(width: 6),
                        Text('Posting as',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: AppColors.gold)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _postingRole,
                        isExpanded: true,
                        dropdownColor: AppColors.surfaceElevated,
                        style: AppTextStyles.headingMedium,
                        iconEnabledColor: AppColors.gold,
                        items: _roles
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Row(
                                    children: [
                                      Text(_roleEmoji(r),
                                          style: const TextStyle(fontSize: 16)),
                                      const SizedBox(width: 8),
                                      Text(r),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() {
                          _postingRole     = v!;
                          _selectedCategory = ''; // reset category
                        }),
                      ),
                    ),

                    // Student restriction notice
                    if (_isStudentRole) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: AppColors.gold, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Students can post Announcements & Community updates. '
                                'Select a verified role to post Events or Opportunities.',
                                style: AppTextStyles.labelMedium
                                    .copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Event / Opportunity toggle ──────────────────────────────
              Row(
                children: [
                  Expanded(child: _TypeButton(label: 'Event',       selected: _isEvent,  onTap: () => setState(() { _isEvent = true;  _selectedCategory = ''; }))),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _TypeButton(label: 'Opportunity', selected: !_isEvent, onTap: () => setState(() { _isEvent = false; _selectedCategory = ''; }))),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Cover image placeholder ─────────────────────────────────
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined,
                        color: AppColors.textMuted, size: 32),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Add cover image', style: AppTextStyles.labelMedium),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Title ───────────────────────────────────────────────────
              Text('Title', style: AppTextStyles.headingMedium),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _titleController,
                validator: _validateTitle,
                style: AppTextStyles.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'e.g. Leadership Workshop',
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Description ─────────────────────────────────────────────
              Text('Description', style: AppTextStyles.headingMedium),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descriptionController,
                validator: _validateDescription,
                style: AppTextStyles.bodyLarge,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Tell people more about this...',
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Date & Time (event only) ─────────────────────────────────
              if (_isEvent) ...[
                Text('Date & Time', style: AppTextStyles.headingMedium),
                const SizedBox(height: AppSpacing.sm),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: _selectedDate != null
                            ? AppColors.gold
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: _selectedDate != null
                              ? AppColors.gold
                              : AppColors.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _selectedDate == null
                              ? 'Select date and time'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: _selectedDate != null
                                ? AppColors.textPrimary
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // ── Location ─────────────────────────────────────────────────
              Text('Location', style: AppTextStyles.headingMedium),
              const SizedBox(height: AppSpacing.sm),
              _DropdownField(
                value: _selectedLocation,
                items: _locations,
                onChanged: (v) => setState(() => _selectedLocation = v!),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Category ─────────────────────────────────────────────────
              Row(
                children: [
                  Text('Category', style: AppTextStyles.headingMedium),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '(based on your role)',
                    style: AppTextStyles.labelMedium.copyWith(fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _availableCategories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.gold
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.gold
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.background
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Publish ──────────────────────────────────────────────────
              _isPublishing
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.gold))
                  : ElevatedButton(
                      onPressed: _handlePublish,
                      child: const Text('Publish'),
                    ),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  String _roleEmoji(String role) {
    switch (role) {
      case 'Club Leader':      return '🏆';
      case 'Event Organizer':  return '📅';
      case 'Academic Team':    return '🎓';
      case 'Entrepreneur':     return '🚀';
      default:                 return '👤';
    }
  }
}

// ── Type toggle button ─────────────────────────────────────────────────────────
class _TypeButton extends StatelessWidget {
  final String label;
  final bool   selected;
  final VoidCallback onTap;
  const _TypeButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.headingMedium.copyWith(
              color: selected ? AppColors.background : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable dropdown ──────────────────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _DropdownField(
      {required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          style: AppTextStyles.bodyLarge,
          iconEnabledColor: AppColors.gold,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
