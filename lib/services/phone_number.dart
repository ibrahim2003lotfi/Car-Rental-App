import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller.text = ' ';
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && !_validatePhoneNumber(_controller.text)) {
      setState(() => _isValid = false);
    } else {
      setState(() => _isValid = true);
    }
  }

  bool _validatePhoneNumber(String value) {
    String number = value.replaceAll('+963 ', '').replaceAll(' ', '');
    return number.length == 9 && number.contains(RegExp(r'^[0-9]+$'));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(9), // +963 + 9 digits
            ],
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixText: '+963 ',
              prefixStyle: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
              errorText: _isValid ? null : 'Please enter 9 digits',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _isValid = _validatePhoneNumber(value);
              });
            },
          ),
          SizedBox(height: 20),
          if (!_isValid)
            Text(
              'Phone number must be 9 digits after +963',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}
