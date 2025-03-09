import 'dart:math';

String generateVerificationCode() {
  Random random = Random();
  return (100000 + random.nextInt(900000)).toString();
}