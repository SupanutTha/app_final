import 'dart:async';

import 'package:final_3/restaurant_model.dart';
import 'package:final_3/share_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _zoomLevel = 13.0;
  Completer<GoogleMapController> _controller = Completer();
  LocationData? currentLocation;
  List<Marker> markers = []; // List to store markers for bookstores
  bool markersLoaded = false;
  @override
  void initState() {
    super.initState();
    _loadBookstoreMarkers();
  }
  Map<String, BookStore> bookstoreMap = {}; 
  Future<void> _loadBookstoreMarkers() async {
  // Fetch Kinokuniya data and create markers
  final bookstoreData = await fetchKinokuniyaData();
  markers = bookstoreData.map((store) {
    final marker = Marker(
      markerId: MarkerId(store.name),
      position: LatLng(store.latitude, store.longitude),
      infoWindow: InfoWindow(title: store.name),
      
    );

    // Store the marker and BookStore object in the map
    bookstoreMap[store.name] = store;

    return marker;
  }).toList();

  // Set the markersLoaded flag to true when markers are loaded
  markersLoaded = true;

  // Trigger a rebuild of the widget when markers are loaded
  if (mounted) {
    setState(() {});
  }
}
  Future<void> _goToLocation(BookStore store) async {
  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: LatLng(store.latitude, store.longitude),
      zoom: 18,
    ),
  ));
  Navigator.of(context).pop(); // Close the drawer after navigating to the location
}

  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    print('location : $location');
    try {
      print('try');
      try{
        print('correct');
        print ( location.getLocation().hashCode);
      }
      catch (e){
        print('error getlocation ; $e');
      }
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
        print('permission denied');
      }
      return null;
      }
  }

  Future<LocationData?> getCurrentLocationWithTimeout() async {
  Location location = Location();
  try {
    return await Future.any([
      location.getLocation(),
      Future.delayed(Duration(seconds: 3), () => null), // Timeout after 10 seconds
    ]);
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      // Handle permission denied
    }
    return null;
  }
}

 Future _goToMe() async {
  final GoogleMapController controller = await _controller.future;
  try {
    print('Getting current location...');
    currentLocation = await getCurrentLocationWithTimeout();
    print('Current location: $currentLocation');

    if (currentLocation != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          zoom: 16,
        ),
      ));
      print('Camera moved to current location');
    } else {
      // Handle the case when currentLocation is null
      print('Current location is null, using default location...');
      currentLocation = LocationData.fromMap({
        "latitude": 13.7650836,
        "longitude": 100.5379664,
        // You may need to set other properties as well
      });

      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          zoom: _zoomLevel,
        ),
      ));
      print('Camera moved to default location');
    }
  } catch (e) {
    print('Error getting current location: $e');
  }

  }
  Future<void> _zoomIn() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
    _updateZoomLevel(controller);
  }

  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
    _updateZoomLevel(controller);
  }

  void _updateZoomLevel(GoogleMapController controller) {
    controller.getZoomLevel().then((zoomLevel) {
      setState(() {
        _zoomLevel = zoomLevel;
      });
    });
  }
 static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _selectedIndex = 0;
  
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Map',
      style: optionStyle,
    ),
    Text(
      'Index 1: QrCode',
      style: optionStyle,
    ),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        // Navigate to the home page
        _zoomOut();
      }
      else{
        _zoomIn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_loadBookstoreMarkers);
    final Completer<GoogleMapController> _googleMapController = Completer<GoogleMapController>();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      //appBar
      appBar: AppBar(title: const Text("Kinokuniya Location"), actions: []),
      //body
      body: Container(
      child: Column(
        children: [
            Expanded(
              child:  GoogleMap(
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(13.7650836, 100.5379664),
                  zoom: _zoomLevel,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                 markers: Set<Marker>.from(markers),
              )
            ),
            
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.near_me),
           onPressed: () async {
            await _goToMe();
            print('check current : $currentLocation');
          },
         
        ),

    // floatingActionButton: Column(
    //    mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     FloatingActionButton.extended(
    //       onPressed: () async {
    //         await _goToMe();
    //         print('check current : $currentLocation');
    //       },
    //       label: Text('My location'),
    //       icon: Icon(Icons.near_me),
    //     ),
    //     SizedBox(height: 10,),
    //     Row(
    //       children: [
    //         SizedBox(width: 20,),
    //         FloatingActionButton(
    //         onPressed: _zoomIn,
    //         tooltip: 'Zoom In',
    //         child: Icon(Icons.zoom_in),
    //       ),
    //       SizedBox(width: 10),
    //       FloatingActionButton(
    //         onPressed: _zoomOut,
    //         tooltip: 'Zoom Out',
    //         child: Icon(Icons.zoom_out),
    //       ),
    //       SizedBox(width: 220),
    //       // FloatingActionButton(
    //       //   onPressed: ()  {
    //       //     print('current_location:$currentLocation');
    //       //     if (currentLocation != null) {
    //       //       Navigator.push(
    //       //         context,
    //       //         MaterialPageRoute(
    //       //           builder: (context) => ShareLocationScreen(),
    //       //         ),
    //       //       );
    //       //     } else {
    //       //       print('null');
    //       //       // Handle the case when currentLocation is null or not available
    //       //       // You can show an error message or handle it as needed.
    //       //     }
    //       //   },
    //       //   tooltip: 'Share Location',
    //       //   child: Icon(Icons.qr_code),
    //       // ),
    //       ],
    //     )
    //   ],
    // ),
    
    drawer: Drawer(
  child: ListView(
    children: [
       DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Kinokuniya Bookstore Branches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
       ),
      ...markers.map((marker) {
      final store = bookstoreMap[marker.infoWindow.title ?? ''];
      return Column(
        children: [
          ListTile(
            title: Text(marker.infoWindow.title ?? ''),
            subtitle: Text(
              'Latitude: ${marker.position.latitude}, Longitude: ${marker.position.longitude}',
            ),
            onTap: () {
              if (store != null) {
                _goToLocation(store);
              }
            },
          ),
         ElevatedButton(
           style: ElevatedButton.styleFrom(onSurface: Colors.red),
           onPressed: (){
             Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ShareLocationScreen(store), 
          ),
        );
           },
           child: Text('share location'),
         ),
         
            Divider(),
        ],
      );
    }).toList(),
    ],
  


  ),
),
bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_in),
            label: 'Zoom In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_out),
            label: 'ZoomOut',
          ),
        ],
        //currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.blue,
        onTap:_onItemTapped,
      ),
    );
  } }//ec