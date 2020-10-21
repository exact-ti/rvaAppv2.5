import 'package:flutter/material.dart';
import 'package:rvaapp/src/Configuration/config.dart';
import 'package:rvaapp/src/shared/modals/notification.dart';

class CustomTextForm extends StatelessWidget {
  final FocusNode fx;
  final VoidCallback methodChange;
  final TextEditingController inputController;

  const CustomTextForm({
    Key key,
    @required this.fx,
    @required this.methodChange,
    @required this.inputController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextFormField(
        focusNode: fx,
        keyboardType: TextInputType.text,
        controller: inputController,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {
          if (value.length < properties['CARACTERES_MINIMOS']) {
            notification(context, "error", "EXACT",
                  "Complete al menos ${properties['CARACTERES_MINIMOS']} caracteres");
            FocusScope.of(context).requestFocus(fx);
          }
          if (value.length > properties['CARACTERES_MAXIMOS']) {
            notification(context, "error", "EXACT",
                  "El código sobrepasa los caracteres máximos");
            FocusScope.of(context).requestFocus(fx);
          }
          if (value.length >= properties['CARACTERES_MINIMOS'] &&
              value.length < properties['CARACTERES_MAXIMOS']) {
            FocusScope.of(context).unfocus();
            new TextEditingController().clear();
          }
        },
        onChanged: (text) {
          methodChange();
        },
        decoration: InputDecoration(
          contentPadding:
              new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          filled: true,
          fillColor: Color(0xFFEAEFF2),
          errorStyle: TextStyle(color: Colors.red, fontSize: 15.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xFFEAEFF2),
              width: 0.0,
            ),
          ),
        ),
      );
  }
}
