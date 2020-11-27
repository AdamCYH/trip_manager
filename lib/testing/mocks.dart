import 'package:http/http.dart' as http;
import 'package:mobile/services/http_service.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {}

class MockHttpService extends Mock implements HttpService {}
