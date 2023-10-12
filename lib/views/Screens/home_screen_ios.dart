import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../Model/weather_model.dart';
import '../../Providers/connectivity_provider.dart';
import '../../Providers/theme_provider.dart';
import '../../Providers/weather_provider.dart';
import '../../utils/image_path.dart';


class Home_ios_Page extends StatefulWidget {
  const Home_ios_Page({Key? key}) : super(key: key);

  @override
  State<Home_ios_Page> createState() => _Home_ios_PageState();
}

class _Home_ios_PageState extends State<Home_ios_Page> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkInternetConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: CupertinoPageScaffold(
          child: (Provider.of<ConnectivityProvider>(context)
              .connection
              .status ==
              "Waiting")
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/No_connection.jpg',
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: _height * 0.01,
                ),
                Text(
                  "No Connection",
                  style: TextStyle(fontSize: _height * 0.022),
                ),
              ],
            ),
          )
              : FutureBuilder(
            future: Provider.of<WeatherProvider>(context, listen: false)
                .weatherData((Provider.of<WeatherProvider>(context)
                .searchLocation
                .location)),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error : ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                Weather? data = snapshot.data;
                return (data == null)
                    ? const Center(
                  child: Text("No Data Available.."),
                )
                    : Stack(
                  children: [
                    Container(
                      height: _height,
                      width: _width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          (Provider.of<ThemeProvider>(context)
                              .themeModel
                              .isDark)
                              ? AssetImage(iosImageDark)
                              : AssetImage(iosImageLight),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter:
                        ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            CupertinoSearchTextField(
                              controller:
                              Provider.of<WeatherProvider>(
                                  context)
                                  .searchLocation
                                  .locationController,
                              placeholder: 'Search',
                              // decoration: BoxDecoration(
                              //   suffixIcon: Row(
                              //     children: <Widget>[
                              //       CupertinoButton(
                              //         child: Icon(
                              //             CupertinoIcons.xmark_circle),
                              //         onPressed: () {
                              //           Provider.of<WeatherProvider>(
                              //                   context,
                              //                   listen: false)
                              //               .searchLocation
                              //               .locationController
                              //               .clear();
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),

                              // decoration: Cupertinodecoration(
                              //   labelText: "Search location",
                              //   suffixIconColor:
                              //       CupertinoColors.white,
                              //   suffixIcon: CupertinoButton(
                              //     onPressed: () {
                              //       Provider.of<WeatherProvider>(
                              //               context,
                              //               listen: false)
                              //           .searchLocation
                              //           .locationController
                              //           .clear();
                              //     },
                              //     child: const Icon(
                              //         CupertinoIcons.xmark_circle),
                              //   ),
                              // ),
                              onSubmitted: (val) {
                                if (val.isNotEmpty) {
                                  Provider.of<WeatherProvider>(
                                      context,
                                      listen: false)
                                      .searchWeather(val);
                                  Provider.of<WeatherProvider>(
                                      context,
                                      listen: false)
                                      .searchLocation
                                      .locationController
                                      .clear();
                                } else {
                                  Provider.of<WeatherProvider>(
                                      context,
                                      listen: false)
                                      .searchWeather(Provider.of<
                                      WeatherProvider>(
                                      context,
                                      listen: false)
                                      .searchLocation
                                      .location);
                                }
                              },
                            ),
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.name,
                                      style: TextStyle(
                                        fontSize: _height * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color:
                                        CupertinoColors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: _height * 0.005,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(CupertinoIcons
                                            .location),
                                        SizedBox(
                                          width: _width * 0.02,
                                        ),
                                        Text(
                                          "Lat :  ${data.lat} °",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.018,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: CupertinoColors
                                                .white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: _width * 0.08,
                                        ),
                                        Text(
                                          "Lon :  ${data.lon} °",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.018,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: CupertinoColors
                                                .white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    Provider.of<ThemeProvider>(
                                        context,
                                        listen: false)
                                        .changeTheme();
                                  },
                                  child: (Provider.of<
                                      ThemeProvider>(
                                      context)
                                      .themeModel
                                      .isDark)
                                      ? const Icon(
                                    CupertinoIcons.sun_max,
                                    color:
                                    CupertinoColors.white,
                                  )
                                      : const Icon(
                                    CupertinoIcons.light_max,
                                    color:
                                    CupertinoColors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _height * 0.1,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              textBaseline: TextBaseline.alphabetic,
                              crossAxisAlignment:
                              CrossAxisAlignment.baseline,
                              children: [
                                Text(
                                  "${data.temp_c}°",
                                  style: TextStyle(
                                    fontSize: _height * 0.08,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                                Text(
                                  data.condition,
                                  style: TextStyle(
                                    fontSize: _height * 0.025,
                                    fontWeight: FontWeight.w500,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics:
                              const BouncingScrollPhysics(),
                              child: Row(
                                children: List.generate(
                                  data.hour.length,
                                      (index) => Padding(
                                    padding: const EdgeInsets.only(
                                        right: 28),
                                    child: Column(
                                      children: [
                                        (data.hour[DateTime.now()
                                            .hour]
                                        ['time']
                                            .split(
                                            "${DateTime.now().day}")[
                                        1] ==
                                            data.hour[index]
                                            ['time']
                                                .split(
                                                "${DateTime.now().day}")[1])
                                            ? Text(
                                          "Now",
                                          style: TextStyle(
                                            color:
                                            CupertinoColors
                                                .white,
                                            fontSize:
                                            _height *
                                                0.022,
                                          ),
                                        )
                                            : Text(
                                          data.hour[index]
                                          ['time']
                                              .split(
                                              "${DateTime.now().day}")[1],
                                          style: TextStyle(
                                            color:
                                            CupertinoColors
                                                .white,
                                            fontSize:
                                            _height *
                                                0.022,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        Image.network(
                                          "http:${data.hour[index]['condition']['icon']}",
                                          height: _height * 0.05,
                                          width: _height * 0.05,
                                        ),
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        Text(
                                          "${data.hour[index]['temp_c']}°",
                                          style: TextStyle(
                                            color: CupertinoColors
                                                .white,
                                            fontSize:
                                            _height * 0.022,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _height * 0.05,
                            ),
                            Text(
                              "Weather details",
                              style: TextStyle(
                                fontSize: _height * 0.02,
                                color: CupertinoColors.white,
                              ),
                            ),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: _height * 0.18,
                                  width: _width * 0.45,
                                  decoration: BoxDecoration(
                                    color:
                                    (Provider.of<ThemeProvider>(
                                        context)
                                        .themeModel
                                        .isDark)
                                        ? CupertinoColors.black
                                        .withOpacity(0.4)
                                        : CupertinoColors.white
                                        .withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.circular(
                                        _height * 0.02),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons
                                              .thermometer_sun,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "Feels Like",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Text(
                                              "${data.feelslike_c}",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.025,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              "°",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.018,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: _height * 0.18,
                                  width: _width * 0.45,
                                  decoration: BoxDecoration(
                                    color:
                                    (Provider.of<ThemeProvider>(
                                        context)
                                        .themeModel
                                        .isDark)
                                        ? CupertinoColors.black
                                        .withOpacity(0.4)
                                        : CupertinoColors.white
                                        .withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.circular(
                                        _height * 0.02),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons.wind,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "SW wind",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Row(
                                          textBaseline: TextBaseline
                                              .ideographic,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .baseline,
                                          children: [
                                            Text(
                                              "${data.wind_kph}",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.025,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              "km/h",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.018,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: _height * 0.18,
                                  width: _width * 0.45,
                                  decoration: BoxDecoration(
                                    color:
                                    (Provider.of<ThemeProvider>(
                                        context)
                                        .themeModel
                                        .isDark)
                                        ? CupertinoColors.black
                                        .withOpacity(0.4)
                                        : CupertinoColors.white
                                        .withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.circular(
                                        _height * 0.02),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons.wind_snow,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "Humidity",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Row(
                                          textBaseline: TextBaseline
                                              .ideographic,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .baseline,
                                          children: [
                                            Text(
                                              "${data.humidity}",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.025,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              "%",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.018,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: _height * 0.18,
                                  width: _width * 0.45,
                                  decoration: BoxDecoration(
                                    color:
                                    (Provider.of<ThemeProvider>(
                                        context)
                                        .themeModel
                                        .isDark)
                                        ? CupertinoColors.black
                                        .withOpacity(0.4)
                                        : CupertinoColors.white
                                        .withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.circular(
                                        _height * 0.02),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons.lightbulb,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "UV",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Row(
                                          textBaseline: TextBaseline
                                              .ideographic,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .baseline,
                                          children: [
                                            Text(
                                              "${data.uv}",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.025,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              "Strong",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.018,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: _height * 0.18,
                                  width: _width * 0.45,
                                  decoration: BoxDecoration(
                                    color:
                                    (Provider.of<ThemeProvider>(
                                        context)
                                        .themeModel
                                        .isDark)
                                        ? CupertinoColors.black
                                        .withOpacity(0.4)
                                        : CupertinoColors.white
                                        .withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.circular(
                                        _height * 0.02),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons.eye,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "Visibility",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Row(
                                          textBaseline: TextBaseline
                                              .ideographic,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .baseline,
                                          children: [
                                            Text(
                                              "${data.vis_km}",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.025,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              "km",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.018,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: _height * 0.18,
                                  width: _width * 0.45,
                                  decoration: BoxDecoration(
                                    color:
                                    (Provider.of<ThemeProvider>(
                                        context)
                                        .themeModel
                                        .isDark)
                                        ? CupertinoColors.black
                                        .withOpacity(0.4)
                                        : CupertinoColors.white
                                        .withOpacity(0.4),
                                    borderRadius:
                                    BorderRadius.circular(
                                        _height * 0.02),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons
                                              .wand_stars_inverse,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "Air pressure",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Row(
                                          textBaseline: TextBaseline
                                              .ideographic,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .baseline,
                                          children: [
                                            Text(
                                              "${data.pressure_mb}",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.025,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              "hPa",
                                              style: TextStyle(
                                                fontSize:
                                                _height * 0.018,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            Container(
                              height: _height * 0.18,
                              width: _width,
                              decoration: BoxDecoration(
                                color: (Provider.of<ThemeProvider>(
                                    context)
                                    .themeModel
                                    .isDark)
                                    ? CupertinoColors.black
                                    .withOpacity(0.4)
                                    : CupertinoColors.white
                                    .withOpacity(0.4),
                                borderRadius: BorderRadius.circular(
                                    _height * 0.02),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          CupertinoIcons.lightbulb,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "Sunrise",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Text(
                                          data.sunrise,
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.024,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          CupertinoIcons.sun_max,
                                          size: _height * 0.04,
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          "Sunset",
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.02,
                                            fontWeight:
                                            FontWeight.w500,
                                            color: (Provider.of<
                                                ThemeProvider>(
                                                context)
                                                .themeModel
                                                .isDark)
                                                ? CupertinoColors
                                                .extraLightBackgroundGray
                                                : CupertinoColors
                                                .black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.003,
                                        ),
                                        Text(
                                          data.sunset,
                                          style: TextStyle(
                                            fontSize:
                                            _height * 0.024,
                                            fontWeight:
                                            FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}