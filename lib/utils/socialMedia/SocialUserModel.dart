class SocialUserModel {
  String _firstName, _lastName, _email, _id;

  SocialUserModel(this._firstName, this._lastName, this._email, this._id);

  get email => _email;

  get id => _id;

  get lastName => _lastName;

  String get firstName => _firstName;
}
