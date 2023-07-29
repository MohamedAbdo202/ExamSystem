
import 'package:conditional_builder/conditional_builder.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../Shared/components/components.dart';
import '../CubitReg/CubitReg.dart';
import '../CubitReg/statereg.dart';
import '../SocialLayout.dart';
import '../themanager.dart';

class SocialRegisterScreen extends StatefulWidget {
  @override
  State<SocialRegisterScreen> createState() => _SocialRegisterScreenState();
}

class _SocialRegisterScreenState extends State<SocialRegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();
  var levelController = TextEditingController();


  bool isPassword = true;

  final List<String> items = [
    'ADMIN',
  ];

  String selectedValue ='ADMIN';



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
                          maxLength: 11,
                          type: TextInputType.phone,
                          validator: ( value)
                          {
                            if(value== null || value.isEmpty)
                            {
                              return 'phone must not be empty';
                            }

                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),



                        SizedBox(
                          height: 30.0.h,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                 role:selectedValue
                                );
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
                        SizedBox(
                          height: 10.0.h,
                        ),
defaultButton(function: (){


  SocialRegisterCubit().uploadJsonFileAdmin();
}, text: 'upload json Proffesore')
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