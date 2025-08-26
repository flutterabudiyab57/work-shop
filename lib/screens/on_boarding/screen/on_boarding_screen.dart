import 'package:abu_diyab_workshop/screens/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "title": "خدمات سيارتك",
      "title2": "بضغطة زر!",
      "description": "دور على كل خدمات سيارتك، من صيانة وغسيل لقطع غيار، بسهولة تامة وبجودة مضمونة.",
      "image": "assets/images/onboarding1.png",
    },
    {
      "title": "خبراء الصيانة",
      "title2": "بين يديك!",
      "description": "اعتمد على أمهر المتخصصين لسيارتك. خدمات احترافية وجودة مضمونة، وين ما كنت ووقت ما تحتاج.",
      "image": "assets/images/onboarding2.png",
    },
    {
      "title": "سيارتك في أمان",
      "title2": "وراحة تامة!",
      "description": "لا تشيل همّ الصيانة بعد اليوم! كل اللي تحتاجه لسيارتك، من الألف للياء، صار بيدك. استمتع بقيادة بلا قلق",
      "image": "assets/images/onboarding3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              reverse: true,
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) => OnboardingContent(
                title: onboardingData[index]["title"] ?? "",
                title2: onboardingData[index]["title2"] ?? "",
                description: onboardingData[index]["description"] ?? "",
                image: onboardingData[index]["image"] ?? "",
              ),

            ),
          ),

          SizedBox(height: 20),
          currentPage == onboardingData.length - 1
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(4, 4), // هنا الزاوية: 4 يمين و4 تحت
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBA1B1B),
                  minimumSize: Size(270, 50),
                  elevation: 0, // خليها صفر عشان ما تدمجش ظل ElevatedButton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "ابدأ الآن",
                  style: GoogleFonts.almarai(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
              : Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: Color(0xFFBA1B1B),
                elevation: 0,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),


          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String title;
  final String title2;
  final String description;
  final String image;

  const OnboardingContent({
    Key? key,
    required this.title,
    required this.title2,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // صورة
          Container(
            height: 250,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          SizedBox(height: 40),

          // العنوان RichText
          RichText(
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Graphik Arabic',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg_tag.png",),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Baseline(
                      baseline: 25, // نفس حجم الـ fontSize عشان ينطبق
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        textDirection: TextDirection.rtl,
                        title2,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Graphik Arabic',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.70),
              fontSize: 20,
              fontFamily: 'Graphik Arabic',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}
