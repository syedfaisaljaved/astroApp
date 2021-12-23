import 'package:astro_app/model/astrologers_model.dart';
import 'package:astro_app/model/daily_panchng_model.dart';
import 'package:astro_app/model/location_model.dart';
import 'package:astro_app/repository/astro_repo.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AstroBloc extends Bloc<AstroEvent, AstroState> {
  final AstroRepo astroRepo;

  AstroBloc({this.astroRepo}) : super(InitAstroState());

  @override
  Stream<AstroState> mapEventToState(AstroEvent event) async* {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      /// not connected to internet
      Fluttertoast.showToast(msg: "No Internet Connection", toastLength: Toast.LENGTH_SHORT);
      return;
    }

    if (event is FetchDailyPanchangData) {
      var data = await astroRepo.getDailyPanchangData(
          day: event.date.day,
          month: event.date.month,
          year: event.date.year,
          placeId: event.placeId);

      if(data.success){
        yield SuccessDailyPanchangData(data.data);
      } else{
        yield ErrorAstroState();
      }
    }

    if(event is FetchAstrologers){
      yield LoadingAstroState();
      var data = await astroRepo.getAstrologers();
      if(data.success)
        yield SuccessAstrologersData(data.data);
      else
        yield ErrorAstroState();
    }
  }
}


abstract class AstroEvent extends Equatable {
  const AstroEvent();
}

class FetchDailyPanchangData extends AstroEvent {
  final String placeId;
  final DateTime date;

  FetchDailyPanchangData({this.date, this.placeId});

  @override
  List<Object> get props => [placeId, date];
}

class FetchAstrologers extends AstroEvent {

  FetchAstrologers();

  @override
  List<Object> get props {}
}

abstract class AstroState extends Equatable {
  const AstroState();
}

class InitAstroState extends AstroState {
  const InitAstroState();

  @override
  List<Object> get props => [];
}

class LoadingAstroState extends AstroState {
  const LoadingAstroState();

  @override
  List<Object> get props => [];
}

class ErrorAstroState extends AstroState {
  const ErrorAstroState();

  @override
  List<Object> get props => [];
}

class SuccessDailyPanchangData extends AstroState {
  final Data data;
  const SuccessDailyPanchangData(this.data);

  @override
  List<Object> get props {}
}

class SuccessAstrologersData extends AstroState {
  final List<AstroData> data;
  const SuccessAstrologersData(this.data);

  @override
  List<Object> get props {}
}
