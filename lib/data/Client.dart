import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'Cookies.dart';

class EspnClient {
  static Dio obtain() {
    var dio = Dio();
    var cookieJar = CookieJar();
    cookieJar.saveFromResponse(
        Uri.parse("https://fantasy.espn.com/"), Cookies().leagueCookies);
    dio.interceptors.add(CookieManager(cookieJar));

    return dio;
  }
}
