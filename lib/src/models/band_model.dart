class BandModel {
  String _id;
  String _name;
  int _votes;

  BandModel({final String id, final String name, final int votes})
      : this._id = id,
        assert(id != null),
        this._name = name,
        assert(name != null),
        this._votes = votes,
        assert(votes >= 0) {
    print('$id, $name, $votes');
  }

  factory BandModel.fromJson(Map<String, dynamic> json) => BandModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      votes: json["votes"] ?? 0);

  set id(final String id) => this._id ??= id;
  String get id => this._id;

  set name(final String name) => this._name ??= name;
  String get name => this._name;

  set votes(final int votes) => this._votes ??= votes;
  int get votes => this._votes;

  String toString() =>
      "Band: {id: ${this._id}, name: ${this._name}, votes: ${this._votes}";

  int get hashCode {
    int hash = 7;
    hash = 83 * hash + this._id.hashCode;
    hash = 83 * hash + this._name.hashCode;
    hash = 83 * hash + this._votes.hashCode;
    return hash;
  }

  operator ==(final Object obj) => obj is BandModel;
}
