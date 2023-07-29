
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Shared/components/components.dart';
import '../CUBIT/cubit.dart';
import '../CUBIT/states.dart';
import 'myprofile.dart';

class editprofile extends StatelessWidget {
  const editprofile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var nameController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SocialCubit()..getUserData(),
    child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {}
        ,builder: (context,state){
          var userModel =  SocialCubit.get(context).userModel;
          var profileImage =SocialCubit.get(context).userImageFile;
          phoneController.text='${userModel?.phone}';
          nameController.text='${userModel?.name}';


          return Scaffold(
            appBar: AppBar(


              automaticallyImplyLeading: false,

              elevation: 0,

              backgroundColor: Colors.white,
              title: Text('Edit Profile',style: TextStyle(color: Colors.blueAccent)),
                actions: [
                  TextButton(onPressed: (){
          SocialCubit.get(context).updateUser(name: nameController.text, phone: phoneController.text);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => myprofile()));

          }, child: Text('Update',style: TextStyle(color: Colors.blueAccent,fontSize: 17.sp),)


                  )],
            ),
            body:ConditionalBuilder(
              condition: userModel!=null,
              builder: (context) => SingleChildScrollView(
              child: Column(

              children: [
              Padding(padding: const EdgeInsets.only(top: 20),
              child: Stack(alignment: AlignmentDirectional.bottomEnd,
              children:[
                  CircleAvatar(
                  radius:92,
                  backgroundColor: Colors.blueAccent, child:  CircleAvatar(
                  radius: 87,

                  backgroundImage:profileImage== null? NetworkImage( '${userModel?.image}',):FileImage(profileImage)as ImageProvider,
                  ),
                  ),
                CircleAvatar(
                  radius: 23,
                    child:
                    IconButton(onPressed: (){
                      SocialCubit.get(context).getProfileImage();
                    }, icon: Icon(Icons.camera_alt,size: 20,)))
              ]
              ),
                  )
                , SizedBox(height: 20.h,),
                if(SocialCubit.get(context).userImageFile !=null)
      InkWell(
      onTap: (){
      SocialCubit.get(context).uploadProfileImage(
      name: nameController.text,
      phone: phoneController.text,

      );

      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => myprofile()));
      },
      child: Text('Upload Profile ',
      style: TextStyle(color: Colors.blueAccent,fontSize: 15.sp),
      ),
      ),
                SizedBox(height: 5.h,),

                if(state is SocialUpdateLoadingState)
                  Container(width: 100.w,
                      height: 5.h,
                      child: const LinearProgressIndicator()),

                SizedBox(height: 20.h
                  ,),

                Padding(padding: EdgeInsets.only(left: 10,right: 10),
                  child: defaultFormField(
                            controller: nameController,
                            label: 'Name',
                            prefix: Icons.person,
                            type: TextInputType.name,
                            validator: ( value)
                            {
                              if(value== null || value.isEmpty)
                              {
                                return 'Name must not be empty';
                              }

                              return null;
                            },
                          ),
                ),

                        SizedBox(height: 10.h,),

                        Padding(padding: EdgeInsets.only(left: 10,right: 10),
                          child: defaultFormField(
                  controller: phoneController,
                  label: 'phone',
                  prefix: Icons.phone,
                  type: TextInputType.number,
                  validator: ( value)
                  {
                    if(value== null || value.isEmpty)
                    {
                      return 'phone must not be empty';
                    }

                    return null;
                  },
                ),
                        ),

      ]      )
      ),
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()),    )   );
    },

    ));
  }

}
