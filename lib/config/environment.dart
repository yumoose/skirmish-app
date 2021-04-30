import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Environment {
  static Future loadEnvironment() async => await dot_env.load();

  static String get supabaseUrl => env['SUPABASE_URL']!;
  static String get supabaseKey => env['SUPABASE_KEY']!;
}
