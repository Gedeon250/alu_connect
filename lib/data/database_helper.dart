import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';

class DatabaseHelper {
  static Database? _db;
  static const String _dbName = 'alu_connect.db';
  static const int _version = 1;

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE saved_events (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        event_type TEXT NOT NULL,
        date_time TEXT NOT NULL,
        location TEXT NOT NULL,
        campus TEXT NOT NULL,
        image_url TEXT NOT NULL,
        saved_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE rsvp_events (
        event_id TEXT PRIMARY KEY,
        status TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  static Future<void> saveRsvp(String eventId, RsvpStatus status) async {
    final db = await database;
    await db.insert(
      'rsvp_events',
      {
        'event_id': eventId,
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeRsvp(String eventId) async {
    final db = await database;
    await db.delete('rsvp_events',
        where: 'event_id = ?', whereArgs: [eventId]);
  }

  static Future<Map<String, String>> getAllRsvps() async {
    final db = await database;
    final rows = await db.query('rsvp_events');
    return {for (var r in rows) r['event_id'] as String: r['status'] as String};
  }

  static Future<void> saveEvent(Event event) async {
    final db = await database;
    await db.insert(
      'saved_events',
      {
        'id': event.id,
        'title': event.title,
        'event_type': event.type.name,
        'date_time': event.dateTime.toIso8601String(),
        'location': event.location,
        'campus': event.campus,
        'image_url': event.imageUrl,
        'saved_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> unsaveEvent(String eventId) async {
    final db = await database;
    await db.delete('saved_events', where: 'id = ?', whereArgs: [eventId]);
  }

  static Future<bool> isEventSaved(String eventId) async {
    final db = await database;
    final rows = await db
        .query('saved_events', where: 'id = ?', whereArgs: [eventId]);
    return rows.isNotEmpty;
  }
}
