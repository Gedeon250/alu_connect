import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/communities_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/community_card.dart';
import '../../widgets/custom_text_field.dart' as ctf;

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communities = context.watch<CommunitiesProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabs(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(communities.search(_query),
                      communities, showAll: true),
                  _buildList(
                    communities.myCommunities
                        .where((c) => c.name
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                        .toList(),
                    communities,
                    emptyMsg: "You haven't joined any communities yet",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Communities',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(Icons.add,
                color: AppColors.primary, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: ctf.SearchBar(
        hint: 'Search communities...',
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _query = v),
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AppColors.primary,
      indicatorWeight: 3,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textMuted,
      labelStyle:
          const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      tabs: const [Tab(text: 'All Clubs'), Tab(text: 'My Clubs')],
    );
  }

  Widget _buildList(
    List communities,
    CommunitiesProvider provider, {
    bool showAll = false,
    String emptyMsg = 'No communities found',
  }) {
    if (communities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.group_off_outlined,
                size: 56, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(emptyMsg,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 15)),
            const SizedBox(height: 8),
            if (!showAll)
              const Text('Explore communities and join ones you like',
                  style: TextStyle(
                      color: AppColors.textMuted, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: communities.length,
      itemBuilder: (context, i) => CommunityCard(
        community: communities[i],
        onJoin: () => provider.toggleJoin(communities[i].id),
        onTap: () => _showCommunityDetail(context, communities[i]),
      ),
    );
  }

  void _showCommunityDetail(BuildContext context, dynamic community) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CommunityDetailSheet(community: community),
    );
  }
}

class _CommunityDetailSheet extends StatelessWidget {
  final dynamic community;

  const _CommunityDetailSheet({required this.community});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(community.imageUrl),
                    backgroundColor: AppColors.surface,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          community.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          community.category,
                          style: const TextStyle(
                              color: AppColors.primary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat('${community.memberCount}', 'Members'),
                  _stat(community.isJoined ? 'Joined' : 'Not joined', 'Status'),
                  _stat(community.leaderName.split(' ').first, 'Leader'),
                ],
              ),
              const Divider(color: AppColors.divider, height: 28),
              const Text(
                'About',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                community.description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<CommunitiesProvider>()
                        .toggleJoin(community.id);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: community.isJoined
                        ? AppColors.surface
                        : AppColors.primary,
                    foregroundColor: community.isJoined
                        ? AppColors.textSecondary
                        : Colors.black,
                    side: community.isJoined
                        ? const BorderSide(color: AppColors.divider)
                        : null,
                  ),
                  child: Text(
                      community.isJoined ? 'Leave Community' : 'Join Community'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}
