import 'package:final_3/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareLocationScreen extends StatefulWidget {
  final BookStore? store;

  const ShareLocationScreen(this.store, {Key? key}) : super(key: key);

  @override
  _ShareLocationScreenState createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  @override
  Widget build(BuildContext context) {
    // Check if a store is provided
    if (widget.store == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('No store information provided')),
      );
    }

    final store = widget.store!;
    final googleMapsUrl = 'https://maps.google.com/?q=${store.latitude},${store.longitude}';

    return Scaffold(
      appBar: AppBar(title: Text(store.name), actions: []),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Center(
              child: QrImageView(data:  googleMapsUrl,
),
             ),
            Text('Store Name: ${store.name}'),
            Text('Latitude: ${store.latitude}'),
            Text('Longitude: ${store.longitude}'),
            // You can add more information here as needed
          ],
        ),
      ),
    );
  }
}
