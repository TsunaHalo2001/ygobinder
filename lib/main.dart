import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'filehelper.dart';
part 'apiservice.dart';
part 'cardclasses.dart';
part 'ygobinder.dart';
part 'ygobinderstate.dart';
part 'myapp.dart';
part 'loadingapp.dart';
part 'homepage.dart';
part 'cardlistapp.dart';
part 'carddetailpageapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const YGOBinder());
}