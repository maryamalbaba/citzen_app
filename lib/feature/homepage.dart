import 'package:citzenapp/core/resource/color_manager.dart';
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
    // نستخدم Directionality للتأكد المطلق من أن الصفحة تقرأ الاتجاه الصحيح
    // حتى وإن حدث أي تعارض في الـ MaterialApp
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: ColorManager.backgroundLight,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 14),
  
                /// SLIDER
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
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
  
                SizedBox(height: 10),
  
                /// INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    sliderImages.length,
                    (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        width: currentPage == index ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? ColorManager.darkGreen
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                ),
  
                SizedBox(height: 20),
  
                /// ACTIONS / SERVICES SECTION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الخدمات الإلكترونية",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3A3A3A),
                        ),
                      ),
                      SizedBox(height: 12),
  
                      /// الخدمة الأولى: أخذ موعد من المديرية
                      _buildServiceCard(
                        title: "أخذ موعد من المديرية",
                        subtitle: "احجز موعدك بسهولة",
                        icon: Icons.calendar_today_outlined,
                        iconBgColor: ColorManager.darkGreen,
                        onTap: () {},
                      ),
  
                      SizedBox(height: 14),
  
                      /// الخدمة الثانية: دليل المعاملات
                      _buildServiceCard(
                        title: "خدمة ساعدني ",
                        subtitle: "تعرف على متطلبات كل معاملة",
                        icon: Icons.menu_book_outlined,
                        iconBgColor: ColorManager.goldenBrown,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
  
                SizedBox(height: 25),
  
                /// LATEST NEWS & ANNOUNCEMENTS SECTION
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "آخر الأخبار والإعلانات",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3A3A3A),
                        ),
                      ),
                      SizedBox(height: 12),
  
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /// الإعلان الأول
                            _buildAnnouncementItem(
                              title: "تحديث أوقات الدوام الرسمي",
                              description: "يُعلم المراجعون بتعديل أوقات الدوام اعتباراً من الأسبوع القادم من ٨ صباحاً حتى ٣ عصراً.",
                              time: "اليوم",
                              badgeColor: ColorManager.goldenBrown,
                            ),
                            
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(color: Colors.grey.shade100, height: 1),
                            ),
  
                            /// الإعلان الثاني
                            _buildAnnouncementItem(
                              title: "فتح باب التسجيل للعام الجديد",
                              description: "بدأ استقبال طلبات التسجيل للعام الدراسي القادم عبر المنصة الإلكترونية.",
                              time: "أمس",
                              badgeColor: ColorManager.darkGreen,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
  
                SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بطاقة الخدمات بعد تصحيح التوجيه التلقائي للـ RTL للغة العربية
  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        height: 100,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1. الأيقونة الملونة (تصبح تلقائياً على اليمين في الـ RTL)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            SizedBox(width: 16),
            
            // 2. النصوص (العنوان والوصف) وتأخذ المساحة المتبقية
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, // يبدأ من اليمين في لغتنا العربية
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xff222222),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                     overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: ColorManager.textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // 3. سهم الانتقال (يصبح تلقائياً في أقصى اليسار)
            // نستخدم السهم المتوافق مع اتجاه اللغة
            Icon(
              Icons.arrow_forward_ios, 
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  /// عنصر الإعلان مع توجيه RTL سليم ومستقر
  Widget _buildAnnouncementItem({
    required String title,
    required String description,
    required String time,
    required Color badgeColor,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // يبدأ النص من اليمين تلقائياً
        children: [
          Row(
            children: [
              // النقطة الملونة
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                    ),
                  ),
              SizedBox(width: 8.w),
              // العنوان
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff222222),
                  ),
                ),
              ),
              // الوقت (يُدفع تلقائياً لليسار بفضل Expanded للعنوان)
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // تفاصيل الخبر
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xff555555),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}