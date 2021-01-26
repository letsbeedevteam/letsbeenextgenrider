class RefreshTokenrequest {
  RefreshTokenrequest(
    this.token,
  );

  String token;

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
