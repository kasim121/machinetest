# machinetest
# MachineTest API Calling (Flutter)

Lightweight Flutter sample that demonstrates calling a REST API, decoding JSON, and mapping it to typed Dart models.

## Project structure (important files)

- `lib/service/service.dart` — `ApiService` that performs an HTTP GET to a sample endpoint and returns an `ApiResponse` model.
- `lib/models/restaurant_response.dart` — model classes and `fromJson` factories that map API JSON to Dart objects.
- `lib/screens/` — example screens that show how to use the service with different state-management approaches.

## Quick start

Prerequisites:
- Flutter SDK installed (stable)
- macOS development setup for iOS (optional)

Steps:
1. Open terminal in this folder (`api/`).
2. Get packages:

   flutter pub get

3. Run the app:

   flutter run

## How the API call works (short)

- `ApiService.getRestaurants()` sends a GET request with `package:http`:
  - `final response = await http.get(Uri.parse(url));`
  - `response` is an `http.Response` containing `statusCode`, `headers`, `body` (String) and `bodyBytes` (Uint8List).
- If `statusCode == 200`, the service calls `jsonDecode(response.body)` to parse the JSON text into Dart objects.
  - `jsonDecode` expects a Dart `String` and returns `dynamic`: a `Map<String, dynamic>` when the JSON starts with `{`, or a `List<dynamic>` when it starts with `[`.
- The parsed value is passed to `ApiResponse.fromJson(json)` which constructs an `ApiResponse` instance with typed nested objects (Location, Restaurant, Menu, etc.).

There are "TRACE" comments in `service.dart` that document the exact JSON shape expected and what is assigned to `json` after decoding.

## Notes & recommendations

- Always check `response.statusCode` and `headers['content-type']` before calling `jsonDecode`.
- Wrap `jsonDecode` and `fromJson` calls in `try/catch` to handle malformed responses (FormatException or runtime errors from missing keys).
- `jsonDecode` is synchronous and CPU-bound. For large payloads consider offloading parsing to an isolate using `compute`.
- Make model `fromJson` factories defensive:
  - Normalize numeric types (handle both `int` and `double`, parse numeric strings).
  - Use null-aware access and provide sensible defaults for optional fields.
  - Accept alternate key names if the API is inconsistent (e.g., `lat` vs `latitude`).

## Example JSON

The project expects a top-level object similar to:

```json
{
  "status": "success",
  "timestamp": "2023-05-01T12:34:56Z",
  "location": { "lat": 12.34, "lng": 56.78 },
  "restaurants": [
    {
      "id": 1,
      "name": "Sushi Place",
      "cuisine": "Japanese",
      "delivery_time": 30,
      "rating": { "score": 4.5, "count": 123 },
      "menu": [ { "id": 10, "name": "Salmon Roll", "price": 9.99, "is_veg": false } ]
    }
  ],
  "pagination": { "page": 1, "per_page": 10, "total_pages": 2 }
}
```

## Next steps (optional)

- Make `fromJson` factories defensive (I can implement these changes).
- Add unit tests to validate parsing with valid and invalid payloads.
- Add error handling UI in screens to show network or parsing errors.

If you want, I can add defensive parsing to `lib/models/restaurant_response.dart` now.
