import 'package:astro_app/bloc/astro_bloc.dart';
import 'package:astro_app/model/daily_panchng_model.dart';
import 'package:astro_app/model/location_model.dart';
import 'package:astro_app/repository/astro_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class DailyPanchangScreen extends StatefulWidget {
  const DailyPanchangScreen({Key key}) : super(key: key);

  @override
  _DailyPanchangScreenState createState() => _DailyPanchangScreenState();
}

class _DailyPanchangScreenState extends State<DailyPanchangScreen> {
  AstroBloc _astroBloc;
  DateTime _selectedDate;
  String _dateText;
  TextEditingController _typeAheadController;

  @override
  void initState() {
    _astroBloc = AstroBloc(astroRepo: AstroRepo());
    _selectedDate = DateTime.now();
    _dateText = DateFormat("dd MMMM, yyyy").format(DateTime.now());
    _typeAheadController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _astroBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return;
      },
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform(
                transform: Matrix4.translationValues(-10, 0, 0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 30,
                        color: Colors.black,
                      ),
                      Text(
                        "Daily Panchang",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "India is a country known for its festival but knowing the exact dates can sometimes be difficult. To ensure you do not miss out on the critical dates we bring you the daily panchang",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Container(
                height: 150,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(20),
                color: Colors.orange.withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Date:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    _dateText ??
                                        DateFormat("dd MMMM, yyyy")
                                            .format(DateTime.now()),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Location:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: TypeAheadFormField(
                            hideOnEmpty: true,
                            hideOnError: true,
                            hideOnLoading: true,
                            hideSuggestionsOnKeyboardHide: false,
                            textFieldConfiguration: TextFieldConfiguration(
                              enableInteractiveSelection: true,
                              style: TextStyle(fontWeight: FontWeight.w300),
                              autofocus: false,
                              controller: _typeAheadController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: "Enter Location",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              print("pattern $pattern");
                              if (pattern.trim().isNotEmpty) {
                                var data = await AstroRepo()
                                    .getLocation(place: pattern.trim());
                                return data.data;
                              }
                            },
                            itemBuilder: (context, PlaceData suggestion) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  suggestion.placeName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              );
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (PlaceData suggestion) {
                              _typeAheadController.text = suggestion.placeName;
                              _astroBloc.add(FetchDailyPanchangData(
                                  placeId: suggestion.placeId,
                                  date: _selectedDate));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _blocBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blocBody() {
    return BlocProvider(
      create: (context) => _astroBloc,
      child: BlocBuilder(
        cubit: _astroBloc,
        builder: (context, state) {
          if (state is SuccessDailyPanchangData) {
            return Container(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          _timeWidget("Sunrise", state.data.sunrise),
                          VerticalDivider(thickness: 0.6,indent: 5, endIndent: 5, color: Colors.black,),
                          _timeWidget("Sunset", state.data.sunset),
                          VerticalDivider(thickness: 0.6,indent: 5, endIndent: 5, color: Colors.black,),
                          _timeWidget("Moonrise", state.data.moonrise),
                          VerticalDivider(thickness: 0.6,indent: 5, endIndent: 5, color: Colors.black,),
                          _timeWidget("Moonset", state.data.moonset),
                        ],
                      ),
                    ),
                  ),
                  _tithiWidget(state.data.tithi),
                  _nakShatraWidget(state.data.nakshatra),
                  _yogWidget(state.data.yog),
                  _karanWidget(state.data.karan),
                  _hinduMaah(state.data.hinduMaah),
                ],
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _tithiWidget(Tithi tithi) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              "Tithi",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          _rowItem("Tithi Number:", tithi.tithiDetails.tithiNumber.toString()),
          _rowItem("Tithi Name:", tithi.tithiDetails.tithiName.toString()),
          _rowItem("Special:", tithi.tithiDetails.special),
          _rowItem("Summary:", tithi.tithiDetails.summary),
          _rowItem("Deity:", tithi.tithiDetails.deity),
          _rowItem("End Time:",
              "${tithi.endTime.hour} hr ${tithi.endTime.minute} min ${tithi.endTime.second} sec"),
        ],
      );

  Widget _nakShatraWidget(Nakshatra nakshatra) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              "Nakshatra",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          _rowItem("Nakshatra Number:",
              nakshatra.nakshatraDetails.nakNumber.toString()),
          _rowItem("Nakshatra Name:", nakshatra.nakshatraDetails.nakName),
          _rowItem("Special:", nakshatra.nakshatraDetails.special),
          _rowItem("Summary:", nakshatra.nakshatraDetails.summary),
          _rowItem("Deity:", nakshatra.nakshatraDetails.deity),
          _rowItem("End Time:",
              "${nakshatra.endTime.hour} hr ${nakshatra.endTime.minute} min ${nakshatra.endTime.second} sec"),
        ],
      );

  Widget _yogWidget(Yog yog) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              "Yog",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          _rowItem("Yog Number:", yog.yogDetails.yogNumber.toString()),
          _rowItem("Yog Name:", yog.yogDetails.yogName),
          _rowItem("Special:", yog.yogDetails.special),
          _rowItem("Meaning:", yog.yogDetails.meaning),
          _rowItem("End Time:",
              "${yog.endTime.hour} hr ${yog.endTime.minute} min ${yog.endTime.second} sec"),
        ],
      );

  Widget _karanWidget(Karan karan) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              "Karan",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          _rowItem("Karan Number:", karan.karanDetails.karanNumber.toString()),
          _rowItem("Karan Name:", karan.karanDetails.karanName),
          _rowItem("Special:", karan.karanDetails.special),
          _rowItem("Deity:", karan.karanDetails.deity),
          _rowItem("End Time:",
              "${karan.endTime.hour} hr ${karan.endTime.minute} min ${karan.endTime.second} sec"),
        ],
      );

  Widget _hinduMaah(HinduMaah hinduMaah) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              "Hindu Maah",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          _rowItem("Purnimanta:", hinduMaah.purnimanta),
          _rowItem("Amanta:", hinduMaah.amanta),
        ],
      );

  Widget _rowItem(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );

  void _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  /// This builds material date picker in Android
  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year.toInt()),
      lastDate: DateTime(DateTime.now().year.toInt() + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateText = DateFormat("dd MMMM, yyyy").format(picked);
      });
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != _selectedDate)
                  setState(() {
                    _selectedDate = picked;
                    _dateText = DateFormat("dd MMMM, yyyy").format(picked);
                  });
              },
              initialDateTime: _selectedDate,
              minimumYear: DateTime.now().year.toInt(),
              maximumYear: DateTime.now().year.toInt() + 1,
            ),
          );
        });
  }

  Widget _timeWidget(String title, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.blue[900],
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                height: 1,
                fontSize: 11,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
  );
}
