import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptData {
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);

    print(encrypted.bytes);
    print(encrypted.base16);
    print(encrypted.base64);
    return encrypted.base64;
  }

  static decryptAES(text) {
    final decrypted = encrypter.decrypt64(text, iv: iv);
    return decrypted.toString();
  }
  // static Encrypted? encrypted;
  // static var decrypted;

  // static encryptAES(plainText) {
  //   final key = Key.fromUtf8('axolon_erp_encryption_key_123456');
  //   final iv = IV.fromLength(16);
  //   final encrypter = Encrypter(AES(key));
  //   encrypted = encrypter.encrypt(plainText, iv: iv);
  //   return encrypted!.base64;
  // print(encrypted!.base64);
  // }

  // static decryptAES(plainText) {
  //   final key = Key.fromUtf8('axolon_erp_encryption_key_123456');
  //   final iv = IV.fromLength(16);
  //   final encrypter = Encrypter(AES(key));
  //   decrypted = encrypter.decrypt(encrypted!, iv: iv);
  //   // print(decrypted);
  //   print(decrypted);
  // }
}
