import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sjq/themes/themes.dart';

class AboutUsScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const AboutUsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About us",
          style: headingM,
        ),
        backgroundColor: colorLightBlue,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0)),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 8,
                vertical: 15,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Breakpoints
                  bool isSmallScreen = constraints.maxWidth < 600;
                  bool isMediumScreen = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;

                  double logo1Size = isSmallScreen
                      ? screenSize.width * 0.5
                      : isMediumScreen
                          ? screenSize.width * 0.3
                          : screenSize.width * 0.2;
                  double logo2Size = isSmallScreen
                      ? screenSize.width * 0.4
                      : isMediumScreen
                          ? screenSize.width * 0.25
                          : screenSize.width * 0.15;
                  double containerPadding = isSmallScreen
                      ? 20
                      : isMediumScreen
                          ? 30
                          : 40;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/logo.png",
                              width: logo1Size, height: logo1Size),
                          const SizedBox(width: 10),
                          Image.asset("assets/logo2.png",
                              width: logo2Size, height: logo2Size),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF96B0D7).withOpacity(0.8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(containerPadding),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "NUTRIVISION FOR BARANGAY CEMBO COMMUNITY",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "Barangay Cembo is situated along the Pasig River and belongs to the Second District of Makati City. It is under the North East Cluster or Cluster 6 with Guadalupe Viejo, West Rembo and Northside. Based on the 2015 Census of Population conducted by the Philippine Statistics Authority (PSA), Cembo has 26,213 total population and a percentage share of 4.50%. By population density, on the other hand, considering its land area and population count, the barangay has 61 persons per 1,000 square meters.This barangay has a total land area of 426,700 square meters and it is predominantly residential. Cembo BLISS and the New Building of Makati Science High School are located within Barangay Cembo.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "CONTACT US",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Tel: 8881-1091 / 8519-2803\nAddress: Barangay 25, Cembo, Located at Ipil Street\nOffice Hours: 8am - 5pm",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
