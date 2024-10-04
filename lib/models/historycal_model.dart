import 'package:code_challenge/config/app_formats.dart';
import 'package:equatable/equatable.dart';

class HistorycalModel extends Equatable {
  const HistorycalModel({
    required this.s,
    required this.p,
    required this.q,
    required this.dc,
    required this.dd,
    required this.t,
  });

  final String s;
  final String p;
  final String q;
  final String dc;
  final String dd;
  final DateTime t;

  factory HistorycalModel.fromJson(Map<String, dynamic> json) {
    return HistorycalModel(
      s: json["s"] ?? "",
      p: json["p"] ?? "",
      q: json["q"] ?? "",
      dc: json["dc"] ?? "",
      dd: json["dd"] ?? "",
      t: AppFormats.msFormat(ms: json["t"] ?? 0).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "s": s,
        "p": p,
        "q": q,
        "dc": dc,
        "dd": dd,
        "t": t,
      };

  @override
  List<Object?> get props => [s, p, q, dc, dd, t];
}

/*
{
	"s": "ETH-USD",
	"p": "2386.36",
	"q": "1.73276849",
	"dc": "-2.6116",
	"dd": "-62.3219",
	"t": 1727935597932
}*/