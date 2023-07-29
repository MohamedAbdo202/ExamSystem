import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../CubitReg/CubitReg.dart';
import '../CubitReg/statereg.dart';
import '../SocialLayout.dart';
import '../../Shared/components/components.dart';
import '../themanager.dart';

class reguser extends StatefulWidget {
  const reguser({Key? key}) : super(key: key);

  @override
  State<reguser> createState() => _reguserState();
}

class _reguserState extends State<reguser> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();
  var levelController = TextEditingController();


  bool isPassword = true;

  final List<String> items = [
    '1','2','3','4'
  ];

  String selectedValue_user='USER';
  String selectedValue='1';



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialLayout()));


          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
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
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Register now to Control',
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 30.0.h,
                        ),
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
                          label: 'User Name',
                          prefix: Icons.person,
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validator: ( value)
                          {
                            if(value== null || value.isEmpty)
                            {
                              return 'email must not be empty';
                            }

                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          label: 'Password',
                          prefix: Icons.lock,
                          suffix: isPassword ? Icons.visibility : Icons.visibility_off,

                          isPassword: SocialRegisterCubit.get(context).isPassword,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          type: TextInputType.visiblePassword,
                          validator: ( value)
                          {
                            if(value== null || value.isEmpty)
                            {
                              return 'password must not be empty';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validator: ( value)
                          {
                            if(value== null || value.isEmpty)
                            {
                              return 'phone must not be empty';
                            }

                            return null;
                          },
                          maxLength: 11,
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),

                        // defaultFormField(
                        //   controller: levelController,
                        //   type: TextInputType.number,
                        //   validator: ( value)
                        //   {
                        //     if(value== null || value.isEmpty)
                        //     {
                        //       return 'phone must not be empty';
                        //     }
                        //
                        //     return null;
                        //   },
                        //   label: 'level',
                        //   prefix: Icons.yard_outlined,
                        // ),
                        // SizedBox(
                        //   height: 15.0,
                        // ),



                        DropdownButtonFormField2(
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          hint: const Text(
                            'Select level',
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                          buttonHeight: 60,
                          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          items: items
                              .map((item) =>
                              DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select level.';
                            }



                          },
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            }); },
                          onSaved: (value) {
                            selectedValue = value.toString();
                          },

                        ),
                        SizedBox(
                          height: 30.0.h,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister1(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                    role:selectedValue_user,
                                    level:selectedValue
                                );
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        themanager()  ));
                              }
                              // if(state is SocialCreateUserSuccessState){
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => reguser()));}

                              },
                            text: 'register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),

SizedBox(height: 10,)     ,
                  defaultButton(function: (){


                    SocialRegisterCubit().uploadJsonFileuser();
                  }, text: 'upload json Student')

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

  }
