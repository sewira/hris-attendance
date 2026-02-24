import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/location/office_location.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:latlong2/latlong.dart';

class MapConfirmationDialog extends StatefulWidget {
  final void Function(double lat, double lng)? onConfirm;

  const MapConfirmationDialog({super.key, this.onConfirm});

  static Future<void> show({void Function(double lat, double lng)? onConfirm}) {
    return Get.dialog(
      Material(
        color: Colors.black.withValues(alpha: 0.2),
        child: Center(
          child: MapConfirmationDialog(onConfirm: onConfirm),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<MapConfirmationDialog> createState() => _MapConfirmationDialogState();
}

class _MapConfirmationDialogState extends State<MapConfirmationDialog> {
  Position? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;
  double? _distanceToOffice;

  static const _officeLatLng = LatLng(
    OfficeLocation.latitude,
    OfficeLocation.longitude,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Layanan lokasi tidak aktif';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Izin lokasi ditolak';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Izin lokasi ditolak secara permanen';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        OfficeLocation.latitude,
        OfficeLocation.longitude,
      );

      setState(() {
        _currentPosition = position;
        _distanceToOffice = distance;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal mendapatkan lokasi';
      });
    }
  }

  bool get _isWithinGeofence =>
      _distanceToOffice != null &&
      _distanceToOffice! <= OfficeLocation.radiusInMeters;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColor.netral1,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            color: AppColor.primary,
            child: const Text(
              'Konfirmasi Lokasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.netral1,
              ),
            ),
          ),

          // Map area
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColor.danger,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : _buildMap(),
          ),

          // Status text
          if (!_isLoading && _errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _isWithinGeofence
                    ? 'Anda berada di area kantor'
                    : 'Anda di luar area kantor (${_distanceToOffice?.toStringAsFixed(0)} m)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isWithinGeofence ? AppColor.succes : AppColor.danger,
                ),
              ),
            ),

          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.danger,
                      foregroundColor: AppColor.netral1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isWithinGeofence
                        ? () => widget.onConfirm?.call(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.succes,
                      foregroundColor: AppColor.netral1,
                      disabledBackgroundColor: AppColor.disable,
                      disabledForegroundColor: AppColor.netral1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Lanjut'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final userLatLng = LatLng(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    return FlutterMap(
      options: MapOptions(
        initialCenter: _officeLatLng,
        initialZoom: 17,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.hr_attendance',
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: _officeLatLng,
              radius: OfficeLocation.radiusInMeters,
              useRadiusInMeter: true,
              color: AppColor.succes.withValues(alpha: 0.2),
              borderColor: AppColor.succes,
              borderStrokeWidth: 2,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: userLatLng,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
