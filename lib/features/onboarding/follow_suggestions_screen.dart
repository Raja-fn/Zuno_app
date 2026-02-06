import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/follow_service.dart';
import '../navigation/main_navigation.dart';

class FollowSuggestionsScreen extends StatelessWidget {
  const FollowSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Follow people")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase
            .from('profiles')
            .select('id, username, avatar_url')
            .neq('id', currentUserId)
            .limit(20),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;
          final followService = FollowService();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: u['avatar_url'] != null
                            ? NetworkImage(u['avatar_url'])
                            : null,
                        child: u['avatar_url'] == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(u['username']),
                      trailing: ElevatedButton(
                        onPressed: () =>
                            followService.follow(u['id']),
                        child: const Text("Follow"),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text("Continue"),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigation(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
