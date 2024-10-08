import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sjq/models/event.model.dart';
import 'package:sjq/themes/themes.dart';
import '../auth/http_service.dart'; // Import your HttpService

class EventListViewer extends StatelessWidget {
  final String date; // Add a date field to filter events by date

  const EventListViewer({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Event>>(
        future: HttpService().fetchEvents(date: date), // Fetch events by date
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No events for this day'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return EventCard(event: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    final eventDateTime = DateTime.parse(event.date);
    final formattedDate = DateFormat.yMMMMd().format(eventDateTime);

    // Ensure event.location is not null, and provide a default value if it is null
    final eventLocation = event.location ?? 'Location not provided';

    // Parse event.time and format it to 12-hour format
    final eventTime = DateFormat.jm().format(DateFormat.Hm().parse(event.time));

    return Column(
      children: [
        display('PROGRAM: ${event.title}'),
        display('DATE: $formattedDate'),
        display('LOCATION: $eventLocation'),
        display('TIME: $eventTime'),
      ],
    );
  }

  Container display(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(onTap: () {}, title: Text(label, style: paragraphS)),
    );
  }
}
