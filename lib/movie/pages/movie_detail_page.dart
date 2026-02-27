import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_flutter/injector.dart';
import 'package:project_flutter/movie/providers/movie_get_detail_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_videos_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_cast_provider.dart';
import 'package:project_flutter/movie/widget/item_movie_widget.dart';
import 'package:project_flutter/movie/widget/webview_widget.dart';
import 'package:project_flutter/movie/widget/youtube_player_widget.dart';
import 'package:project_flutter/movie/providers/bookmark_provider.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              sl<MovieGetDetailProvider>()..getDetail(context, id: id),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              sl<MovieGetVideosProvider>()..getVideos(context, id: id),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetCastProvider>()..getCast(context, id: id),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<BookmarkProvider>()..checkBookmark(id),
        ),
      ],
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _WidgetMovieAppBar(id: id),

            // ========== TRAILER ==========
            Consumer<MovieGetVideosProvider>(
              builder: (_, provider, __) {
                final videos = provider.videos;

                if (videos == null || videos.results.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Trailer tidak tersedia"),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: _Content(
                    title: 'Trailer',
                    padding: 0,
                    body: SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: videos.results.length,
                        itemBuilder: (_, index) {
                          final video = videos.results[index];

                          final thumbnail =
                              "https://img.youtube.com/vi/${video.key}/hqdefault.jpg";

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => YoutubePlayerWidget(
                                    youtubeKey: video.key,
                                    videoId: video.key,
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    thumbnail,
                                    height: 180,
                                    width: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ========== CAST ==========
            Consumer<MovieGetCastProvider>(
              builder: (_, provider, __) {
                final casts = provider.casts;

                if (casts == null || casts.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Cast tidak tersedia"),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: _Content(
                    title: 'Cast',
                    body: SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: casts.length,
                        itemBuilder: (_, index) {
                          final cast = casts[index];

                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w200${cast.profilePath}",
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 80,
                                    width: 80,
                                    decoration: const BoxDecoration(
                                      color: Colors.black12,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person, size: 40),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  cast.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ========== SUMMARY ==========
            const _WidgetSummary(),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
///                    APP BAR WIDGET
///////////////////////////////////////////////////////////////
class _WidgetMovieAppBar extends StatelessWidget {
  final int id;
  const _WidgetMovieAppBar({required this.id});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      pinned: true,
      expandedHeight: 300,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF01B4E4),
                  Color(0xFF90CEA1),
                ],
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      actions: [
        Consumer2<MovieGetDetailProvider, BookmarkProvider>(
          builder: (_, detailProvider, bookmarkProvider, __) {
            final movie = detailProvider.movie;
            if (movie == null) return const SizedBox();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              bookmarkProvider.checkBookmark(movie.id);
            });

            final isSaved = bookmarkProvider.isSaved;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF01B4E4),
                        Color(0xFF90CEA1),
                      ],
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (isSaved) {
                        await bookmarkProvider.removeBookmark(movie.id);
                      } else {
                        await bookmarkProvider.addBookmark(
                          id: movie.id,
                          title: movie.title,
                          poster: movie.posterPath,
                          overview: movie.overview ?? "",
                        );
                      }

                      // **FIX REALTIME UPDATE**
                      await bookmarkProvider.checkBookmark(movie.id);
                    },
                  ),
                ),
              ),
            );
          },
        ),
        Consumer<MovieGetDetailProvider>(
          builder: (_, provider, __) {
            final movie = provider.movie;
            if (movie == null) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF01B4E4),
                        Color(0xFF90CEA1),
                      ],
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.public, color: Colors.white),
                    onPressed: () {
                      if (movie.homepage.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Website resmi film ini tidak tersedia"),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WebviewWidget(
                            title: movie.title,
                            url: movie.homepage,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
      flexibleSpace: Consumer<MovieGetDetailProvider>(
        builder: (_, provider, __) {
          final movie = provider.movie;

          if (movie == null) {
            return Container(color: Colors.black12);
          }

          return ItemMovieWidget(
            movieDetail: movie,
            heightBackdrop: double.infinity,
            widthBackdrop: double.infinity,
            heightPoster: 160,
            widthPoster: 100,
            radius: 0,
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////////
///                    CONTENT WRAPPER
///////////////////////////////////////////////////////////////

class _Content extends StatelessWidget {
  final String title;
  final Widget body;
  final double padding;

  const _Content({
    required this.title,
    required this.body,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: body,
        )
      ],
    );
  }
}

///////////////////////////////////////////////////////////////
///                    SUMMARY SECTION
///////////////////////////////////////////////////////////////

class _WidgetSummary extends StatelessWidget {
  const _WidgetSummary();

  String countryCodeToEmoji(String code) {
    return code.toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
        );
  }

  TableRow _row(String title, String content) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(content),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<MovieGetDetailProvider>(
        builder: (_, provider, __) {
          final movie = provider.movie;
          if (movie == null) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Content(
                title: 'Release Date',
                body: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, size: 32),
                    const SizedBox(width: 6),
                    Text(movie.releaseDate.toString().split(' ').first),
                  ],
                ),
              ),
              _Content(
                title: 'Genres',
                body: Wrap(
                  spacing: 6,
                  children: movie.genres
                      .map((g) => Chip(label: Text(g.name)))
                      .toList(),
                ),
              ),
              _Content(title: 'Overview', body: Text(movie.overview)),
              _Content(
                title: 'Summary',
                body: Table(
                  border: TableBorder.all(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: [
                    _row("Adult", movie.adult ? "Yes" : "No"),
                    _row("Popularity", movie.popularity.toString()),
                    _row("Status", movie.status),
                    _row(
                      "Country",
                      movie.productionCountries.isNotEmpty
                          ? movie.productionCountries
                              .map((c) =>
                                  "${countryCodeToEmoji(c.iso31661)} ${c.name}")
                              .join(", ")
                          : "Unknown",
                    ),
                    _row("Budget", movie.budget.toString()),
                    _row("Revenue", movie.revenue.toString()),
                    _row("Tagline", movie.tagline),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
