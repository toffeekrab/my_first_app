import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/response/trip_idx_get_res.dart';

import '../config/config.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
	late Future<TripIdxGetResponse> futureTrip;

	@override
	void initState() {
		super.initState();
		futureTrip = loadDataAsync();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(),
			body: FutureBuilder<TripIdxGetResponse>(
				future: futureTrip,
				builder: (context, snapshot) {
					if (snapshot.connectionState != ConnectionState.done) {
						return const Center(child: CircularProgressIndicator());
					}
					if (snapshot.hasError) {
						return Text("Error: ${snapshot.error}");
					}
					if (!snapshot.hasData) {
						return const Text("No data");
					}

          final trip = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(trip.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(trip.country, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Image.network(trip.coverimage),
                const SizedBox(height: 8),
                Row (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ราคา ${trip.price} บาท", style: const TextStyle(fontSize: 16)),
                    Text("โซน${trip.destinationZone}", style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(trip.detail, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Center(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text(
                      'จองเลย!!',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
				},
			),
		);
	}

	Future<TripIdxGetResponse> loadDataAsync() async {
		var config = await Configuration.getConfig();
		var url = config['apiEndpoint'];
		var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
		return tripIdxGetResponseFromJson(res.body);
	}
}
