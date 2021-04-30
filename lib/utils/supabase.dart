import 'package:skirmish/config/environment.dart';
import 'package:supabase/supabase.dart';
import 'package:postgrest/src/count_option.dart';

abstract class Supabase {
  static final SupabaseClient _singleton = SupabaseClient(
    Environment.supabaseUrl,
    Environment.supabaseKey,
  );

  static SupabaseClient get client => _singleton;

  static CountOption get exactCount => CountOption.exact;
}
