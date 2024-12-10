import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:When_to_do/main.dart';

// formatters
monthformatter(DateTime datetime) {
  return DateFormat.MMM().format(datetime);
}

weekdayformatter(DateTime datetime) {
  return DateFormat.E().format(datetime);
}

// converters
dateconvert(DateTime datetime) {
  String dateForPostgres =
      '${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}';
  return dateForPostgres;
}

timeconvert(String time) {
  List<String> t = time.split(":");
  String output = t[0] == "0" && t[1] == "00"
      ? ""
      : '${hour12(t[0])}:${t[1]} ${daynight(t[0])}';
  return output;
}

hour12(String hour) {
  return int.parse(hour) - 12 <= 0
      ? "${int.parse(hour)}"
      : "${int.parse(hour) - 12}";
}

daynight(String hour) {
  return int.parse(hour) - 12 < 0 ? "ᴬᴹ" : "ᴾᴹ";
}

// Routing
PageRouteBuilder<dynamic> SlideRTLPageRouting(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

PageRouteBuilder<dynamic> SlideLTRPageRouting(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0); // Slide in from the right
      const end = Offset.zero; // End at the center
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

PageRouteBuilder<dynamic> SlideTTBPageRouting(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

PageRouteBuilder<dynamic> SlideBTTPageRouting(page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, -1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

// validators
validateEmail(String? email) {
  if (email != null) {
    if (email.isEmpty) {
      return "Email can't be Empty";
    } else if (!email.contains("@")) {
      return "Please enter a valid email";
    } else if (email.split("@")[1].split(".")[1].isEmpty) {
      return "Please enter a valid email";
    }
  }
}

validatePass(String? password) {
  RegExp specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  RegExp letters = RegExp(r'[a-zA-Z]');
  RegExp numbers = RegExp(r'[0-9]');

  if (password == null) {
    return "Email can't be null";
  } else if (password.length < 8) {
    return "Password must be more than 8 characters.";
  } else if (!specialChars.hasMatch(password)) {
    return "Password must have at least 1 special character";
  } else if (!letters.hasMatch(password)) {
    return "Password must have at least 1 letter";
  } else if (!numbers.hasMatch(password)) {
    return "Password must have at least 1 numbers";
  }
}

// authentication
Future<dynamic> nativeGoogleSignIn() async {
  /// TODO: update the Web client ID with your own.
  ///
  /// Web Client ID that you registered with Google Cloud.
  const webClientId =
      '1041392467149-h54vhj44tepa4gc34m1i0385u1t2ruv1.apps.googleusercontent.com';

  /// TODO: update the iOS client ID with your own.
  ///
  /// iOS Client ID that you registered with Google Cloud.
  const iosClientId =
      '1041392467149-smo7mamqq5te445jv6c6a59mvi5qvght.apps.googleusercontent.com';

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  try {
    await googleSignIn.signOut();

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      return 'No Access Token found.';
    }
    if (idToken == null) {
      return 'No ID Token found.';
    }

    final res = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    return res;
  } on AuthException catch (e) {
    return e.message;
  }
}

Future<dynamic> signUp(first, last, email, password) async {
  try {
    final AuthResponse response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        "name": "${first} ${last}",
      },
    );
    return response;
  } on AuthException catch (e) {
    return e.message;
  }
}

Future<dynamic> signIn({email, password}) async {
  try {
    AuthResponse response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  } on AuthException catch (e) {
    return e.message;
  }
}
