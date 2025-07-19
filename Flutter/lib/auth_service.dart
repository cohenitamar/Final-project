import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A class to encapsulate the result of authentication methods.
class AuthResult {
  final UserCredential? userCredential;
  final String? errorMessage;

  AuthResult({this.userCredential, this.errorMessage});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// INTERNAL helper that does GoogleSignIn(). Returns a GoogleSignInAccount if the user didn't cancel.
  Future<GoogleSignInAccount?> _signInWithGooglePopup() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      print('Error during Google sign-in popup: $e');
      return null;
    }
  }

  /// ======================
  ///   SIGN UP WITH GOOGLE
  /// ======================
  ///
  /// Creates a new user with Google in Firebase. If `isNewUser == false`,
  /// that means the user already existed, so we return an error.
  Future<AuthResult> signUpWithGoogleInFirebase() async {
    // 1. Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await _signInWithGooglePopup();
    if (googleUser == null) {
      return AuthResult(errorMessage: 'Google Sign-Up was cancelled.');
    }

    try {
      // 2. Obtain tokens from the Google account
      final googleAuth = await googleUser.authentication;

      // 3. Create the Google credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase (creates or reuses an account)
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // 5. Check isNewUser
      final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (!isNewUser) {
        final email = userCredential.user?.email ?? 'unknown';
        return AuthResult(
          errorMessage: 'An account already exists for $email. Please sign in.',
        );
      }

      // If new user, success
      return AuthResult(userCredential: userCredential);

    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in signUpWithGoogleInFirebase: ${e.message}');
      return AuthResult(errorMessage: e.message);
    } catch (e) {
      print('Unknown error in signUpWithGoogleInFirebase: $e');
      return AuthResult(errorMessage: 'An unknown error occurred.');
    }
  }

  /// ======================
  ///   SIGN IN WITH GOOGLE
  /// ======================
  ///
  /// Logs in the user with Google if they already exist in Firebase.
  /// If `isNewUser == true`, we immediately delete that user and return an error,
  /// so we do not keep a newly created user around.
  Future<AuthResult> signInWithGoogleInFirebase() async {
    // 1. Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await _signInWithGooglePopup();
    if (googleUser == null) {
      return AuthResult(errorMessage: 'Google Sign-In was cancelled.');
    }

    try {
      // 2. Obtain tokens from the Google account
      final googleAuth = await googleUser.authentication;

      // 3. Create the Google credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase (creates or reuses an account)
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // 5. Check isNewUser
      final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        // The user doesn't exist in Firebase, but was just created automatically.
        // We'll remove them right away to block creation in the "Sign In" flow.
        final user = userCredential.user;
        final email = user?.email ?? 'unknown';

        // Delete the newly created user from Firebase
        await user?.delete();

        // Also sign out, in case the user is currently signed in
        await _auth.signOut();

        return AuthResult(
          errorMessage: 'No account found for $email. Please sign up first.',
        );
      }

      // If not new, success
      return AuthResult(userCredential: userCredential);

    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in signInWithGoogleInFirebase: ${e.message}');
      return AuthResult(errorMessage: e.message);
    } catch (e) {
      print('Unknown error in signInWithGoogleInFirebase: $e');
      return AuthResult(errorMessage: 'An unknown error occurred.');
    }
  }

  // ==========================================
  //  Sign in / Register with Email & Password
  // ==========================================
  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return AuthResult(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      print('Error during email sign-in: ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = e.message ?? 'An unknown error occurred.';
      }
      return AuthResult(errorMessage: errorMessage);
    } catch (e) {
      print('Unknown error during email sign-in: $e');
      return AuthResult(errorMessage: 'An unknown error occurred.');
    }
  }

  Future<AuthResult> registerWithEmail(String email, String password) async {
    try {
      final userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return AuthResult(userCredential: userCredential);
    } on FirebaseAuthException catch (e) {
      print('Error during email registration: ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage =
          'Password must be at least 8 characters long and contain uppercase and lowercase letters.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = e.message ?? 'An unknown error occurred.';
      }
      return AuthResult(errorMessage: errorMessage);
    } catch (e) {
      print('Unknown error during email registration: $e');
      return AuthResult(errorMessage: 'An unknown error occurred.');
    }
  }

  /// =====================
  ///     CHANGE PASSWORD
  /// =====================
  Future<AuthResult> changePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult(errorMessage: 'No user is currently signed in.');
      }
      await user.updatePassword(newPassword);
      return AuthResult();
    } on FirebaseAuthException catch (e) {
      print('Error during password change: ${e.message}');
      return AuthResult(errorMessage: e.message);
    } catch (e) {
      print('Unknown error during password change: $e');
      return AuthResult(errorMessage: 'An unknown error occurred.');
    }
  }

  /// =====================
  ///       SIGN OUT
  /// =====================
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  /// =============================
  ///   AUTH STATE CHANGES STREAM
  /// =============================
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
