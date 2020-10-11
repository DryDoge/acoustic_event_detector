import 'package:acoustic_event_detector/data/models/sensor.dart';
import 'package:acoustic_event_detector/widgets/custom_circular_indicator.dart';
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

class AddEditScreen extends StatefulWidget {
  static const routeName = '/add-edit';

  final bool isEdit;
  final Sensor sensor;

  AddEditScreen({
    Key key,
    @required this.isEdit,
    this.sensor,
  }) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  SensorsBloc _sensorsBloc;
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

  @override
  void initState() {
    super.initState();
    _focusNodes.forEach((node) {
      node.addListener(() {});
    });
    _sensorsBloc = BlocProvider.of<SensorsBloc>(context);
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
    _focusNodes.forEach((FocusNode element) {
      element.unfocus();
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? S.current.update_sensor : S.current.add_sensor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorHelper.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            _sensorsBloc.add(SensorsRequested());
          },
        ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                            FocusScope.of(context).requestFocus(_focusNodes[1]);
                          },
                          validator: (_) {
                            return _id == null ? 'Zadajte cele cislo' : null;
                          },
                          inputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                        CustomTextField(
                          controller: _controllers[1],
                          focusNode: _focusNodes[1],
                          labelText: S.current.latitude,
                          inputAction: TextInputAction.next,
                          onChanged: (String value) {
                            _latitude = double.tryParse(value);
                          },
                          onFieldSubmitted: (_) {
                            _refreshMap();
                            FocusScope.of(context).requestFocus(_focusNodes[2]);
                          },
                          validator: (_) {
                            return _latitude == null
                                ? 'Zadajte zem sirku cislo'
                                : null;
                          },
                          inputType: TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                        ),
                        CustomTextField(
                          controller: _controllers[2],
                          focusNode: _focusNodes[2],
                          labelText: S.current.longitude,
                          onChanged: (String value) {
                            _longitude = double.tryParse(value);
                          },
                          inputAction: TextInputAction.next,
                          validator: (_) {
                            return _longitude == null
                                ? 'Zadajte zem dlzku cislo'
                                : null;
                          },
                          onFieldSubmitted: (_) {
                            _refreshMap();
                          },
                          inputType: TextInputType.numberWithOptions(
                            signed: true,
                            decimal: true,
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: ColorHelper.darkBlue,
                  indent: 10,
                  endIndent: 10,
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AddSensorMap(
                    latitude: _latitude,
                    longitude: _longitude,
                    refreshMap: _refreshMap,
                  ),
                ),
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
                      _sensorsBloc.add(
                        widget.isEdit
                            ? UpdateSensor(
                                id: _id,
                                latitude: _latitude,
                                longitude: _longitude,
                                oldSensor: widget.sensor,
                              )
                            : AddSensor(
                                id: _id,
                                latitude: _latitude,
                                longitude: _longitude,
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
                    _sensorsBloc.add(SensorsRequested());
                  },
                  label: Text(
                    S.current.cancel,
                    style: Styles.defaultGreyRegular14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
