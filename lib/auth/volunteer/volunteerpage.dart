import 'package:flutter/material.dart';
import 'package:front/auth/volunteer/post_model.dart';
import 'package:front/auth/volunteer/post_service.dart';
import 'package:front/auth/volunteer/post_card.dart';
import 'package:front/color.dart';

class VolunteerHome extends StatefulWidget {
  const VolunteerHome({super.key});

  @override
  State<VolunteerHome> createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends State<VolunteerHome> {
  late Future<List<Post>> futurePosts;

  // ===== Filters state =====
  String selectedStatus = 'All';
  String selectedCondition = 'All';
  String selectedCity = 'All';
  bool newestFirst = true;

  // ===== Cities list =====
  final List<String> cities = [
    'Amman',
    'Irbid',
    'Zarqa',
    'Aqaba',
    'Salt',
    'Madaba',
    'Karak',
    'Tafilah',
    'Ma\'an',
    'Ajloun',
    'Jerash',
  ];

  @override
  void initState() {
    super.initState();
    futurePosts = PostService.getPosts();
  }

  // ===== Apply filters (Front-end only) =====
  List<Post> _applyFilters(List<Post> posts) {
    List<Post> filtered = posts;

    if (selectedStatus != 'All') {
      filtered = filtered
          .where((p) => _mapStateToStatus(p.state) == selectedStatus)
          .toList();
    }

    filtered.sort((a, b) => newestFirst
        ? b.created_at.compareTo(a.created_at)
        : a.created_at.compareTo(b.created_at));

    return filtered;
  }

  // ===== Bottom Sheet =====
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Filter Requests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// 🔹 Status
                    const _SectionTitle('Request Status'),
                    Wrap(
                      spacing: 8,
                      children: [
                        _filterChip(
                          'All',
                          selectedStatus == 'All',
                          Colors.blueGrey,
                          () => setModalState(() => selectedStatus = 'All'),
                        ),
                        _filterChip(
                          'Pending',
                          selectedStatus == 'Pending',
                          Colors.orange,
                          () => setModalState(() => selectedStatus = 'Pending'),
                        ),
                        _filterChip(
                          'Accepted',
                          selectedStatus == 'Accepted',
                          Colors.green,
                          () =>
                              setModalState(() => selectedStatus = 'Accepted'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 Patient Condition
                    const _SectionTitle('Patient Condition'),
                    Wrap(
                      spacing: 8,
                      children: [
                        _filterChip(
                          'All',
                          selectedCondition == 'All',
                          Colors.blueGrey,
                          () => setModalState(() => selectedCondition = 'All'),
                        ),
                        _filterChip(
                          'Visually Impaired',
                          selectedCondition == 'Visually Impaired',
                          Colors.purple,
                          () => setModalState(
                              () => selectedCondition = 'Visually Impaired'),
                        ),
                        _filterChip(
                          'Hearing Impaired',
                          selectedCondition == 'Hearing Impaired',
                          Colors.indigo,
                          () => setModalState(
                              () => selectedCondition = 'Hearing Impaired'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 City (من List)
                    const _SectionTitle('City'),
                    Wrap(
                      spacing: 8,
                      children: [
                        _filterChip(
                          'All',
                          selectedCity == 'All',
                          Colors.blueGrey,
                          () => setModalState(() => selectedCity = 'All'),
                        ),
                        ...cities.map(
                          (city) => _filterChip(
                            city,
                            selectedCity == city,
                            Colors.green,
                            () => setModalState(() => selectedCity = city),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 Sort
                    const _SectionTitle('Sort by Time'),
                    RadioListTile<bool>(
                      title: const Text('Newest first'),
                      value: true,
                      groupValue: newestFirst,
                      activeColor: AppColors.primaryColor,
                      onChanged: (v) => setModalState(() => newestFirst = v!),
                    ),
                    RadioListTile<bool>(
                      title: const Text('Oldest first'),
                      value: false,
                      groupValue: newestFirst,
                      activeColor: AppColors.primaryColor,
                      onChanged: (v) => setModalState(() => newestFirst = v!),
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 Actions
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedStatus = 'All';
                              selectedCondition = 'All';
                              selectedCity = 'All';
                              newestFirst = true;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: AppColors.accent),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text(
          "Help Requests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredPosts = _applyFilters(snapshot.data!);

          if (filteredPosts.isEmpty) {
            return const Center(
              child: Text('No requests match your filters'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filteredPosts.length,
            itemBuilder: (_, i) => PostCard(post: filteredPosts[i]),
          );
        },
      ),
    );
  }
}

/// ===== Helpers =====

Widget _filterChip(
  String label,
  bool selected,
  Color color,
  VoidCallback onTap,
) {
  return ChoiceChip(
    showCheckmark: false,
    selected: selected,
    onSelected: (_) => onTap(),
    selectedColor: color.withOpacity(0.20),
    backgroundColor: AppColors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(19),
      side: BorderSide(
        color: selected ? color : AppColors.background,
      ),
    ),
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selected) ...[
          Icon(Icons.check, size: 16, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            color: selected ? color : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}

/// ===== Utils =====
String _mapStateToStatus(int? state) {
  switch (state) {
    case 0:
      return 'Pending';
    case 1:
      return 'Accepted';
    default:
      return 'All';
  }
}
