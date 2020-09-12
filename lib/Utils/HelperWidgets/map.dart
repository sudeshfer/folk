import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:folk/models/EventModel.dart';

class MapBox extends StatelessWidget {
  EventModel _eventModel;
  final double height;
  MapBox(this._eventModel,{this.height = 250});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(_eventModel.longitute,_eventModel.latitude),
          // minZoom: 10,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point: new LatLng(_eventModel.longitute,_eventModel.latitude),
                builder: (ctx) => new Container(
                  child: FaIcon(
                    FontAwesomeIcons.mapMarkerAlt,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
