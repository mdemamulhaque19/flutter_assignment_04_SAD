import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_4/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45,),
              Text('Login',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.purple,
                    fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 10,),

              TextFormField(
                controller: textEditingController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintStyle: TextStyle(
                        color: Colors.white
                    ),
                    hintText: 'Email',
                  prefixIconColor: Colors.black,
                ),
                validator: (String? value) {
                  String inputText = value ?? '';
                  if(EmailValidator.validate(inputText)== false){
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10,),

              TextFormField(
                controller: passwordEditingController,
                textInputAction: TextInputAction.done,
                obscureText: true,

                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintStyle: TextStyle(
                        color: Colors.white
                    ),
                    hintText: 'Password',
                  prefixIconColor: Colors.black,
                ),
                  validator: (String? value) {
                    if((value?.length ?? 0) <= 6){
                      return 'Password should more than 6 letters';
                    }
                    return null;
                  }
              ),
              SizedBox(height: 12,),
              FilledButton(onPressed: (){
                _onTapFilledButton();
              },
                  child: Icon(Icons.arrow_circle_right_outlined)),
              SizedBox(height: 12,),
              Center(
                  child: Column(
                    children: [
                      TextButton(onPressed: (){},
                          child: Text('Forget Password?')
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: RichText(
                                text: TextSpan(
                                    text: 'Don\'t have an account?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600
                                    ),
                                    children: [

                                      TextSpan(
                                          text: ' Sign-Up',
                                          style: TextStyle(
                                              color: Colors.purple
                                          ),
                                          recognizer: TapGestureRecognizer()..onTap = (){
                                            _onTapSignUpButton();
                                          }
                                      )
                                    ]
                                ),

                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignupPage()));
  }

  void _onTapFilledButton(){
    if(_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login is done')));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  @override
  void dispose(){
    super.dispose();
    textEditingController.dispose();
    passwordEditingController.dispose();
  }
}