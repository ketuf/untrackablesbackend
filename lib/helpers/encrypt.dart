import 'package:jaguar_jwt/jaguar_jwt.dart';

String eschencryschypt(String id, String secret) {
  final claim = JwtClaim(otherClaims: <String, String>{
    'id': id
  });
  return issueJwtHS256(claim, secret);
}
