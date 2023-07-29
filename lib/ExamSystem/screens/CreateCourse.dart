import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Shared/components/components.dart';
import '../Course_Cubit/coursecubit.dart';
import '../Course_Cubit/coursestates.dart';
import '../themanager.dart';


class Create_Course extends StatefulWidget {
  const Create_Course({Key? key}) : super(key: key);

  @override
  State<Create_Course> createState() => _Create_CourseState();
}

class _Create_CourseState extends State<Create_Course> {
  @override
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var ProffesereController = TextEditingController();
  var CourrseID = TextEditingController();
  List<String> professorNames = [];
  List<String> _professorIds = [];
  String? _selectedProfessorId; // Update the field declaration

  void initState() {
    super.initState();
    fetchProfessorIds(); // Call the method to fetch professor IDs from Firestore
  }
  // List to store professor IDs
  Future<void> fetchProfessorIds() async {
    // Fetch professor IDs from Firestore

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'ADMIN')
        .get();

    final List<String> professorIds = querySnapshot.docs.map((doc) => doc.id).toList();
    final List<String> names = querySnapshot.docs.map((doc) => doc['name'] as String).toList();

    setState(() {
      _professorIds = professorIds;
      professorNames = names;

    });
  }


  @override
  Widget build(BuildContext context) {
     return BlocProvider(
      create: (BuildContext context) => CourseReigsterCubit(),
      child: BlocConsumer<CourseReigsterCubit, CourseStates>(
        listener: (context, state) {

        },
    builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,

            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Course',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Create Course',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30.0.h,
                        ),                        SizedBox(height: 15.h,),

                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validator: ( value)
                          {
                            if(value== null || value.isEmpty)
                            {
                              return 'name must not be empty';
                            }

                            return null;
                          },
                          label: 'Course Name',
                          prefix: Icons.yard_outlined,
                        ),                        SizedBox(height: 15.h,),

      Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
      children: [
      // Other form fields...
              DropdownButtonFormField<String>(
              value: _selectedProfessorId,
              onChanged: (value) {
              setState(() {
                _selectedProfessorId = value;
                ProffesereController.text = _selectedProfessorId!;

              });
              },
              items: _professorIds.map((id) {
              final index = _professorIds.indexOf(id);
              final name = professorNames[index];
              return DropdownMenuItem<String>(
              value: id,
              child: Text(name),
              );
              }).toList(),
              hint: Text('Select Professor'),
              decoration: InputDecoration(
              labelText: 'Select Professor',
              hintText: 'Select Professor',
              border:OutlineInputBorder(
              borderSide: BorderSide(
              color: Colors.black,
              ),
              ),
              ),
              validator: (value) {
              if (value == null || value.isEmpty) {
              return 'Please select a professor';
              }
              return null;
              },
              ),
                                SizedBox(height: 15.h,),
                        defaultFormField(
                          controller: CourrseID,
                          type: TextInputType.text,
                          validator: ( value)
                          {
                            if(value== null || value.isEmpty)
                            {
                              return 'name must not be empty';
                            }

                            return null;
                          },
                          label: 'Course ID',
                          prefix: Icons.important_devices,
                        ),
                        SizedBox(height: 15.h,),
                        ConditionalBuilder(
                          condition: state is! CourseLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                               CourseReigsterCubit.get(context).addCourse(CourrseID.text,nameController.text,ProffesereController.text);
                                // FirebaseFirestore.instance.collection("users").doc( ProffesereController.text).update({"course": CourrseID.text});
                               FirebaseFirestore.instance.collection('users').doc(ProffesereController.text).update({
                                 'course': FieldValue.arrayUnion([CourrseID.text])
                               });
                               Navigator.of(context).push(MaterialPageRoute(
                                   builder: (context) =>
                                       themanager()  ));
                              }
                            },
                            text: 'register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),

                      ],
                    ),
                  ),
               ] ))),
              ),
            ),
          );
            }));

  }
  }

