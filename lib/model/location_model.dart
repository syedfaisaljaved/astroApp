class LocationModel {
  String httpStatus;
  int httpStatusCode;
  bool success;
  String message;
  String apiName;
  List<PlaceData> data;

  LocationModel(
      {this.httpStatus,
        this.httpStatusCode,
        this.success,
        this.message,
        this.apiName,
        this.data});

  LocationModel.fromJson(Map<String, dynamic> json) {
    httpStatus = json['httpStatus'];
    httpStatusCode = json['httpStatusCode'];
    success = json['success'];
    message = json['message'];
    apiName = json['apiName'];
    if (json['data'] != null) {
      data = new List<PlaceData>();
      json['data'].forEach((v) {
        data.add(new PlaceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['httpStatus'] = this.httpStatus;
    data['httpStatusCode'] = this.httpStatusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    data['apiName'] = this.apiName;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlaceData {
  String placeName;
  String placeId;

  PlaceData({this.placeName, this.placeId});

  PlaceData.fromJson(Map<String, dynamic> json) {
    placeName = json['placeName'];
    placeId = json['placeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['placeName'] = this.placeName;
    data['placeId'] = this.placeId;
    return data;
  }
}
