import 'package:amp_studenthub/configs/constant.dart';
import 'package:amp_studenthub/network/failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String SUCCESS = Constant.success; // success with data
  static const String NO_CONTENT =
      Constant.success; // success with no data (no content)
  static const String BAD_REQUEST =
      Constant.strBadRequestError; // failure, API rejected request
  static const String UNAUTORISED =
      Constant.strUnauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN =
      Constant.strForbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR =
      Constant.strInternalServerError; // failure, crash in server side
  static const String NOT_FOUND =
      Constant.strNotFoundError; // failure, crash in server side

  // local status code
  static const String CONNECT_TIMEOUT = Constant.strTimeoutError;
  static const String CANCEL = Constant.strDefaultError;
  static const String RECIEVE_TIMEOUT = Constant.strTimeoutError;
  static const String SEND_TIMEOUT = Constant.strTimeoutError;
  static const String CACHE_ERROR = Constant.strCacheError;
  static const String NO_INTERNET_CONNECTION = Constant.strNoInternetError;
  static const String DEFAULT = Constant.strDefaultError;
}

class ApiInternalStatus {
  static const int SUCCESS = 200;
  static const int FAILURE = 400;
}
