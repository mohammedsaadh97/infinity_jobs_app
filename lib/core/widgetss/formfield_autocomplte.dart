import 'package:flutter/material.dart';
import 'package:infinityjobs_app/utilities/text_styles.dart';

class FormFieldAutoComplete extends StatefulWidget {
  final String headingText;
  final String hintText;
  final bool obscureText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLines;
  final Function(String) onchange;
  final AutocompleteOptionsBuilder autocompleteOptionsBuilder;
  final Function(String) onAutocompleteSelected;

  const FormFieldAutoComplete({
    Key? key,
    required this.headingText,
    required this.hintText,
    required this.obscureText,
    required this.suffixIcon,
    required this.prefixIcon,
    required this.textInputType,
    required this.textInputAction,
    required this.controller,
    required this.maxLines,
    required this.onchange,
    required this.autocompleteOptionsBuilder,
    required this.onAutocompleteSelected,
  }) : super(key: key);

  @override
  _FormFieldAutoCompleteState createState() => _FormFieldAutoCompleteState();
}

class _FormFieldAutoCompleteState extends State<FormFieldAutoComplete> {
  String _selectedOption = '';
  bool _showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 0,
            right: 0,
            bottom: 10,
          ),
          child: Text(
            widget.headingText,
            style: KTextStyle.textFieldHintStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.zero, // Set padding to zero
          margin: const EdgeInsets.only(left: 0, right: 0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    widget.onchange(value);
                    setState(() {
                      _selectedOption = value;
                      _showSuggestions = value.isNotEmpty;
                    });
                  },
                  maxLines: widget.maxLines,
                  controller: widget.controller,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.textInputType,
                  obscureText: widget.obscureText,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: widget.prefixIcon,
                    ),
                    suffixIcon: widget.suffixIcon,
                  ),
                ),
                if (_showSuggestions)
                  if (_showSuggestions)
                    Container(
                      padding: EdgeInsets.zero, // Set padding to zero
                      child: ListView.builder(
                        shrinkWrap: true,

                        itemCount: widget.autocompleteOptionsBuilder(
                          TextEditingValue(text: _selectedOption),
                        ).length,
                        itemBuilder: (context, index) {
                          final option = widget.autocompleteOptionsBuilder(
                            TextEditingValue(text: _selectedOption),
                          ).elementAt(index);
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 12), // Adjust the padding here
                            title: Text(option),
                            onTap: () {
                              setState(() {
                                widget.controller.text = option;
                                _selectedOption = option;
                                widget.onAutocompleteSelected(option);
                                _showSuggestions = false; // Hide suggestions after selection
                              });
                            },
                          );
                        },
                      ),
                    ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}

typedef AutocompleteOptionsBuilder = Iterable<String> Function(TextEditingValue textEditingValue);
