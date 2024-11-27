import 'package:asgard_rohit/model/map_marker.dart';
import 'package:flutter/material.dart';

class MarkerDetailsWidget extends StatelessWidget {
  final MapMarker marker;
  const MarkerDetailsWidget(this.marker, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(marker.markerType.icon),
            Text(
              marker.name,
              style: textTheme.headlineSmall,
            ),
            Text(
              marker.description,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
