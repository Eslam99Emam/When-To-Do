import 'package:When_to_do/pages/home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:When_to_do/functions.dart';
import 'package:When_to_do/screens/SignUp.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  GlobalKey<FormState> formstate = GlobalKey();

  Map sign = {
    "email": "",
    "password": "",
  };

  bool valid = false;
  bool showen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Sign In",
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
                          decoration: InputDecoration(
                              hintText: "example@gmail.com",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                // fontSize: 18,
                                color: Colors.grey,
                              ),
                              border: GradientOutlineInputBorder(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6A82FB),
                                    Color(0xFFFC5C7D)
                                  ],
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start),
                          validator: (String? email) => validateEmail(email),
                          onSaved: (email) => sign["email"] = email,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: showen,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(
                                    showen
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 18),
                                onTap: () {
                                  setState(() {
                                    showen = !showen;
                                  });
                                },
                              ),
                              hintText: "",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                              border: GradientOutlineInputBorder(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6A82FB),
                                    Color(0xFFFC5C7D)
                                  ],
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start),
                          validator: (String? password) =>
                              validatePass(password),
                          onSaved: (password) => sign["password"] = password,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (formstate.currentState!.validate()) {
                              formstate.currentState!.save();
                              var auth = await signIn(
                                email: sign["email"],
                                password: sign["password"],
                              );
                              auth.runtimeType == AuthResponse
                                  ? Navigator.pop(context)
                                  : AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      title: 'Error Logging',
                                      desc: '$auth',
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
                              "Log in",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    )),
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
                    var auth = await nativeGoogleSignIn();
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
                            title: 'Error Logging',
                            desc: 'Something went wrong. Please try again.',
                            btnOkColor: Colors.red,
                          ).show();
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
                          "Sign in With",
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
                      "Don't have account ? ",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.indigo,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
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
