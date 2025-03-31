import "dart:math";

import "package:flutter/foundation.dart";
import "package:test_photo_lib/data/db/migrations/migrations.dart";

final class MigrationService {
  List<BaseMigration Function()> get _migrations {
    return [() => DummyMigration1(), () => CreatePhotosTableMigration2()];
  }

  Iterable<BaseMigration Function()> getFor(int from, int to) {
    if (_migrations.isEmpty) throw Exception("There's no migrations!");

    // NOTE: initial migration
    if (from == 0 && to == 1) return _migrations.take(1);

    final list = List<BaseMigration Function()>.from(
      _migrations,
    ).toList(growable: false);

    final isUp = from < to;
    final (lhs, rhs) = (max(0, from), max(0, to));
    final begin = min(lhs, rhs);
    final range = (max(from, to) - min(from, to)).toInt();
    final migrations = list.skip(begin).take(range);
    final m = (isUp ? migrations : migrations.toList(growable: false).reversed);

    if (kDebugMode) {
      final fold = m.fold("\n", (prev, e) {
        return "$prev\t ${isUp ? "✅" : "❌"} ${e.runtimeType}\n";
      });
      print("💿 MIGRATIONS: ${isUp ? "🔼" : "🔽"} from $from to $to: $fold");
    }

    return m;
  }
}
