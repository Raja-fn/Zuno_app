import 'package:flutter/material.dart';
import '../../models/community_model.dart';
import '../../services/community_service.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final service = CommunityService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget _communityList(Future<List<Community>> future, {bool joinable = false}) {
    return FutureBuilder<List<Community>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final communities = snapshot.data!;
        if (communities.isEmpty) {
          return const Center(child: Text("Nothing here yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: communities.length,
          itemBuilder: (context, index) {
            final c = communities[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                title: Text(c.name),
                subtitle: Text("${c.members} members"),
                trailing: joinable
                    ? ElevatedButton(
                  onPressed: () async {
                    await service.joinCommunity(c.id);
                    setState(() {});
                  },
                  child: const Text("Join"),
                )
                    : const Icon(Icons.check_circle, color: Colors.green),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Explore"),
            Tab(text: "Joined"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _communityList(service.fetchExploreCommunities(), joinable: true),
          _communityList(service.fetchJoinedCommunities()),
        ],
      ),
    );
  }
}
