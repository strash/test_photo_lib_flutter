import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart";
import "package:test_photo_lib/data/db/migration_service.dart";

final class AppDatabase {
  Future<Database>? _db;
  final _migrations = MigrationService();

  static final AppDatabase _instance = AppDatabase._();

  factory AppDatabase.instance() => _instance;

  AppDatabase._();

  Future<Database> get db {
    _db ??= _openDb();
    return _db!;
  }

  Future<Database> _openDb() async {
    final String dbPath = await getDatabasesPath();
    final pathToDatabase = path.join(dbPath, "db");
    return await openDatabase(
      pathToDatabase,
      version: const int.fromEnvironment("MIGRATION_VERSION", defaultValue: 1),
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
        await db.rawQuery("PRAGMA journal_mode = WAL");
        await db.execute("VACUUM;");
      },
      onCreate: (db, version) {
        _migrations.getFor(0, version).forEach((e) async => await e().up(db));
      },
      onUpgrade: (db, from, to) {
        _migrations.getFor(from, to).forEach((e) async => await e().up(db));
      },
      onDowngrade: (db, from, to) {
        _migrations.getFor(from, to).forEach((e) async => await e().down(db));
      },
    );
  }
}
