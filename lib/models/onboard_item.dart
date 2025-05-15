class OnboardItem {
  final String image;
  final String title;
  final String desc;

  OnboardItem({
    required this.image,
    required this.title,
    required this.desc,
  });

  factory OnboardItem.fromJson(Map<String, dynamic> json) => OnboardItem(
        image: json['image'],
        title: json['title'],
        desc: json['desc'],
      );
}