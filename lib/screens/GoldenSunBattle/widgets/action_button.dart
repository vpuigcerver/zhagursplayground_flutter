import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;
  final double maxSize;

  const ActionButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onPressed,
    this.maxSize = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxSize,
        maxHeight: maxSize,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellowAccent, width: 3),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(iconPath),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          
        ),
      ),
    );
  }
}
