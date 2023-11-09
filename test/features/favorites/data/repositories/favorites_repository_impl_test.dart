import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/success/write_success.dart';
import 'package:ecom_template/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:ecom_template/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesLocalDataSource extends Mock
    implements FavoritesLocalDataSource {}

void main() {
  late FavoritesRepositoryImpl repository;
  late MockFavoritesLocalDataSource mockFavoritesLocalDataSource;

  setUp(() {
    mockFavoritesLocalDataSource = MockFavoritesLocalDataSource();
    repository =
        FavoritesRepositoryImpl(localDataSource: mockFavoritesLocalDataSource);
  });

  group('getFavorites', () {
    final testFavorites = [
      const Favorite(
        parentProdId: 'test_id1',
      ),
      const Favorite(
        parentProdId: 'test_id2',
      ),
    ];
    test(
        'should return a list of favorites when datasource returns a valid list of favorites',
        () async {
      // arrange
      when(() => mockFavoritesLocalDataSource.getFavorites())
          .thenAnswer((_) async => testFavorites);

      // act
      final result = await repository.getFavorites();

      // assert
      verify(() => mockFavoritesLocalDataSource.getFavorites());
      expect(result, equals(Right(testFavorites)));
    });

    test('should return a CacheFailure when datasource throws an exception',
        () async {
      // arrange
      when(() => mockFavoritesLocalDataSource.getFavorites())
          .thenThrow(Exception());

      // act
      final result = await repository.getFavorites();

      // assert
      verify(() => mockFavoritesLocalDataSource.getFavorites());
      expect(result, equals(Left(CacheFailure())));
    });

    test(
        'should return a CacheFailure when the datasource returns the wrong datatype',
        () async {
      // arrange
      when(() => mockFavoritesLocalDataSource.getFavorites())
          .thenAnswer((_) async => ['test'] as List<Favorite>);

      // act
      final result = await repository.getFavorites();

      // assert
      verify(() => mockFavoritesLocalDataSource.getFavorites());
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('addFavorite', () {
    const testFavorite = Favorite(
      parentProdId: 'test_id1',
    );

    test('should return a WriteSuccess when the datasource returns a success',
        () async {
      // arrange
      when(() => mockFavoritesLocalDataSource.addFavorite(testFavorite))
          .thenAnswer((_) async => const WriteSuccess());

      // act
      final result = await repository.addFavorite(testFavorite);

      // assert
      verify(() => mockFavoritesLocalDataSource.addFavorite(testFavorite));
      expect(result, equals(const Right(WriteSuccess())));
    });

    test('should return a CacheFailure when the datasource throws an exception',
        () async {
      // arrange
      when(() => mockFavoritesLocalDataSource.addFavorite(testFavorite))
          .thenThrow(Exception());

      // act
      final result = await repository.addFavorite(testFavorite);

      // assert
      verify(() => mockFavoritesLocalDataSource.addFavorite(testFavorite));
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('removeFavorite', () {
    const testFavorite = Favorite(
      parentProdId: 'test_id1',
    );

    test('should return a WriteSuccess when the datasource returns a success',
        () async {
      // arrange
      when(() => mockFavoritesLocalDataSource
              .removeFavorite(testFavorite.parentProdId))
          .thenAnswer((_) async => const WriteSuccess());

      // act
      final result = await repository.removeFavorite(testFavorite);

      // assert
      verify(() => mockFavoritesLocalDataSource
          .removeFavorite(testFavorite.parentProdId));
      expect(result, equals(const Right(WriteSuccess())));
    });

    test('should return a CacheFailure when the datasource throws an exception',
        () async {
      // arrange
      when(() => mockFavoritesLocalDataSource
          .removeFavorite(testFavorite.parentProdId)).thenThrow(Exception());

      // act
      final result = await repository.removeFavorite(testFavorite);

      // assert
      verify(() => mockFavoritesLocalDataSource
          .removeFavorite(testFavorite.parentProdId));
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
