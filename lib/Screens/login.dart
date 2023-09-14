import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyperhire/Widgets/progressDialog.dart';
import 'package:hyperhire/main.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 TextEditingController  email = TextEditingController();
TextEditingController  password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:  [
              const SizedBox(height: 50,),
              const Image(image: AssetImage('images/wikilogo.png'), width: 350,height: 200, alignment: Alignment.center,),
              const SizedBox(height: 1,),
              const Text("Login HyperHire-Card", style: TextStyle(fontSize: 24, fontFamily: 'Brand Bolt', ),textAlign: TextAlign.center,),
              Padding(padding: const EdgeInsets.all(20),
              child: Column(
                children:  [
              const SizedBox(height: 1,),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14),
                  hintStyle: TextStyle(fontSize: 10, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 1,),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 14),
                  hintStyle: TextStyle(fontSize: 10, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 15,),
              SizedBox(child: InkWell(
                onTap: (){
                  if(!email.text.contains("@")){
                        displayToastMessage(context, "Email address isn't valid");
                      }else if(password.text.isEmpty){
                        displayToastMessage(context, "Password is required *");
                      }else{
                        loginAndAuthenticateUser(context);
                      }              
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    border: Border.all(width: 2, color: Colors.green),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),             
                  height: 50,
                  width: double.infinity,
                  child: const Center(child: Text("Login", style: TextStyle(fontSize: 18, color: Colors.white),)),
                ),
              ))
                ],
              ),),
              TextButton(onPressed: (){
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>RegisterScreen()));
                Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
              }, child: const Text("Don't have an account? Register Here", style: TextStyle(color: Colors.black),))
            ],
          ),
        ),
      )
      
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async{

      showDialog(context: context, barrierDismissible: false, builder: (context){
        return ProgressDialog(message: 'Authenticating, Please wait ....',);
      });

     final User? firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(email: email.text, password: password.text).
    // ignore: body_might_complete_normally_catch_error
    catchError((onError){
      Navigator.pop(context);
      displayToastMessage(context, "Error: $onError");
    })).user;

     if(firebaseUser != null){//sign-in user
    //Save User info to database

    usersRef.child(firebaseUser.uid).once().then((DatabaseEvent event){
      DataSnapshot snap = event.snapshot;
      if(snap.value !=null){
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        displayToastMessage(context, "You have Successfully Logged In");
      }else{
        Navigator.pop(context);
        _firebaseAuth.signOut();
      displayToastMessage(context, "No records exists for this User: Please create new account");
      }
    });

    }else{
      //error encountered - Display error message
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      displayToastMessage(context, "Error Occured");
    }

  }
}

displayToastMessage(BuildContext context, String message) async{
    Fluttertoast.showToast(msg: message);
  }