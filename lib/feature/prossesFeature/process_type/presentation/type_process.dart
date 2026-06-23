// import 'package:citzenapp/core/resource/color_manager.dart';
// import 'package:flutter/material.dart';
import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/core/service/get_it/injection_container.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/domain/usecase/usecase_typeprocess.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/bloc/type_process_bloc.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/bloc/type_process_event.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/bloc/type_process_state.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/ui.dart';

import 'package:citzenapp/feature/prossesFeature/processes/presentation/ui.dart';

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
          backgroundColor: ColorManager.darkGreen,
          elevation: 0,
          title: Text(
            "  المعاملات المتاحة",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          // تصميم زر العودة المتناسق مع الصورة المرفقة
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),),))),
      body: SafeArea(
        child: BlocProvider(
          // ✨ Magic happens here: sl() automatically finds the UseCase! ✨
          create: (context) => TypeProcessBloc(
            sl<GetTypeProcessUseCase>(),
          )..add(GetTypeProcessEvent()),

          child: Column(
            children: [
           
             
              SizedBox(height: 18.h),
              Expanded(
                child: BlocBuilder<TypeProcessBloc, TypeProcessState>(
                  builder: (context, state) {
                    /// LOADING
                    if (state is TypeProcessLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    /// ERROR
                    if (state is TypeProcessError) {
                      return Center(
                        child: Text(
                          state.message,
                        ),
                      );
                    }

                    /// EMPTY
                    if (state is TypeProcessEmpty) {
                      return Center(
                        child: Text(
                          state.message,
                        ),
                      );
                    }

                    /// SUCCESS
                    if (state is TypeProcessLoaded) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.processes.length,
                        itemBuilder: (context, index) {
                          final item = state.processes[index];

                          return  buildProcessCard(
                            title: item.name,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthProcessesPage(
                                    processTypeId: item
                                        .id, // الـ ID القادم من صفحة الأنواع
                                    title:
                                        'معاملات  AUTH', // أو اسم النوع المختار ديناميكياً
                                  ),
                                ),
                              );
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
