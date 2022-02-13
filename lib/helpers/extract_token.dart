import 'package:jaguar_jwt/jaguar_jwt.dart';
String extractToken(String token, String secret) {
  final JwtClaim claim = verifyJwtHS256Signature(token, secret);
  return claim['id'] as String;  
}
