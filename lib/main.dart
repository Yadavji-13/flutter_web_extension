import 'dart:html';

import 'package:flutter/material.dart' hide Tab;
import 'package:chromeapi/tabs.dart';
import 'dart:js' as js;

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Extension Bookmark',
      color: Color.fromRGBO(41, 42, 45, 1),
      /*theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(41, 42, 45, 1)),
        useMaterial3: true,
      ),*/
      home: MyHomePage(title: 'Extension Bookmark'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _txtTitle = TextEditingController();
  final TextEditingController _txtUrl = TextEditingController();
  final TextEditingController _txtKeyword = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Tab>(
        future: getActiveTab(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _txtTitle.text = snapshot.data!.title ?? "";
            _txtUrl.text = snapshot.data!.url ?? "";
            return Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              color: const Color.fromRGBO(41, 42, 45, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  titleWidget(),
                  const SizedBox(
                    height: 15,
                  ),
                  //keyword
                  keywordWidget(),
                  const SizedBox(
                    height: 15,
                  ),
                  //url
                  urlWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  //buttons
                  bottomActionButtons(context),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ///Bottom action buttons
  Row bottomActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white),
          ),
          child: TextButton(
            onPressed: () {
              debugPrint('1');
              //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              window.close();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white),
          ),
          child: TextButton(
            onPressed: () {
              js.context.callMethod('open', [
                'https://google.com?q=${_txtTitle.text}|${_txtUrl.text}|${_txtKeyword.text}'
              ]);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///Url widget for show current selected tab navigation url
  Row urlWidget() {
    return Row(
      children: [
        const SizedBox(
          width: 60,
          child: Text(
            'Url',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            controller: _txtUrl,
            readOnly: true,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(30, 32, 35, 1.0),
              hintText: 'Url',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  ///Keyword widget for enter user can input in text-field
  Row keywordWidget() {
    return Row(
      children: [
        const SizedBox(
          width: 60,
          child: Text(
            'Keyword',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            controller: _txtKeyword,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(30, 32, 35, 1.0),
              hintText: 'Keyword',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  ///Title widget for show current selected tab navigation title
  Row titleWidget() {
    return Row(
      children: [
        const SizedBox(
          width: 60,
          child: Text(
            'Title',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            controller: _txtTitle,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(30, 32, 35, 1.0),
              hintText: 'Title',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  ///Get current selected(active) tab
  Future<Tab> getActiveTab() async {
    QueryInfo queryInfo = QueryInfo(active: true, lastFocusedWindow: true);
    // Chrome library, not like JS namespaces
    // `chrome.tabs.query` just `query` in this case
    List<Tab> tabs = await query(queryInfo);
    return tabs.singleWhere((tab) => tab.url != null && tab.url!.isNotEmpty);
  }
}
