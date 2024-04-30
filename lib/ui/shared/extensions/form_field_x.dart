extension type InputEmail._(String _email) {
  InputEmail.pure() : this._('');

  InputEmail.dirty(String value) : this._(value);

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

extension type InputPassword._(String _password) {
  InputPassword.pure() : this._('');

  InputPassword.dirty(String value) : this._(value);

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

extension type InputUsername._(String _username) {
  InputUsername.pure() : this._('');

  InputUsername.dirty(String value) : this._(value);

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

extension type Email._(String _email) {
  factory Email(String? value) {
    if (value == null || value.isEmpty) {
      throw ArgumentError('Email is required.');
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      throw ArgumentError('Email is not valid.');
    }
    return Email._(value);
  }

  get value => _email;
}

extension type Password._(String _password) {
  factory Password(String? value) {
    if (value == null || value.isEmpty) {
      throw ArgumentError('Password is required.');
    }

    if (value.length < 4) {
      throw ArgumentError('Password is too short.');
    }
    return Password._(value);
  }

  get value => _password;
}