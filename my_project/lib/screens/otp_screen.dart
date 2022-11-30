import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_project/screens/booking.dart';
import 'package:http/http.dart' as http;


class OtpScreen extends StatefulWidget {
  final String mobile;
  const OtpScreen({Key? key, required this.mobile}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  Future<void> verifyOtpApiCall() async {
    var response = await http.post(Uri.parse("https://flutter.virtualsecretary.in/public/api/verify"),body: {'mobile': '${widget.mobile}','otp': '987654'}, headers: {'q': '{http}'});
    if (response.statusCode == 200) {
     var token= jsonDecode(response.body);
     var snackBar = SnackBar(content: Text('Otp verifyed'));
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Booking(token: token["token"].toString(),)));
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25,top: 40),
            child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,size: 30,color: Color(0xffC4C4C4),)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "OTP",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 36, color: Color(0xff000000), fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 165,),
                TextFormField(
                  controller: otpController,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "OTP",
                    hintStyle: GoogleFonts.montserrat(fontStyle:FontStyle.normal,fontWeight: FontWeight.w400,fontSize: 16,color: const Color(0xffC4C4C4)),
                    border: InputBorder.none,
                    enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                    focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                    errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                  ),
                ),
                const SizedBox(height: 61,),
                InkWell(
                  onTap: () {
                    verifyOtpApiCall();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Color(0xff6200EE), borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text(
                      "Verify",
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xffFFFFFF), fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
