import 'package:flutter/material.dart';
import 'package:app_news/models/news_update_model.dart';
import 'package:app_news/pages/news_detail_page.dart';
import 'package:app_news/pages/widgets/build_nasional_news.dart';
import 'package:app_news/pages/widgets/build_tech_news.dart';
import 'package:app_news/pages/widgets/build_ekonomi_news.dart';
import 'package:app_news/providers/nasional_news_provider.dart';
import 'package:app_news/providers/news_update_provider.dart';
import 'package:app_news/providers/tech_news_provider.dart';
import 'package:app_news/providers/ekonomi_news_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController updateNewsScrollController = ScrollController();
  int updateNewsactiveIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsUpdateProvider>(context, listen: false).fetchNewsUpdate();
      Provider.of<TechNewsProvider>(context, listen: false).fetchTechNews();
      Provider.of<EkonomiNewsProvider>(context, listen: false)
          .fetchEkonomiNews();
      Provider.of<NasionalNewsProvider>(context, listen: false)
          .fetchNasionalNews();
    });

    updateNewsScrollController.addListener(() {
      setState(() {
        updateNewsactiveIndex = (updateNewsScrollController.offset /
                (MediaQuery.of(context).size.width / 1.6))
            .round();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            buildProfile(),
            Consumer<NewsUpdateProvider>(
              builder: (context, newsUpdate, child) {
                if (newsUpdate.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (newsUpdate.beritaList.isEmpty) {
                  return const Text('No Data');
                } else {
                  return buildNewsUpdate(newsUpdate.beritaList.first);
                }
              },
            ),
            const SizedBox(height: 25),
            buildCategoryTabs(),
          ],
        ),
      ),
    );
  }

  Widget buildProfile() {
    return Row(
      children: [
        SizedBox(
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade500,
                backgroundImage: const AssetImage(
                  'assets/profile.jpeg',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning !',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                  ),
                  Text(
                    'Imansyah',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                  )
                ],
              )
            ],
          ),
        ),

        // NOTE: BUTTON
        const Spacer(),
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: Color(0XFFF39E3A),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Stack(
              children: [
                Image.asset(
                  'assets/ic/noti.png',
                  width: 20,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(0XFF0866FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNewsUpdate(NewsUpdateModel berita) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terbaru',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: updateNewsScrollController,
          child: Row(
            children: (berita.posts?.take(5) ?? []).map((news) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NewsDetailPage(link: news.link ?? ''),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 206,
                  width: MediaQuery.of(context).size.width / 1.6,
                  margin: const EdgeInsets.only(right: 23),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(news.thumbnail ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(3),
                              image: DecorationImage(
                                image: NetworkImage(berita.image ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            (berita.title?.split(" | ").first ?? ''),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          news.title ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        buildDotsIndicator(
            berita.posts?.take(5).toList().length ?? 0, updateNewsactiveIndex),
      ],
    );
  }

  Widget buildDotsIndicator(int count, int activeIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        double size = (index == activeIndex) ? 12.0 : 8.0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: (index == activeIndex)
                ? const Color(0XFFF39E3A)
                : const Color(0XFFD9D9D9),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget buildCategoryTabs() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          height: 30,
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0XFFF39E3A),
            ),
            indicatorColor: Colors.amber,
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Tekno'),
              Tab(text: 'Ekonomi'),
              Tab(text: 'Nasional'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: TabBarView(
            controller: _tabController,
            children: [
              Consumer<TechNewsProvider>(
                builder: (context, techNews, child) {
                  if (techNews.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (techNews.techList.isEmpty) {
                    return const Text('No Data');
                  } else {
                    return BuildTechNews(berita: techNews.techList.first);
                  }
                },
              ),
              Consumer<EkonomiNewsProvider>(
                builder: (context, ekonomiNews, child) {
                  if (ekonomiNews.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (ekonomiNews.ekonomiList.isEmpty) {
                    return const Text('No Data');
                  } else {
                    return BuildEkonomiNews(
                        berita: ekonomiNews.ekonomiList.first);
                  }
                },
              ),
              Consumer<NasionalNewsProvider>(
                builder: (context, nasionalNews, child) {
                  if (nasionalNews.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (nasionalNews.nasionalList.isEmpty) {
                    return const Text('No Data');
                  } else {
                    return BuildNasionalNews(
                        berita: nasionalNews.nasionalList.first);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
