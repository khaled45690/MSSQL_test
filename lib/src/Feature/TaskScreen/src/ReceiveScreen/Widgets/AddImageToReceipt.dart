import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sql_test/src/Utilities/Extentions.dart';

import '../../../../../MainWidgets/ImageViewer.dart';

class AddImageToReceipt extends StatelessWidget {
  final List<Uint8List> reciptImageList;
  final Function(int imageIndex) removeReciptPicture;
  const AddImageToReceipt(this.reciptImageList , this.removeReciptPicture,{super.key});

  @override
  Widget build(BuildContext context) {
    return reciptImageList.isNotEmpty ? SizedBox(
      width: context.width(),
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: reciptImageList.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                InkWell(
                  onTap: ()=> context.navigateTo(ImageViewer(reciptImageList[index])),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 5),
                    width: 300,
                    height: 400,
                    child: Image.memory(
                      reciptImageList[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.delete, size: 25),
                    onPressed: () => removeReciptPicture(index),
                    color: Colors.red,
                  ),
                )
              ],
            );
          }),
    ) : const SizedBox(height: 20,);
  }
}
