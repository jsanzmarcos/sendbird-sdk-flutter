import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:sendbird_sdk/constant/error_code.dart';
import 'package:sendbird_sdk/constant/types.dart';
import 'package:sendbird_sdk/core/models/error.dart';
import 'package:sendbird_sdk/core/models/file_info.dart';
import 'package:sendbird_sdk/managers/connection_manager.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';
import 'package:sendbird_sdk/utils/logger.dart';
import 'package:sendbird_sdk/utils/extensions.dart';

enum Method {
  get,
  post,
  put,
  delete,
  patch,
}

class HttpClient {
  Map<String, String> headers = {};
  String baseUrl;
  int port;
  String appId;
  String sessionKey;
  String token;

  bool isLocal = false;
  bool bypassAuth = false;
  StreamController errorController =
      StreamController<SBError>.broadcast(sync: true);

  Map<String, MultipartRequest> uploadRequests = {};

  HttpClient({
    this.baseUrl,
    this.port,
    this.appId,
    this.sessionKey,
    this.token,
    this.headers,
  });

  void cleanUp() {
    sessionKey = null;
    token = null;
    headers = {};
    uploadRequests = {};
    errorController?.close();
  }

  //form commom headers
  Map<String, String> commonHeaders() {
    final commonHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (sessionKey != null)
        'Session-Key': sessionKey
      else if (token != null)
        'Api-Token': token
    };
    if (headers.isNotEmpty) {
      commonHeaders.addAll(headers);
    }

    return commonHeaders;
  }

  Future<dynamic> get({
    String url,
    Map<String, dynamic> queryParams,
    Map<String, String> headers = const {},
  }) async {
    await ConnectionManager.readyToExecuteAPIRequest(force: bypassAuth);

    final uri = Uri(
      scheme: isLocal ? 'http' : 'https',
      host: baseUrl,
      port: port,
      path: url,
      queryParameters: _convertQueryParams(queryParams),
    );

    final request = http.Request('GET', uri);
    request.headers.addAll(commonHeaders());
    request.headers.addAll(headers);

    final res = await request.send();
    final result = await http.Response.fromStream(res);
    return _response(result);
  }

  Future<dynamic> post({
    String url,
    Map<String, dynamic> queryParams,
    Map<String, dynamic> body = const {},
    Map<String, String> headers = const {},
  }) async {
    await ConnectionManager.readyToExecuteAPIRequest(force: bypassAuth);

    final uri = Uri(
      scheme: isLocal ? 'http' : 'https',
      host: baseUrl,
      port: port,
      path: url,
      queryParameters: _convertQueryParams(queryParams),
    );
    final request = http.Request('POST', uri);
    request.body = jsonEncode(body);
    request.headers.addAll(commonHeaders());
    request.headers.addAll(headers);

    final res = await request.send();
    final result = await http.Response.fromStream(res);
    return _response(result);
  }

  Future<dynamic> put({
    String url,
    Map<String, dynamic> queryParams,
    Map<String, dynamic> body = const {},
    Map<String, String> headers = const {},
  }) async {
    await ConnectionManager.readyToExecuteAPIRequest(force: bypassAuth);

    final uri = Uri(
      scheme: isLocal ? 'http' : 'https',
      host: baseUrl,
      port: port,
      path: url,
      queryParameters: _convertQueryParams(queryParams),
    );

    final request = http.Request('PUT', uri);
    request.body = jsonEncode(body);
    request.headers.addAll(commonHeaders());
    request.headers.addAll(headers);

    final res = await request.send();
    final result = await http.Response.fromStream(res);
    return _response(result);
  }

  Future<dynamic> delete({
    String url,
    Map<String, dynamic> queryParams,
    Map<String, dynamic> body = const {},
    Map<String, String> headers = const {},
  }) async {
    await ConnectionManager.readyToExecuteAPIRequest(force: bypassAuth);

    final uri = Uri(
      scheme: isLocal ? 'http' : 'https',
      host: baseUrl,
      port: port,
      path: url,
      queryParameters: _convertQueryParams(queryParams),
    );
    final request = http.Request('DELETE', uri);
    request.headers.addAll(commonHeaders());
    request.body = jsonEncode(body);
    request.headers.addAll(headers);

    final res = await request.send();
    final result = await http.Response.fromStream(res);
    return _response(result);
  }

  Future<dynamic> multipartRequest({
    Method method,
    String url,
    Map<String, dynamic> body,
    Map<String, dynamic> queryParams,
    Map<String, String> headers,
    OnUploadProgressCallback progress,
  }) async {
    await ConnectionManager.readyToExecuteAPIRequest(force: bypassAuth);

    final request = MultipartRequest(
      method.asString().toUpperCase(),
      Uri(
        scheme: isLocal ? 'http' : 'https',
        host: baseUrl,
        port: port,
        path: url,
        queryParameters: _convertQueryParams(queryParams),
      ),
      onProgress: progress,
    );

    body.forEach((key, value) {
      if (value is FileInfo) {
        final part = http.MultipartFile(
          key,
          value.file.openRead(),
          value.file.lengthSync(),
          filename: value.name,
          contentType: MediaType.parse(value.mimeType),
        );
        request.files.add(part);
      } else if (value is List<String>) {
        request.fields[key] = value.join(',');
      } else if (value is List) {
        final converted = value.map((e) => jsonEncode(e));
        request.fields[key] = converted.join(',');
      } else if (value is String) {
        request.fields[key] = value;
      } else if (value != null) {
        request.fields[key] = jsonEncode(value);
      }
    });

    request.headers.addAll(commonHeaders());
    if (headers != null && headers.isNotEmpty) request.headers.addAll(headers);

    String reqId = body['request_id'];
    uploadRequests[reqId] = request;

    final res = await request.send();
    final result = await http.Response.fromStream(res);

    uploadRequests.remove(reqId);
    return _response(result);
  }

  bool cancelUploadRequest(String requestId) {
    final req = uploadRequests[requestId];
    if (req != null) {
      req.cancel();
      uploadRequests.remove(requestId);
      return true;
    }
    return false;
  }

  Future<dynamic> _response(http.Response response) async {
    dynamic res;

    try {
      res = jsonDecode(response.body.toString());
    } catch (e) {
      throw MalformedError();
    }

    final encoder = JsonEncoder.withIndent('  ');
    final resString = '-- Payload: ${encoder.convert(res)}';
    final hasErrorCode =
        response.statusCode >= 400 && response.statusCode < 500;
    final log = hasErrorCode ? logger.e : logger.i;
    log('HTTP request ' +
        response.request.url.toString() +
        '\nHTTP response ' +
        resString +
        '\nHeaders: ${encoder.convert(response.request.headers)}');

    if (response.statusCode >= 400 && response.statusCode < 500) {
      final err = SBError(message: res['message'], code: res['code']);
      errorController.sink.add(err);
      //NOTE: is this best way to do?..
      if (err.code == ErrorCode.sessionKeyExpired) {
        sessionKey = null;
        final result =
            await SendbirdSdk().getInternal().sessionManager.updateSession();
        if (result) {
          throw SessionKeyRefreshSucceededError();
        } else {
          throw SessionKeyRefreshFailedError();
        }
      }
    }

    switch (response.statusCode) {
      case 200:
        return res;
      case 400:
        logger.e('Bad request: ${res['message']}');
        throw BadRequestError(message: res['message'], code: res['code']);
      case 401:
      case 403:
        logger.e('Unauthorized request: ${res['message']}');
        throw UnauthorizeError(message: res['message'], code: res['code']);
      case 500:
      default:
        throw InternalServerError(
            message: 'internal server error :${response.statusCode}');
    }
  }

  Map<String, dynamic> _convertQueryParams(Map<String, dynamic> q) {
    if (q == null) return {};
    final result = <String, dynamic>{};
    q.forEach((key, value) {
      if (value is List) {
        if (value is List<String>) {
          result[key] = value;
        } else {
          result[key] = value.map((e) => e.toString()).toList();
        }
      } else if (value != null) {
        result[key] = value.toString();
      }
    });
    return result;
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  var client = http.Client();

  MultipartRequest(
    String method,
    Uri url, {
    this.onProgress,
  }) : super(method, url);

  final void Function(int bytes, int totalBytes) onProgress;

  void cancel() => client.close();

  @override
  Future<http.StreamedResponse> send() async {
    try {
      var response = await client.send(this);
      var stream = onDone(response.stream, client.close);
      return http.StreamedResponse(
        http.ByteStream(stream),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (_) {
      client.close();
      rethrow;
    }
  }

  Stream<T> onDone<T>(Stream<T> stream, void Function() onDone) =>
      stream.transform(StreamTransformer.fromHandlers(handleDone: (sink) {
        sink.close();
        onDone();
      }));

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    var bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        if (onProgress != null) onProgress(bytes, total);
        sink.add(data);
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}
