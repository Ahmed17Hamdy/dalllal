import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:dalllalalarab/screens/Mainscreen/bottom_tabed.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:dalllalalarab/models/country_backmodel.dart';
import 'package:dalllalalarab/models/homeclass.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class AddAds extends StatefulWidget {
  @override
  _AddAdsState createState() => _AddAdsState();
}

List<Cats> categories;
List mainList = List();
List<Subcategories> subcategories;
List<Cities> cities;
List<Regions> allregions = List<Regions>();
List citiest = List();
List subList = List();
List modelList = List();
String pagetitle = 'إضافة إعلان';
Cats _dropdownValue;
Cities city;
bool _isButtonDisabled = false;

class _AddAdsState extends State<AddAds> {
  final GlobalKey<FormState> _formkeyvalue = new GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _registerscaffoldKey =
      new GlobalKey<ScaffoldState>();
  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();
  final TextEditingController price = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  String _title;
  bool hide = false;
  bool hide1 = false;
  String categoryname = "التصنيف";
  int _cat_id;
  int _area_id;
  int _brand = 0;
  String _body;
  String _price;
  Subcategories subcatvalue;

  String subcatname = "التصنيف الثانوي";

  Models _dropdownValuesub;

  Models model;
  List<YearModel> years = new List<YearModel>();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  String modelname = "الموديل";

  String cityname = 'إخترالمدينة';

  String yearname = "سنة التصنيع";

  YearModel _yearValuesub;

  int userid;

  String regionname = "إختر الحي";

  Regions region;

  List regions = List();

  bool regionvisible = false;

  int _regionid;

  String policy = "";

  Widget buildGridView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          Asset asset = images[index];
          return Padding(
            padding: EdgeInsets.only(left: 2.5, right: 2.5),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: mycolor, width: 3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  ),
                ),
                Positioned(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      images.remove(images[index]);
                    });
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ))
              ],
            ),
          );
        });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 15,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#DDB871",
          actionBarTitle: "إختر صور الإعلان",
          lightStatusBar: true,
          statusBarColor: "#DDB871",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      hide1 = true;
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future<void> _fetchdata() async {
    final prefs = await SharedPreferences.getInstance();
    var response = prefs.getString("response");
    userid = prefs.getInt("User_id")??0;
    if (response != null) {
      var f = jsonDecode(response);
      HomeClass data = new HomeClass.fromJson(f);
      categories = data.data.cats;
      cities = data.data.cities;
      allregions = data.data.regions;
      setState(() {
        mainList = categories;
        subcategories = data.data.subcategories;
        policy = prefs.getString("AppPoloicy" ?? "");
        citiest = cities;
      });
    }
  }

  Future<FormData> RegisterData() async {
    if (_brand != 0 && yearname == "سنة التصنيع") {
      if (images.length != 0) {
        List imageList = [];
        for (Asset asset in images) {
          ByteData byteData = await asset.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();
          MultipartFile multipartFile = new MultipartFile.fromBytes(
            imageData,
            filename: asset.name,
            //   contentType: MediaType("image", "jpg"),
          );

          imageList.add(multipartFile);
        }
        return FormData.fromMap(
          {
            "price": _price,
            "region_id": _regionid,
            //   "model":yearname != "سنة التصنيع" ?int.parse(yearname):0,
            "title": _title,
            "cat_id": _cat_id,
            "area_id": _area_id,
            "brand": _brand,
            "body": _body,
            "type_way": "image",
            "user_id": userid,

            "file_name": imageList,
            //   print(imageList);
          },
        );
      } else {
        return FormData.fromMap({
          "price": _price,
          "region_id": _regionid,
          //   "model":yearname != "سنة التصنيع" ?int.parse(yearname):0,
          "title": _title,
          "cat_id": _cat_id,
          "area_id": _area_id,
          "brand": _brand,
          "body": _body,
          "type_way": "image",
          "user_id": userid,
        });
      }
    } else if (_brand != 0 && yearname != "سنة التصنيع") {
      if (images.length != 0) {
        List imageList = [];
        for (Asset asset in images) {
          ByteData byteData = await asset.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();
          MultipartFile multipartFile = new MultipartFile.fromBytes(
            imageData,
            filename: asset.name,
            //   contentType: MediaType("image", "jpg"),
          );

          imageList.add(multipartFile);
        }
        return FormData.fromMap(
          {
            "title": _title,
            "region_id": _regionid,
            "price": _price,
            "model": int.parse(yearname),
            "cat_id": _cat_id,
            "area_id": _area_id,
            "brand": _brand,
            "body": _body,
            "user_id": userid,
            "type_way": "image",
            "file_name": imageList,
            //   print(imageList);
          },
        );
      } else {
        return FormData.fromMap({
          "price": _price,
          "region_id": _regionid,
          "model": int.parse(yearname),
          "title": _title,
          "cat_id": _cat_id,
          "area_id": _area_id,
          "brand": _brand,
          "body": _body,
          "type_way": "image",
          "user_id": userid,
        });
      }
    } else {
      if (images.length != 0) {
        List imageList = [];
        for (Asset asset in images) {
          ByteData byteData = await asset.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();
          MultipartFile multipartFile = new MultipartFile.fromBytes(
            imageData,
            filename: asset.name,
            //   contentType: MediaType("image", "jpg"),
          );

          imageList.add(multipartFile);
        }
        return FormData.fromMap(
          {
            "title": _title,
            "price": _price,
            //  "model":yearname != "سنة التصنيع" ?int.parse(yearname):0,

            "cat_id": _cat_id,
            "area_id": _area_id,
            "brand": 0,
            "body": _body,
            "user_id": userid,
            "type_way": "image",
            "file_name": imageList,
            //   print(imageList);
          },
        );
      } else {
        return FormData.fromMap({
          "price": _price,
          //   "model":yearname != "سنة التصنيع" ?int.parse(yearname):0,
          "title": _title,
          "cat_id": _cat_id,
          "area_id": _area_id,
          "brand": 0,
          "body": _body,
          "type_way": "image",
          "user_id": userid,
        });
      }
    }
  }

  Future _addadvirtise() async {
    var result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      //  loading.show();
      Response response;
      Dio dio = new Dio();
      var url = "https://dalllal.com/json/addpost";
      dio.options.baseUrl = url;
      // dio.options.connectTimeout = 10000;
      // dio.options.receiveTimeout = 10000;
      response = await dio.post(url,
          data: await RegisterData(),
          options: Options(
            validateStatus: (status) => status < 500,
          ));

      if (response.statusCode == 200) {
        Future.delayed(const Duration(milliseconds: 10000));
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'تم إضافة الإعلان بنجاح ',
            style: ksnackStyle,
          ),
        );
        _btnController.success();
        _registerscaffoldKey.currentState.showSnackBar(snackBar);
        _btnController.reset();

        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomTabbed()),
          );
        });
        //    Navigator.pop(context);
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 5000),
          content: Text(
            'تحقق من إتصالك بالإنترنت',
            style: ksnackStyle,
          ),
        );
        _btnController.error();

// Find the Scaffold in the widget tree and use it to show a SnackBar.
        _registerscaffoldKey.currentState.showSnackBar(snackBar);
        _btnController.reset();
      }
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5000),
        content: Text(
          'تحقق من إتصالك بالإنترنت',
          style: ksnackStyle,
        ),
      );
      _btnController.error();

// Find the Scaffold in the widget tree and use it to show a SnackBar.
      _registerscaffoldKey.currentState.showSnackBar(snackBar);
      _btnController.reset();
    }
  }

  void _getYears() {
    for (int i = 2021; i > 1992; i--) {
      YearModel year = new YearModel();
      year.id = i;
      year.year = i.toString();
      year.input = false;
      years.add(year);
    }
  }

  @override
  void initState() {
    super.initState();
    this._fetchdata();
    this._getYears();
  }

  @override
  Widget build(BuildContext context) {
    var _onPressed;
    if (_isButtonDisabled) {
      _onPressed = () {
        if (_formkeyvalue.currentState.validate()) {
          _addadvirtise();
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.

        } else {
          _btnController.stop();
        }
      };
    }
    return Scaffold(
      key: _registerscaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(pagetitle),
      ),
      backgroundColor: mycolor,
      body: Container(
        decoration: (BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bc.jpg'), fit: BoxFit.cover),
        )),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
            child: Form(
                key: _formkeyvalue,
                autovalidate: false,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                        child: TextFormField(
                          controller: title,
                          onChanged: ((String title) {
                            setState(() {
                              _title = title;
                            });
                          }),
                          // onFieldSubmitted: (v) {
                          //   FocusScope.of(context).requestFocus(focus);
                          // },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "من فضلك أدخل الإسم";
                            } else
                              return null;
                          },
                          style: TextStyle(color: kMyColor),
                          autofocus: false,
                          decoration:
                              kTextFeild.copyWith(labelText: 'إسم الإعلان'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: OutlineDropdownButtonFormField(
                          isExpanded: true,
                          hint: Text(
                            categoryname,
                            style: TextStyle(
                                color: kMyColor,
                                fontFamily: "Changa",
                                fontSize: 20),
                          ),
                          style: TextStyle(color: kMyColor),
                          decoration: kTextFeild.copyWith(
                              suffixIcon: Icon(
                            Icons.arrow_drop_down_circle,
                            color: mycolor,
                          )),
                          iconSize: 0,
                          items: mainList.map((category) {
                            return new DropdownMenuItem<Cats>(
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: "Changa",
                                  ),
                                ),
                                value: category);
                          }).toList(),
                          onChanged: (Cats newVal) {
                            setState(() {
                              subcatvalue = null;
                              _cat_id = 0;
                              model = null;
                              _brand = 0;
                              yearname = "سنة التصنيع";
                              modelname = "إختر الموديل";
                              subcatname = "التصنيف الثانوي";
                              _dropdownValue = newVal;
                              categoryname = newVal.name;
                              if (categoryname == 'السيارات') {
                                hide = true;
                              } else {
                                hide = false;
                                hide1 = false;
                              }

                              subList = subcategories
                                  .where(
                                      (subcat) => subcat.parentId == newVal.id)
                                  .toList();
                              if (subList.length != 0) {
                                hide = true;
                                _brand = 0;
                              } else {
                                hide = false;
                                hide1 = false;
                              }
                            });
                          },
                          validator: (_dropdownValue) => _dropdownValue == null
                              ? 'من فضلك إختر التصنيف'
                              : null,
                        ),
                      ),
                      Visibility(
                        visible: hide,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: OutlineDropdownButtonFormField(
                            isExpanded: true,
                            hint: Text(
                              subcatname,
                              style: TextStyle(
                                  color: kMyColor,
                                  fontFamily: "Changa",
                                  fontSize: 20),
                            ),
                            style: TextStyle(color: Colors.white),
                            decoration: kTextFeild.copyWith(
                                suffixIcon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: mycolor,
                            )),
                            iconSize: 0,
                            value: subcatvalue,
                            items: subList.map((subcat) {
                              return new DropdownMenuItem<Subcategories>(
                                  child: Text(
                                    subcat.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: "Changa",
                                    ),
                                  ),
                                  value: subcat);
                            }).toList(),
                            onChanged: (Subcategories newVal) {
                              setState(() {
                                _dropdownValuesub = null;
                                modelname = "الموديل";
                                subcatname = "التصنيف الثانوي";
                                modelname = "";
                                subcatvalue = newVal;
                                subcatname = newVal.name;
                                _cat_id = newVal.id;

                                modelList = newVal.models;
                                if (modelList.length != 0) {
                                  hide1 = true;
                                } else {
                                  hide1 = false;
                                }
                              });
                            },
                            validator: (value) =>
                                subcatname == "التصنيف الثانوي"
                                    ? 'من فضلك إختر التصنيف الثانوي'
                                    : null,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: hide1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: OutlineDropdownButtonFormField(
                            isExpanded: true,
                            hint: Text(
                              "الموديل",
                              style: TextStyle(
                                  color: kMyColor,
                                  fontFamily: "Changa",
                                  fontSize: 20),
                            ),
                            style: TextStyle(color: kMyColor),
                            decoration: kTextFeild.copyWith(
                                suffixIcon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: mycolor,
                            )),
                            iconSize: 0,
                            value: _dropdownValuesub,
                            items: modelList.map((model) {
                              return new DropdownMenuItem<Models>(
                                  child: Text(
                                    model.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: "Changa",
                                    ),
                                  ),
                                  value: model);
                            }).toList(),
                            onChanged: (Models newVal) {
                              setState(() {
                                _dropdownValuesub = newVal;
                                modelname = newVal.name;
                                _brand = newVal.id;
                              });
                            },
                            validator: (value) => modelname == "الموديل"
                                ? 'من فضلك إختر الموديل'
                                : null,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: hide1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: OutlineDropdownButtonFormField(
                            isExpanded: true,
                            hint: Text(
                              yearname,
                              style: TextStyle(
                                  color: kMyColor,
                                  fontFamily: "Changa",
                                  fontSize: 20),
                            ),
                            style: TextStyle(color: kMyColor),
                            decoration: kTextFeild.copyWith(
                                suffixIcon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: mycolor,
                            )),
                            iconSize: 0,
                            value: _yearValuesub,
                            items: years.map((model) {
                              return new DropdownMenuItem<YearModel>(
                                  child: Text(
                                    model.year,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: "Changa",
                                    ),
                                  ),
                                  value: model);
                            }).toList(),
                            onChanged: (YearModel newVal) {
                              setState(() {
                                _yearValuesub = newVal;
                                yearname = newVal.year;
                              });
                            },
                            validator: (value) => yearname == "سنة الصنع"
                                ? 'من فضلك إختر سنة الصنع'
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: OutlineDropdownButtonFormField(
                          //  value: city,
                          items: citiest.map((city) {
                            return new DropdownMenuItem<Cities>(
                                child: Text(
                                  city.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: "Changa",
                                  ),
                                ),
                                value: city);
                          }).toList(),
                          onChanged: (Cities newVal) {
                            setState(() {
                              city = newVal;
                              region = null;
                              regionname = "إختر الحي";
                              cityname = newVal.name;
                              _area_id = newVal.id;
                              regions.clear();
                              regions.addAll(allregions
                                  .where((sub) => sub.areaId == _area_id)
                                  .toList());
                              if (regions.length != 0) {
                                regionvisible = true;
                              } else {
                                regionvisible = false;
                              }
                              // _cityid = newVal.id.toString();
                            });
                          },
                          validator: (value) =>
                              value == null ? 'من فضلك إختر المدينة' : null,
                          isDense: true,
                          decoration: kTextFeild.copyWith(
                              suffixIcon: Icon(
                            Icons.arrow_drop_down_circle,
                            color: mycolor,
                          )),
                          iconSize: 0,
                          hint: Text(
                            cityname,
                            style: TextStyle(
                                color: kMyColor,
                                fontFamily: "Changa",
                                fontSize: 15),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Visibility(
                        visible: regionvisible,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: OutlineDropdownButtonFormField(
                            //  value: city,
                            items: regions.map((region) {
                              return new DropdownMenuItem<Regions>(
                                  child: Text(
                                    region.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: "Changa",
                                    ),
                                  ),
                                  value: region);
                            }).toList(),
                            onChanged: (Regions newVal) {
                              setState(() {
                                region = newVal;
                                regionname = newVal.name;
                                _regionid = newVal.id;
                                // _cityid = newVal.id.toString();
                              });
                            },

                            isDense: true,
                            decoration: kTextFeild.copyWith(
                                suffixIcon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: mycolor,
                            )),
                            iconSize: 0,
                            hint: Text(
                              regionname,
                              style: TextStyle(
                                  color: kMyColor,
                                  fontFamily: "Changa",
                                  fontSize: 15),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                        child: TextFormField(
                          controller: price,
                          onChanged: ((String price) {
                            setState(() {
                              _price = price;
                            });
                          }),
                          // onFieldSubmitted: (v) {
                          //   FocusScope.of(context).requestFocus(focus);
                          // },
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: kMyColor),
                          autofocus: false,
                          decoration: kTextFeild.copyWith(labelText: 'السعر'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: TextFormField(
                          enableSuggestions: true,
                          textInputAction: TextInputAction.newline,
                          controller: body,
                          onChanged: ((String body) {
                            setState(() {
                              _body = body;
                            });
                          }),
                          maxLines: 10,
                          keyboardType: TextInputType.multiline,
                          maxLength: 500,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "من فضلك أدخل نص الإعلان";
                            } else
                              return null;
                          },
                          style: TextStyle(color: kMyColor),
                          autofocus: false,
                          decoration:
                              kTextFeildAdd.copyWith(labelText: 'نص الإعلان'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "أضف صور الإعلان",
                              style: TextStyle(color: kMyColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    hoverColor: Colors.grey,
                                    highlightColor: mycolor,
                                    splashColor: mycolor,
                                    focusColor: mycolor,
                                    onTap: loadAssets,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2.5),
                                      child: Container(
                                        width: width * 0.2,
                                        height: height * 0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                              color: mycolor, width: 3),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Icon(
                                          FontAwesomeIcons.camera,
                                          color: mycolor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: hide1,
                                  child: Expanded(
                                    flex: 4,
                                    child: Wrap(
                                      children: <Widget>[
                                        Container(
                                            width: width * 0.8,
                                            height: height * 0.1,
                                            child: buildGridView()),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Row(
                          children: <Widget>[
                            Theme(
                                data: ThemeData(unselectedWidgetColor: mycolor),
                                child: Checkbox(
                                    value: _isButtonDisabled,
                                    activeColor: mycolor,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isButtonDisabled = value;
                                      });
                                    })),
                            Text(
                              "الموافقة على ",
                              style: TextStyle(color: mycolor),
                            ),
                            GestureDetector(
                              onTap: _onPolicyPress,
                              child: Text(
                                "إتفاقية العمولة ",
                                style: TextStyle(
                                    color: mycolor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: RoundedLoadingButton(
                          color: kButtonColor,
                          animateOnTap: true,
                          controller: _btnController,
                          width: width * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              child: Text(
                                'إرسال',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onPressed: _onPressed,
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }

  void _onPolicyPress() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Column(
              children: <Widget>[
                Text(
                  "إتفاقية العمولة",
                  style: kDialogText,
                ),
                Divider(),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'بسم الله الرحمن الرحيم',
                    style: kDialogText,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'وَأَوْفُواْ بِعَهْدِ اللهِ إِذَا عَاهَدتُّمْ وَلاَ تَنقُضُواْ الأَيْمَانَ بَعْدَ تَوْكِيدِهَا وَقَدْ جَعَلْتُمُ اللهَ عَلَيْكُمْ كَفِيلاً',
                    style: kDialogText,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    policy,
                    style: kDialogText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '* كما أتعهد بدفع العمولة خلال 10 أيام من إستلام مبلغ المبايعة .',
                    style: kDialogText,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "حسناً",
                    style: kDialogText,
                  ))
            ],
          );
        });
  }
}
