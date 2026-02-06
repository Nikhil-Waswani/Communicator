// This imports the correct platform-specific version
import 'auth_service_stub.dart'
    if (dart.library.html) 'auth_service_web.dart'
    if (dart.library.io) 'auth_service_mobile.dart';

// Now you can use AuthService normally
final authService = AuthService();
