class MovieCastModel {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  MovieCastModel({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory MovieCastModel.fromMap(Map<String, dynamic> map) {
    return MovieCastModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      character: map['character'] ?? '',
      profilePath: map['profile_path'],
    );
  }
}
