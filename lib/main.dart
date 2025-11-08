import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cachefilehelper.dart';
part 'apiservice.dart';
part 'ygobinder.dart';
part 'ygobinderstate.dart';
part 'myapp.dart';
part 'loadingapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const YGOBinder());
}