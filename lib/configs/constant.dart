import 'package:flutter/material.dart';

class Constant {
  static const primaryColor = Color(0xFF3F72AF);
  static const backgroundColor = Color(0xFFF9F7F7);
  static const secondaryColor = Color(0xFF112D4E);
  static const onPrimaryColor = Color(0xFFFFFFFF);
  static const textColor = Color(0xFF000000);
  static const backgroundWithOpacity = Color(0xFFDBE2EF);

  // API
  // static const String baseURL = "http://34.16.137.128";
  static const String baseURL = "http://localhost:4567";
  static const String token =
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZnVsbG5hbWUiOiJOZ3V5ZW4gTmdvYyBRdWFuZyIsImVtYWlsIjoibm5xdWFuZzIwQGNsYy5maXR1cy5lZHUudm4iLCJyb2xlcyI6WzBdLCJpYXQiOjE3MTI5NDA3NjksImV4cCI6MTcxNDE1MDM2OX0.ccOxnGWHxg89-vv9m3TrrKPQsrsFFQqu73QniRQPzOw";
  static const int apiTimeOut = 60000;

// Response Handler
  static const strNoRouteFound = "no_route_found";
  static const strAppName = "app_name";
  static const String success = "success";
  // error handler
  static const String strBadRequestError = "bad_request_error";
  static const String strNoContent = "no_content";
  static const String strForbiddenError = "forbidden_error";
  static const String strUnauthorizedError = "unauthorized_error";
  static const String strNotFoundError = "not_found_error";
  static const String strConflictError = "conflict_error";
  static const String strInternalServerError = "internal_server_error";
  static const String strUnknownError = "unknown_error";
  static const String strTimeoutError = "timeout_error";
  static const String strDefaultError = "default_error";
  static const String strCacheError = "cache_error";
  static const String strNoInternetError = "no_internet_error";
}
