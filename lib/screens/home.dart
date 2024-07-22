import 'package:calculatorapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String displayText = '0';
  String result = '';

  void onButtonClick(String value) {
    setState(() {
      if (value == '=') {
        result = evaluateExpression(displayText);
        displayText = result;
      } else if (value == 'AC') {
        displayText = '0';
        result = '';
      } else if (value == '⌫') {
        displayText = displayText.length > 1 ? displayText.substring(0, displayText.length - 1) : '0';
      } else if (value == '%') {
        // Handle percentage calculation
        displayText = evaluatePercentage(displayText);
      } else {
        if (displayText == '0' || displayText == '00') {
          displayText = value;
        } else {
          displayText += value;
        }
      }
    });
  }

  String evaluateExpression(String expression) {
    try {
      final exp = Expression.parse(expression);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(exp, {});
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  String evaluatePercentage(String expression) {
    try {
      final exp = Expression.parse(expression);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(exp, {}) / 100;
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdDark,
      appBar: AppBar(
        title: Text('Calculator', style: GoogleFonts.rubik(color: Colors.white)),
        backgroundColor: tdDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? buildPortraitLayout()
                : buildLandscapeLayout();
          },
        ),
      ),
    );
  }

  Widget buildPortraitLayout() {
    return Column(
      children: <Widget>[
        buildDisplay(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: tdLightBlack,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                buildButtonRow(['AC', '%', '⌫', '/'], isOperation: true),
                buildButtonRow(['7', '8', '9', '*']),
                buildButtonRow(['4', '5', '6', '-']),
                buildButtonRow(['1', '2', '3', '+']),
                buildButtonRow(['00', '0', '.', '=']),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLandscapeLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: buildDisplay(),
        ),
        VerticalDivider(color: Colors.grey[800], thickness: 1),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(child: buildButtonRow(['AC', '%', '⌫', '/'])),
              Expanded(child: buildButtonRow(['7', '8', '9', '*'])),
              Expanded(child: buildButtonRow(['4', '5', '6', '-'])),
              Expanded(child: buildButtonRow(['1', '2', '3', '+'])),
              Expanded(child: buildButtonRow(['00', '0', '.', '='])),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDisplay() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(24),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            displayText,
            style: GoogleFonts.rubik(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            result,
            style: GoogleFonts.rubik(
              fontSize: 24.0,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons, {bool isOperation = false}) {
    return Expanded(
      child: Row(
        children: buttons.map((button) => buildButton(button, isOperation: isOperation)).toList(),
      ),
    );
  }

  Widget buildButton(String value, {bool isOperation = false}) {
    Color buttonColor;
    Color textColor;

    if (['/', '*', '-', '+', '='].contains(value)) {
      buttonColor = tdRed;
      textColor = Colors.white;
    } else if (['AC', '%', '⌫'].contains(value)) {
      buttonColor = tdGreen;
      textColor = Colors.black;
    } else {
      buttonColor = isOperation ? tdBlack : tdDark;
      textColor = Colors.white;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () => onButtonClick(value),
          child: Text(
            value,
            style: GoogleFonts.rubik(
              fontSize: 24.0,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}






