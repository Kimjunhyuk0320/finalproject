import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TeamStateReadScreen extends StatefulWidget {
  const TeamStateReadScreen({super.key});

  @override
  State<TeamStateReadScreen> createState() => _TeamStateReadScreenState();
}

class _TeamStateReadScreenState extends State<TeamStateReadScreen> {
  @override
  Widget build(BuildContext context) {
    final Map teamApp = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/teamListBanner.png'),
                        fit: BoxFit.cover,
                        alignment: FractionalOffset(0.5, 0.8),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(''),
                              Text(
                                '참가 신청서 조회',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 60.0,
                              ),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/');
                                  },
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teamApp['title'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                teamApp['bandName'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                teamApp['teamTitle'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.035,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 8,
                    child: Html(
                      data: teamApp['content'],
                      extensions: [
                        TagExtension(
                          tagsToExtend: {"img"},
                          builder: (context) {
                            final originalSrc = context.attributes['src'];

                            // Check if the original source starts with "/file"
                            if (originalSrc != null &&
                                originalSrc.startsWith("/file")) {
                              // If it starts with "/file", add the prefix
                              final newSrc = 'http://13.125.19.111$originalSrc';
                              return Image.network(newSrc);
                            } else if (originalSrc != null &&
                                originalSrc.startsWith("//")) {
                              final newSrc = 'http:$originalSrc';
                              return Image.network(newSrc);
                            } else {
                              // If it doesn't start with "/file", use the original source
                              return Image.network(originalSrc!);
                            }
                          },
                        ),
                      ],
                      style: {
                        "body": Style(
                            lineHeight: LineHeight(0),
                            whiteSpace: WhiteSpace.normal,
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                        "p": Style(
                            lineHeight: LineHeight(1.3),
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                        "h1": Style(
                          lineHeight: LineHeight(1.3),
                        ),
                        "h2": Style(
                          lineHeight: LineHeight(1.3),
                        ),
                        "h3": Style(
                          lineHeight: LineHeight(1.3),
                        ),
                        "div": Style(
                            lineHeight: LineHeight(1.3),
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                        "img": Style(
                            width:
                                Width(MediaQuery.of(context).size.width * 0.9),
                            display: Display.inlineBlock,
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
