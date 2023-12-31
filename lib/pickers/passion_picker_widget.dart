import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/pickers/passion_picker.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class PassionPickerWidget extends StatelessWidget {
  const PassionPickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
      return Row(
        children: [
          const Text(
            '結婚願望 ',
          ),
          Text(passionPicker[profileProvider.myProfile.passion] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            child: const Text('選択'),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                child: const Text('戻る'),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text('決定'),
                                onPressed: () {
                                  profileProvider.notifyListeners();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: CupertinoPicker(
                              itemExtent: 40,
                              children: [
                                for (String key in passionPicker.keys) ...{
                                  Text(passionPicker[key] ?? '熱意不明')
                                },
                              ],
                              onSelectedItemChanged: (int index) =>
                                  profileProvider.myProfile.passion =
                                      passionPicker.keys.elementAt(index),
                            ),
                          )
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      );
    });
  }
}
