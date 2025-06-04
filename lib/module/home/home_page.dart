// ignore_for_file: deprecated_member_use

import "dart:io";

import "package:base/base.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_map/flutter_map.dart";
import "package:intl/intl.dart";
import "package:lacak_by_sasat/api/endpoint/location/location_response.dart";
import "package:lacak_by_sasat/constant/preference_key.dart";
import "package:lacak_by_sasat/helper/formats.dart";
import "package:lacak_by_sasat/helper/generals.dart";
import "package:lacak_by_sasat/helper/preferences.dart";
import "package:lacak_by_sasat/module/home/home_bloc.dart";
import "package:lacak_by_sasat/module/home/home_event.dart";
import "package:lacak_by_sasat/module/home/home_state.dart";
import "package:latlong2/latlong.dart";
import "package:url_launcher/url_launcher.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat("dd MMMM yyyy, HH:mm").format(date);
  }

  void _fetchDeviceLocation(String deviceId) {
    context.read<HomeBloc>().add(LoadDeviceLocation(deviceId));
  }

  Future<void> _openMapDirections(double lat, double lng) async {
    // Try using Google Maps URL first
    final googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    // Fallback to maps:// for iOS and geo: for Android
    final fallbackUrl = Uri.parse(
      Platform.isAndroid ? "geo:$lat,$lng?q=$lat,$lng" : "maps://?q=$lat,$lng",
    );

    try {
      // Try launching Google Maps URL
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      }
      // If Google Maps URL fails, try the platform-specific fallback
      else if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(
          fallbackUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // If all else fails, show a dialog with options
        _showMapOpenDialog(lat, lng);
      }
    } catch (e) {
      BaseOverlays.error(message: "Gagal membuka peta: ${e.toString()}");
    }
  }

  void _showMapOpenDialog(double lat, double lng) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Buka Peta"),
        content: Text("Pilih aplikasi peta yang ingin digunakan"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final url = Uri.parse("https://maps.google.com/maps?q=$lat,$lng");
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                BaseOverlays.error(message: "Tidak dapat membuka browser");
              }
            },
            child: Text("Google Maps (Browser)"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Clipboard.setData(
                ClipboardData(
                  text: "$lat, $lng",
                ),
              );
              BaseOverlays.success(message: "Koordinat disalin ke clipboard");
            },
            child: Text("Salin Koordinat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is HomeLoaded && state.deviceLocations == null) {
              context
                  .read<HomeBloc>()
                  .add(LoadDeviceLocation(state.data.primaryDevice.id));
              for (var device in state.data.pairedDevices) {
                context.read<HomeBloc>().add(LoadDeviceLocation(device.id));
              }
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: BaseWidgets.shimmer());
            } else if (state is HomeLoaded) {
              final user = state.data.user;
              final primary = state.data.primaryDevice;
              final paired = state.data.pairedDevices;

              return Column(
                children: [
                  // Header and Primary Device (non-scrollable)
                  Padding(
                    padding: EdgeInsets.all(Dimensions.size15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Profile Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.size15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.size15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: Dimensions.size30,
                                  backgroundColor: Colors.blue[100],
                                  child: Text(
                                    Formats.initials(user.name),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimensions.text20,
                                      color: AppColors.surface(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.size15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: Dimensions.size2),
                                      Text(
                                        user.email,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      SizedBox(height: Dimensions.size2),
                                      Text(
                                        user.telegramNumber,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                      SizedBox(height: Dimensions.size5),
                                      Row(
                                        children: [
                                          Text("Kode Pairing : "),
                                          SizedBox(width: Dimensions.size5),
                                          Text(
                                            Preferences.getString(
                                                  PreferenceKey.PAIRING_CODE,
                                                ) ??
                                                "",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    Generals.signOut();
                                  },
                                  icon: Icon(
                                    Icons.exit_to_app_rounded,
                                    size: Dimensions.size30,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.size25),

                        // Primary Device Section
                        Text(
                          "📱 Perangkat Utama",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Dimensions.size10),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.size15),
                          ),
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(Dimensions.size15),
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.size15),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.smartphone_rounded,
                                    size: Dimensions.size40,
                                    color: AppColors.onPrimaryContainer(),
                                  ),
                                  SizedBox(width: Dimensions.size15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          primary.name,
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        SizedBox(height: Dimensions.size2),
                                        Text(
                                          "Id Perangkat : ${primary.imei}",
                                          style: theme.textTheme.bodySmall,
                                        ),
                                        SizedBox(height: Dimensions.size2),
                                        Text(
                                          "Terhubung Sejak : ${formatDate(primary.createdAt)}",
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (state.deviceLocations?[primary.id] != null)
                          _buildLocationSection(
                            state.deviceLocations![primary.id]!,
                            theme,
                            isPrimary: true,
                          ),
                      ],
                    ),
                  ),

                  // Connected Devices Section (scrollable)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.size15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Dimensions.size10),
                          Row(
                            children: [
                              Text(
                                "📲 Perangkat Terhubung",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: Dimensions.size10),
                              Icon(
                                Icons.link,
                                color: theme.primaryColor,
                                size: Dimensions.size25,
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.size10),
                          ...paired.map(
                            (device) => Column(
                              children: [
                                Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.size15,
                                    ),
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.size15,
                                    ),
                                    onTap: () =>
                                        _fetchDeviceLocation(device.id),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(Dimensions.size15),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.phone_iphone,
                                            size: Dimensions.size35,
                                            color: AppColors.secondary(),
                                          ),
                                          SizedBox(width: Dimensions.size15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nama perangkat : ${device.name}",
                                                  style: TextStyle(
                                                    fontSize: Dimensions.text14,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimensions.size2,
                                                ),
                                                Text(
                                                  "Imei Device : ${device.imei}",
                                                  style: TextStyle(
                                                    fontSize: Dimensions.text12,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimensions.size2,
                                                ),
                                                Text(
                                                  "Disambungkan pada : ${device.createdAt.hour}:${device.createdAt.minute.toString().padLeft(2, '0')}",
                                                  style:
                                                      theme.textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: AppColors.onSurface(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.deviceLocations?[device.id] != null)
                                  _buildLocationSection(
                                    state.deviceLocations![device.id]!,
                                    theme,
                                    isPrimary: false,
                                  ),
                                SizedBox(height: Dimensions.size10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Terjadi kesalahan",
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: Dimensions.size10),
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: Dimensions.size15),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HomeBloc>().add(LoadHomeData()),
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLocationSection(
    LocationResponse location,
    ThemeData theme, {
    bool isPrimary = false,
  }) {
    final position = LatLng(location.latitude, location.longitude);
    final markerColor = isPrimary ? Colors.blue : Colors.green;

    return Column(
      children: [
        SizedBox(height: Dimensions.size15),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.size15),
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.size15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "📍 Peta Lokasi Terakhir",
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.directions, color: Colors.blue),
                      onPressed: () => _openMapDirections(
                        location.latitude,
                        location.longitude,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.size15),
                GestureDetector(
                  onTap: () => _openMapDirections(
                    location.latitude,
                    location.longitude,
                  ),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.size15),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.size15),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: position,
                          initialZoom: 15.0,
                          interactionOptions: const InteractionOptions(
                            flags:
                                InteractiveFlag.all & ~InteractiveFlag.rotate,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName: "com.satsat.findmy",
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: position,
                                width: Dimensions.size40,
                                height: Dimensions.size40,
                                child: GestureDetector(
                                  onTap: () => _openMapDirections(
                                    location.latitude,
                                    location.longitude,
                                  ),
                                  child: Icon(
                                    Icons.location_pin,
                                    color: markerColor,
                                    size: Dimensions.size40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: position,
                                color: markerColor.withOpacity(0.2),
                                borderColor: markerColor,
                                borderStrokeWidth: 2,
                                radius: location.accuracy ?? 20,
                                useRadiusInMeter: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.size10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Waktu: ${DateFormat("dd MMMM yyyy 'Pukul' HH:mm", 'id_ID').format(location.timestamp)}",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: Dimensions.size15),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.size15),
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.size15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🕒 Riwayat Lokasi",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Dimensions.size15),
                _buildLocationListItem(
                  formatDate(location.timestamp),
                  location.latitude,
                  location.longitude,
                  theme,
                ),
                if (location.previousLocations != null &&
                    location.previousLocations!.isNotEmpty)
                  ...location.previousLocations!.map(
                    (prevLocation) => _buildLocationListItem(
                      formatDate(prevLocation.timestamp),
                      prevLocation.latitude,
                      prevLocation.longitude,
                      theme,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationListItem(
    String timestamp,
    double lat,
    double lng,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () => _openMapDirections(lat, lng),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimensions.size10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: Dimensions.size20,
              color: theme.hintColor,
            ),
            SizedBox(width: Dimensions.size10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timestamp,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "latitude ${lat.toStringAsFixed(6)} | longatitude ${lng.toStringAsFixed(6)}",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.directions,
              size: Dimensions.size20,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
