import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_web_to_app_design/API/FirebaseApi.dart';
import 'package:flutter_web_to_app_design/AuthServices/AuthServices.dart';
import 'package:flutter_web_to_app_design/Screens/Student/StudentSignIn.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class AllFieldsFormBloc extends FormBloc<String, String> {

  final userName = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(validators: [FieldBlocValidators.email],);
  final password = TextFieldBloc(
    validators: [FieldBlocValidators.passwordMin6Chars],);

  final dob = InputFieldBloc<DateTime?, Object>(
      initialValue: null, validators: [FieldBlocValidators.required]);

  final gender = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['Male', 'Female'],
  );

  final selectInstitute = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['School', 'College', 'University'],
  );


  final file = InputFieldBloc<File?, String>(
      validators: [FieldBlocValidators.required],
      initialValue: null);

  final image = InputFieldBloc<File?, String>(
      validators: [FieldBlocValidators.required],
      initialValue: null);



  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      userName,
      email,
      password,
      dob,
      gender,
      selectInstitute,

    ]);
  }

  void addErrors() {
    userName.addFieldError('Awesome Error!');
    email.addFieldError('Awesome Error!');
    password.addFieldError('Awesome Error!');
    dob.addFieldError('Awesome Error!');
    gender.addFieldError('Awesome Error!');
    selectInstitute.addFieldError('Awesome Error!');

  }


  @override
  void onSubmitting() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emitSuccess(canSubmitAgain: true);
    } catch (e) {
      emitFailure();
    }
  }
}

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({Key? key}) : super(key: key);

  @override
  State<StudentSignUp> createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {

  File? file;
  firebase_storage.UploadTask? task;
  Reference? task2;

  String? fileUrlDownload;
  String? imageUrlDownload;

  ImagePicker _picker = ImagePicker();
  XFile? image;

  List<dynamic> schoolsList = [];
  List<dynamic> collegesList = [];
  List<dynamic> universitiesList = [];


  final _fireStore = FirebaseFirestore.instance;

  Future<void> getSchoolData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _fireStore.collection("Institutes")
        .doc('data')
        .collection('School').get();

    //for a specific field
    schoolsList =
        querySnapshot.docs.map((doc) => doc.get('School Name')).toList();

    print('This is new data $schoolsList');
  }

  Future<void> getCollegeData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _fireStore.collection("Institutes")
        .doc('data')
        .collection('College').get();

    //for a specific field
    collegesList =
        querySnapshot.docs.map((doc) => doc.get('College Name')).toList();

    print('This is new data $collegesList');
  }

  Future<void> getUniversityData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _fireStore.collection("Institutes")
        .doc('data')
        .collection('University').get();

    //for a specific field
    universitiesList =
        querySnapshot.docs.map((doc) => doc.get('University Name')).toList();

    print('This is new data $universitiesList');
  }

  @override
  void initState() {
    super.initState();
    getSchoolData();
    getCollegeData();
    getUniversityData();
  }

  String? dropdownValue;
  String? dropdownValue2;
  String? dropdownValue3;
  String? selectIndex;



  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);


    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    final imageName = image != null ? basename(image!.path) : 'No Image Selected';

    return BlocProvider(
      create: (context) => AllFieldsFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<AllFieldsFormBloc>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                // Used for removing back buttoon.
                toolbarHeight: 200,
                // Set this height
                flexibleSpace: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Let's get you set up", style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),),
                      SizedBox(height: 20,),
                      Text("It should only take a couple of minutes",
                        style: TextStyle(fontSize: 15, color: Colors.white),),
                      Text(" to create your account",
                        style: TextStyle(fontSize: 15, color: Colors.white),),
                      SizedBox(height: 30,),
                      InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) =>
                                    StudentSignIn()));
                          },
                          child: Text("Go to Login >>",
                            style: TextStyle(
                                fontSize: 15, color: Colors.white),)),


                    ],
                  ),
                ),
                elevation: 2.0,

              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: formBloc.addErrors,
                    icon: const Icon(Icons.error_outline),
                    label: const Text('ADD ERRORS'),
                  ),
                  const SizedBox(height: 12),
                  FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: formBloc.submit,
                    icon: const Icon(Icons.send),
                    label: const Text('SUBMIT'),
                  ),
                ],
              ),
              body: FormBlocListener<AllFieldsFormBloc, String, String>(
                onSubmitting: (context, state)  {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) async {
                  LoadingDialog.hide(context);

                  await uploadFile();

                  await uploadImage();

                  setState(()  {

                    print('$fileUrlDownload file URL');
                    print('$imageUrlDownload image URL');

                  });


                  final String userName = formBloc.userName.value;
                  final String email = formBloc.email.value;
                  final String password = formBloc.password.value;
                  final DateTime? dob = formBloc.dob.value;
                  final String? gender = formBloc.gender.value;
                  final String? institute = formBloc.selectInstitute.value;
                  final String? selectedInstitute = dropdownValue != null ? dropdownValue : dropdownValue2 != null ? dropdownValue2 : dropdownValue3;


                  await authService.createUserWithEmailAndPassword(
                      email,
                      password);

                  FirebaseFirestore.instance.collection('users')
                      .add({
                    'UserName': userName,
                    'Email': email,
                    'Password': password,
                    'date of Birth': dob,
                    'Gender': gender,
                    'Institute': institute,
                    'Institute Name': selectedInstitute,
                    'Fee Structure': fileUrlDownload,
                    'School Image': imageUrlDownload

                  }).then((value) => print("user added"));

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SuccessScreen()));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.failureResponse!)));
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 24.0, bottom: 170),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.userName,
                          decoration: const InputDecoration(
                            labelText: 'UserName',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),

                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.password,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.password),
                          ),
                        ),
                        DateTimeFieldBlocBuilder(
                          dateTimeFieldBloc: formBloc.dob,
                          format: DateFormat('dd-MM-yyyy'),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: Icon(Icons.calendar_today),
                            helperText: 'Date of Birth',
                          ),
                        ),
                        RadioButtonGroupFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.gender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                          ),
                          itemBuilder: (context, item) =>
                              FieldItem(
                                child: Text(item),
                              ),
                        ),


                        DropdownFieldBlocBuilder<String>(
                          onChanged: (value) {
                            setState(() {
                              selectIndex = value ;

                            });
                          },
                          selectFieldBloc: formBloc.selectInstitute,
                          decoration: const InputDecoration(
                            labelText: 'Select Institute',
                          ),
                          itemBuilder: (context, value) =>
                              FieldItem(
                                isEnabled:  value != '',
                                child: Text(value),
                              ),
                        ),
                        ChoiceChipFieldBlocBuilder<String>(

                          selectFieldBloc: formBloc.selectInstitute,
                          itemBuilder: (context, value) =>
                              ChipFieldItem(
                                label: Text(value),
                              ),
                        ),

                        Container(height: 70,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black38)
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: selectIndex == 'College' ?
                            DropdownButton<String>(
                              value: dropdownValue2,
                              icon: Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black87, fontSize: 16),

                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue2 = newValue!;
                                });
                              },
                              items: collegesList
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,),
                                );
                              }).toList(),
                            )
                                :
                            selectIndex == 'School' ?
                            DropdownButton<String>(
                              value: dropdownValue,
                              icon: Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black87, fontSize: 16),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                              items: schoolsList
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                                :
                            DropdownButton<String>(
                              value: dropdownValue3,
                              icon: Icon(Icons.expand_more),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.black87, fontSize: 16),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue3 = newValue!;
                                });
                              },
                              items: universitiesList
                                  .map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),



                        BlocBuilder<InputFieldBloc<File?, String>,
                            InputFieldBlocState<File?, String>>(
                            bloc: formBloc.file,
                            builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  selectFile();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.black38)
                                  ),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.attach_file_outlined,
                                              ),
                                              Text("Select Academic data"),
                                            ],
                                          ),
                                          Text(fileName),
                                          task != null ? buildUploadStatus(task!) : Container()

                                        ],
                                      ),
                                    ),
                                  ),
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );
                            }),
                        SizedBox(height: 10,),
                        BlocBuilder<InputFieldBloc<File?, String>,
                            InputFieldBlocState<File?, String>>(
                            bloc: formBloc.image,
                            builder: (context, state) {
                              return InkWell(
                                onTap: () async {
                                  selectImage();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.black38)
                                  ),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image,
                                              ),
                                              Text("Select User Image"),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 30),
                                            child: Text(imageName),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path!);
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'users/files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {

    });

    if(task == null) return;

    final snapshot = await task!.whenComplete(() {});
    fileUrlDownload = await snapshot.ref.getDownloadURL();

    print('Download-link: $fileUrlDownload');
  }

  Widget buildUploadStatus(firebase_storage.UploadTask task) => StreamBuilder<firebase_storage.TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if(snapshot.hasData)
        {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);

          return Text(
              '$percentage %',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)
          );
        }
        else
        {
          return Container();
        }
      });


  Future selectImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);

  }

  Future uploadImage() async {

    final imageName = basename(image!.path);
    final destination = 'users/images/$imageName';

    task2 = FirebaseStorage.instance.ref(destination);

    await task2!.putFile(File(image!.path));

    imageUrlDownload = await task2!.getDownloadURL();

    print('Download-link: $imageUrlDownload');
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) =>
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.tag_faces, size: 100),
            const SizedBox(height: 10),
            const Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const StudentSignUp())),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue to Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}



