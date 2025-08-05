import 'package:content_scripter/constants/app_contants.dart';
import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:async' show TimeoutException;
import 'package:http/http.dart' as http;
import 'dart:io' show File;

class ApiService {
  static const String _authorizationHeader = "senpai";
  static const Duration _defaultTimeout = Duration(seconds: 10);

  static Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      "authorization": _authorizationHeader,
    };
  }

  static Future<Map<String, dynamic>> _handleRequest(
    Future<Map<String, dynamic>> Function() requestFunction,
  ) async {
    try {
      return await requestFunction();
    } on TimeoutException catch (_) {
      return _handleError(message: "Request Timeout");
    } on http.ClientException catch (e) {
      return _handleError(message: e.message);
    } on FormatException catch (e) {
      return _handleError(message: e.message);
    } catch (e) {
      return _handleError(message: e.toString());
    }
  }

  static Map<String, dynamic> _handleError({required String message}) {
    return {
      'status': 500,
      'body': jsonEncode({'error': message}),
    };
  }

  static Future<Map<String, dynamic>> sendRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    return _handleRequest(() async {
      final response = await http
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: _defaultHeaders(),
          )
          .timeout(_defaultTimeout);

      return {'status': response.statusCode, 'body': response.body};
    });
  }

  static Future<Map<String, dynamic>> sendGetRequest(
    String url, {
    String params = "",
  }) async {
    return _handleRequest(() async {
      final uri = Uri.parse('$url/$params'.trim());
      final response = await http
          .get(
            uri,
            headers: _defaultHeaders(),
          )
          .timeout(_defaultTimeout);

      return {'status': response.statusCode, 'body': response.body};
    });
  }

  static Future<Map<String, dynamic>> sendFormDataRequest(
    String url,
    Map<String, dynamic> formData,
  ) async {
    return _handleRequest(() async {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      formData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      var response = await request.send().timeout(_defaultTimeout);
      var responseBody = await response.stream.bytesToString();

      return {'status': response.statusCode, 'body': responseBody};
    });
  }

  static Future<String> uploadFile({
    required String filePath,
    required String url,
    required String uid,
  }) async {
    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);

    request.headers['authorization'] = _authorizationHeader;
    request.headers['Content-Type'] = "multipart/form-data";
    request.fields['user_id'] = uid;

    final file = File(filePath);
    final fileName = file.path.split('/').last;
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      filename: fileName,
    ));

    try {
      final response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseBody)['file_url'] as String;
      } else {
        throw Exception('Failed to upload profile');
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<String>> fetchTrendingHashtags({String? query}) async {
    const searchUrl = 'https://www.googleapis.com/youtube/v3/search';
    const videoUrl = 'https://www.googleapis.com/youtube/v3/videos';
    const apiKey = AppConstants.tagsApiKey;

    final searchResponse = await http.get(Uri.parse(
      '$searchUrl?part=snippet&q=$query&type=video&chart=mostPopular&maxResults=5&regionCode=US&key=$apiKey',
    ));

    if (searchResponse.statusCode != 200) {
      throw Exception('Failed to load trending videos');
    }

    final searchResults = jsonDecode(searchResponse.body);
    final items = searchResults['items'] as List<dynamic>;
    final ids = items
        .map((e) => e['id']?['videoId'] ?? "")
        .where((id) => id.isNotEmpty)
        .join(",");

    final videoResponse = await http.get(Uri.parse(
      '$videoUrl?part=snippet&id=$ids&key=$apiKey',
    ));

    if (videoResponse.statusCode != 200) {
      throw Exception('Failed to load video details');
    }

    final videoResults = jsonDecode(videoResponse.body);

    final videos = videoResults['items'] as List<dynamic>;
    final uniqueTags = <String>{};
    for (final v in videos) {
      final tags = Set<String>.from(v['snippet']['tags'] ?? []);
      uniqueTags.addAll(tags);
    }

    return uniqueTags.toList();
  }
}
