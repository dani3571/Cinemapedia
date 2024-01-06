import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDataSource extends LocalStorageDataSource {
  late Future<Isar> db;

  IsarDataSource() {
    db = openDb();
  }
  Future<Isar> openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    // Si no tenemos instancias ...
    if (Isar.instanceNames.isEmpty) {
      final isar =
          await Isar.open([MovieSchema], inspector: true, directory: dir.path);
      return isar;
    }
    // Si ya se tiene la instancia que retorne la misma
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();
    return isFavoriteMovie != null ? true : false;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();

    if (favoriteMovie == null) {
      // Insertar
      isar.writeTxnSync(() => isar.movies.putSync(movie));
    } else {
      // Borrar
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
    }
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;

    return isar.movies.where().offset(offset).limit(limit).findAll();
  }
}
