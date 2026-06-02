class ApiHeaders {
  const ApiHeaders._();

  static const String apiKey = 'ppks2020';

  static Map<String, String> noAuth({
    Map<String, String>? extra,
  }) {
    return {
      // Backend lama di collection kadang pakai `api-key`, sedangkan
      // callback Google memakai `x-api-key`. Keduanya dikirim agar aman.
      'api-key': apiKey,
      'x-api-key': apiKey,
      'Accept': 'application/json',
      if (extra != null) ...extra,
    };
  }

  static Map<String, String> withToken(
    String token, {
    Map<String, String>? extra,
  }) {
    return {
      ...noAuth(extra: extra),
      'Authorization': 'Bearer $token',
    };
  }
}
