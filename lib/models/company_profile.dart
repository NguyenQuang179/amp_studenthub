class CompanyProfile {
  final int id;
  final int userId;
  final String companyName;
  final int size;
  final String website;
  final String description;

  CompanyProfile(this.id, this.userId, this.companyName, this.size,
      this.website, this.description);

  CompanyProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        userId = json['userId'] as int,
        companyName = json['companyName'] as String,
        size = json['size'] as int,
        website = json['website'] as String,
        description = json['description'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'companyName': companyName,
        'size': size,
        'website': website,
        'description': description
      };
}
