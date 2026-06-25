import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:citzenapp/feature/prossesFeature/process_type/presentation/type_process.dart';
import 'package:citzenapp/feature/prossesFeature/processes/presentation/ui.dart';
import 'package:flutter/material.dart';

class ChoicFlow extends StatelessWidget {
  const ChoicFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          backgroundColor: ColorManager.primaryGreen,
          elevation: 0,
          title: Text(
            "   تقديم",
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.darkGreen, // لون الخلفية
                foregroundColor: Colors.white, // لون النص
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // الحشو الداخلي
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // نمط النص
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // حواف مستديرة
                ),),
              onPressed: (){
             
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TransactionTypesPage()),
                );
              
            }, child: Text("تقديم معاملة")),
          ),

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.darkGreen, // لون الخلفية
                foregroundColor: Colors.white, // لون النص
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // الحشو الداخلي
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // نمط النص
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // حواف مستديرة
                ),),
              onPressed: (){
             
               
              
                       }, child: Text("تقديم شكوى")),
           ),

        ],
      )),
    );
  }
}
