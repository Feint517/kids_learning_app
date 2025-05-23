import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kids_learning_app/features/authentication/controllers/login/login_controller.dart';
import 'package:kids_learning_app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:kids_learning_app/features/authentication/screens/onboarding/onboarding_screen.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  //* Animation controllers
  late AnimationController slideController;
  late AnimationController scaleController;
  late AnimationController zoomOutController;
  late AnimationController fadeController;
  
  //* Animation values
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> zoomOutAnimation;
  late Animation<double> fadeAnimation;

  //* Observables for the animations
  final isSlideCompleted = false.obs;
  final isScaleCompleted = false.obs;
  final isZoomOutCompleted = false.obs;
  final isFadeCompleted = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    if (kDebugMode) {
      print("Splash Controller initialized");
    }
    
    //* Slide controller
    slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    //* Scale controller
    scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    //* Zoom out controller (quick)
    zoomOutController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    //* Fade controller
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    //* Slide animation
    slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeOutCubic,
    ));

    //* Scale animation (zoom in)
    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut,
    ));

    //* Zoom out animation (logo shrinks to 0)
    zoomOutAnimation = Tween<double>(
      begin: 1.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: zoomOutController,
      curve: Curves.easeIn,
    ));

    //* Fade animation
    fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeOut,
    ));
    
    //* Add listeners to update rxn values
    slideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isSlideCompleted.value = true;
      }
    });
    
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isScaleCompleted.value = true;
      }
    });
    
    zoomOutController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isZoomOutCompleted.value = true;
      }
    });
    
    fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isFadeCompleted.value = true;
      }
    });
    
    //* Start animation sequence after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playAnimationSequence();
    });
  }

  Future<void> playAnimationSequence() async {
    try {
      if (kDebugMode) {
        print("Starting animation sequence");
      }
      
      //* Short delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      //* Slide in
      await slideController.forward();
      
      //* Scale (zoom in)
      await scaleController.forward();
      
      //* Hold a bit
      await Future.delayed(const Duration(milliseconds: 600));
      
      //* Zoom out quickly
      await zoomOutController.forward();
      
      //* Fade out (optional, but keep for smoothness)
      await fadeController.forward();
      
      //* Navigate to appropriate screen
      navigateToNextScreen();
    } catch (e) {
      if (kDebugMode) {
        print("Error in animation sequence: $e");
      }
      //* Fallback navigation in case of error
      Get.offAll(() => const OnBoardingScreen());
    }
  }
  
  void navigateToNextScreen() {
    // Pour afficher l'onboarding à chaque démarrage, on ignore le statut isFirstTime
    if (kDebugMode) {
      print("Redirection vers l'onboarding à chaque démarrage");
    }

    // Toujours naviguer vers l'écran d'onboarding
    Get.offAll(() => const OnBoardingScreen(), transition: Transition.fade);
    Get.put(LoginController());
    Get.put(SignupController(), permanent: true);
  }

  //* Calculate current scale based on animation states
  double getCurrentScale() {
    if (zoomOutController.isAnimating || zoomOutController.isCompleted) {
      // Clamp to a minimum value to ensure the logo shrinks to nearly invisible
      return zoomOutAnimation.value.clamp(0.01, 1.2);
    } else {
      return scaleAnimation.value;
    }
  }
  
  //* Calculate current opacity based on animation states
  double getCurrentOpacity() {
    return fadeController.isAnimating
        ? fadeAnimation.value.clamp(0.0, 1.0)
        : 1.0;
  }

  @override
  void onClose() {
    slideController.dispose();
    scaleController.dispose();
    zoomOutController.dispose();
    fadeController.dispose();
    super.onClose();
  }
}