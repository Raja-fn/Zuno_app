class Community {
  final String id;
  final String name;
  final String description;
  final int members;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
  });

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      members: map['members'] ?? 0,
    );
  }
}
