class Comment {
  int? commentNo;
  String? parentTable;
  int? parentNo;
  String? writer;
  String? username;
  String? content;
  String? regDate;
  String? updDate;
  int? profileNo;

  Comment({
    required this.commentNo,
    required this.parentTable,
    required this.parentNo,
    required this.writer,
    required this.username,
    required this.content,
    required this.regDate,
    required this.updDate,
    required this.profileNo,
  });
}
