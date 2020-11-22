import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/exceptions.dart';
import 'package:mobile/services/http_service.dart';
import 'package:mobile/testing/mocks.dart';
import 'package:mockito/mockito.dart';

const BASE_URL = 'some-url';

void main() {
  HttpService httpService;
  MockClient mockClient = MockClient();

  group('Get call', () {
    setUp(() => {httpService = HttpService(BASE_URL, mockClient)});

    test('with 200 response, should return good response.', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
          (_) async => http.Response('{"title": "some-title"}', 200));

      // Act
      dynamic actual = await httpService.get('some-url');

      // Assert
      verify(mockClient.get(captureAny)).called(1);
      expect(actual, {'title': 'some-title'});
    });

    test('with 400 response, should throw bad request exception.', () {
      // Arrange
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('', 400));

      // Assert
      expect(httpService.get('some-url'), throwsA(isA<BadRequestException>()));
    });

    test('with 401 response, should throw unauthorized exception.', () {
      // Arrange
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('', 401));

      // Assert
      expect(
          httpService.get('some-url'), throwsA(isA<UnauthorisedException>()));
    });

    test('with 404 response, should throw not found exception.', () {
      // Arrange
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('', 404));

      // Assert
      expect(httpService.get('some-url'), throwsA(isA<NotFoundException>()));
    });

    test('with 500 response, should throw fetch data exception.', () {
      // Arrange
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('', 500));

      // Assert
      expect(httpService.get('some-url'), throwsA(isA<FetchDataException>()));
    });
  });

  group('Post call', () {
    setUp(() => {httpService = HttpService(BASE_URL, mockClient)});

    test('with 200 response, should return good response.', () async {
      // Arrange
      when(mockClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response('{"title": "some-title"}', 200));

      // Act
      dynamic actual =
          await httpService.post('some-url', {'some-data': 'some-content'});

      // Assert
      expect(actual, {'title': 'some-title'});
    });
  });
}
