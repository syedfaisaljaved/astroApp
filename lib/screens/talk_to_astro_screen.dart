import 'dart:async';

import 'package:astro_app/bloc/astro_bloc.dart';
import 'package:astro_app/model/astrologers_model.dart';
import 'package:astro_app/repository/astro_repo.dart';
import 'package:astro_app/utils/img_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TalkToAstroScreen extends StatefulWidget {
  const TalkToAstroScreen({Key key}) : super(key: key);

  @override
  _TalkToAstroScreenState createState() => _TalkToAstroScreenState();
}

class _TalkToAstroScreenState extends State<TalkToAstroScreen> {
  AstroBloc _astroBloc;
  List<AstroData> astrologersList;
  TextEditingController _searchQuery;
  bool _isSearching = false;
  int _selectedFilter;
  int _selectedSort;
  StreamController<String> _searchStreamController;

  List<PopUpMenuItemList> sortItemList = [
    PopUpMenuItemList(0, "Experience- high and low"),
    PopUpMenuItemList(1, "Experience- low and high"),
    PopUpMenuItemList(2, "Price- high to low"),
    PopUpMenuItemList(3, "Price- low to high"),
  ];

  List<PopUpMenuItemList> filterItemList = [
    PopUpMenuItemList(0, "English"),
    PopUpMenuItemList(1, "Hindi"),
  ];

  @override
  void initState() {
    _astroBloc = AstroBloc(astroRepo: AstroRepo())..add(FetchAstrologers());
    _searchStreamController = StreamController<String>.broadcast();
    _searchQuery = new TextEditingController();
    _searchQuery.addListener(() {
      _searchStreamController.sink.add(_searchQuery.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _astroBloc.close();
    _searchQuery.dispose();
    _searchStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _astroBloc,
      child: BlocConsumer(
        cubit: _astroBloc,
        listener: (context, state) {
          if (state is SuccessAstrologersData) {
            astrologersList = state.data;
          }
        },
        builder: (context, state) {
          if (state is LoadingAstroState)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );

          if (astrologersList != null)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Talk to an Astrologer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        constraints: BoxConstraints(
                          maxHeight: 24,
                        ),
                        padding: EdgeInsets.zero,
                        icon: Image.asset(
                          search,
                          height: 20,
                        ),
                        onPressed: () {
                          /// search
                          _startSearch();
                        }),
                    _filterWidget(),
                    _sortWidget(),
                  ],
                ),
                if (_isSearching) _buildSearchField(),
                Expanded(
                  child: StreamBuilder<String>(
                      stream: _searchStreamController.stream,
                      builder: (context, snapshot) {
                        var resultList = snapshot.hasData
                            ? astrologersList.where((element) {
                                if (element.firstName
                                    .toLowerCase()
                                    .contains(snapshot.data.toLowerCase()))
                                  return true;
                                if (element.lastName
                                    .toLowerCase()
                                    .contains(snapshot.data.toLowerCase()))
                                  return true;
                                if (element.skills
                                    .where((item) => item.name
                                        .toLowerCase()
                                        .contains(snapshot.data.toLowerCase()))
                                    .toList()
                                    .isNotEmpty) return true;
                                return false;
                              }).toList()
                            : astrologersList;
                        return ListView.separated(
                          padding: EdgeInsets.all(16),
                          shrinkWrap: true,
                          itemCount: resultList.length,
                          itemBuilder: (context, index) =>
                              _astrologerItem(resultList[index]),
                          separatorBuilder: (context, index) {
                            return Divider();
                          },
                        );
                      }),
                ),
              ],
            );

          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _astrologerItem(AstroData astrologer) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            astrologer.images.medium.imageUrl,
            width: 100,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${astrologer.firstName} ${astrologer.lastName}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  getSkills(astrologer.skills),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  getLanguages(astrologer.languages),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "₹${astrologer.additionalPerMinuteCharges}/ Min",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton.icon(
                    color: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    icon: Icon(
                      Icons.call_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Talk on Call",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "Number not Available.",
                          toastLength: Toast.LENGTH_SHORT);
                    }),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "${astrologer.experience} Years",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      );

  String getSkills(List<Skills> skills) {
    String skill = "";

    skills.forEach((Skills element) {
      int index = skills.indexOf(element);
      if (index == skills.length - 1)
        skill += "${element.name}";
      else
        skill += "${element.name}, ";
    });
    return skill;
  }

  String getLanguages(List<Languages> languages) {
    String lang = "";

    languages.forEach((Languages element) {
      int index = languages.indexOf(element);
      if (index == languages.length - 1)
        lang += "${element.name}";
      else
        lang += "${element.name}, ";
    });
    return lang;
  }

  /// search bar

  void _startSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  void _clearSearchQuery() {
    print("close search box");
    _searchQuery.clear();
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.search,
                color: Colors.orange,
                size: 20,
              ),
            ),
            Flexible(
              child: TextField(
                cursorColor: Color(0xff502298),
                controller: _searchQuery,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search Astrologer',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.black, fontSize: 14),
                onChanged: updateSearchQuery,
              ),
            ),
            IconButton(
                constraints: BoxConstraints(
                  maxHeight: 24,
                ),
                padding: EdgeInsets.only(right: 10),
                icon: Icon(
                  Icons.close,
                  color: Colors.orange,
                  size: 20,
                ),
                onPressed: () {
                  /// search
                  _clearSearchQuery();
                }),
          ],
        ),
      ),
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      // searchQuery = newQuery;
    });
    print("search query " + newQuery);
  }

  Widget _filterWidget() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      offset: Offset(100,100),
      icon: Image.asset(
        filter,
        height: 20,
      ),
      onSelected: (selected) async {
        if (selected == "0") {
          setState(() {
            _selectedFilter = int.parse(selected);
            astrologersList = astrologersList.where((element) {
              if (element.languages
                  .where((lang) => lang.name.toLowerCase() == "english")
                  .toList()
                  .isNotEmpty) return true;
              return false;
            }).toList();
          });
        } else if (selected == "1") {
          setState(() {
            _selectedFilter = int.parse(selected);
            astrologersList = astrologersList.where((element) {
              if (element.languages
                  .where((lang) => lang.name.toLowerCase() == "hindi")
                  .toList()
                  .isNotEmpty) return true;
              return false;
            }).toList();
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return filterItemList.map((PopUpMenuItemList item) {
          return PopupMenuItem<String>(
            value: item.id.toString(),
            enabled: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.id == 0)
                  Text(
                    "Filter By",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.orange,
                    ),
                  ),
                if (item.id == 0)
                  SizedBox(
                    height: 10,
                  ),
                if (item.id == 0)
                  Divider(
                    thickness: 1,
                  ),
                Row(
                  children: [
                    Radio(
                      value: item.id,
                      groupValue: _selectedFilter,
                      onChanged: (index) {},
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.item,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Widget _sortWidget() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.only(right: 10),
      offset: Offset(0,100),
      icon: Image.asset(
        sort,
        height: 20,
      ),
      onSelected: (selected) async {
        if (selected == "0") {
          setState(() {
            _selectedSort = int.parse(selected);
            astrologersList
                .sort((a, b) => b.experience.compareTo(a.experience));
          });
        } else if (selected == "1") {
          setState(() {
            _selectedSort = int.parse(selected);
            astrologersList
                .sort((a, b) => a.experience.compareTo(b.experience));
          });
        } else if (selected == "2") {
          setState(() {
            _selectedSort = int.parse(selected);
            astrologersList.sort((a, b) => b.additionalPerMinuteCharges
                .compareTo(a.additionalPerMinuteCharges));
          });
        } else if (selected == "3") {
          setState(() {
            _selectedSort = int.parse(selected);
            astrologersList.sort((a, b) => a.additionalPerMinuteCharges
                .compareTo(b.additionalPerMinuteCharges));
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return sortItemList.map((PopUpMenuItemList item) {
          return PopupMenuItem<String>(
            value: item.id.toString(),
            enabled: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.id == 0)
                  Text(
                    "Sort By",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.orange,
                    ),
                  ),
                if (item.id == 0)
                  SizedBox(
                    height: 10,
                  ),
                if (item.id == 0)
                  Divider(
                    thickness: 1,
                  ),
                Row(
                  children: [
                    Radio(
                      value: item.id,
                      groupValue: _selectedSort,
                      onChanged: (index) {},
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.item,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

class PopUpMenuItemList {
  final int id;
  final String item;

  PopUpMenuItemList(this.id, this.item);
}
