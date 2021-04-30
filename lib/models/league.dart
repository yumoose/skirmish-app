import 'package:equatable/equatable.dart';

class League extends Equatable {
  final String id;
  final String name;
  final String description;
  final int startRating;
  final double kFactor;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String accentColor;
  final String visibility;
  final String? customIconUrl;

  @override
  List<Object> get props => [id, name];

  League.fromSupabase(leagueData)
      : id = (leagueData['id'] as int).toString(),
        name = leagueData['name'] as String,
        description = leagueData['description'] as String,
        startRating = int.tryParse(
              leagueData['start_rating'].toString(),
            ) ??
            1000,
        kFactor = double.tryParse(
              leagueData['k_factor'].toString(),
            ) ??
            32,
        createdAt = DateTime.parse(leagueData['created_at'] as String),
        updatedAt = DateTime.parse(leagueData['updated_at'] as String),
        accentColor = leagueData['accent_color'] as String,
        visibility = leagueData['visibility'] as String,
        customIconUrl = leagueData['custom_icon_url'] as String?;
}
