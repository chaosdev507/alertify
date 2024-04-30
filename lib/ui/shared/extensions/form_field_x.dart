extension type Email._(String _email) {
  Email.pure() : this._('');

  Email.dirty(String value) : this._(value);

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email is not valid.';
    }
    return null;
  }

  String get value => _email;

  bool isEmpty() => _email.isEmpty;

  bool isValid() =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email);
}

extension type Password._(String _password) {
  Password.pure() : this._('');

  Password.dirty(String value) : this._(value);

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < 4) {
      return 'Password is too short.';
    }

    return null;
  }

  String? match(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required.';
    }

    if (value != _password) {
      return 'Passwords do not match.';
    }
    return null;
  }

  String get value => _password;

  bool isEmpty() => _password.isEmpty;

  bool isValid() => _password.length > 3;
}

extension type Username._(String _username) {
  Username.pure() : this._('');

  Username.dirty(String value) : this._(value);

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required.';
    }
    if (value.length < 4) {
      return 'Username is too short.';
    }
    return null;
  }

  String get value => _username;

  bool isEmpty() => _username.isEmpty;

  bool isValid() => _username.length > 3;
}
