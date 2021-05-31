import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../config/color.dart';
import '../widget/appbar.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String initialUrl =
        "https://docs.google.com/viewerng/viewer?url=http://www.semvac.info/adminpanel/aboutus/aboutus.docx";
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: appBackground,
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   // final badgeData = Provider.of<BadgeCounter>(context);
  //   // final badgeCounts = badgeData.count;
  //   return Scaffold(
  //     backgroundColor: appBackground,
  //     appBar: appBar(context),
  //     body: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: SingleChildScrollView(
  //         child: Container(
  //           width: double.infinity,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Center(
  //                 child: Container(
  //                   height: 50,
  //                   child: Text(
  //                     "Hội Đồng SEMVAC",
  //                     style: TextStyle(
  //                       fontSize: 25.0,
  //                       color: titleColor,
  //                       fontWeight: FontWeight.normal,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: RichText(
  //                   textAlign: TextAlign.justify,
  //                   text: TextSpan(
  //                     style: new TextStyle(
  //                       fontSize: 20.0,
  //                       color: Colors.white,
  //                     ),
  //                     children: [
  //                       new TextSpan(
  //                         text: 'Hội Đồng SEMVAC có thể làm gì cho tôi? ',
  //                         style: new TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       new TextSpan(
  //                           text:
  //                               'Một dịch vụ miễn phí chính là SEMVAC Helps để cung cấp tin tức và hướng dẫn cho đủ mọi trường hợp cần, nhất là nếu thân chủ không rành tiếng Anh.'),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: RichText(
  //                   textAlign: TextAlign.justify,
  //                   text: TextSpan(
  //                     style: new TextStyle(
  //                       fontSize: 20.0,
  //                       color: Colors.white,
  //                     ),
  //                     children: [
  //                       new TextSpan(
  //                         text: 'Hội Đồng SEMAC là ai? ',
  //                         style: new TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       new TextSpan(
  //                           text:
  //                               "Hội Đồng SEMAC là tập hợp của nhiều hội đoàn người Việt ở Đông Nam Melbourne (South Eastern Melbourne Vietnamese Associations' Council)."),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 margin: const EdgeInsets.all(8.0),
  //                 // height: mq.width * 0.3,
  //                 decoration: BoxDecoration(
  //                   border: Border.all(
  //                       // color: cardBorderColor,
  //                       ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(8),
  //                   ),
  //                 ),
  //                 child: Container(
  //                   // margin: const EdgeInsets.all(8.0),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(8.0),
  //                     child: Image.asset(
  //                       'assets/images/semvac.jpg',
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: RichText(
  //                   textAlign: TextAlign.justify,
  //                   text: TextSpan(
  //                     style: new TextStyle(
  //                       fontSize: 20.0,
  //                       color: Colors.white,
  //                     ),
  //                     children: [
  //                       new TextSpan(
  //                         text:
  //                             'Hội Đồng SEMAC làm gì để phục vụ các hội đoàn thành viên? ',
  //                         style: new TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       new TextSpan(
  //                           text:
  //                               "Làm những việc như cung cấp nơi để hội họp, giúp hội viên của hội này biết đến hội kia, v.v. Và thường xuyên mời gọi các hội đoàn thành viên cùng tổ chức Trung Thu, Ngày Làm Sạch Nước Úc, .."),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: RichText(
  //                   textAlign: TextAlign.justify,
  //                   text: TextSpan(
  //                     style: new TextStyle(
  //                       fontSize: 20.0,
  //                       color: Colors.white,
  //                     ),
  //                     children: [
  //                       new TextSpan(
  //                         text:
  //                             'App SEMVAC này có chính sách về quyền riêng tư không? ',
  //                         style: new TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       new TextSpan(
  //                           text:
  //                               "App SEMVAC này hoàn toàn không thu thập thông tin cá nhân của người dùng. Người dùng không cần phải ghi danh mới được dùng app, không cần cung cấp tên, số điện thoại, v.v."),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: RichText(
  //                   textAlign: TextAlign.justify,
  //                   text: TextSpan(
  //                     style: new TextStyle(
  //                       fontSize: 20.0,
  //                       color: Colors.white,
  //                     ),
  //                     children: [
  //                       new TextSpan(
  //                         text:
  //                             "SEMVAC cám ơn chính quyền Victoria tài trợ làm app này. ",
  //                         style: new TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       new TextSpan(
  //                           text:
  //                               "Cho đến cuối năm 2021, app SEMVAC sẽ chuyên chở các tin tức và thông tin về Covid đến người dùng. Từ năm 2022, app SEMVAC còn có thêm nhiều tin tức và thông báo về các sinh hoạt khác của SEMVAC."),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 margin: const EdgeInsets.all(8.0),
  //                 // height: mq.width * 0.3,
  //                 decoration: BoxDecoration(
  //                   border: Border.all(
  //                       // color: cardBorderColor,
  //                       ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(8),
  //                   ),
  //                 ),
  //                 child: Container(
  //                   // margin: const EdgeInsets.all(8.0),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(8.0),
  //                     child: Image.asset(
  //                       'assets/images/semvac_location.png',
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Center(
  //                   child: Container(
  //                     child: Text(
  //                       "Copyright © 2021 SEMVAC development team",
  //                       textAlign: TextAlign.justify,
  //                       style: TextStyle(
  //                         fontSize: 15.0,
  //                         color: Colors.white70,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
