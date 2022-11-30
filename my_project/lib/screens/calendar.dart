import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_project/screens/login.dart';
import 'package:http/http.dart' as http;


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _currentDate;

  Future<void> bookDatePostApiCall() async {
    var response = await http.post(Uri.parse("https://flutter.virtualsecretary.in/public/api/book/getBookList"),body: {'month': '${_currentDate!.month.toString()}', 'year': '${_currentDate!.year.toString()}'}, headers: {'q': '{http}'});
    if (response.statusCode == 200) {
      print(response.body);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login(),));

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),
            CalendarCarousel<Event>(
              onDayPressed: (DateTime date, List<Event> events) {
                setState(() {
                  _currentDate = date;
                  print(_currentDate!.year);
                });
              },
              weekendTextStyle: const TextStyle(
                color: Colors.red,
              ),
              thisMonthDayBorderColor: Colors.grey,
              customDayBuilder: (   /// you can provide your own build function to make custom day containers
                  bool isSelectable,
                  int index,
                  bool isSelectedDay,
                  bool isToday,
                  bool isPrevMonthDay,
                  TextStyle textStyle,
                  bool isNextMonthDay,
                  bool isThisMonthDay,
                  DateTime day,
                  ) {
              },
              weekFormat: false,
              height: 420.0,
              selectedDateTime: _currentDate,
              daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
            ),
            InkWell(
              onTap: () {
                bookDatePostApiCall();
              },
              child: Text(
                "Click the date to Book",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 24, color: Color(0xff333333), fontWeight: FontWeight.w300),
                ),
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
