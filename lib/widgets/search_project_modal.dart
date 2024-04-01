import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchProjectModal extends StatefulWidget {
  const SearchProjectModal({Key? key}) : super(key: key);

  @override
  State<SearchProjectModal> createState() => _SearchProjectModalState();
}

class _SearchProjectModalState extends State<SearchProjectModal> {
  TextEditingController controller = TextEditingController();
  List<String> historyList = ['reactjs', 'flutter', 'education app'];

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: 400,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: controller.text.isNotEmpty
                        ? IntrinsicWidth(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.clear();
                                  },
                                  icon: Icon(Icons.close),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.clear();
                                  },
                                  icon: Icon(Icons.forward),
                                ),
                              ],
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (_) {},
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: historyList.length,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final String historyItem = historyList[index];
                        return ListTile(
                          title: Text(historyItem),
                          onTap: () {
                            controller.text = historyItem;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
