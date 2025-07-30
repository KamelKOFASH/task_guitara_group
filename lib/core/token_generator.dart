import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Development token generator for Stream Video
/// WARNING: This is for development only! In production, tokens should be generated server-side
class TokenGenerator {
  static String generateDevelopmentToken({
    required String apiSecret,
    required String userId,
    int? expiration,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final exp = expiration ?? (now + 3600); //* 1 hour from now
    
    final header = {
      'alg': 'HS256',
      'typ': 'JWT',
    };
    
    final payload = {
      'user_id': userId,
      'iss': 'stream-video',
      'sub': 'user/$userId',
      'iat': now,
      'exp': exp,
    };
    
    final encodedHeader = base64UrlEncode(utf8.encode(jsonEncode(header)));
    final encodedPayload = base64UrlEncode(utf8.encode(jsonEncode(payload)));
    
    final message = '$encodedHeader.$encodedPayload';
    final key = utf8.encode(apiSecret);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(utf8.encode(message));
    final signature = base64UrlEncode(digest.bytes);
    
    return '$message.$signature';
  }
  
  static String base64UrlEncode(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }
}
