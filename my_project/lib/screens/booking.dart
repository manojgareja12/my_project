import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Booking extends StatefulWidget {
  final String token;

  const Booking({Key? key, required this.token}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String msg = "";

  late Razorpay razorpay;

  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        _dateController.text = formatter.format(selectedDate);
      });
    }
  }

  Future<void> bookApiCall() async {
    print(_dateController.text.toString());
    var response = await http.post(Uri.parse("https://flutter.virtualsecretary.in/public/api/book"),
        body: {'date': '${_dateController.text.toString()}', 'total': '500'}, headers: {'Authorization': 'Bearer ${widget.token}'});
    if (response.statusCode == 200) {
      print(response.body);
      var snackBar = const SnackBar(content: Text('book successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      openCheckout();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_NNbwJ9tmM0fbxj",
      "amount":   100, // Convert Paisa to Rupees
      "name": "Test Payment By Kamlesh",
      "description": "This is a Test Payment",
      "timeout": "180",
      "theme.color": "#03be03",
      "currency": "INR",
      "prefill": {"contact": "2323232323", "email": "testByKamlesh@razorpay.com"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay!.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("Pament success");
    msg = "SUCCESS: " + response.paymentId.toString();
    showToast(msg);
  }

  void handlerErrorFailure(PaymentFailureResponse response) {
    msg = "ERROR: " + response.code.toString() + " - " + jsonDecode(response.message.toString())['error']['description'];
    showToast(msg);
  }

  void handlerExternalWallet(ExternalWalletResponse response) {
    msg = "EXTERNAL_WALLET: " + response.walletName.toString();
    showToast(msg);
  }

  showToast(msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.withOpacity(0.1),
      textColor: Colors.black54,
    );
  }

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 40),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Color(0xffC4C4C4),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booking",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 36, color: Color(0xff000000), fontWeight: FontWeight.w300),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  TextFormField(
                    controller: _dateController,
                    onTap: () {
                      selectDate(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "13 / 03 / 2022",
                      hintStyle: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xffC4C4C4)),
                      border: InputBorder.none,
                      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Name",
                      hintStyle: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xffC4C4C4)),
                      border: InputBorder.none,
                      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Email",
                      hintStyle: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xffC4C4C4)),
                      border: InputBorder.none,
                      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "9876543210",
                      hintStyle: GoogleFonts.montserrat(fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16, color: const Color(0xffC4C4C4)),
                      border: InputBorder.none,
                      enabledBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                      errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: Color(0xffC4C4C4), width: 2)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 15),
                    child: Text(
                      "Disable",
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 15, color: Color(0xffC4C4C4), fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 31),
              child: Container(
                height: 79,
                width: double.infinity,
                color: const Color(0xffC4C4C4), //.withOpacity(1.0)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AMOUNT",
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 11),
                            child: Text(
                              "TAX",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 67),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹ 5000",
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 11),
                            child: Text(
                              "₹ 250",
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 16),
              child: Column(
                children: [
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Text(
                          "₹ 5250",
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  InkWell(
                    onTap: () {
                      bookApiCall();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Color(0xff6200EE), borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Text(
                        "Book",
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(fontStyle: FontStyle.normal, fontSize: 20, color: Color(0xffFFFFFF), fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
