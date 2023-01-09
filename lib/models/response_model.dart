class ResponseClass<T> {
  bool success = false;
  String message = "";
  T? data;
  Pagination? pagination;

  ResponseClass(
      {required this.success,
      required this.message,
      this.data,
      this.pagination});
}

class Pagination {
  Next? next;
  Previous? previous;
  First? first;
  Last? last;
  String paginationMessage;

  Pagination(
      {required this.next,
      required this.previous,
      required this.first,
      required this.last,
      required this.paginationMessage});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
        next: json['next'].isNotEmpty ? Next.fromJson(json["next"]) : null,
        previous: json['previous'].isNotEmpty
            ?  Previous.fromJson(json['previous'])
            : null,
        first: json['first'].isNotEmpty ? First.fromJson(json['first']) : null,
        last: json['last'].isNotEmpty ? Last.fromJson(json['last']) : null,
        paginationMessage: json['pagination_message']);
  }
}

class Next {
  int page;
  int limit;

  Next({required this.page, required this.limit});

  factory Next.fromJson(Map<String, dynamic> json) {
    return Next(page: json['page'], limit: json['limit']);
  }
}

class Previous {
  int page;
  int limit;

  Previous({required this.page, required this.limit});

  factory Previous.fromJson(Map<String, dynamic> json) {
    return Previous(page: json['page'], limit: json['limit']);
  }
}

class Last {
  int page;
  int limit;

  Last({required this.page, required this.limit});

  factory Last.fromJson(Map<String, dynamic> json) {
    return Last(page: json['page'], limit: json['limit']);
  }
}

class First {
  int page;
  int limit;

  First({required this.page, required this.limit});

  factory First.fromJson(Map<String, dynamic> json) {
    return First(page: json['page'], limit: json['limit']);
  }
}
