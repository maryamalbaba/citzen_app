import 'package:citzenapp/core/resource/color_manager.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();

  final List<String> sliderImages = [
    'assets/images/image_rectangle_light_brown.png',
    'assets/images/image_rectangle_logo.png',
    'assets/images/image_rectangle_light_brown.png',
  ];

  int currentPage = 0;

  /// MOCK
  final bool hasProcesses = true;

  final bool hasComplaints = true;

  @override
  void initState() {
    super.initState();

    _autoSlider();
  }

  void _autoSlider() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        currentPage++;

        if (currentPage >= sliderImages.length) {
          currentPage = 0;
        }

        pageController.animateToPage(
          currentPage,
          duration: const Duration(
            milliseconds: 500,
          ),
          curve: Curves.easeInOut,
        );

        _autoSlider();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
      Container(
        color: Colors.white,
        child: SafeArea(
        //  bottom: false, // 2. إلغاء القص من الأسفل ليمتد المحتوى خلف شريط التنقل
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 14.h),
          
                /// SLIDER
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  height: 170.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.r,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: sliderImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          sliderImages[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
          
                SizedBox(height: 10.h),
          
                /// INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    sliderImages.length,
                    (index) {
                      return AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 3.w,
                        ),
                        width: currentPage == index ? 18.w : 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? ColorManager.darkGreen
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(
                            20.r,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          
                SizedBox(height:  15),
          
                /// PROCESS STEPPER
                if (hasProcesses)
                  _buildStepperCard(
                    title: 'حالة المعاملة',
                  ),
          
                /// COMPLAINT STEPPER
                if (hasComplaints)
                  _buildStepperCard(
                    title: 'حالة الشكوى',
                  ),
          
                SizedBox(height: 10),
          
                /// ACTIONS
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: Column(
                    children: [
                       Container(
                        height: 90.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xffB3A45F,
                          ),
                          borderRadius: BorderRadius.circular(
                            18.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.r,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "أخذ موعد من المديرية ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        height: 90.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xffB3A45F,
                          ),
                          borderRadius: BorderRadius.circular(
                            18.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.r,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'دليل المعاملات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ),
      );
    
  }

  Widget _buildActionCard({
    required String title,
  }) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: const Color(0xffB3A45F),
        borderRadius: BorderRadius.circular(
          18.r,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.r,
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 55.w,
          child: Text(
            title,
            
           
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

Widget _buildStepperCard({
  required String title,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
  
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
  
      SizedBox(height: 15),
  
      Directionality(
        textDirection: TextDirection.rtl,
        child: EasyStepper(
          activeStep: 2,
  
          lineStyle: LineStyle(
            lineLength: 40.w,
            lineThickness: 2,
            lineType: LineType.normal,
            defaultLineColor: Colors.grey.shade300,
          ),
  
          stepRadius: 22.r,
  
          activeStepBackgroundColor:
              Colors.white,
  
          finishedStepBackgroundColor:
              ColorManager.darkGreen,
  
          finishedStepTextColor: Colors.black,
  
          activeStepTextColor: Colors.black,
  
          unreachedStepTextColor: Colors.black,
  
          showLoadingAnimation: false,
  
          steps: [
  
            EasyStep(
              customStep: CircleAvatar(
                radius: 22.r,
                backgroundColor: ColorManager.darkGreen,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              title: 'تم\n الاستلام',
            ),
  
            EasyStep(
              customStep: CircleAvatar(
                
                radius: 22.r,
                backgroundColor: ColorManager.darkGreen,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                   size: 14,
                ),
              ),
              title: 'قيد \nالمعالجة',
            ),
  
            EasyStep(
              customStep: Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorManager.darkGreen,
                  ),
                ),
                child: Center(
                  child: Text('3'),
                ),
              ),
              title: 'تم إرسال \nالرد',
            ),
          ],
        ),
      ),
    ],
  );
}
  Widget _stepItem({
    required String title,
    required String number,
    bool isDone = false,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: isDone ? ColorManager.darkGreen : Colors.white,
          child: isDone
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                )
              : Text(
                  number,
                  style: TextStyle(
                    color: ColorManager.darkGreen,
                  ),
                ),
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
