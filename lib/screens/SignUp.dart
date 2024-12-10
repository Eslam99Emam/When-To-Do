import 'package:When_to_do/pages/home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:When_to_do/functions.dart';
import 'package:When_to_do/screens/SignIn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = GlobalKey();
  String pass = "";
  bool showen1 = true;
  bool showen2 = true;

  Map regestration = {
    "email": "",
    "firstname": "",
    "lastname": "",
    "password": "",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          height: 710,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.displayMedium!.apply(
                        fontWeightDelta: 4,
                      ),
                ),
                SizedBox(
                  height: 32,
                ),
                Form(
                  key: formstate,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (String? name) {
                          if (name.runtimeType == Null) {
                            return "Name can't be null";
                          } else if (name!.length < 2) {
                            return "Name should be at least 2 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "John",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                            border: GradientOutlineInputBorder(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            label: Text(
                              "Firstname",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start),
                        onSaved: (value) {
                          regestration["firstname"] = value;
                        },
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        validator: (String? name) {
                          if (name.runtimeType == Null) {
                            return "Name can't be null";
                          } else if (name!.length < 2) {
                            return "Name should be at least 2 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Doe",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            // fontSize: 18,
                            color: Colors.grey,
                          ),
                          border: GradientOutlineInputBorder(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          label: Text(
                            "lastname",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                        ),
                        onSaved: (value) {
                          regestration["lastname"] = value;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? email) => validateEmail(email),
                        decoration: InputDecoration(
                            hintText: "example@gmail.com",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              // fontSize: 18,
                              color: Colors.grey,
                            ),
                            border: GradientOutlineInputBorder(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            label: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start),
                        onSaved: (value) {
                          regestration["email"] = value;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: showen1,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(
                                  showen1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                  size: 18),
                              onTap: () {
                                showen1 = !showen1;
                                setState(() {});
                              },
                            ),
                            hintText: "",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              // fontSize: 18,
                              color: Colors.grey,
                            ),
                            border: GradientOutlineInputBorder(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            label: Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start),
                        validator: (String? password) => validatePass(password),
                        onChanged: (value) => pass = value,
                        onSaved: (value) {
                          regestration["password"] = value;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        obscureText: showen2,
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(
                                  showen2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                  size: 18),
                              onTap: () {
                                showen2 = !showen2;
                                setState(() {});
                              },
                            ),
                            hintText: "",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              // fontSize: 18,
                              color: Colors.grey,
                            ),
                            border: GradientOutlineInputBorder(
                              gradient: LinearGradient(
                                colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            label: Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start),
                        validator: (String? password) {
                          if (pass != password) {
                            return "This must be the same password you entered";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      InkWell(
                        onTap: () async {
                          if (formstate.currentState!.validate()) {
                            formstate.currentState!.save();
                            var auth = await signUp(
                                regestration["firstname"],
                                regestration["lastname"],
                                regestration["email"],
                                regestration["password"]);
                            auth.runtimeType == AuthResponse
                                ? Navigator.pushReplacement(
                                    context,
                                    SlideBTTPageRouting(
                                      MyHomePage(),
                                    ),
                                  )
                                : AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    animType: AnimType.bottomSlide,
                                    title: 'Error Logging in',
                                    desc: 'Something went wrong.',
                                    btnOkColor: Colors.red,
                                  ).show();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 175,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      " OR ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(fontWeightDelta: 3),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    final auth = await nativeGoogleSignIn();
                    if (auth.runtimeType == AuthResponse) {
                      Navigator.pushReplacement(
                        context,
                        SlideBTTPageRouting(
                          MyHomePage(),
                        ),
                      );
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.bottomSlide,
                        title: 'Error Logging in',
                        desc: 'Something went wrong.',
                        btnOkColor: Colors.red,
                      ).show();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 5.0,
                          spreadRadius: -3,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign up With",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          "assets/google.png",
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Already have account ? ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.indigo,
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Signin(),
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
