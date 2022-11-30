import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_project/screens/otp_screen.dart';
import 'package:http/http.dart' as http;


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController mobileController = TextEditingController();
  Future<void> loginPostApiCall() async {
    var response = await http.post(Uri.parse("https://flutter.virtualsecretary.in/public/api/login"),body: {'mobile': '${mobileController.text.toString()}'}, headers: {'q': '{http}'});
    if (response.statusCode == 200) {
      print(response.body);
      var snackBar = SnackBar(content: Text('Otp Send'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  OtpScreen(mobile: mobileController.text.toString(),)));

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 100),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 36, color: Color(0xff000000), fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(
                height: 165,
              ),
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "Mobile number",
                  hintStyle: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xffC4C4C4)),
                  border: InputBorder.none,
                  enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                  focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                  errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                ),
              ),
              const SizedBox(
                height: 61,
              ),
              InkWell(
                onTap: () {
                  loginPostApiCall();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xff6200EE), borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Text(
                    "Login via OTP",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xffFFFFFF), fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
