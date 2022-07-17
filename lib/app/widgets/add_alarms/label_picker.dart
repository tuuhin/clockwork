import 'package:flutter/material.dart';

class LabelPicker extends StatelessWidget {
  const LabelPicker({Key? key, required this.labelController})
      : super(key: key);
  final TextEditingController labelController;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Label',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.w600, wordSpacing: 1.2),
            ),
            const SizedBox(height: 15),
            TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.name,
              keyboardAppearance: Brightness.light,
              controller: labelController,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(fixedSize: Size(size.width, 50)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Add'))
          ],
        ),
      ),
    );
  }
}
