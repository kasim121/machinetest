import 'dart:convert'; // used to decode JSON response
import 'package:http/http.dart' as http; // http client
import '../models/restaurant_response.dart'; // ApiResponse model
import 'package:api/models/post.dart';

// ApiService: performs HTTP requests to fetch restaurant data
// - Uses `http` to make a GET request to a sample endpoint
// - Parses JSON response and converts it to `ApiResponse` model
// - Throws an exception when the HTTP request fails
class ApiService {
  // Endpoint returning the sample restaurant JSON
  static const String url =
      "https://mocki.io/v1/5c6bfbc3-d14d-4470-a694-12232e069393";

  // Fetches restaurants from the API.
  // Steps:
  // 1. Perform an HTTP GET request to the `url`.
  // 2. If the response status is 200, decode JSON and create `ApiResponse` via factory.
  // 3. If the response status is not 200, throw an exception to signal failure.
  Future<ApiResponse> getRestaurants() async {
    // Send GET request
    final response = await http.get(Uri.parse(url));
    // TRACE: `response` is an instance of `http.Response` with fields:
    // - statusCode (int): HTTP status code from server, e.g. 200 (OK), 404, 500.
    // - headers (Map<String, String>): response metadata, e.g. 'content-type': 'application/json; charset=utf-8'.
    // - body (String): full response payload decoded as a Dart String (use for jsonDecode).
    // - bodyBytes (Uint8List): raw bytes of the response body (useful for binary data).
    // - request (BaseRequest?): the original request object (may be null or present depending on client).
    // - isRedirect (bool), persistentConnection (bool), reasonPhrase (String?) depending on implementation.
    // Example runtime values:
    // - response.statusCode == 200
    // - response.headers['content-type'] == 'application/json; charset=utf-8'
    // - response.body == '{"status":"success", ... }' (raw JSON string)
    // Behavior notes:
    // - Network-level failures (DNS, socket, timeouts) throw exceptions before a Response is returned.
    // - Always check `statusCode` before parsing the body.
    // - Inspect `headers['content-type']` to confirm expected payload (JSON vs HTML).
    // - `response` is an immutable snapshot of the HTTP reply you received; parsing works on this data.

    // TRACE: response.statusCode -> HTTP status code (e.g., 200 means OK)
    // TRACE: response.headers -> response metadata (content-type, cache, etc.)
    // TRACE: response.body -> raw response payload as String
    // TRACE EXAMPLE: response.body (example JSON string):
    // {"status":"success","timestamp":"2023-05-01T12:34:56Z","location":{"lat":12.34,"lng":56.78},"restaurants":[{"id":1,"name":"Sushi Place","cuisine":"Japanese","delivery_time":30,"rating":{"score":4.5,"count":123},"menu":[{"id":10,"name":"Salmon Roll","price":9.99,"is_veg":false}]}],"pagination":{"page":1,"per_page":10,"total_pages":2}}

    // If successful, parse and return model
    if (response.statusCode == 200) {
      // Decode the raw JSON string into a Dart structure
      final json = jsonDecode(response.body);
      // TRACE: json = {
      //   'status': 'success',
      //   'timestamp': '2023-05-01T12:34:56Z',
      //   'location': { 'lat': 12.34, 'lng': 56.78 },
      //   'restaurants': [ { 'id': 1, 'name': 'Sushi Place', 'cuisine': 'Japanese', 'delivery_time': 30, 'rating': { 'score': 4.5, 'count': 123 }, 'menu': [ { 'id': 10, 'name': 'Salmon Roll', 'price': 9.99, 'is_veg': false } ] } ],
      //   'pagination': { 'page': 1, 'per_page': 10, 'total_pages': 2 }
      // }

      // TRACE: ApiResponse.fromJson(json) -> constructs and returns an ApiResponse instance
      // with typed nested objects (Location, List<Restaurant>, Pagination). It will throw if
      // required fields are missing or types are invalid.

      // Convert JSON map into strongly typed ApiResponse model
      return ApiResponse.fromJson(json);
      // TRACE: ApiResponse.fromJson(json) === ApiResponse(
      //   status: 'success',
      //   timestamp: DateTime.parse('2023-05-01T12:34:56Z'),
      //   location: Location(city: 'SomeCity', latitude: 12.34, longitude: 56.78),
      //   restaurants: [
      //     Restaurant(
      //       id: '1',
      //       name: 'Sushi Place',
      //       rating: Rating(average: 4.5, votes: 123),
      //       cuisines: ['Japanese'],
      //       priceRange: PriceRange(currency: 'USD', averageCostForTwo: 40),
      //       delivery: Delivery(available: true, estimatedTime: '30 mins', deliveryFee: 5),
      //       address: Address(street: '123 Main St', area: 'Downtown', city: 'SomeCity', pincode: '12345'),
      //       offers: [],
      //       menu: Menu(categories: [ Category(id: 'c1', name: 'Rolls', items: [ Item(id: '10', name: 'Salmon Roll', price: 999, isVeg: false, rating: 4.5) ]) ])
      //     )
      //   ],
      //   pagination: Pagination(page: 1, pageSize: 10, totalRestaurants: 12, hasNextPage: true)
      // ) -- (a Dart object instance, ready for use)
    }

    // TRACE: Non-200 response -> treated as error; caller receives exception
    throw Exception('Failed to load data');
  }

  // Fetch list of posts (example using jsonplaceholder)
  Future<List<Post>> getPosts() async {
    final postsUrl = 'https://jsonplaceholder.typicode.com/posts';
    final response = await http.get(Uri.parse(postsUrl));
    // TRACE: response.statusCode, response.body etc.
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load posts');
  }

  // Fetch single post by id
  Future<Post> getPostById(int id) async {
    final detailUrl = 'https://jsonplaceholder.typicode.com/posts/$id';
    final response = await http.get(Uri.parse(detailUrl));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Post.fromJson(json);
    }
    throw Exception('Failed to load post');
  }

  // Example of expected JSON payload and mapping to models:
  // {
  //   "status": "success",
  //   "timestamp": "2023-05-01T12:34:56Z", // becomes DateTime in ApiResponse
  //   "location": { "lat": 12.34, "lng": 56.78 },
  //   "restaurants": [
  //     {
  //       "id": 1,
  //       "name": "Sushi Place",
  //       "cuisine": "Japanese",
  //       "delivery_time": 30,
  //       "rating": { "score": 4.5, "count": 123 },
  //       "menu": [
  //         { "id": 10, "name": "Salmon Roll", "price": 9.99, "is_veg": false }
  //       ]
  //     }
  //   ],
  //   "pagination": { "page": 1, "per_page": 10, "total_pages": 2 }
  // }
  //
  // Object / parsing behavior (concise):
  // - ApiResponse.fromJson(json) reads top-level keys and converts `timestamp` (String) to DateTime.
  // - `restaurants` is a JSON array -> List<dynamic> -> mapped to List<Restaurant> via Restaurant.fromJson.
  // - Nested objects (Location, Rating, MenuItem, etc.) are constructed inside their own fromJson factories.
  // - Numeric types may arrive as int or double; model factories should normalize (e.g. toDouble()).
  // - Missing fields or type mismatches can cause the factories to throw; these exceptions bubble up to the caller.
  //
  // How changes in the API affect parsing and what to do:
  // - Field removed or renamed: use null-aware access (json['key']?) and provide default values to avoid exceptions.
  // - Field type changed (e.g., number -> string): add runtime checks and conversions in fromJson (parse string to num).
  // - Additional unexpected fields: ignored by fromJson unless explicitly read.
  // - For robust apps: validate keys, use try/catch around parsing, and surface friendly error messages to UI.
  //
  // Runtime flow in this service:
  // - HTTP 200: decode response.body (jsonDecode) and call ApiResponse.fromJson(json).
  //   * If model parsing succeeds, a fully-typed ApiResponse is returned.
  //   * If parsing fails, exception propagates and should be handled by caller (show error state).
  // - Non-200: this service throws Exception('Failed to load data') so caller can handle network/server errors.
  //
  // If you want, I can update the model factories to be defensive (safe parsing, defaults, type normalization).
}