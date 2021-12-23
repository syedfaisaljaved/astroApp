import 'dart:convert';

import 'package:astro_app/model/astrologers_model.dart';
import 'package:astro_app/model/daily_panchng_model.dart';
import 'package:astro_app/model/location_model.dart';
import 'package:astro_app/network/api_provider.dart';

class AstroRepo {
  static final AstroRepo _authRepo = AstroRepo._();

  AstroRepo._();

  factory AstroRepo() {
    return _authRepo;
  }

  static final apiProvider = ApiProvider();

  Future<DailyPanchangModel> getDailyPanchangData(
      {String placeId, int day, int month, int year}) async {
    return DailyPanchangModel.fromJson(await apiProvider
        .postJson("${apiProvider.baseUrl}horoscope/daily/panchang", jsonEncode({
      "day": day,
      "month": month,
      "year": year,
      "placeId": placeId,
    })));
  }

  Future<LocationModel> getLocation({String place}) async {
    return LocationModel.fromJson(await apiProvider
        .get("${apiProvider.baseUrl}location/place?inputPlace=$place"));
  }

  Future<AstrologersModel> getAstrologers() async {
    return AstrologersModel.fromJson(await apiProvider
        .get("${apiProvider.baseUrl}agent/all"));
  }
}
