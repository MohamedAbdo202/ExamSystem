import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutttter/Graduation%20project/Quiz_app/input_quesitons.dart';
import 'package:flutttter/News%20App/CubitStats.dart';
import 'package:flutttter/News%20App/cubit.dart';
import 'package:flutttter/OFC%20UI/CUBITOFC/ofcubit.dart';
import 'package:flutttter/Shared/components/components.dart';
import 'package:flutttter/Shared/components/constants.dart';
import 'package:flutttter/Shared/cubit/cubit.dart';
import 'package:flutttter/ShopApp/ShopCubit/Shopcubit.dart';
import 'package:hexcolor/hexcolor.dart';


import 'Graduation project/Compenent/constant.dart';
import 'Graduation project/Quiz_app/input_questions_fromjson.dart';
import 'Graduation project/Quiz_app/quizapp_layout.dart';
import 'Graduation project/network/local/cache_helper.dart';
import 'Graduation project/network/remote/dio.dart';
import 'Graduation project/screens/AddStudentToCourse.dart';
import 'Graduation project/screens/AlotofCourses.dart';
import 'Graduation project/screens/allResultforthesudent.dart';
import 'Graduation project/screens/AdminViewData.dart';
import 'Graduation project/screens/All_Admin.dart';
import 'Graduation project/screens/BottomNavBarAdmin.dart';
import 'Graduation project/screens/CreateCourse.dart';
import 'Graduation project/screens/Remove Screen.dart';
import 'Graduation project/screens/AddExaaaaam.dart';
import 'Graduation project/screens/login.dart';

import 'Graduation project/screens/myprofile.dart';
import 'Graduation project/screens/onBoarding.dart';
import 'Graduation project/screens/AddExam.dart';
import 'Graduation project/screens/result_toprof.dart';
import 'Graduation project/screens/testcard.dart';
import 'Graduation project/screens/ShowExamToProffesore.dart';
import 'Graduation project/screens/student show.dart';
import 'Graduation project/screens/submitresultforProfessore.dart';
import 'Graduation project/screens/trytarekbutton.dart';
import 'News App/CubitMode.dart';
import 'News App/HomeLayout.dart';
import 'OFC UI/Models/Model.Despoite/Despoite.dart';
import 'OFC UI/Models/Model.Despoite/OFC_GOLDEN2.dart';
import 'OFC UI/Models/Model.Despoite/OFC_Golden.dart';
import 'OFC UI/Models/Model.PointSystem/Pointsystem.dart';
import 'OFC UI/Models/Model.Setting/ActiveFaceID.dart';
import 'OFC UI/Models/Model.Setting/ChangePASSWORD.dart';
import 'OFC UI/Models/Model.Setting/Secuirty.dart';
import 'OFC UI/Models/Model.home/Drawer.dart';
import 'OFC UI/Models/Model.login/LoginOFC.dart';
import 'OFC UI/Models/Model.Send/Send.dart';
import 'OFC UI/Models/Model.Send/Send2.dart';
import 'OFC UI/Models/Model.Send/Send3.dart';
import 'OFC UI/Models/Model.Setting/SettingsOFC.dart';
import 'OFC UI/Models/Model.Transactions/Transactions.dart';
import 'OFC UI/Models/Model.Transactions/Transfer Summary.dart';
import 'OFC UI/Models/Model.Transactions/TransferList.dart';
import 'OFC UI/Models/Model.crad/Card3.dart';
import 'OFC UI/Models/Model.crad/Cards.dart';
import 'OFC UI/Models/Model.crad/Cards2.dart';
import 'OFC UI/Models/Model.home/HomeOFC.dart';
import 'OFC UI/Models/Model.login/Register.dart';
import 'OFC UI/Models/Model.login/TrueLoginOFC.dart';
import 'OFC UI/Models/Model.map/Contactus.dart';
import 'OFC UI/Models/Model.map/FAQS.dart';
import 'OFC UI/Models/Model.map/Map.dart';
import 'OFC UI/Models/onBoarding.dart';
import 'ShopApp/Modules/home/HomeScreeen.dart';
import 'ShopApp/Modules/login/ShopLoginPage.dart';
import 'ShopApp/Modules/onboardingshop/onBoardingShop.dart';
import 'ShopApp/Modules/products/product_screen.dart';
import 'Shop_Cart_Add/Models/Customer/HomePageCart/HomeCustomer.dart';
import 'Shop_Cart_Add/Models/Customer/ProductPage/ProductCart.dart';
import 'Shop_Cart_Add/Modules/Login/LoginCart.dart';
import 'Shop_Cart_Add/ShopCartCubit/CubitCartt.dart';
import 'firebase_options.dart';
import 'modules/login/Login.dart';


// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Handle FCM message when the app is in the background
// }


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle FCM message when the app is terminated or in the background
  print('onBackgroundMessage: ${message.notification?.title}|${message.notification?.body}');
  showToast(text: '${message.notification?.title}', state: ToastState.Success);

}



void main ()async
{

  WidgetsFlutterBinding.ensureInitialized();
  // FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  await Firebase.initializeApp(
    name: 'name-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // DioHelper.init();
  DioHelper.init();

  await CacheHelper.init();
  uId = CacheHelper.getData(key: 'uId');
  token = CacheHelper.getData(key: 'token');

  // Widget ?widget;
  // String? uid = FirebaseAuth.instance.currentUser?.uid;



  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    showToast(
      text: '${message.data}',
      state: ToastState.Success,
    );
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });




  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen(( event) {
    // Handle FCM message when the app is in the background and opened from the notification
    print('onMessageOpenedApp: ${event.notification?.title}|${event.notification?.body}');
    showToast(text: '${event.data}', state: ToastState.Success);

    // Navigate to a specific page or screen based on the notification data
  });
  bool isDark = CacheHelper.getData(key: 'isDark');
  runApp(MyApp(isDark));
}

// Stateless
// Stateful

// class MyApp

class MyApp extends StatelessWidget
{
  final bool isDark;
  MyApp(this.isDark);

  @override
  Widget build(BuildContext context)
  {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,

        builder: (context , child) {
          return  MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => Newscubit()..getBusiness()..getScience()..getSport(),),
              BlocProvider( create: (BuildContext context)=>Modecubit()..changeAppMode(fromshared:  isDark),
              ),
              BlocProvider(create: (context) => ShopCubit()..getUserData()..getHomeData()..getFavouriteData()..getCategoriesData(),),
              BlocProvider(create: (context) => ShopCubitt()..fetchProducts()..FetchCategory()),
              BlocProvider(create: (context) => OFCCubit())

            ],
            child: BlocConsumer<Modecubit,ModeStats>(
              listener: (context, state) {},
              builder: (context, state) {
                return MaterialApp(
                  themeMode: Modecubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
                  theme: ThemeData(
                    primarySwatch: Colors.green,
                    scaffoldBackgroundColor: Colors.white,
                    appBarTheme: AppBarTheme(
                      toolbarHeight: 60.0.h ,

                      titleSpacing: 20.0,
                      backwardsCompatibility: false,
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.white,
                        statusBarIconBrightness: Brightness.dark,
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0.0,
                      titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      iconTheme: IconThemeData(
                        color: Colors.black,
                      ),
                    ),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Colors.green,
                    ),
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: Colors.green.withOpacity(.8),
                      unselectedItemColor: Colors.grey,
                      elevation: 20.0,
                      backgroundColor: Colors.white,
                    ),
                    textTheme: TextTheme(
                      bodyText1: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // darkTheme: ThemeData(
                  //   primarySwatch: Colors.green,
                  //   scaffoldBackgroundColor: HexColor('333739'),
                  //   appBarTheme: AppBarTheme(
                  //     toolbarHeight: 60.0.h ,
                  //
                  //     titleSpacing: 20.0,
                  //     backwardsCompatibility: false,
                  //     systemOverlayStyle: SystemUiOverlayStyle(
                  //       statusBarColor: HexColor('333739'),
                  //       statusBarIconBrightness: Brightness.light,
                  //     ),
                  //     backgroundColor: HexColor('333739'),
                  //     elevation: 0.0,
                  //     titleTextStyle: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 20.0,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //     iconTheme: IconThemeData(
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
                  //     backgroundColor: Colors.green,
                  //   ),
                  //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  //     type: BottomNavigationBarType.fixed,
                  //     selectedItemColor: Colors.green,
                  //     unselectedItemColor: Colors.grey,
                  //     elevation: 20.0,
                  //     backgroundColor: HexColor('333739'),
                  //   ),
                  //   textTheme: TextTheme(
                  //     bodyText1: TextStyle(
                  //       fontSize: 18.0,
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  debugShowCheckedModeBanner: false,
                  home: onBoarding(),
                );
              },


            ),
          );
        });
  }
}