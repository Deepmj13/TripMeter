import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';

/// Opens one database file per signed-in user. The SQLCipher-compatible key is
/// generated on the device and stored in the platform keystore, never in the
/// database or in logs.
class DatabaseManager {
  DatabaseManager({
    FlutterSecureStorage? secureStorage,
    Future<Directory> Function()? directoryProvider,
    QueryExecutor Function(File file, String key)? executorFactory,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _directoryProvider =
            directoryProvider ?? getApplicationSupportDirectory,
        _executorFactory = executorFactory ?? _openEncrypted;

  final FlutterSecureStorage _secureStorage;
  final Future<Directory> Function() _directoryProvider;
  final QueryExecutor Function(File file, String key) _executorFactory;

  AppDatabase? _database;
  String? _userId;

  AppDatabase get database {
    final database = _database;
    if (database == null) {
      throw StateError('No local database is open for the current user');
    }
    return database;
  }

  String? get userId => _userId;
  bool get isOpen => _database != null;

  Future<AppDatabase> open(String userId) async {
    if (_database != null && _userId == userId) return _database!;
    await close(deleteFile: false);

    final directory = await _directoryProvider();
    await directory.create(recursive: true);
    final file = File('${directory.path}${Platform.pathSeparator}tripmeter_$userId.sqlite');
    final key = await _databaseKey(userId);
    final database = AppDatabase(_executorFactory(file, key));
    _database = database;
    _userId = userId;

    // Force the schema to be created and validate the key before the UI starts.
    await database.customSelect('SELECT 1').get();
    return database;
  }

  Future<void> close({bool deleteFile = false}) async {
    final database = _database;
    final userId = _userId;
    _database = null;
    _userId = null;
    if (database != null) {
      await database.close();
    }
    if (deleteFile && userId != null) {
      final directory = await _directoryProvider();
      for (final suffix in ['', '-wal', '-shm', '-journal']) {
        final file = File(
          '${directory.path}${Platform.pathSeparator}tripmeter_$userId.sqlite$suffix',
        );
        if (await file.exists()) {
          await file.delete();
        }
      }
      await _secureStorage.delete(key: _dbKeyName(userId));
    }
  }

  Future<String> _databaseKey(String userId) async {
    final name = _dbKeyName(userId);
    final existing = await _secureStorage.read(key: name);
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final key = base64UrlEncode(bytes);
    await _secureStorage.write(key: name, value: key);
    return key;
  }

  String _dbKeyName(String userId) => 'tripmeter.db_key.$userId';

  static QueryExecutor _openEncrypted(File file, String key) {
    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        final escaped = key.replaceAll("'", "''");
        database.execute("PRAGMA key = '$escaped'");
        database.execute('PRAGMA cipher_memory_security = ON');
      },
    );
  }
}
