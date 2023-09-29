(function() {
  var bcv_parser;

  bcv_parser = require("../../js/ja_bcv_parser.js").bcv_parser;

  describe("Parsing", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.options.osis_compaction_strategy = "b";
      return p.options.sequence_combination_strategy = "combine";
    });
    it("should round-trip OSIS references", function() {
      var bc, bcv, bcv_range, book, books, i, len, results;
      p.set_options({
        osis_compaction_strategy: "bc"
      });
      books = ["Gen", "Exod", "Lev", "Num", "Deut", "Josh", "Judg", "Ruth", "1Sam", "2Sam", "1Kgs", "2Kgs", "1Chr", "2Chr", "Ezra", "Neh", "Esth", "Job", "Ps", "Prov", "Eccl", "Song", "Isa", "Jer", "Lam", "Ezek", "Dan", "Hos", "Joel", "Amos", "Obad", "Jonah", "Mic", "Nah", "Hab", "Zeph", "Hag", "Zech", "Mal", "Matt", "Mark", "Luke", "John", "Acts", "Rom", "1Cor", "2Cor", "Gal", "Eph", "Phil", "Col", "1Thess", "2Thess", "1Tim", "2Tim", "Titus", "Phlm", "Heb", "Jas", "1Pet", "2Pet", "1John", "2John", "3John", "Jude", "Rev"];
      results = [];
      for (i = 0, len = books.length; i < len; i++) {
        book = books[i];
        bc = book + ".1";
        bcv = bc + ".1";
        bcv_range = bcv + "-" + bc + ".2";
        expect(p.parse(bc).osis()).toEqual(bc);
        expect(p.parse(bcv).osis()).toEqual(bcv);
        results.push(expect(p.parse(bcv_range).osis()).toEqual(bcv_range));
      }
      return results;
    });
    it("should round-trip OSIS Apocrypha references", function() {
      var bc, bcv, bcv_range, book, books, i, j, len, len1, results;
      p.set_options({
        osis_compaction_strategy: "bc",
        ps151_strategy: "b"
      });
      p.include_apocrypha(true);
      books = ["Tob", "Jdt", "GkEsth", "Wis", "Sir", "Bar", "PrAzar", "Sus", "Bel", "SgThree", "EpJer", "1Macc", "2Macc", "3Macc", "4Macc", "1Esd", "2Esd", "PrMan", "Ps151"];
      for (i = 0, len = books.length; i < len; i++) {
        book = books[i];
        bc = book + ".1";
        bcv = bc + ".1";
        bcv_range = bcv + "-" + bc + ".2";
        expect(p.parse(bc).osis()).toEqual(bc);
        expect(p.parse(bcv).osis()).toEqual(bcv);
        expect(p.parse(bcv_range).osis()).toEqual(bcv_range);
      }
      p.set_options({
        ps151_strategy: "bc"
      });
      expect(p.parse("Ps151.1").osis()).toEqual("Ps.151");
      expect(p.parse("Ps151.1.1").osis()).toEqual("Ps.151.1");
      expect(p.parse("Ps151.1-Ps151.2").osis()).toEqual("Ps.151.1-Ps.151.2");
      p.include_apocrypha(false);
      results = [];
      for (j = 0, len1 = books.length; j < len1; j++) {
        book = books[j];
        bc = book + ".1";
        results.push(expect(p.parse(bc).osis()).toEqual(""));
      }
      return results;
    });
    return it("should handle a preceding character", function() {
      expect(p.parse(" Gen 1").osis()).toEqual("Gen.1");
      expect(p.parse("Matt5John3").osis()).toEqual("Matt.5,John.3");
      expect(p.parse("1Ps 1").osis()).toEqual("");
      return expect(p.parse("11Sam 1").osis()).toEqual("");
    });
  });

  describe("Localized book Gen (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Gen (ja)", function() {
      
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("創世記 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("創世 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("創 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("創世記 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("創世 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("創 1:1").osis()).toEqual("Gen.1.1")
		;
      return true;
    });
  });

  describe("Localized book Exod (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Exod (ja)", function() {
      
		expect(p.parse("出エシフト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エシプト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジフト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジプト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エシフト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エシプト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジフト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジプト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("出エシフト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エシプト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジフト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジプト記 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エシフト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エシプト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジフト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出エジプト 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("出 1:1").osis()).toEqual("Exod.1.1")
		;
      return true;
    });
  });

  describe("Localized book Bel (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Bel (ja)", function() {
      
		expect(p.parse("ヘルと竜 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("ヘルと龍 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("ベルと竜 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("ベルと龍 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		;
      return true;
    });
  });

  describe("Localized book Lev (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Lev (ja)", function() {
      
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レヒ記 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レビ記 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レヒ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レビ 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レヒ記 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レビ記 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レヒ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("レビ 1:1").osis()).toEqual("Lev.1.1")
		;
      return true;
    });
  });

  describe("Localized book Num (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Num (ja)", function() {
      
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("民数記 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("民数 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("民 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("民数記 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("民数 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("民 1:1").osis()).toEqual("Num.1.1")
		;
      return true;
    });
  });

  describe("Localized book Sir (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Sir (ja)", function() {
      
		expect(p.parse("シラフの子イイススの知恵書 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("シラ書（集会の書） 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("ヘン・シラの智慧 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("ヘン・シラの知恵 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("ベン・シラの智慧 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("ベン・シラの知恵 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("集会の書 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("シラ書 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("シラ 1:1").osis()).toEqual("Sir.1.1")
		;
      return true;
    });
  });

  describe("Localized book Wis (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Wis (ja)", function() {
      
		expect(p.parse("ソロモンの知恵書 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("ソロモンの智慧 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("知恵の書 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("知恵 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("知 1:1").osis()).toEqual("Wis.1.1")
		;
      return true;
    });
  });

  describe("Localized book Lam (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Lam (ja)", function() {
      
		expect(p.parse("エレミヤの哀歌 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("哀歌 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("哀 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("エレミヤの哀歌 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("哀歌 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("哀 1:1").osis()).toEqual("Lam.1.1")
		;
      return true;
    });
  });

  describe("Localized book EpJer (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: EpJer (ja)", function() {
      
		expect(p.parse("イエレミヤの達書 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("エレミヤの手紙 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("エレミヤの書翰 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("エレミヤ・手 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		;
      return true;
    });
  });

  describe("Localized book Rev (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Rev (ja)", function() {
      
		expect(p.parse("ヨハネの默示録 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ヨハネの黙示録 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("黙示録 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヨハネの默示録 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ヨハネの黙示録 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("黙示録 1:1").osis()).toEqual("Rev.1.1")
		;
      return true;
    });
  });

  describe("Localized book PrMan (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: PrMan (ja)", function() {
      
		expect(p.parse("マナセのいのり 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("マナセの祈り 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("マナセの祈禱 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		;
      return true;
    });
  });

  describe("Localized book Deut (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Deut (ja)", function() {
      
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("申命記 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("申命 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("申 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("申命記 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("申命 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("申 1:1").osis()).toEqual("Deut.1.1")
		;
      return true;
    });
  });

  describe("Localized book Josh (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Josh (ja)", function() {
      
		expect(p.parse("ヨシュア記 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ヨシュア 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヨシュア記 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ヨシュア 1:1").osis()).toEqual("Josh.1.1")
		;
      return true;
    });
  });

  describe("Localized book Judg (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Judg (ja)", function() {
      
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("士師記 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("士師 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("士 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("士師記 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("士師 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("士 1:1").osis()).toEqual("Judg.1.1")
		;
      return true;
    });
  });

  describe("Localized book Ruth (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Ruth (ja)", function() {
      
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("ルツ記 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("ルツ 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("ルツ記 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("ルツ 1:1").osis()).toEqual("Ruth.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Esd (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Esd (ja)", function() {
      
		expect(p.parse("エストラ第一巻 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("エスドラ第一巻 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("エズトラ第一巻 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("エズドラ第一巻 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("エスラ第一書 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("エズラ第一書 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Esd (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Esd (ja)", function() {
      
		expect(p.parse("エストラ第二巻 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("エスドラ第二巻 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("エズトラ第二巻 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("エズドラ第二巻 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("エスラ第二書 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("エズラ第二書 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		;
      return true;
    });
  });

  describe("Localized book Isa (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Isa (ja)", function() {
      
		expect(p.parse("イサヤ書 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("イザヤ書 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("イサヤ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("イザヤ 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("イサヤ書 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("イザヤ書 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("イサヤ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("イザヤ 1:1").osis()).toEqual("Isa.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Sam (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Sam (ja)", function() {
      
		expect(p.parse("サムエル 2 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル後書 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル記Ⅱ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル記下 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("列王記第二巻 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Ⅱサムエル 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル下 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("サムエル 2 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル後書 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル記Ⅱ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル記下 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("列王記第二巻 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Ⅱサムエル 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("サムエル下 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Sam (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Sam (ja)", function() {
      
		expect(p.parse("サムエル 1 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル前書 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル記Ⅰ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル記上 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("列王記第一巻 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Ⅰサムエル 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル上 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("サムエル 1 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル前書 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル記Ⅰ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル記上 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("列王記第一巻 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Ⅰサムエル 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("サムエル上 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Kgs (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Kgs (ja)", function() {
      
		expect(p.parse("列王記第四巻 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王紀略下 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王 2 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王紀下 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王記Ⅱ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王記下 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Ⅱ列王 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列下 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("列王記第四巻 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王紀略下 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王 2 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王紀下 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王記Ⅱ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列王記下 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Ⅱ列王 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("列下 1:1").osis()).toEqual("2Kgs.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Kgs (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Kgs (ja)", function() {
      
		expect(p.parse("列王記第三巻 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王紀略上 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王 1 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王紀上 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王記Ⅰ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王記上 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Ⅰ列王 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列上 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("列王記第三巻 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王紀略上 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王 1 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王紀上 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王記Ⅰ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列王記上 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Ⅰ列王 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("列上 1:1").osis()).toEqual("1Kgs.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Chr (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Chr (ja)", function() {
      
		expect(p.parse("歴代志略下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代誌 2 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代史下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代志下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代誌Ⅱ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代誌下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Ⅱ歴代 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴下 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("歴代志略下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代誌 2 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代史下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代志下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代誌Ⅱ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴代誌下 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Ⅱ歴代 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("歴下 1:1").osis()).toEqual("2Chr.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Chr (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Chr (ja)", function() {
      
		expect(p.parse("歴代志略上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代誌 1 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代史上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代志上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代誌Ⅰ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代誌上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Ⅰ歴代 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴上 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("歴代志略上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代誌 1 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代史上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代志上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代誌Ⅰ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴代誌上 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Ⅰ歴代 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("歴上 1:1").osis()).toEqual("1Chr.1.1")
		;
      return true;
    });
  });

  describe("Localized book Ezra (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Ezra (ja)", function() {
      
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エスラ書 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エスラ記 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エズラ書 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エズラ記 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エスラ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エズラ 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エスラ書 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エスラ記 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エズラ書 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エズラ記 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エスラ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("エズラ 1:1").osis()).toEqual("Ezra.1.1")
		;
      return true;
    });
  });

  describe("Localized book Neh (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Neh (ja)", function() {
      
		expect(p.parse("ネヘミヤ 記 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("ネヘミヤ記 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("ネヘミヤ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ネヘミヤ 記 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("ネヘミヤ記 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("ネヘミヤ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		;
      return true;
    });
  });

  describe("Localized book GkEsth (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: GkEsth (ja)", function() {
      
		expect(p.parse("エステル書殘篇 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("エステル記補遺 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		;
      return true;
    });
  });

  describe("Localized book Esth (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Esth (ja)", function() {
      
		expect(p.parse("エステル 記 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("エステル書 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("エステル記 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("エステル 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("エステル 記 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("エステル書 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("エステル記 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("エステル 1:1").osis()).toEqual("Esth.1.1")
		;
      return true;
    });
  });

  describe("Localized book Job (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Job (ja)", function() {
      
		expect(p.parse("ヨフ 記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨブ 記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨフ記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨブ記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨフ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨブ 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヨフ 記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨブ 記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨフ記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨブ記 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨフ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ヨブ 1:1").osis()).toEqual("Job.1.1")
		;
      return true;
    });
  });

  describe("Localized book Ps (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Ps (ja)", function() {
      
		expect(p.parse("詩篇/聖詠 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("詩篇 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("詩編 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("詩 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("詩篇/聖詠 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("詩篇 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("詩編 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("詩 1:1").osis()).toEqual("Ps.1.1")
		;
      return true;
    });
  });

  describe("Localized book PrAzar (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: PrAzar (ja)", function() {
      
		expect(p.parse("アサルヤの祈り 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("アザルヤの祈り 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		;
      return true;
    });
  });

  describe("Localized book Prov (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Prov (ja)", function() {
      
		expect(p.parse("箴言 知恵の泉 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("格言の書 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("箴言 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("格 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("箴言 知恵の泉 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("格言の書 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("箴言 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("格 1:1").osis()).toEqual("Prov.1.1")
		;
      return true;
    });
  });

  describe("Localized book Eccl (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Eccl (ja)", function() {
      
		expect(p.parse("コヘレトのことは 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("コヘレトのことば 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("コヘレトの言葉 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("伝道者の書 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("コヘレト 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("伝道の書 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("伝道者の 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("傳道之書 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("コヘレトのことは 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("コヘレトのことば 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("コヘレトの言葉 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("伝道者の書 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("コヘレト 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("伝道の書 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("伝道者の 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("傳道之書 1:1").osis()).toEqual("Eccl.1.1")
		;
      return true;
    });
  });

  describe("Localized book SgThree (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: SgThree (ja)", function() {
      
		expect(p.parse("三人の若者の賛歌 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("三童兒の歌 1:1").osis()).toEqual("SgThree.1.1")
		;
      return true;
    });
  });

  describe("Localized book Song (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Song (ja)", function() {
      
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("諸歌の歌 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("雅歌 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("雅 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("諸歌の歌 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("雅歌 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("雅 1:1").osis()).toEqual("Song.1.1")
		;
      return true;
    });
  });

  describe("Localized book Jer (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Jer (ja)", function() {
      
		expect(p.parse("エレミヤ書 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ヱレミヤ記 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("エレミヤ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("エレミヤ書 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ヱレミヤ記 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("エレミヤ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		;
      return true;
    });
  });

  describe("Localized book Ezek (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Ezek (ja)", function() {
      
		expect(p.parse("エセキエル書 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("エゼキエル書 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("エセキエル 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("エゼキエル 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("エセキエル書 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("エゼキエル書 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("エセキエル 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("エゼキエル 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		;
      return true;
    });
  });

  describe("Localized book Dan (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Dan (ja)", function() {
      
		expect(p.parse("タニエル書 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ダニエル書 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("タニエル 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ダニエル 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("タニエル書 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ダニエル書 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("タニエル 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ダニエル 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		;
      return true;
    });
  });

  describe("Localized book Hos (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Hos (ja)", function() {
      
		expect(p.parse("ホセアしょ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ホセア書 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ホセア 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ホセアしょ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ホセア書 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ホセア 1:1").osis()).toEqual("Hos.1.1")
		;
      return true;
    });
  });

  describe("Localized book Joel (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Joel (ja)", function() {
      
		expect(p.parse("よえるしょ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ヨエル書 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ヨエル 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("よえるしょ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ヨエル書 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ヨエル 1:1").osis()).toEqual("Joel.1.1")
		;
      return true;
    });
  });

  describe("Localized book Amos (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Amos (ja)", function() {
      
		expect(p.parse("アモスしょ 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("アモス書 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("アモス 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("アモスしょ 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("アモス書 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("アモス 1:1").osis()).toEqual("Amos.1.1")
		;
      return true;
    });
  });

  describe("Localized book Obad (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Obad (ja)", function() {
      
		expect(p.parse("オハテヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハテア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハテヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハテヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバ 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("オハテヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデヤしょ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハテア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハテヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデア書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデヤ書 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハテヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハデヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバテヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバデヤ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オハ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("オバ 1:1").osis()).toEqual("Obad.1.1")
		;
      return true;
    });
  });

  describe("Localized book Jonah (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Jonah (ja)", function() {
      
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ヨナしょ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ヨナ書 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ヨナ 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ヨナしょ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ヨナ書 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ヨナ 1:1").osis()).toEqual("Jonah.1.1")
		;
      return true;
    });
  });

  describe("Localized book Mic (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Mic (ja)", function() {
      
		expect(p.parse("ミカしょ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ミカ書 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ミカ 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ミカしょ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ミカ書 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ミカ 1:1").osis()).toEqual("Mic.1.1")
		;
      return true;
    });
  });

  describe("Localized book Nah (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Nah (ja)", function() {
      
		expect(p.parse("ナホムしょ 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ナホム書 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ナホム 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ナホムしょ 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ナホム書 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ナホム 1:1").osis()).toEqual("Nah.1.1")
		;
      return true;
    });
  });

  describe("Localized book Hab (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Hab (ja)", function() {
      
		expect(p.parse("ハハククしょ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハバククしょ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハハクク書 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハバクク書 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハハクク 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハバクク 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ハハククしょ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハバククしょ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハハクク書 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハバクク書 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハハクク 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ハバクク 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		;
      return true;
    });
  });

  describe("Localized book Zeph (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Zeph (ja)", function() {
      
		expect(p.parse("セファニヤしょ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニヤしょ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファニア書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニア書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セハニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セパニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファニア 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼハニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼパニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニア 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セハニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セパニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼハニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼパニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファ 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("セファニヤしょ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニヤしょ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファニア書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニア書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セハニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セパニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファニア 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼハニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼパニヤ書 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファニア 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セハニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セパニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼハニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼパニヤ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("セファ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ゼファ 1:1").osis()).toEqual("Zeph.1.1")
		;
      return true;
    });
  });

  describe("Localized book Hag (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Hag (ja)", function() {
      
		expect(p.parse("ハカイしょ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハガイしょ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハカイ書 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハガイ書 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハカイ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハガイ 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ハカイしょ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハガイしょ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハカイ書 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハガイ書 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハカイ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ハガイ 1:1").osis()).toEqual("Hag.1.1")
		;
      return true;
    });
  });

  describe("Localized book Zech (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Zech (ja)", function() {
      
		expect(p.parse("セカリヤしょ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ゼカリヤしょ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("セカリヤ書 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ゼカリヤ書 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("セカリヤ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ゼカリヤ 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("セカリヤしょ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ゼカリヤしょ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("セカリヤ書 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ゼカリヤ書 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("セカリヤ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ゼカリヤ 1:1").osis()).toEqual("Zech.1.1")
		;
      return true;
    });
  });

  describe("Localized book Mal (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Mal (ja)", function() {
      
		expect(p.parse("マラキ書 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("マラキ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("マラ 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("マラキ書 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("マラキ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("マラ 1:1").osis()).toEqual("Mal.1.1")
		;
      return true;
    });
  });

  describe("Localized book Matt (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Matt (ja)", function() {
      
		expect(p.parse("マタイによる福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイの福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ傳福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ伝 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("マタイによる福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイの福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ傳福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ福音書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ伝 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ書 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("マタイ 1:1").osis()).toEqual("Matt.1.1")
		;
      return true;
    });
  });

  describe("Localized book Mark (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Mark (ja)", function() {
      
		expect(p.parse("マルコによる福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコの福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ傳福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ伝 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("マルコによる福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコの福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ傳福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ福音書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ伝 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ書 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("マルコ 1:1").osis()).toEqual("Mark.1.1")
		;
      return true;
    });
  });

  describe("Localized book Luke (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Luke (ja)", function() {
      
		expect(p.parse("ルカによる福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカの福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ傳福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ伝 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ルカによる福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカの福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ傳福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ福音書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ伝 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ書 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ルカ 1:1").osis()).toEqual("Luke.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1John (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1John (ja)", function() {
      
		expect(p.parse("ヨハネの第一の手紙 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ヨハネの第一の書 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ヨハネの手紙Ⅰ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ヨハネの手紙一 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ⅰ ヨハネ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("一ヨハネ 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヨハネの第一の手紙 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ヨハネの第一の書 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ヨハネの手紙Ⅰ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ヨハネの手紙一 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ⅰ ヨハネ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("一ヨハネ 1:1").osis()).toEqual("1John.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2John (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2John (ja)", function() {
      
		expect(p.parse("ヨハネの第二の手紙 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ヨハネの第二の書 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ヨハネの手紙Ⅱ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ヨハネの手紙二 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ⅱ ヨハネ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("二ヨハネ 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヨハネの第二の手紙 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ヨハネの第二の書 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ヨハネの手紙Ⅱ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ヨハネの手紙二 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ⅱ ヨハネ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("二ヨハネ 1:1").osis()).toEqual("2John.1.1")
		;
      return true;
    });
  });

  describe("Localized book 3John (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 3John (ja)", function() {
      
		expect(p.parse("ヨハネの第三の手紙 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ヨハネの第三の書 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ヨハネの手紙Ⅲ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ヨハネの手紙三 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ⅲ ヨハネ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("三ヨハネ 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヨハネの第三の手紙 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ヨハネの第三の書 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ヨハネの手紙Ⅲ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ヨハネの手紙三 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ⅲ ヨハネ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("三ヨハネ 1:1").osis()).toEqual("3John.1.1")
		;
      return true;
    });
  });

  describe("Localized book John (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: John (ja)", function() {
      
		expect(p.parse("ヨハネによる福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネの福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ傳福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ伝 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヨハネによる福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネの福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ傳福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ福音書 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ伝 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ヨハネ 1:1").osis()).toEqual("John.1.1")
		;
      return true;
    });
  });

  describe("Localized book Acts (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Acts (ja)", function() {
      
		expect(p.parse("使徒の働き 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒言行録 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒行伝 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒行傳 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒行録 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒書 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("使徒の働き 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒言行録 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒行伝 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒行傳 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒行録 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒書 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("使徒 1:1").osis()).toEqual("Acts.1.1")
		;
      return true;
    });
  });

  describe("Localized book Rom (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Rom (ja)", function() {
      
		expect(p.parse("ローマの信徒への手紙 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ人への手紙 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ロマ人への書 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ人へ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ書 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ローマの信徒への手紙 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ人への手紙 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ロマ人への書 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ人へ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ書 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ローマ 1:1").osis()).toEqual("Rom.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Cor (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Cor (ja)", function() {
      
		expect(p.parse("コリントの信徒への手紙二 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への第二の手紙 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への後の書 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への手紙Ⅱ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への手紙二 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Ⅱ コリント人へ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント 2 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント後書 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("コリントの信徒への手紙二 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への第二の手紙 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への後の書 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への手紙Ⅱ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント人への手紙二 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Ⅱ コリント人へ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント 2 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("コリント後書 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Cor (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Cor (ja)", function() {
      
		expect(p.parse("コリントの信徒への手紙一 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への第一の手紙 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への前の書 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への手紙Ⅰ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への手紙一 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Ⅰ コリント人へ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント 1 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント前書 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("コリントの信徒への手紙一 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への第一の手紙 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への前の書 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への手紙Ⅰ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント人への手紙一 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Ⅰ コリント人へ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント 1 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("コリント前書 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		;
      return true;
    });
  });

  describe("Localized book Gal (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Gal (ja)", function() {
      
		expect(p.parse("カラテヤの信徒への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤの信徒への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ人への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ人への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ人への書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ人への書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ人へ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ人へ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("カラテヤの信徒への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤの信徒への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ人への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ人への手紙 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ人への書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ人への書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ人へ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ人へ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ書 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("カラテヤ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ガラテヤ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		;
      return true;
    });
  });

  describe("Localized book Eph (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Eph (ja)", function() {
      
		expect(p.parse("エフェソの信徒への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エフェソ人への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ人への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ人への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ人への書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ人への書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エフェソ書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ人へ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ人へ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エフェソ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("エフェソの信徒への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エフェソ人への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ人への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ人への手紙 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ人への書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ人への書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エフェソ書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ人へ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ人へ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エフェソ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エヘソ書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("エペソ書 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		;
      return true;
    });
  });

  describe("Localized book Phil (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Phil (ja)", function() {
      
		expect(p.parse("フィリヒの信徒への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピの信徒への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリヒ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリヒ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリヒ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピ 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("フィリヒの信徒への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピの信徒への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリヒ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ人への手紙 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ人への書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ人へ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリヒ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリヒ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ヒリピ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリヒ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ピリピ書 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリヒ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("フィリピ 1:1").osis()).toEqual("Phil.1.1")
		;
      return true;
    });
  });

  describe("Localized book Col (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Col (ja)", function() {
      
		expect(p.parse("コロサイの信徒への手紙 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ人への手紙 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ人への書 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ人へ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ書 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("コロサイの信徒への手紙 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ人への手紙 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ人への書 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ人へ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ書 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("コロサイ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Thess (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Thess (ja)", function() {
      
		expect(p.parse("テサロニケの信徒への手紙二 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への第二の手紙 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への後の書 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への手紙Ⅱ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への手紙二 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Ⅱ テサロニケ人へ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ 2 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ後書 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("テサロニケの信徒への手紙二 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への第二の手紙 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への後の書 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への手紙Ⅱ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ人への手紙二 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Ⅱ テサロニケ人へ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ 2 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("テサロニケ後書 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Thess (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Thess (ja)", function() {
      
		expect(p.parse("テサロニケの信徒への手紙一 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への第一の手紙 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への前の書 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への手紙Ⅰ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への手紙一 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Ⅰ テサロニケ人へ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ 1 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ前書 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("テサロニケの信徒への手紙一 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への第一の手紙 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への前の書 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への手紙Ⅰ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ人への手紙一 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Ⅰ テサロニケ人へ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ 1 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("テサロニケ前書 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Tim (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Tim (ja)", function() {
      
		expect(p.parse("テモテヘの第二の手紙 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテへの後の書 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテへの手紙Ⅱ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテへの手紙二 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Ⅱ テモテへ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテ 2 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテ後書 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("二テモテ 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("テモテヘの第二の手紙 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテへの後の書 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテへの手紙Ⅱ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテへの手紙二 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Ⅱ テモテへ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテ 2 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("テモテ後書 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("二テモテ 1:1").osis()).toEqual("2Tim.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Tim (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Tim (ja)", function() {
      
		expect(p.parse("テモテヘの第一の手紙 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテへの前の書 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテへの手紙Ⅰ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテへの手紙一 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Ⅰ テモテへ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテ 1 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテ前書 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("一テモテ 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("テモテヘの第一の手紙 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテへの前の書 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテへの手紙Ⅰ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテへの手紙一 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Ⅰ テモテへ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテ 1 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("テモテ前書 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("一テモテ 1:1").osis()).toEqual("1Tim.1.1")
		;
      return true;
    });
  });

  describe("Localized book Titus (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Titus (ja)", function() {
      
		expect(p.parse("ティトに達する書 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへのてかみ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへのてがみ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへの手紙 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスヘの手紙 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへの書 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトス書 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトス 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ティトに達する書 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへのてかみ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへのてがみ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへの手紙 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスヘの手紙 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへの書 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトスへ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトス書 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("テトス 1:1").osis()).toEqual("Titus.1.1")
		;
      return true;
    });
  });

  describe("Localized book Phlm (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Phlm (ja)", function() {
      
		expect(p.parse("フィレモンへの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンへの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンヘの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンへの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンヘの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンへの書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンへの書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("フィレモン書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンへ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモン書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンへ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモン書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("フィレモン 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("フィレモンへの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンへの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンヘの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンへの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンヘの手紙 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンへの書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンへの書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("フィレモン書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモンへ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ヒレモン書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモンへ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ピレモン書 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("フィレモン 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		;
      return true;
    });
  });

  describe("Localized book Heb (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Heb (ja)", function() {
      
		expect(p.parse("ヘフライ人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブライ人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("へフル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("へブル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル人への書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル人への書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフライ書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル人へ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブライ書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル人へ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフライ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブライ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヘフライ人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブライ人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("へフル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("へブル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル人への手紙 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル人への書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル人への書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフライ書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル人へ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブライ書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル人へ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフライ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘフル書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブライ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ヘブル書 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		;
      return true;
    });
  });

  describe("Localized book Jas (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Jas (ja)", function() {
      
		expect(p.parse("ヤコフからの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブからの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフの書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブの書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフ書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブ書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブ 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヤコフからの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブからの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブの手紙 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフの書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブの書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフ書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブ書 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコフ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ヤコブ 1:1").osis()).toEqual("Jas.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Pet (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Pet (ja)", function() {
      
		expect(p.parse("ヘテロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘトロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペテロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペトロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘテロの後の書 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘテロの手紙Ⅱ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘトロの手紙二 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペテロの後の書 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペテロの手紙Ⅱ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペトロの手紙二 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Ⅱ ヘテロ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Ⅱ ペテロ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘトロ 2 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペトロ 2 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("二ヘトロ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("二ペトロ 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヘテロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘトロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペテロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペトロの第二の手紙 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘテロの後の書 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘテロの手紙Ⅱ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘトロの手紙二 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペテロの後の書 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペテロの手紙Ⅱ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペトロの手紙二 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Ⅱ ヘテロ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Ⅱ ペテロ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ヘトロ 2 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ペトロ 2 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("二ヘトロ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("二ペトロ 1:1").osis()).toEqual("2Pet.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Pet (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Pet (ja)", function() {
      
		expect(p.parse("ヘテロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘトロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペテロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペトロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘテロの前の書 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘテロの手紙Ⅰ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘトロの手紙一 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペテロの前の書 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペテロの手紙Ⅰ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペトロの手紙一 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Ⅰ ヘテロ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Ⅰ ペテロ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘトロ 1 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペトロ 1 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("一ヘトロ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("一ペトロ 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ヘテロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘトロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペテロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペトロの第一の手紙 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘテロの前の書 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘテロの手紙Ⅰ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘトロの手紙一 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペテロの前の書 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペテロの手紙Ⅰ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペトロの手紙一 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Ⅰ ヘテロ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Ⅰ ペテロ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ヘトロ 1 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ペトロ 1 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("一ヘトロ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("一ペトロ 1:1").osis()).toEqual("1Pet.1.1")
		;
      return true;
    });
  });

  describe("Localized book Jude (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Jude (ja)", function() {
      
		expect(p.parse("ユタからの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダからの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユタの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユタの書 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダの書 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユタ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダ 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ユタからの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダからの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユタの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダの手紙 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユタの書 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダの書 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユタ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ユダ 1:1").osis()).toEqual("Jude.1.1")
		;
      return true;
    });
  });

  describe("Localized book Tob (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Tob (ja)", function() {
      
		expect(p.parse("トヒト書 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("トヒト記 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("トビト書 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("トビト記 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("トヒト 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("トビト 1:1").osis()).toEqual("Tob.1.1")
		;
      return true;
    });
  });

  describe("Localized book Jdt (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Jdt (ja)", function() {
      
		expect(p.parse("ユティト記 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("ユディト記 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("ユティト 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("ユテト書 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("ユディト 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("ユデト書 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		;
      return true;
    });
  });

  describe("Localized book Bar (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Bar (ja)", function() {
      
		expect(p.parse("ワルフの預言書 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("ハルク書 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("バルク書 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("ハルク 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("バルク 1:1").osis()).toEqual("Bar.1.1")
		;
      return true;
    });
  });

  describe("Localized book Sus (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: Sus (ja)", function() {
      
		expect(p.parse("スサンナ物語 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("スザンナ物語 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("スサンナ 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("スザンナ 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		;
      return true;
    });
  });

  describe("Localized book 2Macc (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 2Macc (ja)", function() {
      
		expect(p.parse("マカヒー第二書 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカビー第二書 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカハイ 2 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカハイ記2 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカハイ記下 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカバイ 2 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカバイ記2 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカバイ記下 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカハイ下 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("マカバイ下 1:1").osis()).toEqual("2Macc.1.1")
		;
      return true;
    });
  });

  describe("Localized book 3Macc (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 3Macc (ja)", function() {
      
		expect(p.parse("マカヒー第三書 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("マカビー第三書 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("マカハイ 3 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("マカハイ記3 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("マカバイ 3 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("マカバイ記3 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		;
      return true;
    });
  });

  describe("Localized book 4Macc (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 4Macc (ja)", function() {
      
		expect(p.parse("マカヒー第四書 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("マカビー第四書 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("マカハイ 4 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("マカハイ記4 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("マカバイ 4 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("マカバイ記4 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		;
      return true;
    });
  });

  describe("Localized book 1Macc (ja)", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    return it("should handle book: 1Macc (ja)", function() {
      
		expect(p.parse("マカヒー第一書 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカビー第一書 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカハイ 1 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカハイ記1 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカハイ記上 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカバイ 1 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカバイ記1 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカバイ記上 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1Macc 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカハイ上 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("マカバイ上 1:1").osis()).toEqual("1Macc.1.1")
		;
      return true;
    });
  });

  describe("Miscellaneous tests", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        osis_compaction_strategy: "bc",
        captive_end_digits_strategy: "delete"
      });
      return p.include_apocrypha(true);
    });
    it("should return the expected language", function() {
      return expect(p.languages).toEqual(["ja"]);
    });
    it("should handle ranges (ja)", function() {
      expect(p.parse("Titus 1:1 ～ 2").osis()).toEqual("Titus.1.1-Titus.1.2");
      expect(p.parse("Matt 1～2").osis()).toEqual("Matt.1-Matt.2");
      expect(p.parse("Phlm 2 ～ 3").osis()).toEqual("Phlm.1.2-Phlm.1.3");
      expect(p.parse("Titus 1:1 ~ 2").osis()).toEqual("Titus.1.1-Titus.1.2");
      expect(p.parse("Matt 1~2").osis()).toEqual("Matt.1-Matt.2");
      return expect(p.parse("Phlm 2 ~ 3").osis()).toEqual("Phlm.1.2-Phlm.1.3");
    });
    it("should handle chapters (ja)", function() {
      expect(p.parse("Titus 1:1, 章 2").osis()).toEqual("Titus.1.1,Titus.2");
      return expect(p.parse("Matt 3:4 章 6").osis()).toEqual("Matt.3.4,Matt.6");
    });
    it("should handle verses (ja)", function() {
      expect(p.parse("Exod 1:1 節 3").osis()).toEqual("Exod.1.1,Exod.1.3");
      return expect(p.parse("Phlm 節 6").osis()).toEqual("Phlm.1.6");
    });
    it("should handle 'and' (ja)", function() {
      expect(p.parse("Exod 1:1 and 3").osis()).toEqual("Exod.1.1,Exod.1.3");
      return expect(p.parse("Phlm 2 AND 6").osis()).toEqual("Phlm.1.2,Phlm.1.6");
    });
    it("should handle titles (ja)", function() {
      expect(p.parse("Ps 3 title, 4:2, 5:title").osis()).toEqual("Ps.3.1,Ps.4.2,Ps.5.1");
      return expect(p.parse("PS 3 TITLE, 4:2, 5:TITLE").osis()).toEqual("Ps.3.1,Ps.4.2,Ps.5.1");
    });
    it("should handle 'ff' (ja)", function() {
      expect(p.parse("Rev 3ff, 4:2ff").osis()).toEqual("Rev.3-Rev.22,Rev.4.2-Rev.4.11");
      return expect(p.parse("REV 3 FF, 4:2 FF").osis()).toEqual("Rev.3-Rev.22,Rev.4.2-Rev.4.11");
    });
    it("should handle translations (ja)", function() {
      expect(p.parse("Lev 1 (JLB)").osis_and_translations()).toEqual([["Lev.1", "JLB"]]);
      return expect(p.parse("lev 1 jlb").osis_and_translations()).toEqual([["Lev.1", "JLB"]]);
    });
    return it("should handle boundaries (ja)", function() {
      p.set_options({
        book_alone_strategy: "full"
      });
      expect(p.parse("\u2014Matt\u2014").osis()).toEqual("Matt.1-Matt.28");
      return expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual("Matt.1.1");
    });
  });

}).call(this);
