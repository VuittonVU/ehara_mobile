class ArticleModel {
  final String title;
  final String imagePath;
  final String date;
  final String content1;
  final String content2;
  final String content3;
  final String? tableImagePath1;
  final String? tableImagePath2;
  final String? sourceLabel;
  final String? sourceUrl;

  const ArticleModel({
    required this.title,
    required this.imagePath,
    required this.date,
    required this.content1,
    required this.content2,
    required this.content3,
    this.tableImagePath1,
    this.tableImagePath2,
    this.sourceLabel,
    this.sourceUrl,
  });
}