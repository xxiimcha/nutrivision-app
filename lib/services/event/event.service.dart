import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjq/models/event.model.dart';
import 'package:table_calendar/table_calendar.dart';

class EventService {
  // Get Events from firebase or any database here.
  Future<List<Event>> getEvents(DateTime selectedDay) async {
    final jsonString = await rootBundle.loadString('assets/data/events.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    // Filter events based on the selected day
    late List<Event> events;

    //  This is just to show loading screen
    // Generate a random duration between 0 and 1 seconds
    final random = Random();
    const maxSeconds = 2;
    final delaySeconds = random.nextInt(maxSeconds + 1);

    // Create a Completer to delay the Future
    final completer = Completer<List<Event>>();

    // Create a Timer to complete the Completer after the random delay
    Timer(Duration(seconds: delaySeconds), () {
      events = jsonList
          .map((json) => Event.fromJson(json))
          .where((event) => isSameDay(DateTime.parse(event.date), selectedDay))
          .toList();
      debugPrint('List: ${events.toString()}');

      completer.complete(events);
    });

    // Return the Future from the Completer
    return completer.future;
  }
}
