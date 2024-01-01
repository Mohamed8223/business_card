import 'package:flutter/material.dart';
import '../../features/auth/auth.dart';
import 'package:clinigram_app/core/core.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';

class IntroductionView extends StatelessWidget {
  const IntroductionView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenSize.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  DottedBorder(
                    borderType: BorderType.Circle,
                    padding: const EdgeInsets.all(25),
                    dashPattern: const [20, 10],
                    color: Colors.blue[300]!,
                    child: DottedBorder(
                      color: Colors.red[600]!,
                      borderType: BorderType.Circle,
                      dashPattern: const [20, 10],
                      padding: EdgeInsets.all(screenWidth * 0.18),
                      child: Transform.translate(
                        offset: Offset(screenWidth * 0.08, 0),
                        child: Text(
                          S.of(context).IntroductionView_Be_Well_We_Here,
                          style: context.textTheme.headlineMedium!.copyWith(
                            color: Colors.black,
                            fontSize: screenWidth > 450
                                ? screenWidth * 0.07
                                : screenWidth * 0.085,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(0, -(screenWidth * 0.15)),
                      child: CircleAvatar(
                        backgroundColor: context.theme.colorScheme.secondary,
                        radius: screenWidth > 450 ? 100 : screenWidth * 0.17,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius:
                                screenWidth > 450 ? 100 : screenWidth * 0.17,
                            backgroundImage: const AssetImage(
                              doctor1Image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: Transform.translate(
                      offset: Offset(-(screenWidth * 0.1), 0),
                      child: CircleAvatar(
                        backgroundColor: context.theme.colorScheme.secondary,
                        radius: screenWidth > 450 ? 90 : screenWidth * 0.15,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: screenWidth > 450 ? 90 : screenWidth * 0.15,
                            backgroundImage: const AssetImage(
                              doctor2Image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(screenWidth * 0.03, 0),
                      child: CircleAvatar(
                        backgroundColor: context.theme.colorScheme.secondary,
                        radius: screenWidth > 450 ? 80 : screenWidth * 0.13,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: screenWidth > 450 ? 80 : screenWidth * 0.13,
                            backgroundImage: const AssetImage(
                              doctor3Image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Text(S.of(context).IntroductionView_Welcome_to_the_Community,
                  style: context.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Text('Clinicate',
                  style: context.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 30,
              ),
              ClinigramButton(
                onPressed: () {
                  context.pushReplacement(const LoginView());
                },
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).IntroductionView_Join_Us,
                        style: context.textTheme.titleMedium!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_outlined,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
