// Models for the API response and nested objects.
//
// Notes about `factory` constructors used below:
// - A `factory` constructor is used to create an instance from a JSON map.
// - It allows running parsing logic and then returning an instance (or a cached/subclass instance)
//   instead of only assigning fields. It can also perform validation and transformation.
// - Using `factory ApiResponse.fromJson(...)` keeps JSON parsing logic colocated with the model.
//
// What if we don't use a `factory` to parse?
// - You could provide a regular named constructor (e.g. `ApiResponse.fromJson`) but a non-factory
//   constructor must initialize all final fields directly and cannot return different types.
// - Alternatively, you would parse JSON outside the model and call the default constructor with
//   parsed values; that scatters parsing logic across the codebase and makes testing harder.
// - `factory` is the idiomatic choice in Dart for parsing/deserializing where you may need
//   to perform logic before creating the instance.

class ApiResponse {
    String status;
    DateTime timestamp;
    Location location;
    List<Restaurant> restaurants;
    Pagination pagination;

    ApiResponse({
        required this.status,
        required this.timestamp,
        required this.location,
        required this.restaurants,
        required this.pagination,
    });

    // Factory constructor: converts a JSON map into an ApiResponse instance.
    // - `json` is the decoded Map<String, dynamic> from the HTTP response body.
    // - Inside the factory we call other `.fromJson` factories for nested objects
    //   (Location.fromJson, Restaurant.fromJson, Pagination.fromJson), so the
    //   entire object graph is created in one place.
    // - Using a `factory` here allows validation and transformation (e.g. parsing
    //   timestamp string to DateTime) before returning the constructed object.
    factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json["status"],
        timestamp: DateTime.parse(json["timestamp"]),
        location: Location.fromJson(json["location"]),
        restaurants: List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "timestamp": timestamp.toIso8601String(),
        "location": location.toJson(),
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
        "pagination": pagination.toJson(),
    };
}

class Location {
    String city;
    double latitude;
    double longitude;

    Location({
        required this.city,
        required this.latitude,
        required this.longitude,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        city: json["city"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "city": city,
        "latitude": latitude,
        "longitude": longitude,
    };
}

class Pagination {
    int page;
    int pageSize;
    int totalRestaurants;
    bool hasNextPage;

    Pagination({
        required this.page,
        required this.pageSize,
        required this.totalRestaurants,
        required this.hasNextPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        totalRestaurants: json["totalRestaurants"],
        hasNextPage: json["hasNextPage"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "totalRestaurants": totalRestaurants,
        "hasNextPage": hasNextPage,
    };
}

class Restaurant {
    String id;
    String name;
    Rating rating;
    List<String> cuisines;
    PriceRange priceRange;
    Delivery delivery;
    Address address;
    List<Offer>? offers;
    Menu? menu;

    Restaurant({
        required this.id,
        required this.name,
        required this.rating,
        required this.cuisines,
        required this.priceRange,
        required this.delivery,
        required this.address,
        this.offers,
        this.menu,
    });

    factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        rating: Rating.fromJson(json["rating"]),
        cuisines: List<String>.from(json["cuisines"].map((x) => x)),
        priceRange: PriceRange.fromJson(json["priceRange"]),
        delivery: Delivery.fromJson(json["delivery"]),
        address: Address.fromJson(json["address"]),
        offers: json["offers"] == null ? [] : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
        menu: json["menu"] == null ? null : Menu.fromJson(json["menu"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rating": rating.toJson(),
        "cuisines": List<dynamic>.from(cuisines.map((x) => x)),
        "priceRange": priceRange.toJson(),
        "delivery": delivery.toJson(),
        "address": address.toJson(),
        "offers": offers == null ? [] : List<dynamic>.from(offers!.map((x) => x.toJson())),
        "menu": menu?.toJson(),
    };
}

class Address {
    String street;
    String area;
    String city;
    String pincode;

    Address({
        required this.street,
        required this.area,
        required this.city,
        required this.pincode,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        area: json["area"],
        city: json["city"],
        pincode: json["pincode"],
    );

    Map<String, dynamic> toJson() => {
        "street": street,
        "area": area,
        "city": city,
        "pincode": pincode,
    };
}

class Delivery {
    bool available;
    String estimatedTime;
    int deliveryFee;

    Delivery({
        required this.available,
        required this.estimatedTime,
        required this.deliveryFee,
    });

    factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        available: json["available"],
        estimatedTime: json["estimatedTime"],
        deliveryFee: json["deliveryFee"],
    );

    Map<String, dynamic> toJson() => {
        "available": available,
        "estimatedTime": estimatedTime,
        "deliveryFee": deliveryFee,
    };
}

class Menu {
    List<Category> categories;

    Menu({
        required this.categories,
    });

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    };
}

class Category {
    String id;
    String name;
    List<Item> items;

    Category({
        required this.id,
        required this.name,
        required this.items,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    String id;
    String name;
    int price;
    bool isVeg;
    double rating;

    Item({
        required this.id,
        required this.name,
        required this.price,
        required this.isVeg,
        required this.rating,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        isVeg: json["isVeg"],
        rating: json["rating"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "isVeg": isVeg,
        "rating": rating,
    };
}

class Offer {
    String id;
    String title;
    String description;

    Offer({
        required this.id,
        required this.title,
        required this.description,
    });

    factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
    };
}

class PriceRange {
    String currency;
    int averageCostForTwo;

    PriceRange({
        required this.currency,
        required this.averageCostForTwo,
    });

    factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        currency: json["currency"],
        averageCostForTwo: json["averageCostForTwo"],
    );

    Map<String, dynamic> toJson() => {
        "currency": currency,
        "averageCostForTwo": averageCostForTwo,
    };
}

class Rating {
    double average;
    int votes;

    Rating({
        required this.average,
        required this.votes,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        average: json["average"]?.toDouble(),
        votes: json["votes"],
    );

    Map<String, dynamic> toJson() => {
        "average": average,
        "votes": votes,
    };
}
