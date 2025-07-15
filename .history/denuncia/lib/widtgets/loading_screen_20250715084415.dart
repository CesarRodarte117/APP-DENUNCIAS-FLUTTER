import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final String message;
  final bool visible;

  const FullScreenLoader({
    Key? key,
    required this.message,
    required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
