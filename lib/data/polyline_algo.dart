//Simplify Polylines
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> simplifyPolyline(List<LatLng> polyline, double tolerance) {
  if (polyline.length < 3) {
    return polyline;
  }

  // Add the first and last point to the simplified polyline
  List<LatLng> simplifiedPolyline = [polyline.first];

  // Apply Douglas-Peucker algorithm
  _simplifyRecursive(polyline, 0, polyline.length - 1, tolerance, simplifiedPolyline);

  // Add the last point to the simplified polyline
  simplifiedPolyline.add(polyline.last);

  return simplifiedPolyline;
}

void _simplifyRecursive(List<LatLng> polyline, int start, int end, double tolerance, List<LatLng> simplified) {
  double maxDistance = 0;
  int index = 0;

  // Find the point with the maximum distance
  for (int i = start + 1; i < end; i++) {
    double distance = _distanceToSegment(polyline[i], polyline[start], polyline[end]);
    if (distance > maxDistance) {
      maxDistance = distance;
      index = i;
    }
  }

  // If the maximum distance is greater than the tolerance, recursively simplify
  if (maxDistance > tolerance) {
    _simplifyRecursive(polyline, start, index, tolerance, simplified);
    _simplifyRecursive(polyline, index, end, tolerance, simplified);
  } else {
    // Add the farthest point to the simplified polyline
    simplified.add(polyline[index]);
  }
}

double _distanceToSegment(LatLng point, LatLng start, LatLng end) {
  double segmentLength = _distance(start.latitude, start.longitude, end.latitude, end.longitude);
  if (segmentLength == 0) {
    return _distance(point.latitude, point.longitude, start.latitude, start.longitude);
  }
  double t = ((point.latitude - start.latitude) * (end.latitude - start.latitude) +
      (point.longitude - start.longitude) * (end.longitude - start.longitude)) /
      (segmentLength * segmentLength);
  if (t < 0) {
    return _distance(point.latitude, point.longitude, start.latitude, start.longitude);
  }
  if (t > 1) {
    return _distance(point.latitude, point.longitude, end.latitude, end.longitude);
  }
  LatLng projection = LatLng(start.latitude + t * (end.latitude - start.latitude),
      start.longitude + t * (end.longitude - start.longitude));
  return _distance(point.latitude, point.longitude, projection.latitude, projection.longitude);
}

double _distance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295;
  double a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}