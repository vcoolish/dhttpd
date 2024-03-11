import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:dhttpd/src/options.dart';

Future<void> main(List<String> args) async {
  Options options;
  try {
    options = parseOptions(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    print(usage);
    exitCode = 64;
    return;
  }

  if (options.help) {
    print(usage);
    return;
  }

  final herokuPort = int.tryParse(Platform.environment['PORT'] ?? '8080');
  
  await Dhttpd.start(
    path: options.path,
    port: herokuPort ?? 8080,
    headers:
        options.headers != null ? _parseKeyValuePairs(options.headers!) : null,
    address: options.host,
  );

  
  print('Server started on port ${herokuPort ?? 8080}');
}

Map<String, String> _parseKeyValuePairs(String str) => <String, String>{
      for (var match in _regex.allMatches(str))
        match.group(1)!: match.group(2)!,
    };

final _regex = RegExp(r'([\w-]+)=([\w-]+)(;|$)');
