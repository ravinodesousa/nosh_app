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
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
      .hasMatch(password)) {
    return {
      "is_valid": false,
      "error":
          "Invalid Password. Password should contain minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character"
    };
  }
  return {"is_valid": true, "error": null};
}

Map<String, dynamic> isValidMobileNo(String mobileNo) {
  if (mobileNo == '') {
    return {"is_valid": false, "error": "Mobile No required"};
  }
  if (!RegExp(r'^[789]\d{9}$').hasMatch(mobileNo)) {
    return {
      "is_valid": false,
      "error":
          "Invalid Mobile No. It shouldn't contain characters and country code."
    };
  }
  return {"is_valid": true, "error": null};
}
