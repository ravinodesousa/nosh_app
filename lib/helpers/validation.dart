Map<String, dynamic> isValidEmail(String email) {
  if (email == '') {
    return {"is_valid": false, "error": "Email required"};
  }
  if (!RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email)) {
    return {"is_valid": false, "error": "Invalid email"};
  }
  return {"is_valid": true, "error": null};
}

Map<String, dynamic> isValidPassword(String password) {
  if (password == '') {
    return {"is_valid": false, "error": "Password required"};
  }
  if (!RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(password)) {
    return {"is_valid": false, "error": "Invalid Password"};
  }
  return {"is_valid": true, "error": null};
}
