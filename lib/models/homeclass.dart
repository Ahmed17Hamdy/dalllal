import 'country_backmodel.dart';

class HomeClass {
  String msg;
  Data data;

  HomeClass({this.msg, this.data});

  HomeClass.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Cats> cats;
  List<Subcategories> subcategories;
  List<Ads> ads;
  List<Countries> countries;
  List<Cities> cities;
  List<Regions> regions;
  Data({this.cats, this.subcategories, this.ads, this.countries, this.cities});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['cats'] != null) {
      cats = new List<Cats>();
      json['cats'].forEach((v) {
        cats.add(new Cats.fromJson(v));
      });
    }
    if (json['subcategories'] != null) {
      subcategories = new List<Subcategories>();
      json['subcategories'].forEach((v) {
        subcategories.add(new Subcategories.fromJson(v));
      });
    }
    if (json['ads'] != null) {
      ads = new List<Ads>();
      json['ads'].forEach((v) {
        ads.add(new Ads.fromJson(v));
      });
    }
    if (json['countries'] != null) {
      countries = new List<Countries>();
      json['countries'].forEach((v) {
        countries.add(new Countries.fromJson(v));
      });
    }
    if (json['cities'] != null) {
      cities = new List<Cities>();
      json['cities'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
    if (json['regions'] != null) {
      regions = new List<Regions>();
      json['regions'].forEach((v) {
        regions.add(new Regions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cats != null) {
      data['cats'] = this.cats.map((v) => v.toJson()).toList();
    }
    if (this.subcategories != null) {
      data['subcategories'] =
          this.subcategories.map((v) => v.toJson()).toList();
    }
    if (this.ads != null) {
      data['ads'] = this.ads.map((v) => v.toJson()).toList();
    }
    if (this.countries != null) {
      data['countries'] = this.countries.map((v) => v.toJson()).toList();
    }
    if (this.cities != null) {
      data['cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    if (this.regions != null) {
      data['regions'] = this.regions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cats {
  int id;
  int parentId;
  String name;
  String logo;
  String icon;
  String createdAt;
  String updatedAt;
  List<Models> models;

  Cats(
      {this.id,
      this.parentId,
      this.name,
      this.logo,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.models});

  Cats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    logo = json['logo'];
    icon = json['icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['models'] != null) {
      models = new List<Models>();
      json['models'].forEach((v) {
        models.add(new Models.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['icon'] = this.icon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.models != null) {
      data['models'] = this.models.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategories {
  int id;
  int parentId;
  String name;
  String logo;
  String icon;
  String createdAt;
  String updatedAt;
  List<Models> models;

  Subcategories(
      {this.id,
      this.parentId,
      this.name,
      this.logo,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.models});

  Subcategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    logo = json['logo'];
    icon = json['icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['models'] != null) {
      models = new List<Models>();
      json['models'].forEach((v) {
        models.add(new Models.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['icon'] = this.icon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.models != null) {
      data['models'] = this.models.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Models {
  int id;
  int parentId;
  String name;
  String logo;
  String icon;
  String createdAt;
  String updatedAt;
  List<Models> models;

  Models(
      {this.id,
      this.parentId,
      this.name,
      this.logo,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.models});

  Models.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    logo = json['logo'];
    icon = json['icon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['models'] != null) {
      models = new List<Models>();
      json['models'].forEach((v) {
        models.add(new Models.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['icon'] = this.icon;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.models != null) {
      data['models'] = this.models.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ads {
  int id;
  int userId;
  int delUser;
  int catId;
  int brand;
  int model;
  int areaId;
  String price;
  String soum;
  String title;
  int parentId;
  String body;
  double lat;
  double lng;
  String contact;
  String type;
  int top;
  int codeNumber;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String image;
  List<String> images;
  String timeAgo;
  List<Comments> comments;
  int cityId;
  String userName;
  String cityName;
  List<Comments> cmnt;
  User user;
  Area area;
  int regionId;
  int views;
  int sold;
  Ads(
      {this.id,
      this.regionId,
      this.userId,
      this.delUser,
      this.catId,
      this.parentId,
      this.brand,
      this.model,
      this.areaId,
      this.price,
      this.soum,
      this.title,
      this.body,
      this.lat,
      this.lng,
      this.contact,
      this.type,
      this.top,
      this.codeNumber,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.image,
      this.images,
      this.timeAgo,
      this.comments,
      this.cityId,
      this.userName,
      this.cityName,
      this.cmnt,
      this.user,
      this.sold,
      this.views,
      this.area});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    regionId = json['region_id'];
    userId = json['user_id'];
    delUser = json['del_user'];
    catId = json['cat_id'];
    parentId = json['parent_id'];
    brand = json['brand'];
    model = json['model'];
    areaId = json['area_id'];
    price = json['price'];
    soum = json['soum'];
    title = json['title'];
    body = json['body'];
    lat = json['lat'];
    lng = json['lng'];
    contact = json['contact'];
    type = json['type'];
    top = json['top'];
    views = json['views'];
    sold = json['sold'];
    codeNumber = json['code_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    image = json['image'];
    images = json['images'].cast<String>();
    timeAgo = json['time_ago'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    cityId = json['city_id'];
    userName = json['user_name'];
    cityName = json['city_name'];
    if (json['cmnt'] != null) {
      cmnt = new List<Comments>();
      json['cmnt'].forEach((v) {
        cmnt.add(new Comments.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    area = json['area'] != null ? new Area.fromJson(json['area']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['del_user'] = this.delUser;
    data['cat_id'] = this.catId;
    data['brand'] = this.brand;
    data['model'] = this.model;
    data['area_id'] = this.areaId;
    data['price'] = this.price;
    data['soum'] = this.soum;
    data['title'] = this.title;
    data['body'] = this.body;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['views'] = this.views;
    data['sold'] = this.sold;
    data['contact'] = this.contact;
    data['type'] = this.type;
    data['top'] = this.top;
    data['region_id'] = this.regionId;
    data['code_number'] = this.codeNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['image'] = this.image;
    data['images'] = this.images;
    data['time_ago'] = this.timeAgo;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['city_id'] = this.cityId;
    data['user_name'] = this.userName;
    data['city_name'] = this.cityName;
    if (this.cmnt != null) {
      data['cmnt'] = this.cmnt.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.area != null) {
      data['area'] = this.area.toJson();
    }
    return data;
  }
}

class Comments {
  int id;
  int userId;
  int delUser;
  int postId;
  String body;
  int active;
  String createdAt;
  String updatedAt;
  String userName;
  String timeAgo;
  User user;

  Comments(
      {this.id,
      this.userId,
      this.delUser,
      this.postId,
      this.body,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.userName,
      this.timeAgo,
      this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    delUser = json['del_user'];
    postId = json['post_id'];
    body = json['body'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
    timeAgo = json['time_ago'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['del_user'] = this.delUser;
    data['post_id'] = this.postId;
    data['body'] = this.body;
    data['active'] = this.active;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    data['time_ago'] = this.timeAgo;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String username;
  String name;
  String email;
  String phone;
  int rank;
  int type;
  String active;
  String image;
  int authComplete;
  int codeVerify;
  String passwordCodeVerify;
  String notf;
  int forbidden;
  String apiToken;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int country;
  int city;
  int evaluation;
  String googleToken;

  User(
      {this.id,
      this.username,
      this.name,
      this.email,
      this.phone,
      this.rank,
      this.type,
      this.active,
      this.image,
      this.authComplete,
      this.codeVerify,
      this.passwordCodeVerify,
      this.notf,
      this.forbidden,
      this.apiToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.country,
      this.city,
      this.evaluation,
      this.googleToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    rank = json['rank'];
    type = json['type'];
    active = json['active'];
    image = json['image'];
    authComplete = json['auth_complete'];
    codeVerify = json['code_verify'];
    passwordCodeVerify = json['password_code_verify'];
    notf = json['notf'];
    forbidden = json['forbidden'];
    apiToken = json['api_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    country = json['country'];
    city = json['city'];
    evaluation = json['evaluation'];
    googleToken = json['google_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['rank'] = this.rank;
    data['type'] = this.type;
    data['active'] = this.active;
    data['image'] = this.image;
    data['auth_complete'] = this.authComplete;
    data['code_verify'] = this.codeVerify;
    data['password_code_verify'] = this.passwordCodeVerify;
    data['notf'] = this.notf;
    data['forbidden'] = this.forbidden;
    data['api_token'] = this.apiToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['country'] = this.country;
    data['city'] = this.city;
    data['evaluation'] = this.evaluation;
    data['google_token'] = this.googleToken;
    return data;
  }
}

class Area {
  int id;
  int parentId;
  String name;
  int code;
  String createdAt;
  String updatedAt;

  Area(
      {this.id,
      this.parentId,
      this.name,
      this.code,
      this.createdAt,
      this.updatedAt});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Regions {
  int id;
  int areaId;
  String city;
  String name;
  String createdAt;
  String updatedAt;

  Regions(
      {this.id,
      this.areaId,
      this.city,
      this.name,
      this.createdAt,
      this.updatedAt});

  Regions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaId = json['area_id'];
    city = json['city'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['area_id'] = this.areaId;
    data['city'] = this.city;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class YearModel {
  int id;
  String year;
  bool input;
}
