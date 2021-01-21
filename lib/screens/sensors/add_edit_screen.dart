import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/screens/sensors/pick_location_screen.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
import 'package:acoustic_event_detector/widgets/custom_floating_button.dart';
import 'package:acoustic_event_detector/widgets/custom_platform_alert_dialog.dart';
import 'package:acoustic_event_detector/widgets/custom_safe_area.dart';
import 'package:acoustic_event_detector/widgets/custom_text_field.dart';
import 'package:acoustic_event_detector/widgets/sensors/add_sensor_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:acoustic_event_detector/generated/l10n.dart';
import 'package:acoustic_event_detector/screens/sensors/bloc/sensors_bloc.dart';
import 'package:acoustic_event_detector/utils/color_helper.dart';
import 'package:acoustic_event_detector/utils/styles.dart';
import 'package:acoustic_event_detector/widgets/custom_app_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';

class AddEditScreen extends StatefulWidget {
  static const routeName = '/add-edit';

  final bool canDelete;
  final bool isEdit;
  final bool isMap;
  final Sensor sensor;

  AddEditScreen({
    Key key,
    @required this.isEdit,
    @required this.canDelete,
    this.isMap = false,
    this.sensor,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = [FocusNode(), FocusNode(), FocusNode()];

  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  double _latitude;
  double _longitude;
  int _id;
  Placemark _placemark;

  @override
  void initState() {
    super.initState();
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    if (widget.sensor != null) {
      _latitude = widget.sensor.latitude;
      _longitude = widget.sensor.longitude;
      _id = widget.sensor.id;

      _controllers[0]..text = _id.toString();
      _controllers[1]..text = _latitude.toString();
      _controllers[2]..text = _longitude.toString();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((TextEditingController element) {
      element.dispose();
    });
    super.dispose();
  }

  void _refreshMap() {
    if (_formKey.currentState.validate()) {
      _focusNodes.forEach((FocusNode element) {
        element.unfocus();
      });
      setState(() {});
    }
  }

  bool _checkRanges({
    @required double min,
    @required double max,
    @required double value,
  }) {
    if (value == null) {
      return false;
    }
    return value <= max && value >= min;
  }

  Future<Placemark> _getPlacemark() async {
    if (_latitude != null &&
        _longitude != null &&
        _checkRanges(min: -90.0, max: 90.0, value: _latitude) &&
        _checkRanges(min: -180.0, max: 180.0, value: _longitude)) {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(_latitude, _longitude);

      return placemarks.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        widget.isMap
            ? BlocProvider.of<SensorsBloc>(context, listen: false)
                .add(SensorsMapRequested())
            : BlocProvider.of<SensorsBloc>(context, listen: false)
                .add(SensorsRequested());
        return true;
      },
      child: CustomSafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: widget.isEdit
                ? widget.canDelete
                    ? '${S.current.update_sensor} ${S.current.id}: ${widget.sensor.id}'
                    : '${S.current.sensor} ${S.current.id}: ${widget.sensor.id}'
                : S.current.add_sensor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: ColorHelper.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.isMap
                    ? BlocProvider.of<SensorsBloc>(context, listen: false)
                        .add(SensorsMapRequested())
                    : BlocProvider.of<SensorsBloc>(context, listen: false)
                        .add(SensorsRequested());
              },
            ),
            actions: widget.isEdit && widget.canDelete
                ? [
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: ColorHelper.white,
                      ),
                      onPressed: () async {
                        final action = await showDialog(
                          context: context,
                          builder: (context) => CustomPlatformAlertDialog(
                            oneOptionOnly: false,
                            onlySecondImportant: true,
                            title: S.current.delete_sensor,
                            message: Text(
                              S.current.delete_question,
                              style: Styles.defaultGreyRegular14,
                            ),
                          ),
                        );

                        if (action == CustomAction.First) {
                          Navigator.pop(context);
                          BlocProvider.of<SensorsBloc>(context, listen: false)
                              .add(
                            DeleteSensor(sensorToBeDeleted: widget.sensor),
                          );
                        }
                      },
                    )
                  ]
                : [],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _controllers[0],
                              focusNode: _focusNodes[0],
                              labelText: S.current.id,
                              inputAction: TextInputAction.next,
                              onChanged: (String value) {
                                _id = int.tryParse(value);
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[1]);
                              },
                              validator: (_) {
                                return _id == null
                                    ? S.current.id_error_message
                                    : null;
                              },
                              inputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            CustomTextField(
                              controller: _controllers[1],
                              focusNode: _focusNodes[1],
                              labelText: S.current.latitude,
                              inputAction: TextInputAction.next,
                              onChanged: (String value) {
                                _latitude = double.tryParse(value);
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[2]);
                              },
                              validator: (_) => !_checkRanges(
                                min: -90.0,
                                max: 90.0,
                                value: _latitude,
                              )
                                  ? S.current.latitute_error_message
                                  : null,
                              inputType: TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            CustomTextField(
                              controller: _controllers[2],
                              focusNode: _focusNodes[2],
                              labelText: S.current.longitude,
                              onChanged: (String value) {
                                _longitude = double.tryParse(value);
                              },
                              inputAction: TextInputAction.next,
                              validator: (_) => !_checkRanges(
                                min: -180.0,
                                max: 180.0,
                                value: _longitude,
                              )
                                  ? S.current.longitude_error_message
                                  : null,
                              onFieldSubmitted: (_) {
                                _refreshMap();
                              },
                              inputType: TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            _focusNodes[1].hasFocus || _focusNodes[2].hasFocus
                                ? CustomFloatingButton(
                                    onPressed: () async {
                                      final LatLng pickedPlace =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PickLocationScreen(),
                                        ),
                                      );
                                      setState(() {
                                        _latitude = double.parse(pickedPlace
                                            .latitude
                                            .toStringAsFixed(6));
                                        _longitude = double.parse(pickedPlace
                                            .longitude
                                            .toStringAsFixed(6));
                                        _controllers[1].text = pickedPlace
                                            .latitude
                                            .toStringAsFixed(6);
                                        _controllers[2].text = pickedPlace
                                            .longitude
                                            .toStringAsFixed(6);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.place_rounded,
                                      color: ColorHelper.white,
                                    ),
                                    label: S.current.pick_on_map,
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: ColorHelper.darkBlue,
                      indent: 10.0,
                      endIndent: 10.0,
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 220.0,
                      width: double.infinity,
                      child: FutureBuilder<Placemark>(
                        future: _getPlacemark(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                S.current.no_address_found,
                                style: Styles.defaultGreyRegular16,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Center(child: CustomCircularIndicator());
                          }
                          _placemark = snapshot.data;
                          return AddSensorMap(
                            latitude: _latitude,
                            longitude: _longitude,
                            refreshMap: _refreshMap,
                            placemark: _placemark == null
                                ? null
                                : _placemark.street == 'Unnamed Road'
                                    ? S.current.no_address_found_short
                                    : '${_placemark?.street} ${_placemark?.subLocality}',
                          );
                        },
                      ),
                    ),
                    if (widget.canDelete)
                      RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: ColorHelper.darkBlue,
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: ColorHelper.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            BlocProvider.of<SensorsBloc>(context, listen: false)
                                .add(
                              widget.isEdit
                                  ? UpdateSensor(
                                      id: _id,
                                      latitude: double.parse(
                                          _latitude.toStringAsFixed(6)),
                                      longitude: double.parse(
                                          _longitude.toStringAsFixed(6)),
                                      oldSensor: widget.sensor,
                                      address:
                                          '${_placemark.street} ${_placemark.subLocality}',
                                    )
                                  : AddSensor(
                                      id: _id,
                                      latitude: double.parse(
                                          _latitude.toStringAsFixed(6)),
                                      longitude: double.parse(
                                          _longitude.toStringAsFixed(6)),
                                      address:
                                          '${_placemark.street} ${_placemark.subLocality}',
                                    ),
                            );
                          }
                        },
                        label: Text(
                          widget.isEdit ? S.current.save : S.current.create,
                          style: Styles.whiteRegular18,
                        ),
                      ),
                    FlatButton.icon(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: ColorHelper.defaultGrey,
                        size: 18.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.isMap
                            ? BlocProvider.of<SensorsBloc>(
                                context,
                                listen: false,
                              ).add(SensorsMapRequested())
                            : BlocProvider.of<SensorsBloc>(
                                context,
                                listen: false,
                              ).add(SensorsRequested());
                      },
                      label: Text(
                        widget.canDelete ? S.current.cancel : S.current.back,
                        style: Styles.defaultGreyRegular14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
