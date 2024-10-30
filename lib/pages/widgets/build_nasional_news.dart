import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_news/models/nasional_news_model.dart';
import 'package:app_news/pages/news_detail_page.dart';

class BuildNasionalNews extends StatelessWidget {
  final NasionalNewsModel berita;
  const BuildNasionalNews({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: (berita.posts ?? []).map((nasional) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewsDetailPage(link: nasional.link ?? ''),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(nasional.thumbnail ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nasional.title ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              (berita.title?.split(" - ").last ?? ''),
                              style: const TextStyle(
                                color: Color(0XFF969696),
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              radius: 3,
                              backgroundColor: Color(0XFF969696),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatDate(nasional.pubDate.toString()),
                              style: const TextStyle(
                                color: Color(0XFF969696),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('MMMM, dd', 'id_ID').format(dateTime);
  }
}
