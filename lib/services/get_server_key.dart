import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "communicatordb-bf810",
          "private_key_id": "a738ae312ab1823681e7ac4c48d3ca9a32db08f7",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDf5aPa7WDJLrKb\n45GzkfRt30NCgm7u1nI8Y9/+TkCtB1b1R3T9yY+PgY305SHhTnM+XKbIXjRjyq+p\n9mq9nMkKaNmPy+7AvyDSPMAnL3FtfAL/+ZaiPoEtNa2jgDnLaH/JdSatJbQK2gT2\nysXQ91BRlu6GfQA2q5Sbnov2UM7/9mP7hEgzpFFbGYbBFb+gr9rbHzY+u0v0ANn7\n4cLS9gPpid0WRNN6Bn+NlS2NbYTVdCrLqBrzlajxrDNi4HcIK6NW2aZjU13194k2\n1A+Rliubm9rEbbfV++sRfl5bIWLWB/fa01RzmHJFlwZThhALnb5/akUAMeqJvPvi\nMYwiZzqlAgMBAAECggEAIKy+gjFw1cNpIPtv1MU45vz1b6Qh5NyqbLpFovMQGMBQ\ntjiAsBXli9OkICh9Toh4pJH4bBblbefTRYpW7weNxmVhVM018W6jL1Na1o0jsE7w\nECPAUjqtdufVyJ3qsU71kTS12YB+WzQQk+SpRFMHZ3TPqBRfftsA88oKUn7eCrgI\nSMC9ffnAzMY6Eh5jUj62ZBdU1oqxqo06fQVzAuGxmHyFH7w5moHDTbJ7JdI8BXxs\nqrijf9DlWylL29lNutQZZh3h/xyXd32GkUtNuUW/2+jfKVG+0BD+lIqPedTAvfd5\nUn7JCjnDOBFPOTmYP3oJB3pz1egxLpz9IJ2jnepW+QKBgQD89z/7ZWxMkm+Rexgn\n04qQgeHHiTNR7MM58Xpe51bhkoCEBmaS9D/h/VIkiNMFJJgQe5DvT/j1G6CdE7L/\nAK9dvNh6EnUm/bGlWmAjlHvP3n23J0PZ0IPO9/zJsJFoEBSFisYJ5CGsjlsizA1O\nCKRMiRjn48fYieF+0i1ZS7DNCQKBgQDilSHdgVwBXtKG0cyLle0A/L/mc6UbNI1h\nj7H7BVvRQNL0qwDU74vvcxQ0eMQSNeqt/gRH6YrARH4UY2UuT6pbgQmU1q8alq7h\nJ+dl5pEA2yZr4MBFQDTV1/3lhFPHtefLogA6dBZXY7IHEu+YLjwPS1yXKg0RedxI\n+qnBbaLDvQKBgQC2PbH8fO7uozh5SIL4fi//N3Le+3rbdISZA9yy7lrrG042zx2q\nlQhI2OUKqP/NXrWmej7KCYVDn+mv//ceOvIbx+b02sNHmdEXXOqR93DTKmjLQCBj\nlRLAUmvtKaU3oQ4Hvxg5G/8ef1gs03BqXVNwR/yHYtQgrgSkBurgv+TZcQKBgQCF\nXcBsL8sm51hFkNGzy5CQBzUxARrKs5kQNtNM7G+J8Hz7FHhN3Z3hWDwpUngeO+wh\nc6WzakyINQh9GbAhnTSp3X71Q5QXs1/GGYXDXf41ociwsL6bRFqVECha4xOpNnH0\nUyuNPG02DPFp5oRub7BcVEBwnYjJo4+8yQYIW271hQKBgDfXWNxuEP+ijWxxUtVr\nss7KGY7+RpCgvCq1MNdbNF50YoxpZvHB9aeFKiCD0JZw/CImCHJtDOLiBNbjCZzg\nBSmIQfT0l1jJJ9Ar5ayqZHK+GK2kGIZ4RbtFzfO9IMKg7TTMFNFaQ7ZaVkoQxxhL\nBYq+iccNMW8txgVNIZHABYer\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-fbsvc@communicatordb-bf810.iam.gserviceaccount.com",
          "client_id": "112146386875983544344",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40communicatordb-bf810.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);

    String serverKey = client.credentials.accessToken.data;
    return serverKey;
  }
}
