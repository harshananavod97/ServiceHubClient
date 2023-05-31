import 'package:flutter/material.dart';
import 'package:servicehub_client/Colors.dart';

class Styles {
  static var termsAndCondition =
      "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book."
              "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book." +
          "Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero's De Finibus Bonorum et Malorum for use in a type specimen book.";

  static AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      //leadingWidth: 30,
      titleSpacing: 0,
      backgroundColor: white,
      foregroundColor: Colors.black,
      leading: Padding(
        padding: const EdgeInsets.only(left: 22),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: InkWell(
        child: const Text('Back'),
        onTap: () => Navigator.of(context).pop(),
      ),
    );
  }

  static var defaultPadding =
      const EdgeInsets.symmetric(horizontal: 35, vertical: 0);
}
