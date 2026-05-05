import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' hide User;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

/// 카카오 네이티브 앱 키 (Kakao Developers 콘솔 → 내 애플리케이션 → 앱 키)
/// TODO: 실제 키로 교체 + 안드로이드 AndroidManifest.xml/iOS Info.plist 설정 필요
const _kakaoNativeAppKey = 'YOUR_KAKAO_NATIVE_APP_KEY';

/// 카카오 → Firebase 커스텀 토큰 교환 Cloud Function 엔드포인트
/// TODO: 배포 후 URL로 교체 (Firebase Functions에서 onRequest로 작성)
/// 함수 contract:
///   POST  body: { "kakaoAccessToken": "..." }
///   200   body: { "firebaseToken": "<custom token>" }
const _kakaoExchangeUrl = 'https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/kakaoLogin';

class AuthService {
  static FirebaseAuth get _auth => FirebaseAuth.instance;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  static User? get currentUser => _auth.currentUser;

  static Future<void> init() async {
    try {
      KakaoSdk.init(nativeAppKey: _kakaoNativeAppKey);
    } catch (e) {
      // 네이티브 키가 안 채워진 단계에선 그냥 통과 (Apple/Google은 그래도 동작)
      if (kDebugMode) {
        debugPrint('[Auth] KakaoSdk init skipped: $e');
      }
    }
  }

  // ─── Apple ───────────────────────────────
  static Future<UserCredential> signInWithApple() async {
    final apple = await SignInWithApple.getAppleIDCredential(
      scopes: const [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    final cred = OAuthProvider('apple.com').credential(
      idToken: apple.identityToken,
      accessToken: apple.authorizationCode,
    );
    return _auth.signInWithCredential(cred);
  }

  // ─── Google ──────────────────────────────
  static Future<UserCredential> signInWithGoogle() async {
    // google_sign_in 7.x: 새 API
    final google = GoogleSignIn.instance;
    await google.initialize();
    final account = await google.authenticate();
    final auth = account.authentication;
    final cred = GoogleAuthProvider.credential(idToken: auth.idToken);
    return _auth.signInWithCredential(cred);
  }

  // ─── Kakao ───────────────────────────────
  // Firebase Auth는 카카오를 직접 지원 안 함 → 카카오 토큰을
  // 백엔드(Cloud Function)에서 검증한 뒤 Firebase 커스텀 토큰을 발급받아
  // signInWithCustomToken으로 로그인.
  static Future<UserCredential> signInWithKakao() async {
    // 1. 카카오 로그인 (카톡 설치 시 카톡으로, 아니면 웹뷰 fallback)
    OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (_) {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    // 2. 액세스 토큰을 Cloud Function에 전달 → Firebase custom token 받기
    final res = await http.post(
      Uri.parse(_kakaoExchangeUrl),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'kakaoAccessToken': token.accessToken}),
    );
    if (res.statusCode != 200) {
      throw Exception('Kakao 교환 실패 (${res.statusCode}): ${res.body}');
    }
    final firebaseToken = (jsonDecode(res.body) as Map<String, dynamic>)['firebaseToken'] as String;

    // 3. Firebase 로그인
    return _auth.signInWithCustomToken(firebaseToken);
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    try { await UserApi.instance.logout(); } catch (_) {}
    try { await GoogleSignIn.instance.signOut(); } catch (_) {}
  }
}
