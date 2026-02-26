import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:latlong2/latlong.dart';

class MapConfirmationDialog extends StatefulWidget {
  final void Function(double lat, double lng)? onConfirm;

  const MapConfirmationDialog({super.key, this.onConfirm});

  static Future<void> show({void Function(double lat, double lng)? onConfirm}) {
    return Get.dialog(
      Material(
        color: Colors.black.withOpacity(0.2),
        child: Center(child: MapConfirmationDialog(onConfirm: onConfirm)),
      ),
      barrierDismissible: false,
    );
  }

  @override
  State<MapConfirmationDialog> createState() => _MapConfirmationDialogState();
}

class _MapConfirmationDialogState extends State<MapConfirmationDialog> {
  final controller = Get.find<DashboardController>();

  Position? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;

  double? _officeLat;
  double? _officeLng;
  double? _radius;
  double? _distance;
  bool _isNear = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
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
          _errorMessage = 'Izin lokasi ditolak permanen';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final result = await controller.checkLocation(
        lat: position.latitude,
        lng: position.longitude,
      );

      if (result == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal validasi lokasi';
        });
        return;
      }

      setState(() {
        _currentPosition = position;
        _officeLat = result.officeLat;
        _officeLng = result.officeLng;
        _radius = result.maxDistanceMeters;
        _distance = result.distanceMeters;
        _isNear = result.isNear;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal mendapatkan lokasi';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColor.netral1,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
            color: AppColor.primary,
            child: const Text(
              'Konfirmasi lokasi saat ini',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: AppColor.netral1,
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : _buildMap(),
          ),

          if (!_isLoading && _errorMessage == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                _isNear
                    ? 'Anda berada di area kantor'
                    : 'Anda di luar area kantor (${_distance?.toStringAsFixed(0)} m)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isNear ? AppColor.succes : AppColor.danger,
                ),
              ),
            ),

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
                    onPressed: (_isNear && _currentPosition != null)
                        ? () {
                            widget.onConfirm?.call(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            );
                          }
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

    final officeLatLng = LatLng(_officeLat!, _officeLng!);

    return FlutterMap(
      options: MapOptions(initialCenter: userLatLng, initialZoom: 16),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.hr_attendance',
        ),
        CircleLayer(
          circles: [
            CircleMarker(
              point: officeLatLng,
              radius: _radius!,
              useRadiusInMeter: true,
              color: AppColor.succes.withOpacity(0.2),
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
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
