import 'package:flutter/material.dart';
import 'package:sdtudy_flow/app/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nlihgsqreneeywimtzgc.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5saWhnc3FyZW5lZXl3aW10emdjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA2MjYwNjYsImV4cCI6MjA3NjIwMjA2Nn0.Lj5TLaQg3SSps_kUI4MqjV6SlkenwNNQr1eIBLpYfSI',
  );
  runApp(const MyApp());
}
