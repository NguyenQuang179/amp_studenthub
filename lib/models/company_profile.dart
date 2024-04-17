class CompanyProfile {
  final String id;
  final String fullname;
  final String companyName;
  final int size;
  final String website;
  final String description;

  CompanyProfile(this.id, this.fullname, this.companyName, this.size,
      this.website, this.description);

  CompanyProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        fullname = json['name'] as String,
        companyName = json['companyName'] as String,
        size = json['size'] as int,
        website = json['website'] as String,
        description = json['descriptions'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': fullname,
        'companyName': companyName,
        'size': size,
        'website': website,
        'description': description
      };
}
