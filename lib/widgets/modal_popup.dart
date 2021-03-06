import 'package:flutter/material.dart';
import 'package:privacy_of_animal/resources/constants.dart';

class ModalProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.width,
      height: ScreenUtil.height*1.3,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false,color: Colors.grey), 
          ),
          Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}