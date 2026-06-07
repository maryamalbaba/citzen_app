// import 'package:citzenapp/core/resource/color_manager.dart';
// import 'package:flutter/material.dart';
import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/process/domain/usecase/usecase_typeprocess.dart';
import 'package:citzenapp/feature/process/presentation/bloc/type_process_bloc.dart';
import 'package:citzenapp/feature/process/presentation/bloc/type_process_event.dart';
import 'package:citzenapp/feature/process/presentation/bloc/type_process_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionTypesPage extends StatelessWidget {
  const TransactionTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xff004D40),
        elevation: 0,
        centerTitle: true,

        title: Text(
          'تقديم معاملة',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),

            child: IconButton(
              onPressed: () {},

              icon: Icon(
                Icons.arrow_forward,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child:BlocProvider(
    // ✨ Magic happens here: sl() automatically finds the UseCase! ✨
    create: (context) => TypeProcessBloc(
      sl<GetTypeProcessUseCase>(), 
    )..add(GetTypeProcessEvent()),

          child: Column(
            children: [
              SizedBox(height: 20.h),

              Text(
                'أنواع المعاملات المتاحة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff004D40),
                ),
              ),

              SizedBox(height: 5.h),

              Text(
                'لمديرية التريية والتعليم  لريف دمشق ',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xff004D40),
                ),
              ),

              SizedBox(height: 18.h),

              Expanded(
                child: BlocBuilder<
                    TypeProcessBloc,
                    TypeProcessState>(
                  builder: (context, state) {

                    /// LOADING
                    if (state
                        is TypeProcessLoading) {
                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    /// ERROR
                    if (state
                        is TypeProcessError) {
                      return Center(
                        child: Text(
                          state.message,
                        ),
                      );
                    }

                    /// EMPTY
                    if (state
                        is TypeProcessEmpty) {
                      return Center(
                        child: Text(
                          state.message,
                        ),
                      );
                    }

                    /// SUCCESS
                    if (state
                        is TypeProcessLoaded) {
                      return ListView.builder(
                        physics:
                            const BouncingScrollPhysics(),

                        itemCount:
                            state.processes.length,

                        itemBuilder:
                            (context, index) {

                          final item =
                              state.processes[index];

                          return TransactionCard(
                            title: item.name,

                            image:
                                'assets/images/logo.png',

                            onTap: () {
                              print(item.id);
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),

      child: GestureDetector(
        onTap: onTap,

        child: Container(
          height: 70,

          margin: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 4,
          ),

          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 16.h,
          ),

          decoration: BoxDecoration(
            color: const Color(0xffECE8DD),

            borderRadius:
                BorderRadius.circular(14.r),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.12),

                blurRadius: 6.r,

                offset: Offset(0, 3.h),
              ),
            ],
          ),

          child: Row(
            children: [

              SizedBox(width: 14.w),

              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,

                  style: TextStyle(
                    fontSize: 15,
                    color:
                        const Color(0xff9E875B),

                    fontWeight:
                        FontWeight.w400,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                ),

                child: CircleAvatar(
                  radius: 28,

                  backgroundColor:
                      ColorManager.extraLightBaieg,

                  child: Image.asset(
                    image,
                    width: 32,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter_screenutil/flutter_screenutil.dart';



// class TransactionTypesPage extends StatelessWidget {
//   TransactionTypesPage({super.key});

//   final List<TransactionTypeModel> transactions = [
//     TransactionTypeModel(
//       id: 1,
//       title: 'عملية نقل طالب من ريف إلى دمشق',
//       image: 'assets/images/logo.png',
//     ),

//     TransactionTypeModel(
//       id: 2,
//       title: 'عملية نقل طالب من ريف إلى دمشق',
//       image: 'assets/images/logo.png',
//     ),

//     TransactionTypeModel(
//       id: 3,
//       title: 'عملية نقل طالب من ريف إلى دمشق',
//       image: 'assets/images/logo.png',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F5),

//       appBar: AppBar(
//         backgroundColor: const Color(0xff004D40),
//         elevation: 0,
//         centerTitle: true,

//         title: Text(
//           'تقديم معاملة',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),

//         actions: [
//           Padding(
//             padding: EdgeInsets.only(left: 10.w),

//             child: IconButton(
//               onPressed: () {},

//               icon: Icon(
//                 Icons.arrow_forward,
//                 size: 24,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),

//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(height: 20.h),

//             Text(
//               'أنواع المعاملات المتاحة',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xff004D40),
//               ),
//             ),

//             SizedBox(height: 5.h),

//             Text(
//               'لمديرية التريية والتعليم  لريف دمشق ',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: const Color(0xff004D40),
//               ),
//             ),

//             SizedBox(height: 18.h),

//             Expanded(
//               child: ListView.builder(
//                 physics: const BouncingScrollPhysics(),

//                 itemCount: transactions.length,

//                 itemBuilder: (context, index) {
                 

//                   return TransactionCard(
//                     title:transactions[index].title,
//                     image: transactions[index].image,

//                     onTap: () {
//                       print(transactions[index].id);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// class TransactionCard extends StatelessWidget {
//   final String title;
//   final String image;
//   final VoidCallback onTap;

//   const TransactionCard({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: GestureDetector(
//         onTap: onTap,
      
//         child: Container(
//           height: 70,
//           margin: EdgeInsets.symmetric(
//             horizontal: 14.w,
//             vertical: 4,
//           ),
      
//           padding: EdgeInsets.symmetric(
//             horizontal: 14.w,
//             vertical: 16.h,
//           ),
      
//           decoration: BoxDecoration(
//             color: const Color(0xffECE8DD),
      
//             borderRadius: BorderRadius.circular(14.r),
      
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.12),
//                 blurRadius: 6.r,
//                 offset: Offset(0, 3.h),
//               ),
//             ],
//           ),
      
//           child: Row(
//             children: [
      
//               SizedBox(width: 14.w),
      
//               Expanded(
//                 child: Text(
//                   title,
//                   textAlign: TextAlign.right,
      
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: const Color(0xff9E875B),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8,right: 8),
//                 child: CircleAvatar(

//                   radius: 28,
//                   backgroundColor: ColorManager.extraLightBaieg,
                
//                   child: Image.asset(
//                     image,
//                     width: 32,
//                   //  height: 32,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// class TransactionTypeModel {
//   final int id;
//   final String title;
//   final String image;

//   TransactionTypeModel({
//     required this.id,
//     required this.title,
//     required this.image,
//   });
// }