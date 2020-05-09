import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iit_app/screens/drawer.dart';

// TODO: in androidManifest.xml , api key has to be changed  (register on goole cloud platform from original gmail and generate api key and enable required services)

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Google Maps (under dev)'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        drawer: SideBar(context: context),
        body: LocationScreen(),
      ),
    );
  }
}

class LocationScreen extends StatefulWidget {
  final Key _mapKey = UniqueKey();
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return TheMap(key: widget._mapKey);
  }
}

class TheMap extends StatefulWidget {
  ///key is required, otherwise map crashes on hot reload
  TheMap({@required Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TheMap> {
  Color color = Colors.green;
  Completer<GoogleMapController> mapController = Completer();

  List<Marker> _hostelMarkers = <Marker>[];
  List<Marker> _departmentMarkers = <Marker>[];
  List<Marker> _lectureHallMarkers = <Marker>[];
  List<Marker> _otherMarkers = <Marker>[];
  List<Marker> _allMarkers = <Marker>[];
  List<Marker> _displayMarkers = <Marker>[];

  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(25.267878, 82.990494),
    zoom: 15,
    bearing: 0.0,
    tilt: 0.0,
  );

  moveCameraToMarker(Map coord) async {
    final GoogleMapController controller = await mapController.future;
    _cameraPosition = CameraPosition(
      target: LatLng(coord['LatLng'].latitude, coord['LatLng'].longitude),
      zoom: 18,
      tilt: 75,
      bearing: 45,
    );
    controller.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition),
    );
  }

  Marker _getMarker({String category, var coord, int i, double hue}) {
    return Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      markerId: MarkerId('category ${i.toString()}'),
      position: LatLng(coord['LatLng'].latitude, coord['LatLng'].longitude),
      infoWindow: InfoWindow(
        title: coord['title'],
      ),
      onTap: () => moveCameraToMarker(coord),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);

    color = Colors.blue;
    int i = 0;
    for (var coord in coords['Hostels']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'Hostel', coord: coord, i: i, hue: BitmapDescriptor.hueRed);
      this._hostelMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    i = 0;
    for (var coord in coords['Departments']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'Department',
          coord: coord,
          i: i,
          hue: BitmapDescriptor.hueGreen);

      this._departmentMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    i = 0;

    for (var coord in coords['Lecture Halls']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'LT', coord: coord, i: i, hue: BitmapDescriptor.hueOrange);

      this._lectureHallMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }

    i = 0;
    for (var coord in coords['Others']) {
      i += 1;
      Marker newMarker = _getMarker(
          category: 'Other',
          coord: coord,
          i: i,
          hue: BitmapDescriptor.hueViolet);

      this._otherMarkers.add(newMarker);
      this._allMarkers.add(newMarker);
    }
    _displayMarkers.addAll(_allMarkers);

    setState(() {
      print(_displayMarkers.length);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: const LatLng(25.267878, 82.990494),
              zoom: 15,
              bearing: 0.0,
              tilt: 0.0,
            ),
            mapType: MapType.terrain,
            mapToolbarEnabled: true,
            markers: Set.from(_displayMarkers),
            onTap: (tappedPosition) {
              print(
                  'lattitude : ${tappedPosition.latitude}      longitude: ${tappedPosition.longitude}');
            },
          ),
        ],
      );
}

Map<String, dynamic> coords = {
  "Hostels": [
    {
      "title": "Limbdi Hostel",
      "LatLng": LatLng(25.261155, 82.986075),
    },
    {
      "title": "Rajputana Hostel",
      "LatLng": LatLng(25.262417, 82.986178),
    },
    {
      "title": "Dhanraj Giri Hostel",
      "LatLng": LatLng(25.263944, 82.986100),
    },
    {
      "title": "Morvi Hostel",
      "LatLng": LatLng(25.265029, 82.986136),
    },
    {
      "title": "CV Raman Hostel",
      "LatLng": LatLng(25.265925, 82.986291),
    },
    {
      "title": "Ramanujan Hostel",
      "LatLng": LatLng(25.263271, 82.984804),
    },
    {
      "title": "Aryabhatta Hostel",
      "LatLng": LatLng(25.264109, 82.984266),
    },
    {
      "title": "S.N. Bose Hostel",
      "LatLng": LatLng(25.263361, 82.984020),
    },
    {
      "title": "Visvesvaraya Hostel",
      "LatLng": LatLng(25.262324, 82.984066),
    },
    {
      "title": "S.C Dey Hostel",
      "LatLng": LatLng(25.260016, 82.986522),
    },
    {
      "title": "Vivekananda Hostel",
      "LatLng": LatLng(25.259132, 82.986793),
    },
    {
      "title": "Vishwakarma Hostel",
      "LatLng": LatLng(25.257850, 82.985653),
    },
    {
      "title": "GSC(old) Hostel",
      "LatLng": LatLng(25.260617, 82.984292),
    },
    {
      "title": "GSC(ext) Hostel",
      "LatLng": LatLng(25.260247, 82.984530),
    },
    {
      "title": "New Girls Hostel",
      "LatLng": LatLng(25.261197, 82.983797),
    },
  ],
  "Departments": [
    {
      "title": "Electronics",
      "LatLng": LatLng(25.262838, 82.990496),
    },
    {
      "title": "CSE",
      "LatLng": LatLng(25.262479, 82.993714),
    },
    {
      "title": "MnC",
      "LatLng": LatLng(25.261849, 82.993503),
    },
    {
      "title": "Electrical",
      "LatLng": LatLng(25.261384, 82.992030),
    },
    {
      "title": "Mechanical",
      "LatLng": LatLng(25.261692, 82.991760),
    },
    {
      "title": "Civil",
      "LatLng": LatLng(25.262817, 82.991948),
    },
    {
      "title": "Ceramic",
      "LatLng": LatLng(25.259739, 82.992809),
    },
    {
      "title": "Engineering Physics",
      "LatLng": LatLng(25.259533, 82.992948),
    },
  ],
  "Others": [
    {
      "title": "Main library ",
      "LatLng": LatLng(25.261830, 82.989142),
    },
    {
      "title": "Technex office ",
      "LatLng": LatLng(25.261365, 82.986336),
    },
    {
      "title": "CCD ",
      "LatLng": LatLng(25.258250, 82.986543),
    },
    {
      "title": "GTAC ",
      "LatLng": LatLng(25.259733, 82.984981),
    },
    {
      "title": "Cafeteria ",
      "LatLng": LatLng(25.260441, 82.991436),
    },
    {
      "title": "Rajputana ground ",
      "LatLng": LatLng(25.262233, 82.987315),
    },
    {
      "title": "Gymkhana ",
      "LatLng": LatLng(25.259643, 82.988997),
    },
    {
      "title": "ADV ",
      "LatLng": LatLng(25.258719, 82.990153),
    },
  ],
  "Lecture Halls": [
    {
      "title": "ABLT ",
      "LatLng": LatLng(25.262779, 82.988583),
    },
    {
      "title": "LT3 ",
      "LatLng": LatLng(25.258845, 82.992690),
    },
  ],
};
