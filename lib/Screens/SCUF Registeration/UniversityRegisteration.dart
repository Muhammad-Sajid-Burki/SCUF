import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_web_to_app_design/API/FirebaseApi.dart';
import 'package:flutter_web_to_app_design/AuthServices/AuthServices.dart';
import 'package:flutter_web_to_app_design/Screens/Institutes/InstitutesScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';


class AllFieldsFormBloc extends FormBloc<String, String> {

  final uniName = TextFieldBloc(validators: [FieldBlocValidators.required],
  );

  final uniAddress = TextFieldBloc(validators: [FieldBlocValidators.required],);

  final email = TextFieldBloc(validators: [FieldBlocValidators.email],);
  final password = TextFieldBloc(validators: [FieldBlocValidators.passwordMin6Chars],);

  final contactNo = TextFieldBloc(validators: [FieldBlocValidators.required],);

  final marksPercentage = TextFieldBloc(validators: [FieldBlocValidators.required],);

  final link = TextFieldBloc();

  final sector = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['Government', 'Private'],
  );


  final subject = MultiSelectFieldBloc<String, dynamic>(
    validators: [FieldBlocValidators.required],
    items: [
       'Sociology',
       'Psychology',
       'International Relations',
       'Biotechnology',
       'Software Engineering',
       'Political Science',
       'BBA',
       'Economics',
       'Linguistics',
       'Biochemistry',
       'Public Administration',
       'HRM',
       'Microbiology',
       'Marketing',
       'Geography',
       'Educational Psychology',
       'Pharmacy',
       'Philosophy',
       'DPT',
       'Statistics',
       'IT',
       'Mechanical Engineering',
       'Bioinformatics',
       'Educational Research',
       'Clinical Psychology',
       'Criminology',
       'Psycholinguistics',
       'Social Psychology',
       'Computer Science',
       'Zoology',
       'Physics',
       'Mass Communication',
       'Environmental Science',
       'Education',
       'Law',
       'Project Management',
       'Civil Engineering',
       'Mathematics',
       'Financial Management',
       'International Law',
       'Health Psychology',
       'Electrical Engineering',
       'Macroeconomics',
       'ICS',
       'Sociolinguistics',
       'Chemistry',
       'Genetics',
       'Graphic Designing',
       'Educational Administration',
       'Biomedical Engineering',
       'Architect',
    ],
  );



  final file = InputFieldBloc<File?, String>(
      validators: [FieldBlocValidators.required],
      initialValue: null);

  final image = InputFieldBloc<File?, String>(
      validators: [FieldBlocValidators.required],
      initialValue: null);


  AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      uniName,
      uniAddress,
      sector,
      subject,
      link,
      email,
      contactNo,
      marksPercentage,
      password
    ]);
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

class UniversityRegisteration extends StatefulWidget {
  const UniversityRegisteration({Key? key}) : super(key: key);

  @override
  State<UniversityRegisteration> createState() => _UniversityRegisterationState();
}

class _UniversityRegisterationState extends State<UniversityRegisteration> {

  File? file;
  firebase_storage.UploadTask? task;
  Reference? task2;

  String? fileUrlDownload;
  String? imageUrlDownload;

  ImagePicker _picker = ImagePicker();
  XFile? image;

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
              appBar: AppBar(title: const Text('University Registeration')),
              floatingActionButton: FloatingActionButton.extended(
                heroTag: null,
                onPressed: formBloc.submit,
                icon: const Icon(Icons.send),
                label: const Text('SUBMIT'),
              ),
              body: FormBlocListener<AllFieldsFormBloc, String, String>(
                onSubmitting: (context, state) {
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


                  final String uniName = formBloc.uniName.value;
                  final String uniAddress = formBloc.uniAddress.value;
                  final String? sector = formBloc.sector.value;
                  final List<String> subject = formBloc.subject.value;
                  final String link = formBloc.link.value;
                  final String email = formBloc.email.value;
                  final String password = formBloc.password.value;
                  final String contactNo = formBloc.contactNo.value;
                  final String marksPercentage = formBloc.marksPercentage.value;

                  await authService.createUserWithEmailAndPassword(
                      email,
                      password);

                  FirebaseFirestore.instance.collection('Institutes').doc('data')
                      .collection('University')
                      .add({
                    'University Name': uniName,
                    'University Address': uniAddress,
                    'Email': email,
                    'Password': password,
                    'Contact no': contactNo,
                    'Percentage of Marks': marksPercentage,
                    'Sector': sector,
                    'Fields': subject,
                    'Link': link,
                    'Fee Structure': fileUrlDownload,
                    'University Image': imageUrlDownload

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
                    padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 24.0, bottom: 100),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          keyboardType: TextInputType.text,
                          textFieldBloc: formBloc.uniName,
                          decoration: const InputDecoration(
                            labelText: 'University Name',
                            prefixIcon: Icon(Icons.school),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          keyboardType: TextInputType.text,
                          textFieldBloc: formBloc.uniAddress,
                          decoration: const InputDecoration(
                            labelText: 'University Address',
                            prefixIcon: Icon(Icons.home),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          keyboardType: TextInputType.emailAddress,
                          textFieldBloc: formBloc.email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          keyboardType: TextInputType.visiblePassword,
                          textFieldBloc: formBloc.password,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.password),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          keyboardType: TextInputType.phone,
                          textFieldBloc: formBloc.contactNo,
                          decoration: const InputDecoration(
                            labelText: 'Contact No',
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        TextFieldBlocBuilder(
                          keyboardType: TextInputType.phone,
                          textFieldBloc: formBloc.marksPercentage,
                          decoration: const InputDecoration(
                            labelText: 'Percentage of Marks',
                            prefixIcon: Icon(Icons.credit_score),
                          ),
                        ),
                        DropdownFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.sector,
                          decoration: const InputDecoration(
                            labelText: 'Sector',
                          ),
                          itemBuilder: (context, value) => FieldItem(
                            isEnabled: value != '',
                            child: Text(value
                            ),
                          ),
                        ),
                        CheckboxGroupFieldBlocBuilder<String>(
                          multiSelectFieldBloc: formBloc.subject,
                          decoration: const InputDecoration(
                            labelText: 'Fields/Programs',
                          ),
                          itemBuilder: (context, item) => FieldItem(
                            child: Text(item),
                          ),
                        ),
                        ChoiceChipFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.sector,
                          itemBuilder: (context, value) => ChipFieldItem(
                            label: Text(value),
                          ),
                        ),
                        FilterChipFieldBlocBuilder<String>(
                          multiSelectFieldBloc: formBloc.subject,
                          itemBuilder: (context, value) => ChipFieldItem(
                            label: Text(value),
                          ),
                        ),
                        BlocBuilder<InputFieldBloc<File?, String>,
                            InputFieldBlocState<File?, String>>(
                            bloc: formBloc.file,
                            builder: (context, state) {
                              return InkWell(
                                onTap: () async {
                                  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

                                  if (result == null) return;
                                  final path = result.files.single.path;
                                  setState(() {
                                    selectFile();
                                  });
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
                                              Text("Select Fee Structure"),
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
                                              Text("Select University Image"),
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
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.link,
                          decoration: const InputDecoration(
                            labelText: 'Link to your own website',
                            prefixIcon: Icon(Icons.link_outlined),
                          ),
                        ),
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
    final destination = 'university/files/$fileName';

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
    final destination = 'university/images/$imageName';

    task2 = FirebaseStorage.instance.ref(destination);

    await task2!.putFile(File(image!.path));

    imageUrlDownload = await task2!.getDownloadURL();

    print('Download-link: $imageUrlDownload');
  }


}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
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
                      MaterialPageRoute(
                          builder: (_) => InstitutesScreen())),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue to Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
