import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:template_app/services/dev_logger/dev_logger.dart';
import 'package:template_app/services/isar/isar_service.dart';

class BaseRepository<CollectionType> {
  ProviderRef ref;
  late Future<Isar> isar;
  late DevLogger log;

  BaseRepository(this.ref, String logGroup) {
    isar = ref.read(isarPod.future);
    log = DevLogger(logGroup);
  }

  Stream<List<CollectionType>> listenAll() async* {
    final db = await isar;

    yield* db.collection<CollectionType>().where().watch(fireImmediately: true);
  }

  Future<List<CollectionType>> getAll() async {
    final db = await isar;
    return db.collection<CollectionType>().where().findAll();
  }

  Stream<CollectionType> listenById(Id id) async* {
    final db = await isar;
    yield* db
        .collection<CollectionType>()
        .watchObject(id, fireImmediately: true)
        .cast();
  }

  Future<CollectionType?> getById(Id id) async {
    final db = await isar;
    final collection = db.collection<CollectionType>();
    return collection.get(id);
  }

  Future<int> save(CollectionType collection) async {
    final db = await isar;
    return db.writeTxn<int>(() {
      return db.collection<CollectionType>().put(collection);
    });
  }

  Future<void> delete(Id id) async {
    final db = await isar;
    db.writeTxn(() {
      return db.collection<CollectionType>().delete(id);
    });
  }
}
