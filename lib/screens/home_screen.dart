import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/cat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;

  @override
  void initState() {
    catController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    catAnimation = Tween(begin: -35.0, end: -80.0)
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));

    boxController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.7)
        .animate(CurvedAnimation(parent: boxController, curve: Curves.linear));
    boxController.forward();
    boxController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    super.initState();
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
      ),
      body: InkWell(
        onTap: onTap,
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildCatAnimation(),
              buildBoxAnimation(),
              buildLeftFlapAnimation(),
              buildRightFlapAnimation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          top: catAnimation.value,
          right: 0,
          left: 0,
          child: child ?? const SizedBox(),
        );
      },
      child: const Cat(),
    );
  }

  Widget buildBoxAnimation() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlapAnimation() {
    return Positioned(
      left: 3,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: boxAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
        child: Container(
        height: 20,
        width: 130,
        color: Colors.brown,
      ),
      ),
    );
  }

  Widget buildRightFlapAnimation() {
    return Positioned(
      right: 3,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: - boxAnimation.value,
            alignment: Alignment.topRight,
            child: child,
          );
        },
        child: Container(
        height: 20,
        width: 130,
        color: Colors.brown,
      ),
      ),
    );
  }
}
