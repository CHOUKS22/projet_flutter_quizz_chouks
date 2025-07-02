import 'dart:convert';
import 'package:crypto/crypto.dart';

// Classe pour gérer le hachage des mots de passe
// Utilise SHA-256 pour sécuriser les mots de passe
class PasswordHasher {
  // Hash simple
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Vérification du mot de passe
  static bool verifyPassword(String password, String hashedPassword) {
    String hashedInput = hashPassword(password);
    return hashedInput == hashedPassword;
  }

  // Génération d'un salt (optionnel)
  static String generateSalt() {
    var random = DateTime.now().millisecondsSinceEpoch.toString();
    var bytes = utf8.encode(random);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  // Hash avec salt
  static String hashPasswordWithSalt(String password, String salt) {
    String saltedPassword = password + salt;
    return hashPassword(saltedPassword);
  }
}
