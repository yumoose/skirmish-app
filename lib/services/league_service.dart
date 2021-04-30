import 'package:skirmish/exceptions/league_exception.dart';
import 'package:skirmish/models/league.dart';
import 'package:skirmish/utils/supabase.dart';
import 'package:supabase/supabase.dart';

class LeagueService {
  late SupabaseClient _supabase;

  LeagueService({SupabaseClient? supabase}) {
    _supabase = supabase ?? Supabase.client;
  }

  Future<Iterable<League>> leagues() async {
    final leaguesResponse =
        await _supabase.from('leagues').select().order('created_at').execute();

    if (leaguesResponse.error != null) {
      throw LeagueException('Failed to fetch leagues. Please try again later.');
    }

    final leaguesData = leaguesResponse.data as List;
    final leagues = leaguesData.map(
      (leagueData) => League.fromSupabase(leagueData),
    );

    return leagues;
  }

  Future<League> league({required String leagueId}) async {
    final leaguesResponse = await _supabase
        .from('leagues')
        .select()
        .eq('id', leagueId)
        .single()
        .execute();

    if (leaguesResponse.error != null) {
      throw LeagueException(
          'Failed to fetch league ($leagueId). Please try again later.');
    }

    final leagueData = leaguesResponse.data;
    final league = League.fromSupabase(leagueData);

    return league;
  }
}
