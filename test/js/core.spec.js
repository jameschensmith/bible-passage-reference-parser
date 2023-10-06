(function() {
  var bcv_parser;

  bcv_parser = require("../../js/en_bcv_parser.js").bcv_parser;

  describe("Pre-parsing", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = {};
      return p = new bcv_parser;
    });
    it("should be defined", function() {
      return expect(p).toBeDefined();
    });
    it("should have book regexps", function() {
      expect(p.regexps.books[0].osis).toEqual(["Gen"]);
      return expect(p.regexps.escaped_passage).toBeDefined();
    });
    it("should reset itself", function() {
      p.s = "string";
      p.entities = [1];
      p.options.book_alone_strategy = "hi";
      p.reset();
      expect(p.s).toEqual("");
      expect(p.entities).toEqual([]);
      expect(p.passage.books).toEqual([]);
      expect(p.passage.indices).toEqual({});
      return expect(p.options.book_alone_strategy).toEqual("hi");
    });
    it("should reset itself when creating a new object", function() {
      p.s = "string";
      p.entities = [1];
      p.options.book_alone_strategy = "hi";
      p.options.nonexistent_option = "hi";
      p = new bcv_parser;
      expect(p.s).toEqual("");
      expect(p.entities).toEqual([]);
      expect(p.passage).toEqual(null);
      expect(p.options.book_alone_strategy).not.toEqual("hi");
      return expect(p.options.nonexistent_option).toBeUndefined();
    });
    it("should handle resetting options", function() {
      p.options.book_alone_strategy = "hi";
      p.options.nonexistent_option = "hi";
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "hi",
        nonexistent_option: "hi"
      });
      expect(p.options.book_alone_strategy).toEqual("hi");
      expect(p.options.nonexistent_option).toEqual("hi");
      p = new bcv_parser;
      expect(p.options.book_alone_strategy).not.toEqual("hi");
      return expect(p.options.nonexistent_option).toBeUndefined();
    });
    it("should allow setting whether to include the Apocrypha via `set_options`", function() {
      expect(p.options.include_apocrypha).toBeFalsy();
      p.set_options({
        include_apocrypha: "unknown"
      });
      expect(p.options.include_apocrypha).toBeFalsy();
      p.set_options({
        include_apocrypha: true
      });
      return expect(p.options.include_apocrypha).toBeTruthy();
    });
    it("should allow setting whether to include the Apocrypha via `include_apocrypha()`", function() {
      expect(p.options.include_apocrypha).toBeFalsy();
      p.include_apocrypha("unknown");
      expect(p.options.include_apocrypha).toBeFalsy();
      p.include_apocrypha(true);
      return expect(p.options.include_apocrypha).toBeTruthy();
    });
    it("shouldn't allow changing to an unknown versification system", function() {
      p.versification_system("unknown");
      return expect(p.options.versification_system).toEqual("default");
    });
    it("should allow changing to the `vulgate` versification system and back again", function() {
      p.set_options({
        versification_system: "vulgate"
      });
      expect(p.options.versification_system).toEqual("vulgate");
      expect(p.translations["default"].chapters.Ps[118]).toEqual(7);
      expect(p.parse("Ps 118:176").osis()).toEqual("Ps.118.176");
      expect(p.parse("Ps 119:176").osis()).toEqual("");
      expect(p.parse("Ps 151:1").osis()).toEqual("");
      p.set_options({
        versification_system: "default"
      });
      expect(p.options.versification_system).toEqual("default");
      expect(p.translations["default"].chapters.Ps[118]).toEqual(176);
      expect(p.parse("Ps 118:176").osis()).toEqual("");
      expect(p.parse("Ps 119:176").osis()).toEqual("Ps.119.176");
      return expect(p.parse("Ps 151:1").osis()).toEqual("");
    });
    it("should allow the `vulgate` versification system to work with the Apocrypha", function() {
      p.set_options({
        versification_system: "vulgate",
        include_apocrypha: true
      });
      expect(p.options.versification_system).toEqual("vulgate");
      expect(p.translations["default"].chapters.Ps[118]).toEqual(7);
      expect(p.parse("Ps 118:176").osis()).toEqual("Ps.118.176");
      expect(p.parse("Ps 119:176").osis()).toEqual("");
      expect(p.parse("Ps 151:1").osis()).toEqual("Ps.151.1");
      p.set_options({
        versification_system: "default"
      });
      expect(p.options.versification_system).toEqual("default");
      expect(p.translations["default"].chapters.Ps[118]).toEqual(176);
      expect(p.parse("Ps 118:176").osis()).toEqual("");
      expect(p.parse("Ps 119:176").osis()).toEqual("Ps.119.176");
      return expect(p.parse("Ps 151:1").osis()).toEqual("Ps.151.1");
    });
    it("should handle inline alternate versification systems", function() {
      expect(p.parse("Matt 15 ESV, Matt 15 NIV, Matt 15").osis_and_translations()).toEqual([["Matt.15", "ESV"], ["Matt.15", "NIV"], ["Matt.15", ""]]);
      expect(p.parse("Third John 15 ESV, Third John 15 NIV, Third John 15").osis_and_translations()).toEqual([["3John.1.15", "ESV"], ["3John.1.15", ""]]);
      expect(p.parse("Third John 15 ESV, NIV, KJV").osis_and_translations()).toEqual([["3John.1.15", "ESV,NIV,KJV"]]);
      expect(p.parse("Third John 15 NIV, KJV, ESV, ").osis_and_translations()).toEqual([["3John.1.15", "NIV,KJV,ESV"]]);
      return expect(p.parse("Third John 15 NIV, ESV, KJV").osis_and_translations()).toEqual([["3John.1.15", "NIV,ESV,KJV"]]);
    });
    it("should create (promote) start books based on the default translation when a translation doesn't explicitly define them", function() {
      expect(p.parse("Num 14-Deut 6 KJV").osis_and_translations()).toEqual([["Num.14-Deut.6", "KJV"]]);
      p.set_options({
        versification_system: "kjv"
      });
      return expect(p.parse("Joshua 14:2-Judges 6 CEB").osis_and_translations()).toEqual([["Josh.14.2-Judg.6.40", "CEB"]]);
    });
    it("should reset versification systems properly when switching among several systems", function() {
      expect(p.parse("Ps 118:176").osis()).toEqual("");
      expect(p.parse("Ps 119:176").osis()).toEqual("Ps.119.176");
      expect(p.parse("3 John 15").osis()).toEqual("3John.1.15");
      p.set_options({
        versification_system: "vulgate"
      });
      expect(p.parse("Ps 118:176").osis()).toEqual("Ps.118.176");
      expect(p.parse("Ps 119:176").osis()).toEqual("");
      expect(p.parse("3 John 15").osis()).toEqual("3John.1.15");
      p.set_options({
        versification_system: "kjv"
      });
      expect(p.parse("Ps 118:176").osis()).toEqual("");
      expect(p.parse("Ps 119:176").osis()).toEqual("Ps.119.176");
      return expect(p.parse("3 John 15").osis()).toEqual("");
    });
    it("should allow adding a new versification system", function() {
      p.translations.new_system = {
        order: {
          Ps: 1,
          Matt: 2
        },
        chapters: {
          Ps: [3, 4, 5],
          Matt: [6, 7, 8]
        }
      };
      p.set_options({
        versification_system: "new_system"
      });
      expect(p.options.versification_system).toEqual("new_system");
      expect(p.parse("Ps 1:3").osis()).toEqual("Ps.1.3");
      expect(p.parse("Ps 1:4").osis()).toEqual("");
      expect(p.parse("Ps 2ff").osis()).toEqual("Ps.2-Ps.3");
      expect(p.parse("Proverbs 2:3").osis()).toEqual("");
      expect(p.parse("Ps 3-Proverbs 2:3").osis()).toEqual("Ps.3");
      expect(p.parse("Ps 3\u2014Matt 2:7").osis()).toEqual("Ps.3-Matt.2");
      expect(p.parse("Ps 3-Matt 2:8").osis()).toEqual("Ps.3-Matt.2");
      return expect(p.parse("Ps 3-Matt 4").osis()).toEqual("Ps.3-Matt.3");
    });
    it("should handle two translations in a row", function() {
      expect(p.parse("Matt 1,4 ESV 2-3 NIV").osis_and_indices()).toEqual([
        {
          osis: "Matt.1,Matt.4",
          translations: ["ESV"],
          indices: [0, 12]
        }, {
          osis: "Matt.2-Matt.3",
          translations: ["NIV"],
          indices: [13, 20]
        }
      ]);
      expect(p.parse("3 Jn 15 ESV 15 NIV").osis_and_indices()).toEqual([
        {
          osis: "3John.1.15",
          translations: ["ESV"],
          indices: [0, 11]
        }
      ]);
      return expect(p.parse("3 Jn 15 NIV 15 ESV").osis_and_indices()).toEqual([
        {
          osis: "3John.1.15",
          translations: ["ESV"],
          indices: [12, 18]
        }
      ]);
    });
    it("should delete the previously added new versification system when creating a new object", function() {
      return expect(p.translations.new_system).toBeDefined();
    });
    it("should handle control characters", function() {
      var match_string, replaced_string, test_string;
      expect(p.replace_control_characters(" hi ").length).toEqual(4);
      test_string = " \x1ehi\x1e \r\n \x1f0\x1f\n\r\u00a0\x00\u001e\u2014\xa0\x1f\x1f";
      match_string = "  hi  \r\n  0 \n\r\u00a0\x00 \u2014\xa0  ";
      replaced_string = p.replace_control_characters(test_string);
      expect(replaced_string.length).toEqual(test_string.length);
      return expect(escape(replaced_string)).toEqual(escape(match_string));
    });
    it("should handle non-Latin digits when asked", function() {
      expect(p.parse("2 Peter \u0662:\u0663-\u0664").osis()).toEqual("");
      p.set_options({
        non_latin_digits_strategy: "replace"
      });
      return expect(p.parse("2 Peter \u0662:\u0663-\u0664").osis()).toEqual("2Pet.2.3-2Pet.2.4");
    });
    it("should match basic books", function() {
      var books, ref, s;
      ref = p.match_books("Jeremiah, Genesisjer (NIV)"), s = ref[0], books = ref[1];
      expect(books.length).toEqual(2);
      expect(books[0]).toEqual({
        value: "Jeremiah",
        parsed: ["Jer"],
        type: "book",
        start_index: 0
      });
      expect(books[1]).toEqual({
        value: "NIV",
        parsed: "niv",
        type: "translation",
        start_index: 22
      });
      return expect(s).toEqual("\x1f0\x1f, Genesisjer (\x1e1\x1e)");
    });
    it("should match passage sequences", function() {
      var j, len, post, ref, results, s, sequences;
      sequences = [["\x1f0\x1f", "R"], ["\x1f0\x1f 1:2, 3:4; see also 5:6-7 and compare cf. 8.9ff (\x1e1\x1e)", "R"], ["see \x1f0\x1f", "seeR"], ["see \"\x1f999\x1f\" ", "see R"], ["\x1f0\x1f and me.", "Rme."], ["my\x1f0\x1f and .", "my\x1f0\x1f and ."], [" \x1f0\x1f and . then \x1f1\x1f 2-3ff for\x1f1\x1f 3", "RthenRfor\x1f1\x1f 3"], ["1\x1f0\x1f2", "1\x1f0\x1f2"], ["\x1f0\x1f2\x1f1\x1f3", "R"], ["\x1f\x1f \x1fa\x1f 2", "\x1f\x1f \x1fa\x1f 2"]];
      results = [];
      for (j = 0, len = sequences.length; j < len; j++) {
        ref = sequences[j], s = ref[0], post = ref[1];
        s = s.replace(p.regexps.escaped_passage, function(match, $1, $2) {
          return "R";
        });
        results.push(expect(s).toEqual(post));
      }
      return results;
    });
    it("should handle consecutive checking", function() {
      p.reset();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 2
      }, "default")).toBeTruthy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 1,
        v: 2
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, "default")).toBeFalsy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 3
      }, "default")).toBeFalsy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 1,
        v: 31
      }, {
        b: "Gen",
        c: 2,
        v: 1
      }, "default")).toBeTruthy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 1,
        v: 30
      }, {
        b: "Gen",
        c: 1,
        v: 2
      }, "default")).toBeFalsy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 1,
        v: 31
      }, {
        b: "Gen",
        c: 1,
        v: 2
      }, "default")).toBeFalsy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 1,
        v: 31
      }, {
        b: "Gen",
        c: 2,
        v: 2
      }, "default")).toBeFalsy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 50,
        v: 26
      }, {
        b: "Exod",
        c: 1,
        v: 1
      }, "default")).toBeTruthy();
      expect(p.is_verse_consecutive({
        b: "Gen",
        c: 50,
        v: 25
      }, {
        b: "Exod",
        c: 1,
        v: 1
      }, "default")).toBeFalsy();
      return expect(p.is_verse_consecutive({
        b: "Gen",
        c: 50,
        v: 26
      }, {
        b: "Exod",
        c: 1,
        v: 2
      }, "default")).toBeFalsy();
    });
    it("should identify being followed by a book", function() {
      p.reset();
      expect(p.starts_with_book({
        type: "bc"
      })).toBeTruthy();
      expect(p.starts_with_book({
        type: "cv"
      })).toBeFalsy();
      expect(p.starts_with_book({
        type: "range",
        start: {
          type: "bcv"
        }
      })).toBeTruthy();
      return expect(p.starts_with_book({
        type: "range",
        start: {
          type: "integer"
        }
      })).toBeFalsy();
    });
    it("should turn on/off the Apocrypha", function() {
      p.reset();
      p.include_apocrypha(true);
      expect(p.translations["default"].chapters.Ps[150]).toEqual(7);
      expect(p.translations["default"].order.Tob).toEqual(67);
      expect(p.options.include_apocrypha).toBeTruthy();
      p.include_apocrypha(false);
      expect(p.translations["default"].chapters.Ps[150]).not.toBeDefined();
      return expect(p.options.include_apocrypha).toBeFalsy();
    });
    it("should handle case-sensitivity", function() {
      var test_string;
      p.reset();
      test_string = "heb 12, ex 3, i macc2";
      expect(p.parse(test_string).osis()).toEqual("Heb.12,Exod.3");
      p.set_options({
        case_sensitive: "unknown"
      });
      expect(p.parse(test_string).osis()).toEqual("Heb.12,Exod.3");
      p.set_options({
        case_sensitive: "books"
      });
      expect(p.parse(test_string).osis()).toEqual("");
      p.set_options({
        case_sensitive: "books"
      });
      expect(p.parse(test_string).osis()).toEqual("");
      p.set_options({
        include_apocrypha: true
      });
      expect(p.parse(test_string).osis()).toEqual("");
      p.set_options({
        case_sensitive: "none"
      });
      return expect(p.parse(test_string).osis()).toEqual("Heb.12,Exod.3,1Macc.2");
    });
    it("should replace ends correctly", function() {
      expect(p.replace_match_end("\x1f0\x1f 3b")).toEqual("\x1f0\x1f 3b");
      expect(p.replace_match_end("\x1f0\x1f 3b.")).toEqual("\x1f0\x1f 3b");
      expect(p.replace_match_end("\x1f0\x1f 3chapter")).toEqual("\x1f0\x1f 3");
      expect(p.replace_match_end("\x1f0\x1f 3ff. ")).toEqual("\x1f0\x1f 3ff.");
      expect(p.replace_match_end("\x1f0\x1f go")).toEqual("\x1f0\x1f");
      expect(p.replace_match_end("\x1f0\x1f 3.")).toEqual("\x1f0\x1f 3");
      expect(p.replace_match_end("(\x1e0\x1e)")).toEqual("(\x1e0\x1e)");
      return expect(p.replace_match_end("[\x1e0\x1e]")).toEqual("[\x1e0\x1e]");
    });
    it("should pluck null passages", function() {
      p.parse("Jonah 2");
      expect(p.passage.pluck("none", [])).toEqual(null);
      return expect(p.passage.pluck("none", [
        {
          type: "b"
        }
      ])).toEqual(null);
    });
    return it("should handle `pluck_last_recursively` with various input", function() {
      p.parse("Jonah 3");
      expect(p.passage.pluck_last_recursively("integer", [])).toEqual(null);
      expect(p.passage.pluck_last_recursively("integer", [null])).toEqual(null);
      expect(function() {
        return p.passage.pluck_last_recursively("integer", [
          {
            type: "b"
          }
        ]);
      }).toThrow();
      return expect(function() {
        return p.passage.pluck_last_recursively("integer", null);
      }).toThrow();
    });
  });

  describe("OSIS parsing strategies", function() {
    var p, translation;
    p = {};
    translation = {};
    beforeEach(function() {
      p = {};
      p = new bcv_parser;
      p.reset();
      translation = "default";
      return p.options.book_alone_strategy = "ignore";
    });
    it("should return OSIS for b-b with various parsing strategies", function() {
      p.options.osis_compaction_strategy = "b";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen-Rev");
      p.options.book_alone_strategy = "first_chapter";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen-Rev");
      p.options.book_alone_strategy = "full";
      p.options.osis_compaction_strategy = "bc";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1-Gen.50");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1-Rev.22");
      p.options.book_alone_strategy = "first_chapter";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1-Rev.22");
      p.options.book_alone_strategy = "full";
      p.options.osis_compaction_strategy = "bcv";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1.1-Gen.50.26");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1.1-Rev.22.21");
      p.options.book_alone_strategy = "first_chapter";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1.1-Gen.1.31");
      return expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1.1-Rev.22.21");
    });
    it("should return OSIS for bc-b with various parsing strategies", function() {
      p.options.osis_compaction_strategy = "b";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen-Rev");
      p.options.book_alone_strategy = "first_chapter";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen-Rev");
      p.options.book_alone_strategy = "full";
      p.options.osis_compaction_strategy = "bc";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1-Gen.50");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1-Rev.22");
      p.options.book_alone_strategy = "first_chapter";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1-Gen.50");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1-Rev.22");
      p.options.book_alone_strategy = "full";
      p.options.osis_compaction_strategy = "bcv";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1.1-Gen.50.26");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1.1-Rev.22.21");
      p.options.book_alone_strategy = "first_chapter";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1.1-Gen.50.26");
      return expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1.1-Rev.22.21");
    });
    it("should return OSIS for bcv-b with various parsing strategies", function() {
      p.options.osis_compaction_strategy = "b";
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen-Rev");
      p.options.osis_compaction_strategy = "bc";
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1-Gen.50");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1-Rev.22");
      p.options.osis_compaction_strategy = "bcv";
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen"
      }, translation)).toEqual("Gen.1.1-Gen.50.26");
      return expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Rev"
      }, translation)).toEqual("Gen.1.1-Rev.22.21");
    });
    it("should return OSIS for b-bc with various parsing strategies", function() {
      p.options.osis_compaction_strategy = "b";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 2
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 1
      }, translation)).toEqual("Gen.1-Rev.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 22
      }, translation)).toEqual("Gen-Rev");
      p.options.osis_compaction_strategy = "bc";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 2
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 1
      }, translation)).toEqual("Gen.1-Rev.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 22
      }, translation)).toEqual("Gen.1-Rev.22");
      p.options.osis_compaction_strategy = "bcv";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1
      }, translation)).toEqual("Gen.1.1-Gen.1.31");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 2
      }, translation)).toEqual("Gen.1.1-Gen.2.25");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.20");
      return expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 22
      }, translation)).toEqual("Gen.1.1-Rev.22.21");
    });
    it("should return OSIS for b-bcv with various parsing strategies", function() {
      p.options.osis_compaction_strategy = "b";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 2,
        v: 1
      }, translation)).toEqual("Gen.1.1-Gen.2.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
      p.options.osis_compaction_strategy = "bc";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
      p.options.osis_compaction_strategy = "bcv";
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1.1-Gen.1.31");
      expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1.1-Gen.2.25");
      return expect(p.to_osis({
        b: "Gen"
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
    });
    it("should return OSIS for bcs", function() {
      p.options.osis_compaction_strategy = "b";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 2,
        v: 1
      }, translation)).toEqual("Gen.1.1-Gen.2.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
      p.options.osis_compaction_strategy = "bc";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
      p.options.osis_compaction_strategy = "bcv";
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1.1-Gen.1.31");
      expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1.1-Gen.2.25");
      return expect(p.to_osis({
        b: "Gen",
        c: 1
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
    });
    return it("should return OSIS for bcvs", function() {
      p.options.osis_compaction_strategy = "b";
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 2,
        v: 1
      }, translation)).toEqual("Gen.1.1-Gen.2.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
      p.options.osis_compaction_strategy = "bc";
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1-Gen.2");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
      p.options.osis_compaction_strategy = "bcv";
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 1,
        v: 31
      }, translation)).toEqual("Gen.1.1-Gen.1.31");
      expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Gen",
        c: 2,
        v: 25
      }, translation)).toEqual("Gen.1.1-Gen.2.25");
      return expect(p.to_osis({
        b: "Gen",
        c: 1,
        v: 1
      }, {
        b: "Rev",
        c: 1,
        v: 1
      }, translation)).toEqual("Gen.1.1-Rev.1.1");
    });
  });

  describe("Basic passage parsing", function() {
    var p, psg, translation_obj;
    p = new bcv_parser;
    psg = {};
    translation_obj = {
      translation: "default",
      osis: "",
      alias: "default"
    };
    beforeEach(function() {
      p = {};
      p = new bcv_parser;
      p.reset();
      return psg = p.passage;
    });
    it("should handle start indices", function() {
      psg.books = [
        {
          start_index: 0,
          value: "Genesis"
        }, {
          start_index: 12,
          value: "N"
        }
      ];
      expect(psg.calculate_indices("\x1f0\x1f 2:3", 0)).toEqual([
        {
          start: 0,
          end: 1,
          index: 0
        }, {
          start: 2,
          end: 6,
          index: 4
        }
      ]);
      expect(psg.calculate_indices("\x1f0\x1f 2:3-\x1e1\x1e 5", 0)).toEqual([
        {
          start: 0,
          end: 1,
          index: 0
        }, {
          start: 2,
          end: 9,
          index: 4
        }, {
          start: 10,
          end: 12,
          index: 2
        }
      ]);
      psg.books = [
        {
          start_index: 3,
          value: "Genesis"
        }, {
          start_index: 15,
          value: "N"
        }
      ];
      expect(psg.calculate_indices("pre\x1f0\x1f 2:3", "0")).toEqual([
        {
          start: 0,
          end: 4,
          index: 0
        }, {
          start: 5,
          end: 9,
          index: 4
        }
      ]);
      expect(psg.calculate_indices("pre\x1f0\x1f 2:3-\x1e1\x1e 5", 0)).toEqual([
        {
          start: 0,
          end: 4,
          index: 0
        }, {
          start: 5,
          end: 12,
          index: 4
        }, {
          start: 13,
          end: 15,
          index: 2
        }
      ]);
      psg.books = [
        {
          start_index: 8,
          value: "Genesis"
        }, {
          start_index: 15,
          value: "Exodus"
        }
      ];
      return expect(psg.calculate_indices("\x1f0\x1f\x1f1\x1f 6", "08")).toEqual([
        {
          start: 0,
          end: 1,
          index: 8
        }, {
          start: 2,
          end: 4,
          index: 12
        }, {
          start: 5,
          end: 7,
          index: 15
        }
      ]);
    });
    it("should match absolute indices", function() {
      psg.indices = [
        {
          start: 1,
          end: 2,
          index: 1
        }, {
          start: 3,
          end: 4,
          index: 6
        }
      ];
      expect(psg.get_absolute_indices([1, 2])).toEqual([2, 4]);
      expect(psg.get_absolute_indices([2, 3])).toEqual([3, 10]);
      expect(psg.get_absolute_indices([0, 4])).toEqual([null, 11]);
      return expect(psg.get_absolute_indices([3, 5])).toEqual([9, null]);
    });
    it("should validate refs with starts only", function() {
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: 1
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref(null, {
        b: "gen",
        c: 1
      })).toEqual({
        valid: false,
        messages: {
          start_book_not_exist: true
        }
      });
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: 51
      })).toEqual({
        valid: false,
        messages: {
          start_chapter_not_exist: 50
        }
      });
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: 0
      })).toEqual({
        valid: false,
        messages: {
          start_chapter_is_zero: 1
        }
      });
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: 1,
        v: "31"
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: 1,
        v: 0
      })).toEqual({
        valid: false,
        messages: {
          start_verse_is_zero: 1
        }
      });
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: 1,
        v: 32
      })).toEqual({
        valid: false,
        messages: {
          start_verse_not_exist: 31
        }
      });
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: "none"
      })).toEqual({
        valid: false,
        messages: {
          start_chapter_not_numeric: true
        }
      });
      expect(psg.validate_ref(null, {
        b: "Gen",
        c: 1,
        v: "none"
      })).toEqual({
        valid: false,
        messages: {
          start_verse_not_numeric: true
        }
      });
      return expect(psg.validate_ref(null, {
        b: "Phlm",
        c: 2
      })).toEqual({
        valid: false,
        messages: {
          start_chapter_not_exist_in_single_chapter_book: 1
        }
      });
    });
    it("should validate refs with starts and ends", function() {
      expect(psg.validate_ref(null, {
        b: "Matt"
      }, {
        b: "Phlm"
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref(null, {
        b: "Matt"
      }, {
        b: "Matt"
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref(null, {
        b: "Matt"
      }, {
        b: "Mal"
      })).toEqual({
        valid: false,
        messages: {
          end_book_before_start: true
        }
      });
      expect(psg.validate_ref(null, {
        b: "Matt",
        c: "five"
      }, {
        b: "Phlm",
        c: "one"
      })).toEqual({
        valid: false,
        messages: {
          start_chapter_not_numeric: true,
          end_chapter_not_numeric: true
        }
      });
      expect(psg.validate_ref(null, {
        b: "Matt",
        c: 5,
        v: "six"
      }, {
        b: "Phlm",
        c: 2
      })).toEqual({
        valid: false,
        messages: {
          start_verse_not_numeric: true,
          end_chapter_not_exist_in_single_chapter_book: 1
        }
      });
      return expect(psg.validate_ref(null, {
        b: "Matt",
        c: 50,
        v: 12
      }, {
        b: "Matt",
        c: 2
      })).toEqual({
        valid: false,
        messages: {
          start_chapter_not_exist: 28,
          end_chapter_before_start: true
        }
      });
    });
    it("should validate start refs", function() {
      expect(psg.validate_start_ref("default", {
        b: "Matt"
      }, {})).toEqual([true, {}]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        c: 5
      }, {})).toEqual([true, {}]);
      expect(psg.validate_start_ref("default", {}, {})).toEqual([
        false, {
          start_book_not_defined: true
        }
      ]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        c: "five"
      }, {})).toEqual([
        false, {
          start_chapter_not_numeric: true
        }
      ]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        c: 5,
        v: 10
      }, {})).toEqual([true, {}]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        c: 5,
        v: "ten"
      }, {})).toEqual([
        false, {
          start_verse_not_numeric: true
        }
      ]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        c: "five",
        v: "ten"
      }, {})).toEqual([
        false, {
          start_chapter_not_numeric: true
        }
      ]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        v: 10
      }, {})).toEqual([true, {}]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        v: "ten"
      }, {})).toEqual([
        false, {
          start_verse_not_numeric: true
        }
      ]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        c: 5,
        v: 100
      }, {})).toEqual([
        false, {
          start_verse_not_exist: 48
        }
      ]);
      expect(psg.validate_start_ref("default", {
        b: "Matt",
        c: 100,
        v: 100
      }, {})).toEqual([
        false, {
          start_chapter_not_exist: 28
        }
      ]);
      return expect(psg.validate_start_ref("default", {
        b: "None",
        c: 2,
        v: 1
      }, {})).toEqual([
        false, {
          start_book_not_exist: true
        }
      ]);
    });
    it("should validate end refs", function() {
      expect(psg.validate_end_ref("default", {
        b: "Matt"
      }, {
        b: "Mark"
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Mark"
      }, {
        b: "Matt"
      }, true, {})).toEqual([
        false, {
          end_book_before_start: true
        }
      ]);
      expect(psg.validate_end_ref("default", {}, {}, {}, {}, {})).toEqual([
        false, {
          end_book_not_exist: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Mark",
        c: 4
      }, {
        b: "Matt",
        c: 5
      }, true, {})).toEqual([
        false, {
          end_book_before_start: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "None",
        c: 5
      }, {
        b: "Mark",
        c: 4
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_ref(null, {
        b: "None",
        c: 5
      }, {
        b: "Mark",
        c: 4
      })).toEqual({
        valid: false,
        messages: {
          start_book_not_exist: true
        }
      });
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5
      }, {
        b: "Matt",
        c: 6
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: 10
      }, {
        b: "Matt",
        c: 4,
        v: 10
      }, true, {})).toEqual([
        false, {
          end_chapter_before_start: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt"
      }, {
        b: "Matt",
        c: 4
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 1
      }, {
        b: "Matt",
        c: 0
      }, true, {})).toEqual([
        false, {
          end_chapter_is_zero: 1,
          end_chapter_before_start: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt"
      }, {
        b: "Matt",
        c: 0
      }, true, {})).toEqual([
        false, {
          end_chapter_is_zero: 1,
          end_chapter_before_start: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 2
      }, {
        b: "Matt",
        c: "four"
      }, true, {})).toEqual([
        false, {
          end_chapter_not_numeric: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5
      }, {
        b: "Matt",
        c: 5,
        v: 4
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: 4
      }, {
        b: "Matt",
        c: 5,
        v: 4
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: 4
      }, {
        b: "Matt",
        c: 5,
        v: 6
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: 4
      }, {
        b: "Matt",
        c: 5,
        v: 1000
      }, true, {})).toEqual([
        true, {
          end_verse_not_exist: 48
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: 4
      }, {
        b: "Matt",
        c: 5,
        v: 3
      }, true, {})).toEqual([
        false, {
          end_verse_before_start: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: 7
      }, {
        b: "Matt",
        c: 5,
        v: "eight"
      }, true, {})).toEqual([
        false, {
          end_verse_not_numeric: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: "seven"
      }, {
        b: "Matt",
        c: 5,
        v: "eight"
      }, true, {})).toEqual([
        false, {
          end_verse_not_numeric: true
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: 7
      }, {
        b: "Matt",
        c: 5,
        v: 100
      }, true, {})).toEqual([
        true, {
          end_verse_not_exist: 48
        }
      ]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: 5,
        v: "seven"
      }, {
        b: "Matt",
        c: 5,
        v: 8
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: "four",
        v: "seven"
      }, {
        b: "Matt",
        c: 5,
        v: 8
      }, true, {})).toEqual([true, {}]);
      expect(psg.validate_end_ref("default", {
        b: "Matt",
        c: null,
        v: 7
      }, {
        b: "Matt",
        c: null,
        v: 8
      }, true, {})).toEqual([true, {}]);
      return expect(psg.validate_end_ref("default", {
        b: "Matt"
      }, {
        b: "Exod",
        c: "one",
        v: "two"
      }, true, {})).toEqual([
        false, {
          end_book_before_start: true,
          end_chapter_not_numeric: true,
          end_verse_not_numeric: true
        }
      ]);
    });
    it("should handle translations", function() {
      expect(psg.validate_ref([
        {
          translation: "default",
          osis: "",
          alias: "default"
        }, {
          translation: "niv",
          alias: "default"
        }
      ], {
        b: "1Pet",
        c: 3
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref([
        {
          no_key: "none"
        }
      ], {
        b: "Obad",
        c: 1
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref(null, {
        b: "Obad",
        c: 1,
        "translations": null
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref("12", {
        b: "Obad",
        c: 1
      })).toEqual({
        valid: false,
        messages: {
          translation_invalid: ["1", "2"]
        }
      });
      expect(psg.validate_ref(12, {
        b: "Obad",
        c: 1
      })).toEqual({
        valid: true,
        messages: {}
      });
      expect(psg.validate_ref([12], {
        b: "Obad",
        c: 1
      })).toEqual({
        valid: false,
        messages: {
          translation_invalid: [12]
        }
      });
      expect(psg.validate_ref([], {
        b: "Obad",
        c: 1
      })).toEqual({
        valid: true,
        messages: {}
      });
      return expect(function() {
        return psg.validate_ref([null], {
          b: "Obad",
          c: 1
        });
      }).toThrow();
    });
    it("should handle bvs posing as bcs", function() {
      psg.books = [];
      psg.books[0] = {
        parsed: ["Phlm"]
      };
      expect(psg.bc({
        absolute_indices: [0, 6],
        value: [
          {
            type: "b",
            absolute_indices: [0, 3],
            value: 0
          }, {
            type: "c",
            absolute_indices: [5, 6],
            value: [
              {
                type: "integer",
                absolute_indices: [5, 6],
                value: 2
              }
            ]
          }
        ]
      }, [], {
        b: "Gen",
        c: 6,
        v: 6
      })).toEqual([
        [
          {
            absolute_indices: [0, 6],
            value: [
              {
                type: "b",
                absolute_indices: [0, 3],
                value: 0
              }, {
                type: "c",
                absolute_indices: [5, 6],
                value: [
                  {
                    type: "integer",
                    absolute_indices: [5, 6],
                    value: 2
                  }
                ]
              }
            ],
            start_context: {
              b: "Gen",
              c: 6,
              v: 6
            },
            passages: [
              {
                start: {
                  b: "Phlm",
                  c: 1,
                  v: 2
                },
                end: {
                  b: "Phlm",
                  c: 1,
                  v: 2
                },
                valid: {
                  valid: true,
                  messages: {
                    start_chapter_not_exist_in_single_chapter_book: 1
                  }
                }
              }
            ]
          }
        ], {
          b: "Phlm",
          c: 1,
          v: 2
        }
      ]);
      expect(psg.bc({
        absolute_indices: [0, 6],
        value: [
          {
            type: "b",
            absolute_indices: [0, 3],
            value: 0
          }, {
            type: "c",
            absolute_indices: [5, 6],
            value: [
              {
                type: "integer",
                absolute_indices: [5, 6],
                value: 7
              }
            ]
          }
        ]
      }, [], {
        b: "Gen",
        c: 6,
        v: 6
      })).toEqual([
        [
          {
            absolute_indices: [0, 6],
            value: [
              {
                type: "b",
                absolute_indices: [0, 3],
                value: 0
              }, {
                type: "c",
                absolute_indices: [5, 6],
                value: [
                  {
                    type: "integer",
                    absolute_indices: [5, 6],
                    value: 7
                  }
                ]
              }
            ],
            start_context: {
              b: "Gen",
              c: 6,
              v: 6
            },
            passages: [
              {
                start: {
                  b: "Phlm",
                  c: 1,
                  v: 7
                },
                end: {
                  b: "Phlm",
                  c: 1,
                  v: 7
                },
                valid: {
                  valid: true,
                  messages: {
                    start_chapter_not_exist_in_single_chapter_book: 1
                  }
                }
              }
            ]
          }
        ], {
          b: "Phlm",
          c: 1,
          v: 7
        }
      ]);
      psg.books[0] = {
        parsed: ["Phlm", "Phil"]
      };
      expect(psg.bc({
        absolute_indices: [0, 6],
        value: [
          {
            type: "b",
            value: 0
          }, {
            type: "c",
            value: [
              {
                type: "integer",
                value: 2
              }
            ]
          }
        ]
      }, [], {
        translations: [
          {
            translation: "niv",
            osis: "NIV",
            alias: "default"
          }, {
            translation: "kjv",
            osis: "KJV",
            alias: "default"
          }
        ]
      })).toEqual([
        [
          {
            absolute_indices: [0, 6],
            value: [
              {
                type: "b",
                value: 0
              }, {
                type: "c",
                value: [
                  {
                    type: "integer",
                    value: 2
                  }
                ]
              }
            ],
            start_context: {
              translations: [
                {
                  translation: "niv",
                  osis: "NIV",
                  alias: "default"
                }, {
                  translation: "kjv",
                  osis: "KJV",
                  alias: "default"
                }
              ]
            },
            passages: [
              {
                start: {
                  b: "Phlm",
                  c: 1,
                  v: 2
                },
                end: {
                  b: "Phlm",
                  c: 1,
                  v: 2
                },
                valid: {
                  valid: true,
                  messages: {
                    start_chapter_not_exist_in_single_chapter_book: 1
                  }
                },
                alternates: [
                  {
                    start: {
                      b: "Phil",
                      c: 2
                    },
                    end: {
                      b: "Phil",
                      c: 2
                    },
                    valid: {
                      valid: true,
                      messages: {}
                    }
                  }
                ],
                translations: [
                  {
                    translation: "niv",
                    osis: "NIV",
                    alias: "default"
                  }, {
                    translation: "kjv",
                    osis: "KJV",
                    alias: "default"
                  }
                ]
              }
            ]
          }
        ], {
          b: "Phlm",
          c: 1,
          v: 2,
          translations: [
            {
              translation: "niv",
              osis: "NIV",
              alias: "default"
            }, {
              translation: "kjv",
              osis: "KJV",
              alias: "default"
            }
          ]
        }
      ]);
      expect(psg.bc({
        absolute_indices: [0, 6],
        value: [
          {
            type: "b",
            value: 0
          }, {
            type: "c",
            value: [
              {
                type: "integer",
                value: 7
              }
            ]
          }
        ]
      }, [], {
        translations: [
          {
            translation: "niv",
            osis: "NIV",
            alias: "default"
          }, {
            translation: "kjv",
            osis: "KJV",
            alias: "default"
          }
        ]
      })).toEqual([
        [
          {
            absolute_indices: [0, 6],
            value: [
              {
                type: "b",
                value: 0
              }, {
                type: "c",
                value: [
                  {
                    type: "integer",
                    value: 7
                  }
                ]
              }
            ],
            start_context: {
              translations: [
                {
                  translation: "niv",
                  osis: "NIV",
                  alias: "default"
                }, {
                  translation: "kjv",
                  osis: "KJV",
                  alias: "default"
                }
              ]
            },
            passages: [
              {
                start: {
                  b: "Phlm",
                  c: 1,
                  v: 7
                },
                end: {
                  b: "Phlm",
                  c: 1,
                  v: 7
                },
                valid: {
                  valid: true,
                  messages: {
                    start_chapter_not_exist_in_single_chapter_book: 1
                  }
                },
                alternates: [
                  {
                    start: {
                      b: "Phil",
                      c: 7
                    },
                    end: {
                      b: "Phil",
                      c: 7
                    },
                    valid: {
                      valid: false,
                      messages: {
                        start_chapter_not_exist: 4
                      }
                    }
                  }
                ],
                translations: [
                  {
                    translation: "niv",
                    osis: "NIV",
                    alias: "default"
                  }, {
                    translation: "kjv",
                    osis: "KJV",
                    alias: "default"
                  }
                ]
              }
            ]
          }
        ], {
          b: "Phlm",
          c: 1,
          v: 7,
          translations: [
            {
              translation: "niv",
              osis: "NIV",
              alias: "default"
            }, {
              translation: "kjv",
              osis: "KJV",
              alias: "default"
            }
          ]
        }
      ]);
      psg.books[0] = {
        parsed: ["Phil", "Phlm"]
      };
      expect(psg.bc({
        absolute_indices: [0, 6],
        value: [
          {
            type: "b",
            absolute_indices: [0, 3],
            value: 0
          }, {
            type: "c",
            value: [
              {
                type: "integer",
                absolute_indices: [5, 6],
                value: 2
              }
            ]
          }
        ]
      }, [], {})).toEqual([
        [
          {
            absolute_indices: [0, 6],
            value: [
              {
                type: "b",
                absolute_indices: [0, 3],
                value: 0
              }, {
                type: "c",
                value: [
                  {
                    type: "integer",
                    absolute_indices: [5, 6],
                    value: 2
                  }
                ]
              }
            ],
            start_context: {},
            passages: [
              {
                start: {
                  b: "Phil",
                  c: 2
                },
                end: {
                  b: "Phil",
                  c: 2
                },
                valid: {
                  valid: true,
                  messages: {}
                },
                alternates: [
                  {
                    start: {
                      b: "Phlm",
                      c: 1,
                      v: 2
                    },
                    end: {
                      b: "Phlm",
                      c: 1,
                      v: 2
                    },
                    valid: {
                      valid: true,
                      messages: {
                        start_chapter_not_exist_in_single_chapter_book: 1
                      }
                    }
                  }
                ]
              }
            ]
          }
        ], {
          b: "Phil",
          c: 2
        }
      ]);
      return expect(psg.bc({
        absolute_indices: [0, 6],
        value: [
          {
            type: "b",
            absolute_indices: [0, 3],
            value: 0
          }, {
            type: "c",
            absolute_indices: [5, 6],
            value: [
              {
                type: "integer",
                absolute_indices: [5, 6],
                value: 7
              }
            ]
          }
        ]
      }, [], {
        b: "Gen",
        c: 6,
        v: 6
      })).toEqual([
        [
          {
            absolute_indices: [0, 6],
            value: [
              {
                type: "b",
                absolute_indices: [0, 3],
                value: 0
              }, {
                type: "c",
                absolute_indices: [5, 6],
                value: [
                  {
                    type: "integer",
                    absolute_indices: [5, 6],
                    value: 7
                  }
                ]
              }
            ],
            start_context: {
              b: "Gen",
              c: 6,
              v: 6
            },
            passages: [
              {
                start: {
                  b: "Phlm",
                  c: 1,
                  v: 7
                },
                end: {
                  b: "Phlm",
                  c: 1,
                  v: 7
                },
                valid: {
                  valid: true,
                  messages: {
                    start_chapter_not_exist_in_single_chapter_book: 1
                  }
                },
                alternates: [
                  {
                    start: {
                      b: "Phil",
                      c: 7
                    },
                    end: {
                      b: "Phil",
                      c: 7
                    },
                    valid: {
                      valid: false,
                      messages: {
                        start_chapter_not_exist: 4
                      }
                    }
                  }
                ]
              }
            ]
          }
        ], {
          b: "Phlm",
          c: 1,
          v: 7
        }
      ]);
    });
    it("should handle `bc_title`s", function() {
      psg.books = [{}];
      psg.books[0].parsed = ["Phil", "Phlm", "Ps"];
      return expect(psg.bc_title({
        type: "bc_title",
        indices: [0, 10],
        absolute_indices: [0, 12],
        value: [
          {
            type: "bc",
            absolute_indices: [0, 6],
            value: [
              {
                type: "b",
                absolute_indices: [0, 5],
                value: 0
              }, {
                type: "c",
                absolute_indices: [5, 6],
                value: [
                  {
                    type: "integer",
                    absolute_indices: [5, 6],
                    value: 7
                  }
                ]
              }
            ]
          }, {
            type: "title",
            value: ["title"],
            indices: [5, 9]
          }
        ]
      }, [], {})).toEqual([
        [
          {
            type: "bcv",
            indices: [0, 10],
            absolute_indices: [0, 12],
            value: [
              {
                type: "bc",
                absolute_indices: [0, 6],
                value: [
                  {
                    type: "b",
                    absolute_indices: [0, 5],
                    value: 0
                  }, {
                    type: "c",
                    absolute_indices: [5, 6],
                    value: [
                      {
                        type: "integer",
                        absolute_indices: [5, 6],
                        value: 7
                      }
                    ]
                  }
                ],
                start_context: {},
                passages: [
                  {
                    start: {
                      b: "Ps",
                      c: 7
                    },
                    end: {
                      b: "Ps",
                      c: 7
                    },
                    valid: {
                      valid: true,
                      messages: {}
                    }
                  }
                ]
              }, {
                type: "v",
                value: [
                  {
                    type: "integer",
                    value: 1,
                    indices: [5, 9]
                  }
                ],
                indices: [5, 9]
              }
            ],
            start_context: {},
            passages: [
              {
                start: {
                  b: "Ps",
                  c: 7,
                  v: 1
                },
                end: {
                  b: "Ps",
                  c: 7,
                  v: 1
                },
                valid: {
                  valid: true,
                  messages: {}
                }
              }
            ]
          }
        ], {
          b: "Ps",
          c: 7,
          v: 1
        }
      ]);
    });
    it("should adjust `RegExp.lastIndex` correctly", function() {
      expect(p.adjust_regexp_end([], 10, 10)).toEqual(0);
      expect(p.adjust_regexp_end([], 10, 9)).toEqual(1);
      expect(p.adjust_regexp_end([
        {}, {
          indices: [0, 5]
        }
      ], 10, 10)).toEqual(4);
      return expect(p.adjust_regexp_end([
        {}, {
          indices: [0, 9]
        }
      ], 10, 10)).toEqual(0);
    });
    return it("should handle `next_v` correctly", function() {
      var context, out, passage, ref, ref1;
      p.parse("Gen 1:2a");
      passage = {
        "type": "next_v",
        "value": [
          {
            "type": "bcv",
            "value": [
              {
                "type": "bc",
                "value": [
                  {
                    "type": "b",
                    "value": 0,
                    "indices": [0, 2]
                  }, {
                    "type": "c",
                    "value": [
                      {
                        "type": "integer",
                        "value": 1,
                        "indices": [4, 4]
                      }
                    ],
                    "indices": [4, 4]
                  }
                ],
                "indices": [0, 4]
              }, {
                "type": "v",
                "value": [
                  {
                    "type": "integer",
                    "value": 2,
                    "indices": [6, 6]
                  }
                ],
                "indices": [6, 6]
              }
            ],
            "indices": [0, 7]
          }
        ],
        "indices": [0, 7]
      };
      ref = p.passage.next_v(passage, [], {}), out = ref[0], context = ref[1];
      expect(context).toEqual({
        b: "Gen",
        c: 1,
        v: 3
      });
      expect(out[0].absolute_indices).toEqual([0, 8]);
      p.parse("Gen 6f");
      passage = {
        "type": "next_v",
        "value": [
          {
            "type": "bc",
            "value": [
              {
                "type": "b",
                "value": 0,
                "indices": [0, 2]
              }, {
                "type": "c",
                "value": [
                  {
                    "type": "integer",
                    "value": 6,
                    "indices": [4, 4]
                  }
                ],
                "indices": [4, 4]
              }
            ],
            "indices": [0, 4]
          }
        ],
        "indices": [0, 5]
      };
      ref1 = p.passage.next_v(passage, [], {}), out = ref1[0], context = ref1[1];
      expect(context).toEqual({
        b: "Gen",
        c: 7
      });
      return expect(out[0].absolute_indices).toEqual([0, 6]);
    });
  });

  describe("Parsing with context", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = {};
      p = new bcv_parser;
      p.options.osis_compaction_strategy = "b";
      return p.options.sequence_combination_strategy = "combine";
    });
    it("should handle book context", function() {
      expect(p.parse_with_context("2", "Gen").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: [""],
          indices: [0, 1]
        }
      ]);
      expect(p.parse_with_context("2:3", "Gen").osis_and_indices()).toEqual([
        {
          osis: "Gen.2.3",
          translations: [""],
          indices: [0, 3]
        }
      ]);
      expect(p.parse_with_context("2ff", "Gen").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Gen.50",
          translations: [""],
          indices: [0, 3]
        }
      ]);
      expect(p.parse_with_context("verse 2", "Gen").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.2",
          translations: [""],
          indices: [0, 7]
        }
      ]);
      expect(p.parse_with_context("ch. 2-10", "Gen").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Gen.10",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse_with_context("chapter 6", "Gen").osis_and_indices()).toEqual([
        {
          osis: "Gen.6",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      return expect(p.parse_with_context("and 6 KJV", "Gen").osis_and_indices()).toEqual([
        {
          osis: "Gen.6",
          translations: ["KJV"],
          indices: [4, 9]
        }
      ]);
    });
    it("should handle chapter context", function() {
      expect(p.parse_with_context("2", "Gen 1").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: [""],
          indices: [0, 1]
        }
      ]);
      expect(p.parse_with_context("2:3", "Gen 1").osis_and_indices()).toEqual([
        {
          osis: "Gen.2.3",
          translations: [""],
          indices: [0, 3]
        }
      ]);
      expect(p.parse_with_context("2ff", "Gen 1").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Gen.50",
          translations: [""],
          indices: [0, 3]
        }
      ]);
      expect(p.parse_with_context("verse 16", "John 3").osis_and_indices()).toEqual([
        {
          osis: "John.3.16",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse_with_context("ch. 2-10", "Gen 8").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Gen.10",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse_with_context("chapter 6", "Gen 1").osis_and_indices()).toEqual([
        {
          osis: "Gen.6",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse_with_context("and 6 KJV", "Gen 5").osis_and_indices()).toEqual([
        {
          osis: "Gen.6",
          translations: ["KJV"],
          indices: [4, 9]
        }
      ]);
      return expect(p.parse_with_context("verse 2", "Genesis 3").osis()).toEqual("Gen.3.2");
    });
    it("should handle verse context", function() {
      expect(p.parse_with_context("2", "Gen 1:5").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.2",
          translations: [""],
          indices: [0, 1]
        }
      ]);
      expect(p.parse_with_context("2:3", "Gen 1:6").osis_and_indices()).toEqual([
        {
          osis: "Gen.2.3",
          translations: [""],
          indices: [0, 3]
        }
      ]);
      expect(p.parse_with_context("2ff", "Gen 1:8").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.2-Gen.1.31",
          translations: [""],
          indices: [0, 3]
        }
      ]);
      expect(p.parse_with_context("verse 16", "John 3:2").osis_and_indices()).toEqual([
        {
          osis: "John.3.16",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse_with_context("ch. 2-10", "Gen 1:5").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Gen.10",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse_with_context("chapter 6", "Gen 1:7").osis_and_indices()).toEqual([
        {
          osis: "Gen.6",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      return expect(p.parse_with_context("and 6 KJV", "Gen 17:5").osis_and_indices()).toEqual([
        {
          osis: "Gen.17.6",
          translations: ["KJV"],
          indices: [4, 9]
        }
      ]);
    });
    it("should handle sequences", function() {
      expect(p.parse_with_context("19-80,4,5,20:6-10", "Gen 17:5").osis_and_indices()).toEqual([
        {
          osis: "Gen.17.19-Gen.17.27,Gen.17.4-Gen.17.5,Gen.20.6-Gen.20.10",
          translations: [""],
          indices: [0, 17]
        }
      ]);
      return expect(p.parse_with_context("19:2-80,4,5,20:6-10", "Gen 17:5").osis_and_indices()).toEqual([
        {
          osis: "Gen.19.2-Gen.19.38,Gen.19.4-Gen.19.5,Gen.20.6-Gen.20.10",
          translations: [""],
          indices: [0, 19]
        }
      ]);
    });
    it("should handle translations", function() {
      expect(p.parse_with_context("15", "3 John 14 NIV").osis_and_indices()).toEqual([
        {
          osis: "3John.1.15",
          translations: [""],
          indices: [0, 2]
        }
      ]);
      return expect(p.parse_with_context("15 NIV", "3 John 14 NIV").osis_and_indices()).toEqual([]);
    });
    it("should handle unusual cases", function() {
      expect(p.parse_with_context("-16", "Gen 14").osis_and_indices()).toEqual([
        {
          osis: "Gen.16",
          translations: [""],
          indices: [1, 3]
        }
      ]);
      return expect(p.parse_with_context("Exodus 22", "Gen 14").osis_and_indices()).toEqual([
        {
          osis: "Exod.22",
          translations: [""],
          indices: [0, 9]
        }
      ]);
    });
    it("should handle lack of context", function() {
      expect(p.parse_with_context("16", "none").osis_and_indices()).toEqual([]);
      expect(function() {
        return p.parse_with_context("16", null).osis_and_indices();
      }).toThrow();
      return expect(p.parse_with_context("chapter 22", "see").osis_and_indices()).toEqual([]);
    });
    return it("should not find matches in a few places", function() {
      expect(p.parse_with_context("ff", "Gen 17").osis_and_indices()).toEqual([]);
      expect(p.parse_with_context("a", "Gen 17:4").osis_and_indices()).toEqual([]);
      return expect(p.parse_with_context("and", "Gen 17:5").osis_and_indices()).toEqual([]);
    });
  });

  describe("Parsing", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.options.osis_compaction_strategy = "b";
      return p.options.sequence_combination_strategy = "combine";
    });
    it("should handle books", function() {
      p.options.book_alone_strategy = "full";
      expect(p.parse("Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen",
          indices: [0, 7],
          translations: [""]
        }
      ]);
      return expect(p.parse("1\u00a0Cor").osis_and_indices()).toEqual([
        {
          osis: "1Cor",
          indices: [0, 5],
          translations: [""]
        }
      ]);
    });
    it("should handle bcs", function() {
      expect(p.parse("Genesis ch 3 (NIV, ESV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.3",
          translations: ["NIV", "ESV"],
          indices: [0, 23]
        }
      ]);
      expect(p.parse("Genesis 1:2-ch 7").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.2-Gen.7.24",
          translations: [""],
          indices: [0, 16]
        }
      ]);
      expect(p.parse("and Gen 1 5, Jere 2-3 see my Genesis ch 6 (NIV, ESV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.5,Jer.2-Jer.3",
          translations: [""],
          indices: [4, 21]
        }, {
          osis: "Gen.6",
          translations: ["NIV", "ESV"],
          indices: [29, 52]
        }
      ]);
      expect(p.parse("Jer.5.ESV").osis_and_indices()).toEqual([
        {
          osis: "Jer.5",
          indices: [0, 9],
          translations: ["ESV"]
        }
      ]);
      expect(p.parse("Matt 1 ESV, Matt 2 NIV").osis_and_indices()).toEqual([
        {
          osis: "Matt.1",
          indices: [0, 10],
          translations: ["ESV"]
        }, {
          osis: "Matt.2",
          indices: [12, 22],
          translations: ["NIV"]
        }
      ]);
      return expect(p.parse("Matt 1 1st to see").osis_and_indices()).toEqual([
        {
          osis: "Matt.1",
          indices: [0, 6],
          translations: [""]
        }
      ]);
    });
    it("should handle bvs", function() {
      expect(p.parse("Genesis verse 2").osis()).toEqual("Gen.1.2");
      expect(p.parse("Philemon verse 3").osis()).toEqual("Phlm.1.3");
      expect(p.parse("Philemon 4").osis()).toEqual("Phlm.1.4");
      expect(p.parse("Philemon 5-6").osis()).toEqual("Phlm.1.5-Phlm.1.6");
      expect(p.parse("Genesis verse 7-8").osis()).toEqual("Gen.1.7-Gen.1.8");
      expect(p.parse("Philemon verse9- Philemon verse 10").osis()).toEqual("Phlm.1.9-Phlm.1.10");
      expect(p.parse("Philemon verse 11, Philemon verse 12").osis()).toEqual("Phlm.1.11-Phlm.1.12");
      return expect(p.parse("Genesis 13a").osis()).toEqual("Gen.13");
    });
    it("should handle ranges", function() {
      expect(p.parse("Genesis 1-2").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.2",
          translations: [""],
          indices: [0, 11]
        }
      ]);
      expect(p.parse("Genesis 1-2 ESV, NIV").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.2",
          translations: ["ESV", "NIV"],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Genesis 1-2 [ESV, NIV]").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.2",
          translations: ["ESV", "NIV"],
          indices: [0, 22]
        }
      ]);
      expect(p.parse("(Genesis 1-2 (ESV, NIV))").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.2",
          translations: ["ESV", "NIV"],
          indices: [1, 23]
        }
      ]);
      expect(p.parse("Genesis 1-Jeremiah 2").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Jer.2",
          translations: [""],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Genesis 1-Jeremiah 2:5").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.1-Jer.2.5",
          translations: [""],
          indices: [0, 22]
        }
      ]);
      expect(p.parse("Genesis 1-Jeremiah 2:100").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Jer.2",
          translations: [""],
          indices: [0, 24]
        }
      ]);
      expect(p.parse("Genesis 1-1:2").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.1-Gen.1.2",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      expect(p.parse("Genesis 1-2:1").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.1-Gen.2.1",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      expect(p.parse("Genesis 1-2:100").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.2",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Philemon 1").osis_and_indices()).toEqual([
        {
          osis: "Phlm",
          translations: [""],
          indices: [0, 10]
        }
      ]);
      expect(p.parse("Philemon 1-10").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1.1-Phlm.1.10",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      expect(p.parse("Philemon 2-10").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1.2-Phlm.1.10",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      expect(p.parse("Philemon 1-1:10").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1.1-Phlm.1.10",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Philemon 2-100").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1.2-Phlm.1.25",
          translations: [""],
          indices: [0, 14]
        }
      ]);
      expect(p.parse("Philemon 1-68").osis_and_indices()).toEqual([
        {
          osis: "Phlm",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      expect(p.parse("Genesis 2-Philemon 2").osis_and_indices()).toEqual([
        {
          osis: "Gen.2.1-Phlm.1.2",
          translations: [""],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Genesis 2-Philemon 1").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Phlm.1",
          translations: [""],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Genesis 1:2-Philemon 2").osis_and_indices()).toEqual([
        {
          osis: "Gen.1.2-Phlm.1.2",
          translations: [""],
          indices: [0, 22]
        }
      ]);
      expect(p.parse("Philemon 2-Hebrews 2").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1.2-Heb.2.18",
          translations: [""],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Philem 1-Hebrews 2").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1-Heb.2",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("jo 1-2").osis_and_indices()).toEqual([
        {
          osis: "John.1-John.2",
          translations: [""],
          indices: [0, 6]
        }
      ]);
      expect(p.parse("Jeremiah 2-Genesis 1").osis_and_indices()).toEqual([
        {
          osis: "Jer.2,Gen.1",
          translations: [""],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Genesis 51-Jeremiah 6").osis_and_indices()).toEqual([
        {
          osis: "Jer.6",
          translations: [""],
          indices: [11, 21]
        }
      ]);
      return expect(p.parse("Devotions: John 10:22-42  vs 27 \"My sheep hear my voice").osis_and_indices()).toEqual([
        {
          osis: "John.10.22-John.21.25",
          translations: [""],
          indices: [11, 31]
        }
      ]);
    });
    it("should match integers correctly", function() {
      expect(p.parse("Zechariah 2").osis()).toEqual("Zech.2");
      expect(p.parse("Zechariah 12").osis()).toEqual("Zech.12");
      expect(p.parse("Zechariah 12").osis()).toEqual("Zech.12");
      expect(p.parse("Zechariah 120").osis()).toEqual("");
      expect(p.parse("Zechariah 1000").osis()).toEqual("");
      expect(p.parse("Zechariah 1,000").osis()).toEqual("");
      expect(p.parse("Zechariah 12,000").osis()).toEqual("");
      return expect(p.parse("Zechariah 120,000").osis()).toEqual("");
    });
    it("should handle book ranges with an `ignore` `book_sequence_strategy` and an `ignore` `book_range_strategy`", function() {
      p.options.book_alone_strategy = "ignore";
      p.options.book_sequence_strategy = "ignore";
      p.options.book_range_strategy = "ignore";
      expect(p.parse("Gen-Jeremiah").osis()).toEqual("");
      expect(p.parse("Genesis 1-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen.1",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Genesis 2-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Jeremiah-Isaiah").osis()).toEqual("");
      expect(p.parse("Genesis-Philemon").osis()).toEqual("");
      expect(p.parse("Genesis-Philemon 1").osis_and_indices()).toEqual([
        {
          osis: "Phlm",
          translations: [""],
          indices: [8, 18]
        }
      ]);
      expect(p.parse("Genesis 1-Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen.1",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Genesis 2-Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Genesis 2-Philemon").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Genesis-Philemon 2").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1.2",
          translations: [""],
          indices: [8, 18]
        }
      ]);
      expect(p.parse("Luke-Acts").osis()).toEqual("");
      expect(p.parse("Gen-Exodus 2 (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Exod.2",
          translations: ["NIV"],
          indices: [4, 18]
        }
      ]);
      return expect(p.parse("Gen 2-Exodus (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: ["NIV"],
          indices: [0, 18]
        }
      ]);
    });
    it("should handle book ranges with an `ignore` `book_sequence_strategy` and an `include` `book_range_strategy`", function() {
      p.options.book_alone_strategy = "ignore";
      p.options.book_sequence_strategy = "ignore";
      p.options.book_range_strategy = "include";
      expect(p.parse("Gen-Jeremiah").osis()).toEqual("Gen-Jer");
      expect(p.parse("Genesis 1-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen-Jer",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Genesis 2-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Jer.52",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Jeremiah-Isaiah").osis()).toEqual("");
      expect(p.parse("Genesis-Philemon").osis_and_indices()).toEqual([
        {
          osis: "Gen-Phlm",
          translations: [""],
          indices: [0, 16]
        }
      ]);
      expect(p.parse("Genesis-Philemon 1").osis()).toEqual("Gen-Phlm");
      expect(p.parse("Genesis 1-Genesis").osis()).toEqual("Gen");
      expect(p.parse("Genesis 2-Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Gen.50",
          translations: [""],
          indices: [0, 17]
        }
      ]);
      expect(p.parse("Genesis 2-Philemon").osis()).toEqual("Gen.2-Phlm.1");
      expect(p.parse("Genesis-Philemon 2").osis()).toEqual("Gen.1.1-Phlm.1.2");
      expect(p.parse("Luke-Acts").osis()).toEqual("Luke-Acts");
      expect(p.parse("Gen-Exodus 2 (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Exod.2",
          translations: ["NIV"],
          indices: [0, 18]
        }
      ]);
      return expect(p.parse("Gen 2-Exodus (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Exod.40",
          translations: ["NIV"],
          indices: [0, 18]
        }
      ]);
    });
    it("should handle book ranges with an `include` `book_sequence_strategy` and an `ignore` `book_range_strategy`", function() {
      p.options.book_alone_strategy = "full";
      p.options.book_sequence_strategy = "include";
      p.options.book_range_strategy = "ignore";
      expect(p.parse("Gen-Jeremiah").osis()).toEqual("");
      expect(p.parse("Genesis 1-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen.1",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Genesis 2-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Jeremiah-Isaiah").osis()).toEqual("Jer,Isa");
      expect(p.parse("Genesis-Philemon").osis_and_indices()).toEqual([]);
      expect(p.parse("Genesis-Philemon 1").osis()).toEqual("Phlm");
      expect(p.parse("Genesis 1-Genesis").osis()).toEqual("Gen.1");
      expect(p.parse("Genesis 2-Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Genesis 2-Philemon").osis()).toEqual("Gen.2");
      expect(p.parse("Genesis-Philemon 2").osis()).toEqual("Phlm.1.2");
      expect(p.parse("Luke-Acts").osis()).toEqual("");
      expect(p.parse("Gen-Exodus 2 (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Exod.2",
          translations: ["NIV"],
          indices: [4, 18]
        }
      ]);
      return expect(p.parse("Gen 2-Exodus (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.2",
          translations: ["NIV"],
          indices: [0, 18]
        }
      ]);
    });
    it("should handle book ranges with an `include` `book_sequence_strategy` and an `include` `book_range_strategy`", function() {
      p.options.book_alone_strategy = "full";
      p.options.book_sequence_strategy = "include";
      p.options.book_range_strategy = "include";
      expect(p.parse("Gen-Jeremiah").osis()).toEqual("Gen-Jer");
      expect(p.parse("Genesis 1-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen-Jer",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Genesis 2-Jeremiah").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Jer.52",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Jeremiah-Isaiah").osis()).toEqual("Jer,Isa");
      expect(p.parse("Genesis-Philemon").osis_and_indices()).toEqual([
        {
          osis: "Gen-Phlm",
          translations: [""],
          indices: [0, 16]
        }
      ]);
      expect(p.parse("Genesis-Philemon 1").osis()).toEqual("Gen-Phlm");
      expect(p.parse("Genesis 1-Genesis").osis()).toEqual("Gen");
      expect(p.parse("Genesis 2-Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Gen.50",
          translations: [""],
          indices: [0, 17]
        }
      ]);
      expect(p.parse("Genesis 2-Philemon").osis()).toEqual("Gen.2-Phlm.1");
      expect(p.parse("Genesis-Philemon 2").osis()).toEqual("Gen.1.1-Phlm.1.2");
      expect(p.parse("Luke-Acts").osis()).toEqual("Luke-Acts");
      expect(p.parse("Gen-Exodus 2 (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Exod.2",
          translations: ["NIV"],
          indices: [0, 18]
        }
      ]);
      return expect(p.parse("Gen 2-Exodus (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Gen.2-Exod.40",
          translations: ["NIV"],
          indices: [0, 18]
        }
      ]);
    });
    it("should handle sequences", function() {
      expect(p.parse("Genesis 1, 2, 3, 4").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.4",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Genesis 1-3, Jer 2").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.3,Jer.2",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Genesis 1-3, Philemon 1").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.3,Phlm",
          translations: [""],
          indices: [0, 23]
        }
      ]);
      expect(p.parse("Genesis 1-3, Philemon 1-2").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.3,Phlm.1.1-Phlm.1.2",
          translations: [""],
          indices: [0, 25]
        }
      ]);
      return expect(p.parse("Matt 5:2 John 2").osis()).toEqual("Matt.5,2John.1.2");
    });
    it("should handle a `separate` `sequence_combination_strategy`", function() {
      p.options.sequence_combination_strategy = "separate";
      expect(p.parse("Genesis 1-3, Jer 2").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.3",
          translations: [""],
          indices: [0, 11]
        }, {
          osis: "Jer.2",
          translations: [""],
          indices: [13, 18]
        }
      ]);
      expect(p.parse("Genesis 1-3, Jer 2 skip Phlm 3,4").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.3",
          translations: [""],
          indices: [0, 11]
        }, {
          osis: "Jer.2",
          translations: [""],
          indices: [13, 18]
        }, {
          osis: "Phlm.1.3-Phlm.1.4",
          translations: [""],
          indices: [24, 32]
        }
      ]);
      expect(p.parse("Eph. 4. Gen, Matt, 6").osis_and_indices()).toEqual([
        {
          osis: "Eph.4",
          indices: [0, 6],
          translations: [""]
        }, {
          osis: "Matt.6",
          indices: [13, 20],
          translations: [""]
        }
      ]);
      expect(p.parse("Eph. 4. Gen, Matt, 1cor6-7").osis_and_indices()).toEqual([
        {
          osis: "Eph.4",
          indices: [0, 6],
          translations: [""]
        }, {
          osis: "1Cor.6-1Cor.7",
          indices: [19, 26],
          translations: [""]
        }
      ]);
      expect(p.parse("Eph. 4. Gen, Matt, 1cor, 6-7").osis_and_indices()).toEqual([
        {
          osis: "Eph.4",
          indices: [0, 6],
          translations: [""]
        }, {
          osis: "1Cor.6-1Cor.7",
          indices: [19, 28],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt 1: 98, 99, 2, 97, 8 John 3:2").osis_and_indices()).toEqual([
        {
          osis: "Matt.1.2",
          indices: [16, 17],
          translations: [""]
        }, {
          osis: "Matt.1.8",
          indices: [23, 24],
          translations: [""]
        }, {
          osis: "John.3.2",
          indices: [25, 33],
          translations: [""]
        }
      ]);
      return expect(p.parse("Jdg 12:11 break Judges 99,2,KJV").osis_and_indices()).toEqual([
        {
          osis: "Judg.12.11",
          indices: [0, 9],
          translations: [""]
        }, {
          osis: "Judg.2",
          indices: [26, 31],
          translations: ["KJV"]
        }
      ]);
    });
    it("should handle an `ignore` `book_sequence_strategy`", function() {
      p.options.book_alone_strategy = "ignore";
      p.options.book_sequence_strategy = "ignore";
      expect(p.parse("This is Isaiah 23:10. Also Isaiah 1:2.").osis_and_indices()).toEqual([
        {
          osis: "Isa.23.10,Isa.1.2",
          translations: [""],
          indices: [8, 37]
        }
      ]);
      expect(p.parse("This is Isaiah 23:10. Also Isaiah 1:2 is good.").osis_and_indices()).toEqual([
        {
          osis: "Isa.23.10,Isa.1.2",
          translations: [""],
          indices: [8, 37]
        }
      ]);
      expect(p.parse("This is Isaiah 23:10. Genesis Isaiah 1:2 is good.").osis_and_indices()).toEqual([
        {
          osis: "Isa.23.10,Isa.1.2",
          translations: [""],
          indices: [8, 40]
        }
      ]);
      expect(p.parse("Genesis, Exodus").osis_and_indices()).toEqual([]);
      expect(p.parse("Isaiah 41:10 is my").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10",
          indices: [0, 12],
          translations: [""]
        }
      ]);
      return expect(p.parse("Isaiah 41:10 ha ha ha").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10",
          indices: [0, 12],
          translations: [""]
        }
      ]);
    });
    it("should handle an `include` `book_sequence_strategy` with a `first_chapter` book_alone_strategy`", function() {
      p.options.book_alone_strategy = "first_chapter";
      p.options.book_sequence_strategy = "include";
      expect(p.parse("This is Isaiah 23:10. Also Isaiah 1:2.").osis_and_indices()).toEqual([
        {
          osis: "Isa.1,Isa.23.10,Isa.1.2",
          translations: [""],
          indices: [5, 37]
        }
      ]);
      expect(p.parse("This is Isaiah 23:10. Also Isaiah 1:2 is good.").osis_and_indices()).toEqual([
        {
          osis: "Isa.1,Isa.23.10,Isa.1.2,Isa.1",
          translations: [""],
          indices: [5, 40]
        }
      ]);
      expect(p.parse("This is Isaiah 23:10. Genesis Isaiah 1:2 is good.").osis_and_indices()).toEqual([
        {
          osis: "Isa.1,Isa.23.10,Gen.1,Isa.1.2,Isa.1",
          translations: [""],
          indices: [5, 43]
        }
      ]);
      expect(p.parse("Genesis, Exodus").osis_and_indices()).toEqual([
        {
          osis: "Gen.1,Exod.1",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Isaiah 41:10 is my").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10,Isa.1",
          indices: [0, 15],
          translations: [""]
        }
      ]);
      return expect(p.parse("Isaiah 41:10 ha ha ha").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10,Hab.1,Hab.1,Hab.1",
          indices: [0, 21],
          translations: [""]
        }
      ]);
    });
    it("should handle an `include` `book_sequence_strategy` with a `full` book_alone_strategy`", function() {
      p.options.book_alone_strategy = "full";
      p.options.book_sequence_strategy = "include";
      expect(p.parse("This is Isaiah 23:10. Also Isaiah 1:2.").osis_and_indices()).toEqual([
        {
          osis: "Isa,Isa.23.10,Isa.1.2",
          translations: [""],
          indices: [5, 37]
        }
      ]);
      expect(p.parse("This is Isaiah 23:10. Also Isaiah 1:2 is good.").osis_and_indices()).toEqual([
        {
          osis: "Isa,Isa.23.10,Isa.1.2,Isa",
          translations: [""],
          indices: [5, 40]
        }
      ]);
      expect(p.parse("This is Isaiah 23:10. Genesis Isaiah 1:2 is good.").osis_and_indices()).toEqual([
        {
          osis: "Isa,Isa.23.10,Gen,Isa.1.2,Isa",
          translations: [""],
          indices: [5, 43]
        }
      ]);
      expect(p.parse("Genesis, Exodus").osis_and_indices()).toEqual([
        {
          osis: "Gen-Exod",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Isaiah 41:10 is my").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10,Isa",
          indices: [0, 15],
          translations: [""]
        }
      ]);
      return expect(p.parse("Isaiah 41:10 ha ha ha").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10,Hab,Hab,Hab",
          indices: [0, 21],
          translations: [""]
        }
      ]);
    });
    it("should handle `case_sensitive` correctly with `include_apocrypha: true`", function() {
      expect(p.parse("Tobit 1").osis()).toEqual("");
      expect(p.parse("sus 1").osis()).toEqual("");
      p.set_options({
        case_sensitive: "books"
      });
      p.include_apocrypha(true);
      expect(p.parse("Tobit 1").osis()).toEqual("Tob.1");
      expect(p.parse("sus 1").osis()).toEqual("");
      p.set_options({
        case_sensitive: "none"
      });
      expect(p.parse("Tobit 1").osis()).toEqual("Tob.1");
      return expect(p.parse("sus 1").osis()).toEqual("Sus");
    });
    it("should handle cbs", function() {
      expect(p.parse("Chapter 1 of Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen.1",
          indices: [0, 20],
          translations: [""]
        }
      ]);
      expect(p.parse("Chapter 1 of Genesis 15").osis()).toEqual("Gen.1,Gen.15");
      expect(p.parse("Chapter 1 of Genesis verse 16").osis()).toEqual("Gen.1.16");
      expect(p.parse("Chapter 1 of Genesis, verse 17").osis()).toEqual("Gen.1.17");
      expect(p.parse("Chapter 1 of Genesis, verses 18-19").osis()).toEqual("Gen.1.18-Gen.1.19");
      expect(p.parse("Chapter 1 of Genesis, verses 18-19:4").osis()).toEqual("Gen.1.18-Gen.19.4");
      expect(p.parse("Genesis chapter 3 of Mark").osis()).toEqual("Gen.3");
      expect(p.parse("1st ch. of Mark").osis()).toEqual("Mark.1");
      expect(p.parse("20nd ch. of the book of Luke").osis()).toEqual("Luke.20");
      expect(p.parse("119th chapter of the book of Psalms verses 23-25").osis()).toEqual("Ps.119.23-Ps.119.25");
      expect(p.parse("119 th ch. of the book of Psalms").osis()).toEqual("");
      return expect(p.parse("4th chapter of Galatians, 1-6 ").osis()).toEqual("Gal.4,Gal");
    });
    it("should handle cb ranges", function() {
      expect(p.parse("Chapters 1-3 of Genesis").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.3",
          indices: [0, 23],
          translations: [""]
        }
      ]);
      expect(p.parse("Chapters 1-4 of Genesis 15").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.4,Gen.15",
          indices: [0, 26],
          translations: [""]
        }
      ]);
      expect(p.parse("Chs. 1 to 5 of Genesis verse 16").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.5,Gen.5.16",
          indices: [0, 31],
          translations: [""]
        }
      ]);
      expect(p.parse("Ch. 1 through 6 of Genesis, verse 17").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.6,Gen.6.17",
          indices: [0, 36],
          translations: [""]
        }
      ]);
      expect(p.parse("Chapters 1-7 of Genesis, vv. 18-19").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.7,Gen.7.18-Gen.7.19",
          indices: [0, 34],
          translations: [""]
        }
      ]);
      expect(p.parse("Chapters 1-8 of Genesis, verses 18-19:4").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.8,Gen.8.18-Gen.19.4",
          indices: [0, 39],
          translations: [""]
        }
      ]);
      return expect(p.parse("Genesis chapters 3-4 of Mark").osis_and_indices()).toEqual([
        {
          osis: "Gen.3-Gen.4",
          indices: [0, 20],
          translations: [""]
        }
      ]);
    });
    it("should handle c_psalms (\"23rd Psalm\")", function() {
      expect(p.parse("23rd Psalm").osis_and_indices()).toEqual([
        {
          osis: "Ps.23",
          indices: [0, 10],
          translations: [""]
        }
      ]);
      expect(p.parse("150th Psalm").osis()).toEqual("Ps.150");
      expect(p.parse("1stPsalm").osis()).toEqual("Ps.1");
      expect(p.parse("11th Psalm").osis()).toEqual("Ps.11");
      expect(p.parse("11st Psalm").osis()).toEqual("");
      expect(p.parse("101th Psalm").osis()).toEqual("");
      expect(p.parse("101st Psalm").osis()).toEqual("Ps.101");
      expect(p.parse("111th Psalm").osis()).toEqual("Ps.111");
      expect(p.parse("111st Psalm").osis()).toEqual("");
      expect(p.parse("121st Psalm").osis()).toEqual("Ps.121");
      expect(p.parse("122st Psalm").osis()).toEqual("");
      expect(p.parse("122th Psalm").osis()).toEqual("");
      expect(p.parse("113st Psalm").osis()).toEqual("");
      expect(p.parse("113rd Psalm").osis()).toEqual("");
      expect(p.parse("113th Psalm").osis()).toEqual("Ps.113");
      expect(p.parse("103th Psalm").osis()).toEqual("");
      expect(p.parse("103rd Psalm").osis()).toEqual("Ps.103");
      expect(p.parse("122 nd Psalm").osis()).toEqual("Ps.122");
      expect(p.parse("23rd Psalm, 122 nd Psalm").osis()).toEqual("Ps.23,Ps.122");
      expect(p.parse("23rd Psalm, 2 122 nd Psalm").osis()).toEqual("Ps.23,Ps.2,Ps.122");
      expect(p.parse("23rd Psalm vv.3-4, 1st Psalm v3").osis()).toEqual("Ps.23.3-Ps.23.4,Ps.1.3");
      expect(p.parse("23rd Psalm vv.3-4, 1st Psalmverse 3").osis()).toEqual("Ps.23.3-Ps.23.4");
      expect(p.parse("23rd Psalm, verse 6").osis()).toEqual("Ps.23.6");
      expect(p.parse("23rd Psalm, verses 2-3").osis()).toEqual("Ps.23.2-Ps.23.3");
      return expect(p.parse("23rd Psalm, verses 2 and 4").osis()).toEqual("Ps.23.2,Ps.23.4");
    });
    it("should handle translation sequences", function() {
      p.parse("Genesis 5 (NIV, ESV, KJV, NIRV, NAS)");
      expect(p.entities.length).toEqual(2);
      expect(p.entities[0].passages[0].translations.length).toEqual(5);
      expect(p.osis_and_translations()).toEqual([["Gen.5", "NIV,ESV,KJV,NIRV,NASB"]]);
      p.parse("Jer 1 NIV, Genesis 50, TNIV, Ge 6");
      expect(p.entities.length).toEqual(5);
      expect(p.entities[0].passages[0].translations[0].osis).toEqual("NIV");
      expect(p.entities[2].passages[0].translations[0].osis).toEqual("TNIV");
      expect(p.entities[4].passages[0].translations).not.toBeDefined();
      expect(p.osis_and_translations()).toEqual([["Jer.1", "NIV"], ["Gen.50", "TNIV"], ["Gen.6", ""]]);
      expect(p.parse("Matt 1 ESV 2-3 NIV").osis_and_translations()).toEqual([["Matt.1", "ESV"], ["Matt.2-Matt.3", "NIV"]]);
      p.set_options({
        book_alone_strategy: "full"
      });
      expect(p.parse("Rom amp A 2 amp 3").parsed_entities()).toEqual([
        {
          osis: "Rom",
          indices: [0, 7],
          translations: ["AMP"],
          entity_id: 0,
          entities: [
            {
              osis: "Rom",
              type: "b",
              indices: [0, 7],
              translations: ["AMP"],
              start: {
                b: "Rom",
                c: 1,
                v: 1
              },
              end: {
                b: "Rom",
                c: 16,
                v: 27
              },
              enclosed_indices: void 0,
              entity_id: 0,
              entities: [
                {
                  start: {
                    b: "Rom",
                    c: 1,
                    v: 1
                  },
                  end: {
                    b: "Rom",
                    c: 16,
                    v: 27
                  },
                  valid: {
                    valid: true,
                    messages: {}
                  },
                  translations: [
                    {
                      translation: "amp",
                      alias: "default",
                      osis: "AMP"
                    }
                  ],
                  type: "b",
                  absolute_indices: [0, 7]
                }
              ]
            }
          ]
        }
      ]);
      return expect(p.parse("Matthew 3:1 NIV 12 7:1").osis_and_indices()).toEqual([
        {
          osis: "Matt.3.1",
          translations: ["NIV"],
          indices: [0, 15]
        }, {
          osis: "Matt.3.12",
          translations: [""],
          indices: [16, 18]
        }, {
          osis: "Matt.7.1",
          translations: [""],
          indices: [19, 22]
        }
      ]);
    });
    it("should handle translations preceded by various bcv types", function() {
      p.set_options({
        book_alone_strategy: "full",
        book_range_strategy: "include"
      });
      expect(p.parse("Psalm 3:title (ESV)").osis_and_indices()).toEqual([
        {
          osis: "Ps.3.1",
          translations: ["ESV"],
          indices: [0, 19]
        }
      ]);
      expect(p.parse("1-2 John (ESV)").osis_and_indices()).toEqual([
        {
          osis: "1John-2John",
          translations: ["ESV"],
          indices: [0, 14]
        }
      ]);
      expect(p.parse("23rd Psalm (ESV)").osis_and_indices()).toEqual([
        {
          osis: "Ps.23",
          translations: ["ESV"],
          indices: [0, 16]
        }
      ]);
      expect(p.parse("23rd Psalm ESV").osis_and_indices()).toEqual([
        {
          osis: "Ps.23",
          translations: ["ESV"],
          indices: [0, 14]
        }
      ]);
      expect(p.parse("1-2 Thess (NASB, TNIV )3").osis_and_indices()).toEqual([
        {
          osis: "1Thess-2Thess",
          translations: ["NASB", "TNIV"],
          indices: [0, 23]
        }, {
          osis: "2Thess.3",
          translations: [""],
          indices: [23, 24]
        }
      ]);
      return expect(p.parse("1-2 Thess (NASB, TNIV )43").osis_and_indices()).toEqual([
        {
          osis: "1Thess-2Thess",
          translations: ["NASB", "TNIV"],
          indices: [0, 23]
        }
      ]);
    });
    it("should check ends before start", function() {
      var psg;
      p.reset();
      psg = p.passage;
      expect(psg.range_get_new_end_value({
        "c": 105
      }, {
        "c": 6
      }, {
        messages: {}
      }, "c")).toEqual(106);
      expect(psg.range_get_new_end_value({
        "c": 105
      }, {
        "c": 106
      }, {
        messages: {}
      }, "c")).toEqual(0);
      expect(psg.range_get_new_end_value({
        "c": 110
      }, {
        "c": 11
      }, {
        messages: {}
      }, "c")).toEqual(111);
      expect(psg.range_get_new_end_value({
        "c": 110
      }, {
        "c": 20
      }, {
        messages: {}
      }, "c")).toEqual(120);
      expect(psg.range_get_new_end_value({
        "c": 111
      }, {
        "c": 10
      }, {
        messages: {}
      }, "c")).toEqual(0);
      expect(psg.range_get_new_end_value({
        "c": 111
      }, {
        "c": 2
      }, {
        messages: {}
      }, "c")).toEqual(112);
      expect(psg.range_get_new_end_value({
        "c": 111
      }, {
        "c": 0
      }, {
        messages: {}
      }, "c")).toEqual(0);
      expect(psg.range_get_new_end_value({
        "c": 11
      }, {
        "c": 4
      }, {
        messages: {}
      }, "c")).toEqual(14);
      expect(psg.range_get_new_end_value({
        "c": 3
      }, {
        "c": 2
      }, {
        messages: {}
      }, "c")).toEqual(0);
      expect(psg.range_get_new_end_value({
        "c": 100
      }, {
        "c": 9
      }, {
        messages: {}
      }, "c")).toEqual(109);
      expect(psg.range_get_new_end_value({
        "c": 100
      }, {
        "c": 19
      }, {
        messages: {}
      }, "c")).toEqual(119);
      expect(psg.range_get_new_end_value({
        "c": 102
      }, {
        "c": 24
      }, {
        messages: {}
      }, "c")).toEqual(124);
      return expect(psg.range_get_new_end_value({
        "c": 105
      }, {
        "c": 104
      }, {
        messages: {}
      }, "c")).toEqual(0);
    });
    it("should handle ends before starts (ints)", function() {
      expect(p.parse("Ps 121, 22").osis_and_indices()[0].osis).toEqual("Ps.121,Ps.22");
      expect(p.parse("Ps 121-22").osis_and_indices()[0].osis).toEqual("Ps.121-Ps.122");
      expect(p.parse("Ps 121-2").osis_and_indices()[0].osis).toEqual("Ps.121-Ps.122");
      expect(p.parse("Psalm 121-Gen 2").osis_and_indices()[0].osis).toEqual("Ps.121,Gen.2");
      expect(p.parse("genisis 50-49").osis_and_indices()[0].osis).toEqual("Gen.50,Gen.49");
      expect(p.parse("Gen 28-9").osis_and_indices()[0].osis).toEqual("Gen.28-Gen.29");
      expect(p.parse("Gen 28:1-51:100").osis_and_indices()[0].osis).toEqual("Gen.28-Gen.50");
      expect(p.parse("Gen 28:1-51:1").osis_and_indices()[0].osis).toEqual("Gen.28-Gen.50");
      expect(p.parse("Gen 28-0").osis_and_indices()[0].osis).toEqual("Gen.28");
      expect(p.parse("Gen 1:16-7").osis_and_indices()[0].osis).toEqual("Gen.1.16-Gen.1.17");
      expect(p.parse("ps119 170-1").osis_and_indices()[0].osis).toEqual("Ps.119.170-Ps.119.171");
      expect(p.parse("phlm 1:12-3").osis_and_indices()[0].osis).toEqual("Phlm.1.12-Phlm.1.13");
      return expect(p.parse("phlm 12-3").osis_and_indices()[0].osis).toEqual("Phlm.1.12-Phlm.1.13");
    });
    it("should handle ends before starts (cvs)", function() {
      expect(p.parse("Ps 121-22:4").osis_and_indices()[0].osis).toEqual("Ps.121.1-Ps.122.4");
      expect(p.parse("Ps 121-6:4").osis_and_indices()[0].osis).toEqual("Ps.121.1-Ps.126.4");
      expect(p.parse("Ps 121-36:4").osis_and_indices()[0].osis).toEqual("Ps.121.1-Ps.136.4");
      expect(p.parse("Ps 21-0:4").osis_and_indices()[0].osis).toEqual("Ps.21");
      expect(p.parse("Proverbs 31:30-31:1").osis()).toEqual("Prov.31.30,Prov.31.1");
      expect(p.parse("Proverbs 31:30-1:1").osis()).toEqual("Prov.31.30,Prov.1.1");
      expect(p.parse("Proverbs 31:30-30:1").osis()).toEqual("Prov.31.30,Prov.30.1");
      expect(p.parse("Ps 21:2-1:4").osis_and_indices()[0].osis).toEqual("Ps.21.2,Ps.1.4");
      expect(p.parse("Ps 21:6-1:4").osis_and_indices()[0].osis).toEqual("Ps.21.6,Ps.1.4");
      expect(p.parse("Ps 22:6-1:4").osis_and_indices()[0].osis).toEqual("Ps.22.6,Ps.1.4");
      expect(p.parse("Ps 21:6-2:4").osis_and_indices()[0].osis).toEqual("Ps.21.6-Ps.22.4");
      return expect(p.parse("Ps 21:6-19:4,3:5").osis_and_indices()[0].osis).toEqual("Ps.21.6,Ps.19.4,Ps.3.5");
    });
    it("should handle ends before starts (verses)", function() {
      expect(p.parse("Ps 119:125-24a").osis_and_indices()[0].osis).toEqual("Ps.119.125,Ps.119.24");
      expect(p.parse("Ps 119:125-4a").osis_and_indices()[0].osis).toEqual("Ps.119.125,Ps.119.4");
      expect(p.parse("Ps 119:125-26a").osis_and_indices()[0].osis).toEqual("Ps.119.125-Ps.119.126");
      expect(p.parse("Ps 119:125-6a").osis_and_indices()[0].osis).toEqual("Ps.119.125-Ps.119.126");
      expect(p.parse("Ps 119:16-4a").osis_and_indices()[0].osis).toEqual("Ps.119.16,Ps.119.4");
      expect(p.parse("Ps 119:16-7a").osis_and_indices()[0].osis).toEqual("Ps.119.16-Ps.119.17");
      expect(p.parse("Ps 119:6-4a,3:5").osis_and_indices()[0].osis).toEqual("Ps.119.6,Ps.119.4,Ps.3.5");
      return expect(p.parse("Ps 119:6-7a,3:5").osis_and_indices()[0].osis).toEqual("Ps.119.6-Ps.119.7,Ps.3.5");
    });
    it("should handle ffs", function() {
      expect(p.parse("Gen5ff").osis_and_indices()).toEqual([
        {
          osis: "Gen.5-Gen.50",
          translations: [""],
          indices: [0, 6]
        }
      ]);
      expect(p.parse("Gen 6ff").osis_and_indices()).toEqual([
        {
          osis: "Gen.6-Gen.50",
          translations: [""],
          indices: [0, 7]
        }
      ]);
      expect(p.parse("Ps 121ff").osis_and_indices()[0].osis).toEqual("Ps.121-Ps.150");
      expect(p.parse("Ps 121:1ff .").osis_and_indices()[0].osis).toEqual("Ps.121");
      expect(p.parse("Ps 121:2f.").osis_and_indices()[0].osis).toEqual("Ps.121.2-Ps.121.8");
      expect(p.parse("ge 1 ff").osis_and_indices()[0].osis).toEqual("Gen");
      expect(p.parse("Phm 1ff").osis_and_indices()[0].osis).toEqual("Phlm");
      expect(p.parse("Phm 1:1ff").osis_and_indices()[0].osis).toEqual("Phlm");
      expect(p.parse("Phm 1:2ff").osis_and_indices()[0].osis).toEqual("Phlm.1.2-Phlm.1.25");
      expect(p.parse("Phm 2ff").osis_and_indices()[0].osis).toEqual("Phlm.1.2-Phlm.1.25");
      expect(p.parse("Phm v. 3ff").osis_and_indices()[0].osis).toEqual("Phlm.1.3-Phlm.1.25");
      expect(p.parse("ge 50f").osis_and_indices()[0]).toEqual({
        osis: "Gen.50",
        indices: [0, 6],
        translations: [""]
      });
      expect(p.parse("ge 50:60ff").osis_and_indices()[0]).toEqual(void 0);
      expect(p.parse("Ps 121-2ff").osis_and_indices()[0].osis).toEqual("Ps.121-Ps.150");
      expect(p.parse("Ps 121-122:3ff").osis_and_indices()[0].osis).toEqual("Ps.121-Ps.122");
      expect(p.parse("Phm 1-4ff").osis_and_indices()[0].osis).toEqual("Phlm");
      expect(p.parse("Phm 1:1-4 ff").osis_and_indices()[0].osis).toEqual("Phlm");
      expect(p.parse("Phm 1:2-4ff").osis_and_indices()[0].osis).toEqual("Phlm.1.2-Phlm.1.25");
      expect(p.parse("Phm 2-4ff").osis_and_indices()[0].osis).toEqual("Phlm.1.2-Phlm.1.25");
      expect(p.parse("ge 50-50f").osis_and_indices()[0]).toEqual({
        osis: "Gen.50",
        indices: [0, 9],
        translations: [""]
      });
      expect(p.parse("Ps 121ff-2ff").osis_and_indices()[0].osis).toEqual("Ps.121-Ps.150,Ps.2-Ps.150");
      expect(p.parse("Ps 121ff-122:3ff").osis_and_indices()[0].osis).toEqual("Ps.121-Ps.150,Ps.122.3-Ps.122.9");
      expect(p.parse("Phm 1ff-4ff").osis_and_indices()[0].osis).toEqual("Phlm,Phlm.1.4-Phlm.1.25");
      expect(p.parse("Phm 1:1ff-4ff").osis_and_indices()[0].osis).toEqual("Phlm,Phlm.1.4-Phlm.1.25");
      expect(p.parse("Phm 1:2ff-4ff").osis_and_indices()[0].osis).toEqual("Phlm.1.2-Phlm.1.25,Phlm.1.4-Phlm.1.25");
      expect(p.parse("Phm 2ff-4ff").osis_and_indices()[0].osis).toEqual("Phlm.1.2-Phlm.1.25,Phlm.1.4-Phlm.1.25");
      expect(p.parse("ge 50f-50f").osis_and_indices()[0]).toEqual({
        osis: "Gen.50,Gen.50",
        indices: [0, 10],
        translations: [""]
      });
      expect(p.parse("ge 50:1 forever").osis_and_indices()[0]).toEqual({
        osis: "Gen.50.1",
        indices: [0, 7],
        translations: [""]
      });
      expect(p.parse("ge 50:1 fa").osis_and_indices()[0]).toEqual({
        osis: "Gen.50.1",
        indices: [0, 7],
        translations: [""]
      });
      expect(p.parse("so f").osis_and_indices()).toEqual([]);
      expect(p.parse("and 1 COR 11: 5 FF.").osis_and_indices()).toEqual([
        {
          osis: "1Cor.11.5-1Cor.11.34",
          indices: [4, 19],
          translations: [""]
        }
      ]);
      expect(p.parse("and 1 COR 11: 5 FF").osis_and_indices()).toEqual([
        {
          osis: "1Cor.11.5-1Cor.11.34",
          indices: [4, 18],
          translations: [""]
        }
      ]);
      expect(p.parse("Eccl 10:2-99ff").osis_and_indices()).toEqual([
        {
          osis: "Eccl.10.2-Eccl.10.20",
          indices: [0, 14],
          translations: [""]
        }
      ]);
      return expect(p.parse("Eccl 10:21ff").osis_and_indices()).toEqual([]);
    });
    it("should handle zeroes as errors", function() {
      p.options.zero_chapter_strategy = "error";
      p.options.zero_verse_strategy = "error";
      expect(p.parse("Hosea 2:0").osis()).toEqual("");
      expect(p.parse("Hosea 0:2").osis()).toEqual("");
      expect(p.parse("Hosea 2:2-3:0").osis()).toEqual("Hos.2.2");
      expect(p.parse("Hosea 2:0-3:0").osis()).toEqual("");
      expect(p.parse("Hosea 2, 0").osis()).toEqual("Hos.2");
      expect(p.parse("Hosea 2-0").osis()).toEqual("Hos.2");
      expect(p.parse("Hosea 2:2, 0").osis()).toEqual("Hos.2.2");
      expect(p.parse("Phlm 0:2").osis()).toEqual("");
      expect(p.parse("Phlm 0").osis()).toEqual("");
      return expect(p.parse("Phlm 0-0").osis()).toEqual("");
    });
    it("should handle zeroes as chapter upgrades", function() {
      p.options.zero_chapter_strategy = "upgrade";
      expect(p.parse("Hosea 2:0").osis()).toEqual("");
      expect(p.parse("Hosea 0:2").osis()).toEqual("Hos.1.2");
      expect(p.parse("Hosea 2:2-3:0").osis()).toEqual("Hos.2.2");
      expect(p.parse("Hosea 2:0-3:0").osis()).toEqual("");
      expect(p.parse("Hosea 2, 0").osis()).toEqual("Hos.2,Hos.1");
      expect(p.parse("Hosea 2-0").osis()).toEqual("Hos.2,Hos.1");
      expect(p.parse("Hosea 2:2, 0").osis()).toEqual("Hos.2.2");
      expect(p.parse("Phlm 0:2").osis()).toEqual("Phlm.1.2");
      expect(p.parse("Phlm 0").osis()).toEqual("Phlm");
      return expect(p.parse("Phlm 0-0").osis()).toEqual("Phlm");
    });
    it("should handle zeroes as verse upgrades", function() {
      p.set_options({
        zero_verse_strategy: "upgrade"
      });
      expect(p.parse("Hosea 2:0").osis()).toEqual("Hos.2.1");
      expect(p.parse("Hosea 0:2").osis()).toEqual("");
      expect(p.parse("Hosea 2:2-3:0").osis()).toEqual("Hos.2.2-Hos.3.1");
      expect(p.parse("Hosea 2:0-3:0").osis()).toEqual("Hos.2.1-Hos.3.1");
      expect(p.parse("Hosea 2, 0").osis()).toEqual("Hos.2");
      expect(p.parse("Hosea 2-0").osis()).toEqual("Hos.2.1");
      expect(p.parse("Hosea 2:2, 0").osis()).toEqual("Hos.2.2,Hos.2.1");
      expect(p.parse("Phlm 0:2").osis()).toEqual("");
      expect(p.parse("Phlm 0").osis()).toEqual("Phlm.1.1");
      expect(p.parse("Phlm 0-0").osis()).toEqual("Phlm.1.1");
      return expect(p.parse("Ps 20:1-0:4").osis()).toEqual("Ps.20.1");
    });
    it("should handle zeroes as allowed verses", function() {
      p.set_options({
        zero_verse_strategy: "allow"
      });
      expect(p.parse("Hosea 2:0").osis()).toEqual("Hos.2.0");
      expect(p.parse("Hosea 0:2").osis()).toEqual("");
      expect(p.parse("Hosea 2:2-3:0").osis()).toEqual("Hos.2.2-Hos.3.0");
      expect(p.parse("Hosea 2:0-3:0").osis()).toEqual("Hos.2.0-Hos.3.0");
      expect(p.parse("Hosea 2, 0").osis()).toEqual("Hos.2");
      expect(p.parse("Hosea 2-0").osis()).toEqual("Hos.2.0");
      expect(p.parse("Hosea 2:2, 0").osis()).toEqual("Hos.2.2,Hos.2.0");
      expect(p.parse("Phlm 0:2").osis()).toEqual("");
      expect(p.parse("Phlm 0").osis()).toEqual("Phlm.1.0");
      expect(p.parse("Phlm 0-0").osis()).toEqual("Phlm.1.0");
      return expect(p.parse("Ps 20:1-0:4").osis()).toEqual("Ps.20.1");
    });
    it("should handle zeroes as both upgrades", function() {
      p.options.zero_chapter_strategy = "upgrade";
      p.options.zero_verse_strategy = "upgrade";
      expect(p.parse("Hosea 2:0").osis()).toEqual("Hos.2.1");
      expect(p.parse("Hosea 0:2").osis()).toEqual("Hos.1.2");
      expect(p.parse("Hosea 2:2-3:0").osis()).toEqual("Hos.2.2-Hos.3.1");
      expect(p.parse("Hosea 2:0-3:0").osis()).toEqual("Hos.2.1-Hos.3.1");
      expect(p.parse("Hosea 2, 0").osis()).toEqual("Hos.2,Hos.1");
      expect(p.parse("Hosea 2-0").osis()).toEqual("Hos.2.1");
      expect(p.parse("Hosea 2:2, 0").osis()).toEqual("Hos.2.2,Hos.2.1");
      expect(p.parse("Phlm 0:2").osis()).toEqual("Phlm.1.2");
      expect(p.parse("Phlm 0").osis()).toEqual("Phlm");
      expect(p.parse("Phlm 0-0").osis()).toEqual("Phlm");
      expect(p.parse("Ps 20:1-0:4").osis()).toEqual("Ps.20.1,Ps.1.4");
      return expect(p.parse("John 1:10-0").osis()).toEqual("John.1.10,John.1.1");
    });
    it("should handle zeroes as chapter upgrade and allowed verse", function() {
      p.options.zero_chapter_strategy = "upgrade";
      p.options.zero_verse_strategy = "allow";
      expect(p.parse("Hosea 2:0").osis()).toEqual("Hos.2.0");
      expect(p.parse("Hosea 0:2").osis()).toEqual("Hos.1.2");
      expect(p.parse("Hosea 2:2-3:0").osis()).toEqual("Hos.2.2-Hos.3.0");
      expect(p.parse("Hosea 2:0-3:0").osis()).toEqual("Hos.2.0-Hos.3.0");
      expect(p.parse("Hosea 2, 0").osis()).toEqual("Hos.2,Hos.1");
      expect(p.parse("Hosea 2-0").osis()).toEqual("Hos.2.0");
      expect(p.parse("Hosea 2:2, 0").osis()).toEqual("Hos.2.2,Hos.2.0");
      expect(p.parse("Phlm 0:2").osis()).toEqual("Phlm.1.2");
      expect(p.parse("Phlm 0").osis()).toEqual("Phlm");
      expect(p.parse("Phlm 0-0").osis()).toEqual("Phlm");
      return expect(p.parse("Ps 20:1-0:4").osis()).toEqual("Ps.20.1,Ps.1.4");
    });
    it("should handle a `delete` `captive_end_digits_strategy`", function() {
      p.options.book_alone_strategy = "ignore";
      p.options.captive_end_digits_strategy = "delete";
      expect(p.parse("Rev 2").osis()).toEqual("Rev.2");
      expect(p.parse("Rev 2a").osis()).toEqual("Rev.2");
      expect(p.parse("Rev 2, 3a").osis()).toEqual("Rev.2,Rev.2.3");
      expect(p.parse("Rev 2- 3ab").osis()).toEqual("Rev.2");
      expect(p.parse("Rev 2:1 - 3a").osis()).toEqual("Rev.2.1-Rev.2.3");
      expect(p.parse("Rev 2:1 - 3 * a").osis_and_indices()).toEqual([
        {
          osis: "Rev.2.1-Rev.2.3",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Rev 2:1-3 4a").osis()).toEqual("Rev.2.1-Rev.2.4");
      expect(p.parse("Rev 2:1-2Hi").osis()).toEqual("Rev.2.1-Rev.2.2");
      expect(p.parse("Rev 2:1-2 3Hi").osis()).toEqual("Rev.2.1-Rev.2.2");
      expect(p.parse("Rev 2:1-2 Matt 3Hi").osis()).toEqual("Rev.2.1-Rev.2.2");
      expect(p.parse("Rev 2:1-3 NIV 2 for").osis()).toEqual("Rev.2.1-Rev.2.3");
      expect(p.parse("Rev 2:1-4 NIV 2 to").osis()).toEqual("Rev.2.1-Rev.2.4");
      expect(p.parse("Rev 2:1-4 NIV 2m").osis()).toEqual("Rev.2.1-Rev.2.4");
      expect(p.parse("Rev 2:1-3 NIV*2*").osis()).toEqual("Rev.2.1-Rev.2.3");
      p.options.book_alone_strategy = "include";
      return expect(p.parse("Rev 2:1-2 Matt 3Hi").osis()).toEqual("Rev.2.1-Rev.2.2");
    });
    it("should handle an `include` `captive_end_digits_strategy`", function() {
      p.options.captive_end_digits_strategy = "include";
      expect(p.parse("Rev 2").osis()).toEqual("Rev.2");
      expect(p.parse("Rev 2a").osis()).toEqual("Rev.2");
      expect(p.parse("Rev 2, 3a").osis()).toEqual("Rev.2,Rev.2.3");
      expect(p.parse("Rev 2- 3ab").osis()).toEqual("Rev.2-Rev.3");
      expect(p.parse("Rev 2:1 - 3a").osis()).toEqual("Rev.2.1-Rev.2.3");
      expect(p.parse("Rev 2:1 - 3 * a").osis_and_indices()).toEqual([
        {
          osis: "Rev.2.1-Rev.2.3",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Rev 2:1-3 4a").osis()).toEqual("Rev.2.1-Rev.2.4");
      expect(p.parse("Rev 2:1-2Hi").osis()).toEqual("Rev.2.1-Rev.2.2");
      expect(p.parse("Rev 2:1-3 4Hi").osis()).toEqual("Rev.2.1-Rev.2.4");
      return expect(p.parse("Rev 2:1-2 Matt 3Hi").osis()).toEqual("Rev.2.1-Rev.2.2,Matt.3");
    });
    it("should handle a `verse` `end_range_digits_strategy`", function() {
      p.options.end_range_digits_strategy = "verse";
      expect(p.parse("Jer 33-11").osis()).toEqual("Jer.33.11");
      expect(p.parse("Heb 13-15").osis()).toEqual("Heb.13.15");
      expect(p.parse("Jer 33-11a").osis()).toEqual("Jer.33.11");
      expect(p.parse("Heb 13-15a").osis()).toEqual("Heb.13.15");
      expect(p.parse("Gal 5-22a").osis()).toEqual("Gal.5.22");
      expect(p.parse("Matt 5- verse 6").osis()).toEqual("Matt.5.6");
      expect(p.parse("Phm 7-8").osis()).toEqual("Phlm.1.7-Phlm.1.8");
      expect(p.parse("Phm 8-7").osis()).toEqual("Phlm.1.8,Phlm.1.7");
      expect(p.parse("Phm 7 to verse 6").osis()).toEqual("Phlm.1.7,Phlm.1.6");
      expect(p.parse("Phm 17 to verse 0").osis()).toEqual("Phlm.1.17");
      expect(p.parse("Phil 2, verse 3:1").osis()).toEqual("Phil.2.1-Phil.3.1");
      expect(p.parse("Phil 2, verse 4:1").osis()).toEqual("Phil.2,Phil.4.1");
      expect(p.parse("Phil 2 to verse 3:1").osis()).toEqual("Phil.2.1-Phil.3.1");
      return expect(p.parse("Phil 2 to verse 1:1").osis()).toEqual("Phil.2,Phil.1.1");
    });
    it("should handle a `sequence` `end_range_digits_strategy`", function() {
      p.options.end_range_digits_strategy = "sequence";
      expect(p.parse("Jer 33-11").osis()).toEqual("Jer.33,Jer.11");
      expect(p.parse("Heb 13-15").osis()).toEqual("Heb.13");
      expect(p.parse("Jer 33-11a").osis()).toEqual("Jer.33.1-Jer.33.11");
      expect(p.parse("Heb 13-15a").osis()).toEqual("Heb.13.1-Heb.13.15");
      expect(p.parse("Gal 5-22a").osis()).toEqual("Gal.5.1-Gal.5.22");
      expect(p.parse("Matt 5- verse 6").osis()).toEqual("Matt.5.6");
      expect(p.parse("Phm 8-7").osis()).toEqual("Phlm.1.8,Phlm.1.7");
      expect(p.parse("Phm 7 to verse 6").osis()).toEqual("Phlm.1.7,Phlm.1.6");
      expect(p.parse("Phm 17 to verse 0").osis()).toEqual("Phlm.1.17");
      expect(p.parse("Phil 2, verse 3:1").osis()).toEqual("Phil.2.1-Phil.3.1");
      expect(p.parse("Phil 2, verse 4:1").osis()).toEqual("Phil.2,Phil.4.1");
      expect(p.parse("Phil 2 to verse 3:1").osis()).toEqual("Phil.2.1-Phil.3.1");
      return expect(p.parse("Phil 2 to verse 1:1").osis()).toEqual("Phil.2,Phil.1.1");
    });
    it("should handle no matches", function() {
      return expect(p.parse("Nothing").osis()).toEqual("");
    });
    it("should handle `bcv_range` hyphens", function() {
      expect(p.parse("1 John-2-3-4").osis_and_indices()).toEqual([
        {
          osis: "1John.2.3-1John.2.4",
          indices: [0, 12],
          translations: [""]
        }
      ]);
      return expect(p.parse("Matt-5-6-7").osis()).toEqual("Matt.5.6-Matt.5.7");
    });
    it("should handle a `combine` `consecutive_combination_strategy`", function() {
      p.set_options({
        consecutive_combination_strategy: "combine"
      });
      expect(p.parse("Genesis 12, 50, NIV, 6 split Matt 4, 5, 6:1-50, ch 8 ESV, MATT 10").osis_and_translations()).toEqual([["Gen.12,Gen.50", "NIV"], ["Gen.6", ""], ["Matt.4-Matt.6,Matt.8", "ESV"], ["Matt.10", ""]]);
      return expect(p.parse("Rev 2:1, 2, 3 4Hi").osis()).toEqual("Rev.2.1-Rev.2.3");
    });
    it("should handle a `separate` `consecutive_combination_strategy`", function() {
      p.set_options({
        consecutive_combination_strategy: "separate",
        book_sequence_strategy: "full"
      });
      expect(p.parse("Genesis 12, 50, NIV, 6 split Matt 4, 5, 6:1-50, ch 8 ESV, MATT 10").osis_and_translations()).toEqual([["Gen.12,Gen.50", "NIV"], ["Gen.6", ""], ["Matt.4,Matt.5,Matt.6,Matt.8", "ESV"], ["Matt.10", ""]]);
      expect(p.parse("Philemon verse 11, Philemon verse 12").osis()).toEqual("Phlm.1.11,Phlm.1.12");
      expect(p.parse("Genesis 1, 2, 3, 4").osis_and_indices()).toEqual([
        {
          osis: "Gen.1,Gen.2,Gen.3,Gen.4",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Genesis 1-3, Jer 2 skip Phlm 3,4").osis_and_indices()).toEqual([
        {
          osis: "Gen.1-Gen.3,Jer.2",
          translations: [""],
          indices: [0, 18]
        }, {
          osis: "Phlm.1.3,Phlm.1.4",
          translations: [""],
          indices: [24, 32]
        }
      ]);
      expect(p.parse("Genesis, Exodus").osis_and_indices()).toEqual([
        {
          osis: "Gen,Exod",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Rev 2:1-3 4a").osis()).toEqual("Rev.2.1-Rev.2.3,Rev.2.4");
      expect(p.parse("Rev 2:1, 2, 3 4Hi").osis()).toEqual("Rev.2.1,Rev.2.2,Rev.2.3");
      expect(p.parse("Reading and reflecting on Philippians 1 & 2. ").osis()).toEqual("Phil.1,Phil.2");
      expect(p.parse("  john 3:16 i memorized it when i was 5.  now i like john 3:16-18..  vs 17 and 18 go with it too. they kinda help/clarify vs 16.").osis()).toEqual("John.3.16,John.3.16-John.3.18,John.3.17,John.3.18");
      expect(p.parse("Matt 4:8/9.").osis()).toEqual("Matt.4.8,Matt.4.9");
      expect(p.parse("Second Reading - Gen 22:1-2, 9a, 10-13, 15-18 ...   ").osis()).toEqual("Gen.22.1-Gen.22.2,Gen.22.9,Gen.22.10-Gen.22.13,Gen.22.15-Gen.22.18");
      expect(p.parse("John 3:16~17").osis()).toEqual("John.3.16,John.3.17");
      expect(p.parse("Proverbs 15, Mark 7,8 and 9").osis()).toEqual("Prov.15,Mark.7,Mark.8,Mark.9");
      expect(p.parse("-Job 32:21-22-Col 3:25-Deut 10:17-Ja 2:1-4-Lev 19:15-Rom 2:9-11-Acts 10:34-35-Dt 1:17").osis()).toEqual("Job.32.21-Job.32.22,Col.3.25,Deut.10.17,Jas.2.1-Jas.2.4,Lev.19.15-Rom.2.9,Rom.2.11,Acts.10.34,Acts.10.35,Deut.1.17");
      expect(p.parse("1John3v21,22; 1John5v14,15").osis()).toEqual("1John.3.21,1John.3.22,1John.5.14,1John.5.15");
      expect(p.parse("Deuteronomy 6,7Ecclesiastes 2John 19").osis()).toEqual("Deut.6,Deut.7,Eccl");
      expect(p.parse("Jas 1:26,27. Vs 26- bridle.").osis()).toEqual("Jas.1.26,Jas.1.27,Jas.1.26");
      expect(p.parse("1 Corinthians 4-7 and 8.").osis()).toEqual("1Cor.4-1Cor.7,1Cor.8");
      expect(p.parse("Mark3.4.5.6.7.8.9.10.11").osis()).toEqual("Mark.3.4,Mark.5.6,Mark.7.8,Mark.9.10,Mark.9.11");
      return expect(p.parse("Deut 28 - v66-67 is a real").osis()).toEqual("Deut.28.66-Deut.28.67,Isa");
    });
    it("should handle a `combine` `consecutive_combination_strategy` and a `separate` `sequence_combination_strategy`", function() {
      p.set_options({
        consecutive_combination_strategy: "combine",
        sequence_combination_strategy: "separate"
      });
      expect(p.parse("2 Chronicles 32:32,33").osis()).toEqual("2Chr.32.32-2Chr.32.33");
      expect(p.parse("2 Chronicles 31, 32").osis()).toEqual("2Chr.31-2Chr.32");
      return expect(p.parse("Isa 7:14 (Matt 1:23); 9:1, 2 (Matt 4:15, 16); 22:1").osis()).toEqual("Isa.7.14,Matt.1.23,Matt.9.1-Matt.9.2,Matt.4.15-Matt.4.16,Matt.22.1");
    });
    it("should handle a `separate` `consecutive_combination_strategy` and a `combine` `sequence_combination_strategy`", function() {
      p.set_options({
        consecutive_combination_strategy: "separate",
        sequence_combination_strategy: "combine"
      });
      expect(p.parse("2 Chronicles 32:32,33").osis()).toEqual("2Chr.32.32,2Chr.32.33");
      expect(p.parse("2 Chronicles 31, 32").osis()).toEqual("2Chr.31,2Chr.32");
      return expect(p.parse("Isa 7:14 (Matt 1:23); 9:1, 2 (Matt 4:15, 16); 22:1").osis()).toEqual("Isa.7.14,Matt.1.23,Matt.9.1,Matt.9.2,Matt.4.15,Matt.4.16,Matt.22.1");
    });
    it("should handle B,C,V as a special case", function() {
      expect(p.parse("Matt, 5, 6").osis_and_indices()).toEqual([
        {
          osis: "Matt.5.6",
          indices: [0, 10],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt,5,6, 7, 8").osis_and_indices()).toEqual([
        {
          osis: "Matt.5.6-Matt.5.8",
          indices: [0, 14],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt, 5, 6, 9, 10,").osis_and_indices()).toEqual([
        {
          osis: "Matt.5.6,Matt.5.9-Matt.5.10",
          indices: [0, 17],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt, 5, 6:1").osis_and_indices()).toEqual([
        {
          osis: "Matt.5.1-Matt.6.1",
          indices: [0, 12],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt, 5, 7:1").osis_and_indices()).toEqual([
        {
          osis: "Matt.5,Matt.7.1",
          indices: [0, 12],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt, 7:12, 6:3").osis_and_indices()).toEqual([
        {
          osis: "Matt.7.12,Matt.6.3",
          indices: [0, 15],
          translations: [""]
        }
      ]);
      expect(p.parse("John Matt, 7,12, 6:3 Mark").osis_and_indices()).toEqual([
        {
          osis: "Matt.7.12,Matt.6.3",
          indices: [5, 20],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt, 5").osis_and_indices()).toEqual([
        {
          osis: "Matt.5",
          indices: [0, 7],
          translations: [""]
        }
      ]);
      expect(p.parse("John 2-3, Gen, Matt, 5").osis_and_indices()).toEqual([
        {
          osis: "John.2-John.3,Matt.5",
          indices: [0, 22],
          translations: [""]
        }
      ]);
      return expect(p.parse("John 2-3, Gen, Matt, 5, 6").osis_and_indices()).toEqual([
        {
          osis: "John.2-John.3,Matt.5.6",
          indices: [0, 25],
          translations: [""]
        }
      ]);
    });
    it("should handle an `include` `invalid_sequence_strategy", function() {
      p.set_options({
        invalid_sequence_strategy: "include"
      });
      expect(p.parse("Gen 99, Ha 2").osis_and_indices()).toEqual([
        {
          osis: "Hab.2",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("Genesis 51-Jeremiah 6").osis_and_indices()).toEqual([
        {
          osis: "Jer.6",
          translations: [""],
          indices: [0, 21]
        }
      ]);
      expect(p.parse("Genesis 51, 50").osis_and_indices()).toEqual([
        {
          osis: "Gen.50",
          translations: [""],
          indices: [0, 14]
        }
      ]);
      expect(p.parse("Mk 2, Genesis 51, 50, 51, 47").osis_and_indices()).toEqual([
        {
          osis: "Mark.2,Gen.50,Gen.47",
          translations: [""],
          indices: [0, 28]
        }
      ]);
      return expect(p.parse("Is 67 Mk 2, Genesis 51, 47, Hebrews 51, 7:1").osis_and_indices()).toEqual([
        {
          osis: "Mark.2,Gen.47,Heb.7.1",
          translations: [""],
          indices: [0, 43]
        }
      ]);
    });
    it("should handle an `ignore` `invalid_sequence_strategy", function() {
      p.set_options({
        invalid_sequence_strategy: "ignore"
      });
      expect(p.parse("Gen 99, Ha 2").osis_and_indices()).toEqual([
        {
          osis: "Hab.2",
          translations: [""],
          indices: [8, 12]
        }
      ]);
      expect(p.parse("Genesis 51, 50").osis_and_indices()).toEqual([
        {
          osis: "Gen.50",
          translations: [""],
          indices: [0, 14]
        }
      ]);
      expect(p.parse("Mk 2, Genesis 51, 50, 51, 47").osis_and_indices()).toEqual([
        {
          osis: "Mark.2,Gen.50,Gen.47",
          translations: [""],
          indices: [0, 28]
        }
      ]);
      return expect(p.parse("Is 67 Mk 2, Genesis 51, 47, Hebrews 51, 7:1").osis_and_indices()).toEqual([
        {
          osis: "Mark.2,Gen.47,Heb.7.1",
          translations: [""],
          indices: [6, 43]
        }
      ]);
    });
    it("should handle an `include` `invalid_passage_strategy`", function() {
      p.set_options({
        invalid_passage_strategy: "include"
      });
      expect(p.parse("ge 50:60ff").parsed_entities()[0].entities[0].entities[0].valid.messages).toEqual({
        start_verse_not_exist: 26
      });
      expect(p.parse("ge 51:1").osis_and_indices()).toEqual([]);
      expect(p.parse("matt 29-34").osis_and_translations()).toEqual([]);
      expect(p.parse("heb 0:6").osis()).toEqual("");
      expect(p.parse("1 Kings 45, 12:3").osis_and_translations()).toEqual([["1Kgs.12.3", ""]]);
      return expect(p.parse("ha 67").parsed_entities()[0].entities).toEqual([
        {
          osis: "",
          type: "bc",
          indices: [0, 5],
          translations: [""],
          start: {
            b: "Hab",
            c: 67
          },
          end: {
            b: "Hab",
            c: 67
          },
          entity_id: 0,
          enclosed_indices: void 0,
          entities: [
            {
              start: {
                b: "Hab",
                c: 67
              },
              end: {
                b: "Hab",
                c: 67
              },
              valid: {
                valid: false,
                messages: {
                  start_chapter_not_exist: 3
                }
              },
              alternates: [
                {
                  start: {
                    b: "Hag",
                    c: 67
                  },
                  end: {
                    b: "Hag",
                    c: 67
                  },
                  valid: {
                    valid: false,
                    messages: {
                      start_chapter_not_exist: 2
                    }
                  }
                }
              ],
              type: "bc",
              absolute_indices: [0, 5]
            }
          ]
        }
      ]);
    });
    it("should handle `pre_book` ranges", function() {
      p.set_options({
        book_alone_strategy: "full"
      });
      p.set_options({
        book_sequence_strategy: "ignore"
      });
      p.set_options({
        book_range_strategy: "include"
      });
      expect(p.parse("1-2 Sam").osis_and_indices()).toEqual([
        {
          osis: "1Sam-2Sam",
          translations: [""],
          indices: [0, 7]
        }
      ]);
      expect(p.parse("2-3 John").osis_and_indices()).toEqual([
        {
          osis: "2John-3John",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse("First through Third John").osis_and_indices()).toEqual([
        {
          osis: "1John-3John",
          translations: [""],
          indices: [0, 24]
        }
      ]);
      expect(p.parse("1-2 Sam 3").osis_and_indices()).toEqual([
        {
          osis: "2Sam.3",
          translations: [""],
          indices: [2, 9]
        }
      ]);
      expect(p.parse("Ruth 1-2 Sam").osis_and_indices()).toEqual([
        {
          osis: "Ruth-2Sam",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("Ruth 1-2 Chr").osis_and_indices()).toEqual([
        {
          osis: "Ruth-2Chr",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("Joel 1-2 Chr").osis_and_indices()).toEqual([
        {
          osis: "Joel.1",
          translations: [""],
          indices: [0, 6]
        }
      ]);
      expect(p.parse("1-2 Sam, 1-2 Kings, Ruth 3, 1-3 John").osis_and_indices()).toEqual([
        {
          osis: "2Sam-2Kgs,Ruth.3,Ruth-3John",
          translations: [""],
          indices: [2, 36]
        }
      ]);
      expect(p.parse("1-2 Sam, 1-2 Chronicles, Ruth 3, 1-3 John").osis_and_indices()).toEqual([
        {
          osis: "2Sam-2Chr,Ruth.3,Ruth-3John",
          translations: [""],
          indices: [2, 41]
        }
      ]);
      expect(p.parse("Ez 2. Then 1-3 John (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Ezek.2",
          translations: [""],
          indices: [0, 4]
        }, {
          osis: "1John-3John",
          translations: ["NIV"],
          indices: [11, 25]
        }
      ]);
      expect(p.parse("1-3 John").osis_and_indices()).toEqual([
        {
          osis: "1John-3John",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse("3-3 John").osis_and_indices()).toEqual([
        {
          osis: "3John",
          translations: [""],
          indices: [2, 8]
        }
      ]);
      expect(p.parse("1 and 3 John").osis_and_indices()).toEqual([
        {
          osis: "3John",
          translations: [""],
          indices: [6, 12]
        }
      ]);
      expect(p.parse("Mark 2. Then 1-3 John (NIV), Revelation 6").osis_and_indices()).toEqual([
        {
          osis: "Mark.2",
          translations: [""],
          indices: [0, 6]
        }, {
          osis: "1John-3John",
          translations: ["NIV"],
          indices: [13, 27]
        }, {
          osis: "Rev.6",
          translations: [""],
          indices: [29, 41]
        }
      ]);
      expect(p.parse("Phil 2:4; 1 and 2 Timothy").osis_and_indices()).toEqual([
        {
          osis: "Phil.2.4,Phil.2.1",
          translations: [""],
          indices: [0, 11]
        }
      ]);
      return expect(p.parse("Phil 2:4; 1-2 Timothy").osis_and_indices()).toEqual([
        {
          osis: "Phil.2.4,Phil.2-2Tim.4",
          translations: [""],
          indices: [0, 21]
        }
      ]);
    });
    it("should handle `pre_book` ranges with an `include` `book_sequence_strategy`", function() {
      p.set_options({
        book_alone_strategy: "full"
      });
      p.set_options({
        book_range_strategy: "include"
      });
      p.set_options({
        book_sequence_strategy: "include"
      });
      expect(p.parse("1-2 Sam").osis_and_indices()).toEqual([
        {
          osis: "1Sam-2Sam",
          translations: [""],
          indices: [0, 7]
        }
      ]);
      expect(p.parse("2-3 John").osis_and_indices()).toEqual([
        {
          osis: "2John-3John",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse("First through Third John").osis_and_indices()).toEqual([
        {
          osis: "1John-3John",
          translations: [""],
          indices: [0, 24]
        }
      ]);
      expect(p.parse("1-2 Sam 3").osis_and_indices()).toEqual([
        {
          osis: "2Sam.3",
          translations: [""],
          indices: [2, 9]
        }
      ]);
      expect(p.parse("Numbers 1-2 Sam").osis_and_indices()).toEqual([
        {
          osis: "Num-2Sam",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Ruth 1-2 Sam").osis_and_indices()).toEqual([
        {
          osis: "Ruth-2Sam",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("Ruth 1-2 Chr").osis_and_indices()).toEqual([
        {
          osis: "Ruth-2Chr",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("Joel 1-2 Chr").osis_and_indices()).toEqual([
        {
          osis: "Joel.1,2Chr",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("Ez 2. Then 1-3 John (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Ezek.2",
          translations: [""],
          indices: [0, 4]
        }, {
          osis: "1John-3John",
          translations: ["NIV"],
          indices: [11, 25]
        }
      ]);
      expect(p.parse("Mark 2. Then 1-3 John (NIV), Revelation 6").osis_and_indices()).toEqual([
        {
          osis: "Mark.2",
          translations: [""],
          indices: [0, 6]
        }, {
          osis: "1John-3John",
          translations: ["NIV"],
          indices: [13, 27]
        }, {
          osis: "Rev.6",
          translations: [""],
          indices: [29, 41]
        }
      ]);
      expect(p.parse("1-2 Sam, 1-2 Kings, Ruth 3, 1-3 John").osis_and_indices()).toEqual([
        {
          osis: "2Sam,2Sam-2Kgs,Ruth.3,Ruth-3John",
          translations: [""],
          indices: [2, 36]
        }
      ]);
      return expect(p.parse("1-2 Sam, 1-2 Chronicles, Ruth 3, 1-3 John").osis_and_indices()).toEqual([
        {
          osis: "2Sam,2Sam-2Chr,Ruth.3,Ruth-3John",
          translations: [""],
          indices: [2, 41]
        }
      ]);
    });
    it("should handle Psalm titles", function() {
      expect(p.parse("Ps 3:2, ch 119 title, ch23").osis()).toEqual("Ps.3.2,Ps.119.1,Ps.23");
      expect(p.parse("Ps 3, Title, 4, 6-7 title").osis()).toEqual("Ps.3.1,Ps.3.4,Ps.3.6-Ps.7.1");
      expect(p.parse("Ps 3title4").osis()).toEqual("Ps.3.1,Ps.3.4");
      expect(p.parse("Ps 3title-4").osis()).toEqual("Ps.3.1-Ps.3.4");
      expect(p.parse("Ps 3title-ch 4").osis()).toEqual("Ps.3-Ps.4");
      expect(p.parse("Ps 76 titles").osis_and_indices()).toEqual([
        {
          osis: "Ps.76",
          translations: [""],
          indices: [0, 5]
        }
      ]);
      expect(p.parse("Ps 76 titles, 4").osis_and_indices()).toEqual([
        {
          osis: "Ps.76",
          translations: [""],
          indices: [0, 5]
        }
      ]);
      expect(p.parse("Ps 76 titles, 4, 3 John 2").osis_and_indices()).toEqual([
        {
          osis: "Ps.76",
          translations: [""],
          indices: [0, 5]
        }, {
          osis: "3John.1.2",
          translations: [""],
          indices: [17, 25]
        }
      ]);
      expect(p.parse("Ps 76 titles-3").osis_and_indices()).toEqual([
        {
          osis: "Ps.76",
          translations: [""],
          indices: [0, 5]
        }
      ]);
      expect(p.parse("Ps 3:TITLE, 4 TITLE, 5: TITLE NIV").osis()).toEqual("Ps.3.1,Ps.4.1,Ps.5.1");
      expect(p.parse("Jo 3, title, 4 NIV").osis()).toEqual("John.3-John.4");
      expect(p.parse("Jo 3, title, 4, Ps 2, 3title.").osis_and_indices()).toEqual([
        {
          osis: "John.3-John.4,Ps.2.1-Ps.3.1",
          translations: [""],
          indices: [0, 28]
        }
      ]);
      expect(p.parse("Jo 3, title - 4, Ps 2 title - 3title").osis_and_indices()).toEqual([
        {
          osis: "John.3-John.4,Ps.2.1-Ps.3.1",
          translations: [""],
          indices: [0, 36]
        }
      ]);
      expect(p.parse("Acts 2:22, 27. Title").osis_and_indices()).toEqual([
        {
          osis: "Acts.2.22,Acts.2.27",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      expect(p.parse("Acts 2:22-27. Title").osis_and_indices()).toEqual([
        {
          osis: "Acts.2.22-Acts.2.27",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("Acts 2:22, ch 27. Title").osis_and_indices()).toEqual([
        {
          osis: "Acts.2.22,Acts.27",
          translations: [""],
          indices: [0, 16]
        }
      ]);
      expect(p.parse("Philemon 3, 1. Title").osis_and_indices()).toEqual([
        {
          osis: "Phlm.1.3,Phlm.1.1",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      expect(p.parse("Ps 1;70:title ").osis()).toEqual("Ps.1,Ps.70.1");
      expect(p.parse("2 Timothy 1-10 Title: Encouragement").osis_and_indices()).toEqual([
        {
          osis: "2Tim.1.10",
          translations: [""],
          indices: [0, 14]
        }
      ]);
      expect(p.parse("Ps 3:title=").osis()).toEqual("Ps.3.1");
      expect(p.parse("Ps 3:title and").osis()).toEqual("Ps.3.1");
      expect(p.parse("Matt 3:4a title and").osis_and_indices()).toEqual([
        {
          osis: "Matt.3.4",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Matt 3:4a and.").osis_and_indices()).toEqual([
        {
          osis: "Matt.3.4",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("1st Thessalonaians 37 title - vs. 722 II Choranthians 141").osis()).toEqual("");
      expect(p.parse("Psalms - chapter 128 title MSG").osis()).toEqual("Ps.128.1");
      return expect(p.parse("John 137 chapts. 153 title NKJV").osis_and_indices()).toEqual([]);
    });
    it("should handle parentheses with a `combine` `sequence_combination_strategy`", function() {
      expect(p.parse("Ps 117 (118,119, and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.120",
          translations: [""],
          indices: [0, 25]
        }
      ]);
      expect(p.parse("Ps 117 (118, and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.118,Ps.120",
          translations: [""],
          indices: [0, 21]
        }
      ]);
      expect(p.parse("Ps 117 (119, and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117,Ps.119-Ps.120",
          translations: [""],
          indices: [0, 21]
        }
      ]);
      expect(p.parse("Ps 117(118)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.118",
          translations: [""],
          indices: [0, 11]
        }
      ]);
      expect(p.parse("Ps 119:1, 5 (118:1-2, 4)").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1,Ps.119.5,Ps.118.1-Ps.118.2,Ps.118.4",
          translations: [""],
          indices: [0, 24]
        }
      ]);
      expect(p.parse("Ps 119:1, ( 2 )").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1-Ps.119.2",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Ps 119:1, ( 2 ), Matt 5:6 (and 7)").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1-Ps.119.2,Matt.5.6-Matt.5.7",
          translations: [""],
          indices: [0, 33]
        }
      ]);
      expect(p.parse("Acts 19:24, 38 (2)").osis_and_indices()).toEqual([
        {
          osis: "Acts.19.24,Acts.19.38,Acts.19.2",
          translations: [""],
          indices: [0, 18]
        }
      ]);
      expect(p.parse("Hab 1:3 (cf. v. 2 )").osis_and_indices()).toEqual([
        {
          osis: "Hab.1.3,Hab.1.2",
          translations: [""],
          indices: [0, 19]
        }
      ]);
      expect(p.parse("(Hab 1:3 cf. v. 2)").osis_and_indices()).toEqual([
        {
          osis: "Hab.1.3,Hab.1.2",
          translations: [""],
          indices: [1, 17]
        }
      ]);
      expect(p.parse("(Hab 1:3 cf. v. 2)(NIV)").osis_and_indices()).toEqual([
        {
          osis: "Hab.1.3,Hab.1.2",
          translations: ["NIV"],
          indices: [1, 23]
        }
      ]);
      expect(p.parse("Exodus 12:1-4 (5-10) 11-14").osis_and_indices()).toEqual([
        {
          osis: "Exod.12.1-Exod.12.14",
          translations: [""],
          indices: [0, 26]
        }
      ]);
      return expect(p.parse("(Lu 22:32; Rv 3:2) (Jn 17:3) (Jude 3-19)").osis_and_indices()).toEqual([
        {
          osis: "Luke.22.32,Rev.3.2",
          translations: [""],
          indices: [1, 17]
        }, {
          osis: "John.17.3",
          translations: [""],
          indices: [20, 27]
        }, {
          osis: "Jude.1.3-Jude.1.19",
          translations: [""],
          indices: [30, 39]
        }
      ]);
    });
    it("should handle parentheses with a `separate` `sequence_combination_strategy`", function() {
      p.set_options({
        sequence_combination_strategy: "separate"
      });
      expect(p.parse("Ps 117 (118,119, and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.120",
          translations: [""],
          indices: [0, 25]
        }
      ]);
      expect(p.parse("Ps 117 (118, and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.118",
          translations: [""],
          indices: [0, 11]
        }, {
          osis: "Ps.120",
          translations: [""],
          indices: [17, 20]
        }
      ]);
      expect(p.parse("Ps 117 (119, and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117",
          translations: [""],
          indices: [0, 6]
        }, {
          osis: "Ps.119-Ps.120",
          translations: [""],
          indices: [8, 20]
        }
      ]);
      expect(p.parse("Ps 117(118)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.118",
          translations: [""],
          indices: [0, 11]
        }
      ]);
      expect(p.parse("Ps 119:1, 5 (118:1-2, 4)").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1",
          translations: [""],
          indices: [0, 8]
        }, {
          osis: "Ps.119.5",
          translations: [""],
          indices: [10, 11]
        }, {
          osis: "Ps.118.1-Ps.118.2",
          translations: [""],
          indices: [13, 20]
        }, {
          osis: "Ps.118.4",
          translations: [""],
          indices: [22, 23]
        }
      ]);
      expect(p.parse("Ps 119:1, ( 2 )").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1-Ps.119.2",
          translations: [""],
          indices: [0, 15]
        }
      ]);
      expect(p.parse("Acts 19:24, 38 (2)").osis_and_indices()).toEqual([
        {
          osis: "Acts.19.24",
          translations: [""],
          indices: [0, 10]
        }, {
          osis: "Acts.19.38",
          translations: [""],
          indices: [12, 14]
        }, {
          osis: "Acts.19.2",
          translations: [""],
          indices: [16, 17]
        }
      ]);
      expect(p.parse("Ps 119:1, ( 2 ), Matt 5:6 and 7").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1-Ps.119.2",
          translations: [""],
          indices: [0, 15]
        }, {
          osis: "Matt.5.6-Matt.5.7",
          translations: [""],
          indices: [17, 31]
        }
      ]);
      expect(p.parse("Ps 119:1, ( 2 ), Matt 5:6 (and 7)").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1-Ps.119.2",
          translations: [""],
          indices: [0, 15]
        }, {
          osis: "Matt.5.6-Matt.5.7",
          translations: [""],
          indices: [17, 33]
        }
      ]);
      expect(p.parse("Ps 119:1, ( 2, cf. 6-10 ), Matt 5:6 (and 7)").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.1-Ps.119.2",
          translations: [""],
          indices: [0, 13]
        }, {
          osis: "Ps.119.6-Ps.119.10",
          translations: [""],
          indices: [19, 23]
        }, {
          osis: "Matt.5.6-Matt.5.7",
          translations: [""],
          indices: [27, 43]
        }
      ]);
      expect(p.parse("Hab 1:3 (cf. v. 2 )").osis_and_indices()).toEqual([
        {
          osis: "Hab.1.3",
          translations: [""],
          indices: [0, 7]
        }, {
          osis: "Hab.1.2",
          translations: [""],
          indices: [13, 17]
        }
      ]);
      expect(p.parse("Hab 1:3 (cf. v. 2 )(NIV)").osis_and_indices()).toEqual([
        {
          osis: "Hab.1.3",
          translations: ["NIV"],
          indices: [0, 7]
        }, {
          osis: "Hab.1.2",
          translations: ["NIV"],
          indices: [13, 24]
        }
      ]);
      expect(p.parse("Exodus 12:1-4 (5-10) 11-14").osis_and_indices()).toEqual([
        {
          osis: "Exod.12.1-Exod.12.14",
          translations: [""],
          indices: [0, 26]
        }
      ]);
      return expect(p.parse("(Lu 22:32; Rv 3:2) (Jn 17:3) (Jude 3-19)").osis_and_indices()).toEqual([
        {
          osis: "Luke.22.32",
          translations: [""],
          indices: [1, 9]
        }, {
          osis: "Rev.3.2",
          translations: [""],
          indices: [11, 17]
        }, {
          osis: "John.17.3",
          translations: [""],
          indices: [20, 27]
        }, {
          osis: "Jude.1.3-Jude.1.19",
          translations: [""],
          indices: [30, 39]
        }
      ]);
    });
    it("should handle nested parentheses with a `combine` `sequence_combination_strategy`", function() {
      expect(p.parse("Ps 117 (118,(119), and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.120",
          translations: [""],
          indices: [0, 27]
        }
      ]);
      expect(p.parse("(Hab 2:3 cf. (ch. (2)) (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Hab.2.3",
          translations: [""],
          indices: [1, 8]
        }
      ]);
      return expect(p.parse("(Hab 1:3 cf. (v. ((2)))(NIV)").osis_and_indices()).toEqual([
        {
          osis: "Hab.1.3",
          translations: [""],
          indices: [1, 8]
        }
      ]);
    });
    it("should handle nested parentheses with a `separate` `sequence_combination_strategy`", function() {
      p.set_options({
        sequence_combination_strategy: "separate"
      });
      expect(p.parse("Ps 117 (118,(119), and 120)").osis_and_indices()).toEqual([
        {
          osis: "Ps.117-Ps.120",
          translations: [""],
          indices: [0, 27]
        }
      ]);
      expect(p.parse("(Hab 2:3 cf. (ch. (2)) (NIV)").osis_and_indices()).toEqual([
        {
          osis: "Hab.2.3",
          translations: [""],
          indices: [1, 8]
        }
      ]);
      return expect(p.parse("(Hab 1:3 cf. (v. ((2)))(NIV)").osis_and_indices()).toEqual([
        {
          osis: "Hab.1.3",
          translations: [""],
          indices: [1, 8]
        }
      ]);
    });
    it("should handle parentheses with a lone start book", function() {
      expect(p.parse("Matt (Mark Luke 1:1)").osis_and_indices()).toEqual([
        {
          osis: "Luke.1.1",
          indices: [11, 19],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark Luke 1:2) John").osis_and_indices()).toEqual([
        {
          osis: "Luke.1.2",
          indices: [11, 19],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark Luke 1:3, John)").osis_and_indices()).toEqual([
        {
          osis: "Luke.1.3",
          indices: [11, 19],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark Luke 1:4, John) Acts").osis_and_indices()).toEqual([
        {
          osis: "Luke.1.4",
          indices: [11, 19],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark Luke 1:5, John Acts 1)").osis_and_indices()).toEqual([
        {
          osis: "Luke.1.5,Acts.1",
          indices: [11, 32],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark Luke 1:6, John Acts 1) Rom").osis_and_indices()).toEqual([
        {
          osis: "Luke.1.6,Acts.1",
          indices: [11, 32],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark Luke 1:7, John Acts 1, Rom) 1Cor").osis_and_indices()).toEqual([
        {
          osis: "Luke.1.7,Acts.1",
          indices: [11, 32],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark 1:1)").osis_and_indices()).toEqual([
        {
          osis: "Mark.1.1",
          indices: [6, 14],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark 1:2) Luke").osis_and_indices()).toEqual([
        {
          osis: "Mark.1.2",
          indices: [6, 14],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark 1:3 Luke)").osis_and_indices()).toEqual([
        {
          osis: "Mark.1.3",
          indices: [6, 14],
          translations: [""]
        }
      ]);
      expect(p.parse("Matt (Mark 1:4 Luke John 1:1)").osis_and_indices()).toEqual([
        {
          osis: "Mark.1.4,John.1.1",
          indices: [6, 28],
          translations: [""]
        }
      ]);
      return expect(p.parse("Matt (Mark 1:5 Luke John 1:1) Acts").osis_and_indices()).toEqual([
        {
          osis: "Mark.1.5,John.1.1",
          indices: [6, 28],
          translations: [""]
        }
      ]);
    });
    it("should round-trip OSIS references", function() {
      var bc, bcv, bcv_range, book, books, j, len, results;
      p.set_options({
        osis_compaction_strategy: "bc"
      });
      books = ["Gen", "Exod", "Lev", "Num", "Deut", "Josh", "Judg", "Ruth", "1Sam", "2Sam", "1Kgs", "2Kgs", "1Chr", "2Chr", "Ezra", "Neh", "Esth", "Job", "Ps", "Prov", "Eccl", "Song", "Isa", "Jer", "Lam", "Ezek", "Dan", "Hos", "Joel", "Amos", "Obad", "Jonah", "Mic", "Nah", "Hab", "Zeph", "Hag", "Zech", "Mal", "Matt", "Mark", "Luke", "John", "Acts", "Rom", "1Cor", "2Cor", "Gal", "Eph", "Phil", "Col", "1Thess", "2Thess", "1Tim", "2Tim", "Titus", "Phlm", "Heb", "Jas", "1Pet", "2Pet", "1John", "2John", "3John", "Jude", "Rev"];
      results = [];
      for (j = 0, len = books.length; j < len; j++) {
        book = books[j];
        bc = book + ".1";
        bcv = bc + ".1";
        bcv_range = bcv + "-" + bc + ".2";
        expect(p.parse(bc).osis()).toEqual(bc);
        expect(p.parse(bcv).osis()).toEqual(bcv);
        results.push(expect(p.parse(bcv_range).osis()).toEqual(bcv_range));
      }
      return results;
    });
    it("should handle books preceded by `\\w`", function() {
      expect(p.parse("1Matt2").osis_and_indices()).toEqual([]);
      expect(p.parse("1 Matt2").osis_and_indices()).toEqual([
        {
          osis: "Matt.2",
          translations: [""],
          indices: [2, 7]
        }
      ]);
      expect(p.parse("1Matt2John1").osis_and_indices()).toEqual([]);
      expect(p.parse("1 Matt2John1").osis_and_indices()).toEqual([
        {
          osis: "2John",
          translations: [""],
          indices: [6, 12]
        }
      ]);
      expect(p.parse("1 Matt2Phlm3").osis_and_indices()).toEqual([
        {
          osis: "Matt.2,Phlm.1.3",
          translations: [""],
          indices: [2, 12]
        }
      ]);
      expect(p.parse("1Matt2-4Phlm3").osis_and_indices()).toEqual([]);
      expect(p.parse("1 Matt2-4John3").osis_and_indices()).toEqual([
        {
          osis: "Matt.2-Matt.4,John.3",
          translations: [""],
          indices: [2, 14]
        }
      ]);
      expect(p.parse("1John1:2John2").osis_and_indices()).toEqual([
        {
          osis: "1John.1,2John.1.2",
          translations: [""],
          indices: [0, 13]
        }
      ]);
      return expect(p.parse("1John21John2").osis_and_indices()).toEqual([
        {
          osis: "John.2",
          translations: [""],
          indices: [7, 12]
        }
      ]);
    });
    it("should handle alternate names for books", function() {
      expect(p.parse("1 Kingdoms 1:1").osis()).toEqual("1Sam.1.1");
      expect(p.parse("2 Kingdoms 1:1").osis()).toEqual("2Sam.1.1");
      expect(p.parse("Third Kingdoms 1:1").osis()).toEqual("1Kgs.1.1");
      expect(p.parse("4th Kingdoms 1:1").osis()).toEqual("2Kgs.1.1");
      expect(p.parse("paralipomenon 1:1").osis()).toEqual("1Chr.1.1");
      return expect(p.parse("2 Paralipomenon 1:1").osis()).toEqual("2Chr.1.1");
    });
    it("should handle translations with different book orders when setting the `versification_system` manually", function() {
      var j, kjv, len, nab, query, ref, results, tests;
      p.include_apocrypha(true);
      tests = [["Genesis 1 to Exodus 2", "Gen.1-Exod.2", "Gen.1-Exod.2"], ["1 Esdras 1 to Tobit 2", "1Esd.1,Tob.2", "1Esd.1-Tob.2"], ["2 Esdras 3\u2014Tobit 5", "2Esd.3,Tob.5", "2Esd.3-Tob.5"]];
      results = [];
      for (j = 0, len = tests.length; j < len; j++) {
        ref = tests[j], query = ref[0], kjv = ref[1], nab = ref[2];
        p.set_options({
          versification_system: "default"
        });
        expect(p.parse("" + query).osis()).toEqual(kjv);
        p.set_options({
          versification_system: "nab"
        });
        results.push(expect(p.parse("" + query).osis()).toEqual(nab));
      }
      return results;
    });
    it("should handle translations with different book orders in parsed strings", function() {
      var j, kjv, len, nab, query, ref, results, tests;
      p.include_apocrypha(true);
      tests = [["Genesis 1 to Exodus 2", "Gen.1-Exod.2", "Gen.1-Exod.2"], ["1 Esdras 1 to Tobit 2", "1Esd.1,Tob.2", "1Esd.1-Tob.2"], ["2 Esdras 3\u2014Tobit 5", "2Esd.3,Tob.5", "2Esd.3-Tob.5"]];
      results = [];
      for (j = 0, len = tests.length; j < len; j++) {
        ref = tests[j], query = ref[0], kjv = ref[1], nab = ref[2];
        expect(p.parse(query + " KJV").osis()).toEqual(kjv);
        results.push(expect(p.parse(query + " NAB").osis()).toEqual(nab));
      }
      return results;
    });
    it("should handle long strings", function() {
      var i, j, string, strings;
      strings = [];
      for (i = j = 1; j <= 1001; i = ++j) {
        strings.push("John.1");
      }
      string = strings.join(",");
      expect(p.parse(string).osis()).toEqual(string);
      return expect(p.parse("Ps 1,Ps 1,Ps 1,Ps 1,Ps 1,Ps 1,Ps 1,Ps 1,Ps 1,Ps 1,Psalm 1").osis()).toEqual("Ps.1,Ps.1,Ps.1,Ps.1,Ps.1,Ps.1,Ps.1,Ps.1,Ps.1,Ps.1,Ps.1");
    });
    it("should handle weird invalid ranges", function() {
      p.set_options({
        book_alone_strategy: "first_chapter",
        book_sequence_strategy: "include",
        book_range_strategy: "include"
      });
      expect(p.parse("Ti 8- Nu 9- Ma 10- Re").osis()).toEqual("Num.9,Matt.10-Rev.22");
      expect(p.parse("EX34 9PH to CO7").osis()).toEqual("Exod.34.9,Phil-Col");
      expect(p.parse("Proverbs 31:2. Vs 10 to dan").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10-Dan.12.13",
          translations: [""],
          indices: [0, 27]
        }
      ]);
      expect(p.parse("Proverbs 31:2. Vs 10 to dan. Is a good").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10-Dan.12.13,Isa.1",
          translations: [""],
          indices: [0, 31]
        }
      ]);
      expect(p.parse("Proverbs 31:2. Vs 10 to dan. Is a (NIV) good").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10-Dan.12.13,Isa.1",
          translations: ["NIV"],
          indices: [0, 39]
        }
      ]);
      expect(p.parse("Proverbs 31:2. Vs 10 to dan (NIV). Is a good").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10-Dan.12.13",
          translations: ["NIV"],
          indices: [0, 33]
        }, {
          osis: "Isa.1",
          translations: [""],
          indices: [35, 37]
        }
      ]);
      p.set_options({
        book_alone_strategy: "ignore",
        book_sequence_strategy: "ignore",
        book_range_strategy: "ignore"
      });
      expect(p.parse("Ti 8- Nu 9- Ma 10- Re").osis()).toEqual("Num.9,Matt.10");
      expect(p.parse("EX34 9PH to CO7").osis()).toEqual("Exod.34.9,Col.4");
      expect(p.parse("Proverbs 31:2. Vs 10 to dan").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10",
          translations: [""],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Proverbs 31:2. Vs 10 to dan. Is a good").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10",
          translations: [""],
          indices: [0, 20]
        }
      ]);
      expect(p.parse("Proverbs 31:2. Vs 10 to dan. Is a (NIV) good").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10",
          translations: ["NIV"],
          indices: [0, 39]
        }
      ]);
      return expect(p.parse("Proverbs 31:2. Vs 10 to dan (NIV). Is a (NIV) good").osis_and_indices()).toEqual([
        {
          osis: "Prov.31.2,Prov.31.10",
          translations: ["NIV"],
          indices: [0, 33]
        }
      ]);
    });
    it("should handle ambiguous books", function() {
      expect(p.parse("Ph 80").osis()).toEqual("");
      expect(p.parse("Ph 1:4").osis()).toEqual("Phil.1.4");
      expect(p.parse("Ph 80 KJV").osis_and_translations()).toEqual([]);
      expect(p.parse("Ph 1:4 KJV").osis_and_translations()).toEqual([["Phil.1.4", "KJV"]]);
      expect(p.parse_with_context("Ph 1:4 KJV", "Mark 2:3 NIV").osis_and_translations()).toEqual([["Phil.1.4", "KJV"]]);
      expect(p.parse_with_context("Ph 1:5", "Mark 2:3 NIV").osis_and_translations()).toEqual([["Phil.1.5", ""]]);
      expect(p.parse("Ph 1:6, Ma 1:1 NIV").osis_and_translations()).toEqual([["Phil.1.6,Matt.1.1", "NIV"]]);
      expect(p.parse("Ph 1:7 ESV, Ma 1:2 NIV").osis_and_translations()).toEqual([["Phil.1.7", "ESV"], ["Matt.1.2", "NIV"]]);
      return expect(p.parse("Ph 3 ESV, Ma 3 NIV").osis_and_translations()).toEqual([["Phil.3", "ESV"], ["Matt.3", "NIV"]]);
    });
    it("should handle `single_chapter_1_strategy`", function() {
      p.set_options({
        book_range_strategy: "include"
      });
      expect(p.parse("Jude 1").osis()).toEqual("Jude");
      expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1");
      expect(p.parse("Jude 1-2").osis()).toEqual("Jude.1.1-Jude.1.2");
      expect(p.parse("Jude 1:1-4").osis()).toEqual("Jude.1.1-Jude.1.4");
      expect(p.parse("Titus 2-Philemon 1").osis()).toEqual("Titus.2-Phlm.1");
      expect(p.parse("Titus 3-Philemon").osis()).toEqual("Titus.3-Phlm.1");
      p.set_options({
        single_chapter_1_strategy: "verse"
      });
      expect(p.parse("Jude 1").osis()).toEqual("Jude.1.1");
      expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1");
      expect(p.parse("Jude 1-2").osis()).toEqual("Jude.1.1-Jude.1.2");
      expect(p.parse("Jude 1:1-4").osis()).toEqual("Jude.1.1-Jude.1.4");
      expect(p.parse("Titus 2-Philemon 1").osis()).toEqual("Titus.2.1-Phlm.1.1");
      return expect(p.parse("Titus 3-Philemon").osis()).toEqual("Titus.3-Phlm.1");
    });
    return it("should handle a `punctuation_strategy` switch", function() {
      expect(p.parse("Matt 1, 2. 3").osis()).toEqual("Matt.1,Matt.2.3");
      p.set_options({
        punctuation_strategy: "eu"
      });
      expect(p.options.punctuation_strategy).toEqual("eu");
      expect(p.parse("Matt 2, 3. 4").osis()).toEqual("Matt.2.3-Matt.2.4");
      p.set_options({
        punctuation_strategy: "unknown"
      });
      expect(p.options.punctuation_strategy).toEqual("unknown");
      expect(p.parse("Matt 3, 4. 5").osis()).toEqual("Matt.3,Matt.4.5");
      p.set_options({
        punctuation_strategy: "us"
      });
      expect(p.options.punctuation_strategy).toEqual("us");
      expect(p.parse("Matt 4, 5. 6 NIV, 7").osis()).toEqual("Matt.4,Matt.5.6,Matt.5.7");
      p.set_options({
        punctuation_strategy: "unknown"
      });
      expect(p.options.punctuation_strategy).toEqual("unknown");
      return expect(p.parse("Matt 5, 6. 7").osis()).toEqual("Matt.5,Matt.6.7");
    });
  });

  describe("Apocrypha parsing", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      p.options.osis_compaction_strategy = "b";
      return p.options.sequence_combination_strategy = "combine";
    });
    it("should round-trip OSIS Apocrypha references", function() {
      var bc, bcv, bcv_range, book, books, j, k, len, len1, results;
      p.set_options({
        osis_compaction_strategy: "bc",
        ps151_strategy: "b"
      });
      p.include_apocrypha(true);
      books = ["Tob", "Jdt", "GkEsth", "Wis", "Sir", "Bar", "PrAzar", "Sus", "Bel", "SgThree", "EpJer", "1Macc", "2Macc", "3Macc", "4Macc", "1Esd", "2Esd", "PrMan", "Ps151"];
      for (j = 0, len = books.length; j < len; j++) {
        book = books[j];
        bc = book + ".1";
        bcv = bc + ".1";
        bcv_range = bcv + "-" + bc + ".2";
        expect(p.parse(bc).osis()).toEqual(bc);
        expect(p.parse(bcv).osis()).toEqual(bcv);
        expect(p.parse(bcv_range).osis()).toEqual(bcv_range);
      }
      p.set_options({
        ps151_strategy: "c"
      });
      expect(p.parse("Ps151.1").osis()).toEqual("Ps.151");
      expect(p.parse("Ps151.1.1").osis()).toEqual("Ps.151.1");
      expect(p.parse("Ps151.1-Ps151.2").osis()).toEqual("Ps.151.1-Ps.151.2");
      p.include_apocrypha(false);
      results = [];
      for (k = 0, len1 = books.length; k < len1; k++) {
        book = books[k];
        bc = book + ".1";
        results.push(expect(p.parse(bc).osis()).toEqual(""));
      }
      return results;
    });
    it("should not die when turning off the Apocrypha between `parse()` and output", function() {
      p.include_apocrypha(true);
      p.parse("Epistle of Jeremiah 3 NRSV");
      expect(p.osis_and_indices()).toEqual([
        {
          osis: "EpJer.1.3",
          translations: ["NRSV"],
          indices: [0, 26]
        }
      ]);
      p.include_apocrypha(false);
      expect(p.osis_and_indices()).toEqual([
        {
          osis: "EpJer.1.3",
          translations: ["NRSV"],
          indices: [0, 26]
        }
      ]);
      p.include_apocrypha(true);
      expect(p.osis_and_indices()).toEqual([
        {
          osis: "EpJer.1.3",
          translations: ["NRSV"],
          indices: [0, 26]
        }
      ]);
      p.parse("Epistle of Jeremiah 4, Jeremiah 4 NRSV");
      expect(p.osis_and_indices()).toEqual([
        {
          osis: "EpJer.1.4,Jer.4",
          translations: ["NRSV"],
          indices: [0, 38]
        }
      ]);
      p.include_apocrypha(false);
      expect(p.osis_and_indices()).toEqual([
        {
          osis: "EpJer.1.4,Jer.4",
          translations: ["NRSV"],
          indices: [0, 38]
        }
      ]);
      p.include_apocrypha(true);
      expect(p.osis_and_indices()).toEqual([
        {
          osis: "EpJer.1.4,Jer.4",
          translations: ["NRSV"],
          indices: [0, 38]
        }
      ]);
      return p.include_apocrypha(false);
    });
    it("should handle Apocrypha ranges", function() {
      p.include_apocrypha(true);
      expect(p.parse("Rev 21-Tobit 3").osis()).toEqual("Rev.21-Tob.3");
      return p.include_apocrypha(false);
    });
    it("should handle `pre_book` ranges in the Apocrypha", function() {
      p.set_options({
        book_alone_strategy: "full"
      });
      p.set_options({
        book_range_strategy: "include"
      });
      p.include_apocrypha(true);
      expect(p.parse("1-3 Macc").osis_and_indices()).toEqual([
        {
          osis: "1Macc-3Macc",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse("1 and 4 Macc").osis_and_indices()).toEqual([
        {
          osis: "4Macc",
          translations: [""],
          indices: [6, 12]
        }
      ]);
      expect(p.parse("2 and 3 Macc").osis_and_indices()).toEqual([
        {
          osis: "2Macc-3Macc",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      expect(p.parse("2 and 4 Macc").osis_and_indices()).toEqual([
        {
          osis: "4Macc",
          translations: [""],
          indices: [6, 12]
        }
      ]);
      expect(p.parse("1-4 Macc").osis_and_indices()).toEqual([
        {
          osis: "1Macc-4Macc",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse("2-4 Macc").osis_and_indices()).toEqual([
        {
          osis: "2Macc-4Macc",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      expect(p.parse("3-3 Macc").osis_and_indices()).toEqual([
        {
          osis: "3Macc",
          translations: [""],
          indices: [2, 8]
        }
      ]);
      expect(p.parse("3-4 Macc").osis_and_indices()).toEqual([
        {
          osis: "3Macc-4Macc",
          translations: [""],
          indices: [0, 8]
        }
      ]);
      return expect(p.parse("3 and 4 Macc").osis_and_indices()).toEqual([
        {
          osis: "3Macc-4Macc",
          translations: [""],
          indices: [0, 12]
        }
      ]);
    });
    it("should handle Psalm 151 with the Apocrypha enabled and `ps151_strategy` = `b`", function() {
      var j, k, len, len1, ref, ref1, result, test, tests;
      p.set_options({
        osis_compaction_strategy: "bc",
        include_apocrypha: true,
        ps151_strategy: "b"
      });
      tests = [["Ps 149, 151, 2", "Ps.149,Ps151.1,Ps.2"], ["Ps 150, 151, 2", "Ps.150,Ps151.1,Ps.2"], ["Ps 151", "Ps151.1"], ["Ps 151:2", "Ps151.1.2"], ["Ps 151 title", "Ps151.1.1"], ["151st Psalm", "Ps151.1"], ["151st Psalm, verse 2", "Ps151.1.2"], ["Ps 119-150, 151, 2", "Ps.119-Ps.150,Ps151.1,Ps.2"], ["Ps 151:2,3", "Ps151.1.2-Ps151.1.3"], ["Ps 151:2,4", "Ps151.1.2,Ps151.1.4"], ["Ps 151:2-4", "Ps151.1.2-Ps151.1.4"], ["Ps 151, 2", "Ps151.1,Ps.2"], ["Ps 119, 151:2, 3", "Ps.119,Ps151.1.2-Ps151.1.3"], ["Ps 119, 151:2, 4", "Ps.119,Ps151.1.2,Ps151.1.4"], ["Ps 119, 151 title, 3", "Ps.119,Ps151.1.1,Ps151.1.3"], ["Job 3-Pr 3", "Job.3-Prov.3"], ["Ps 119-151 title", "Ps.119-Ps.150,Ps151.1.1"], ["Ps 149ff", "Ps.149-Ps.150,Ps151.1"], ["chapters 140 to 151 from Psalms", "Ps.140-Ps.150,Ps151.1"], ["Ps 149:2-151:3", "Ps.149.2-Ps.150.6,Ps151.1.1-Ps151.1.3"], ["Ps 149-151", "Ps.149-Ps.150,Ps151.1"], ["Ps 151-Proverbs 3", "Ps151.1,Prov.1-Prov.3"], ["Ps 151:2-Proverbs 3:3", "Ps151.1.2-Ps151.1.7,Prov.1.1-Prov.3.3"], ["Ps 150:5-151:2", "Ps.150.5-Ps.150.6,Ps151.1.1-Ps151.1.2"], ["Ps 150:6-151:2", "Ps.150.6,Ps151.1.1-Ps151.1.2"], ["Ps 150-151", "Ps.150,Ps151.1"], ["Ps 150, 151", "Ps.150,Ps151.1"], ["Ps 149-Psalm 151", "Ps.149-Ps.150,Ps151.1"], ["1 Maccabees 3 through Ps 151, 151:3", "1Macc.3,Ps151.1,Ps151.1.3"], ["Job 3-Ps 151", "Job.3-Ps.150,Ps151.1"], ["Prov 3-Ps 151", "Prov.3,Ps151.1"], ["Ps151.1", "Ps151.1"], ["Ps151.1.3", "Ps151.1.3"], ["Ps151.1.3-Ps151.1.4", "Ps151.1.3-Ps151.1.4"], ["Ps151.1.3-4", "Ps151.1.3-Ps151.1.4"], ["Ps151", "Ps151.1"], ["Ps151.1, 3-4", "Ps151.1,Ps.3-Ps.4"], ["Ps151, 2:3-4", "Ps151.1,Ps.2.3-Ps.2.4"], ["Ps150. 6:3-4", "Ps.150.6,Ps.150.3-Ps.150.4"], ["Ps151. 6:3-4", "Ps151.1.6,Ps151.1.3-Ps151.1.4"], ["Ps151.1 verse 3-4", "Ps151.1.3-Ps151.1.4"], ["Ps151.1:3-4", "Ps151.1.3-Ps151.1.4"], ["Ps151.1 title", "Ps151.1.1"], ["Ps151.1 title-3", "Ps151.1.1-Ps151.1.3"], ["Ps151.1 2", "Ps151.1.2"], ["Ps151.1 2-3", "Ps151.1.2-Ps151.1.3"], ["Ps150.2-Ps151.1.3", "Ps.150.2-Ps.150.6,Ps151.1.1-Ps151.1.3"], ["Ps150.2-Ps151.1", "Ps.150.2-Ps.150.6,Ps151.1"], ["Ps150.2-Ps151", "Ps.150.2-Ps.150.6,Ps151.1"], ["ps151.1.3-ps151.1.4", "Ps151.1.1,Ps151.1.3,Ps151.1.1,Ps151.1.4"], ["ps151.1", "Ps151.1.1"], ["psalms-39-789", "Ps.39-Ps.150,Ps151.1"]];
      for (j = 0, len = tests.length; j < len; j++) {
        ref = tests[j], test = ref[0], result = ref[1];
        expect(p.parse(test).osis()).toEqual(result);
      }
      for (k = 0, len1 = tests.length; k < len1; k++) {
        ref1 = tests[k], test = ref1[0], result = ref1[1];
        expect(p.parse(test + " (KJV)").osis()).toEqual(result);
      }
      expect(p.parse("Ps 150 (151)").osis_and_indices()).toEqual([
        {
          osis: "Ps.150,Ps151.1",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      return expect(p.parse("Ps 150 (151) (KJV)").osis_and_indices()).toEqual([
        {
          osis: "Ps.150,Ps151.1",
          translations: ["KJV"],
          indices: [0, 18]
        }
      ]);
    });
    it("should handle Psalm 151 with the Apocrypha enabled and `ps151_strategy` = `c` (the default)", function() {
      var j, k, len, len1, ref, ref1, result, test, tests;
      p.set_options({
        osis_compaction_strategy: "bc",
        include_apocrypha: true,
        ps151_strategy: "c"
      });
      tests = [["Ps 149, 151, 2", "Ps.149,Ps.151,Ps.2"], ["Ps 150, 151, 2", "Ps.150-Ps.151,Ps.2"], ["Ps 151", "Ps.151"], ["Ps 151:2", "Ps.151.2"], ["Ps 151 title", "Ps.151.1"], ["151st Psalm", "Ps.151"], ["151st Psalm, verse 2", "Ps.151.2"], ["Ps 119-150, 151, 2", "Ps.119-Ps.151,Ps.2"], ["Ps 151:2,3", "Ps.151.2-Ps.151.3"], ["Ps 151:2,4", "Ps.151.2,Ps.151.4"], ["Ps 151:2-4", "Ps.151.2-Ps.151.4"], ["Ps 151, 2", "Ps.151,Ps.2"], ["Ps 119, 151:2, 3", "Ps.119,Ps.151.2-Ps.151.3"], ["Ps 119, 151:2, 4", "Ps.119,Ps.151.2,Ps.151.4"], ["Ps 119, 151 title, 3", "Ps.119,Ps.151.1,Ps.151.3"], ["Job 3-Pr 3", "Job.3-Prov.3"], ["Ps 119-151 title", "Ps.119.1-Ps.151.1"], ["Ps 149ff", "Ps.149-Ps.151"], ["chapters 140 to 151 from Psalms", "Ps.140-Ps.151"], ["Ps 149:2-151:3", "Ps.149.2-Ps.151.3"], ["Ps 149-151", "Ps.149-Ps.151"], ["Ps 151-Proverbs 3", "Ps.151-Prov.3"], ["Ps 151:2-Proverbs 3:3", "Ps.151.2-Prov.3.3"], ["Ps 150:5-151:2", "Ps.150.5-Ps.151.2"], ["Ps 150:6-151:2", "Ps.150.6-Ps.151.2"], ["Ps 150-151", "Ps.150-Ps.151"], ["Ps 150, 151", "Ps.150-Ps.151"], ["Ps 149-Psalm 151", "Ps.149-Ps.151"], ["1 Maccabees 3 through Ps 151, 151:3", "1Macc.3,Ps.151,Ps.151.3"], ["Job 3-Ps 151", "Job.3-Ps.151"], ["Prov 3-Ps 151", "Prov.3,Ps.151"], ["Ps151.1", "Ps.151"], ["Ps151.1.3", "Ps.151.3"], ["Ps151.1.3-Ps151.1.4", "Ps.151.3-Ps.151.4"], ["Ps151.1.3-4", "Ps.151.3-Ps.151.4"], ["Ps151", "Ps.151"], ["Ps151.1, 3-4", "Ps.151,Ps.3-Ps.4"], ["Ps151, 2:3-4", "Ps.151,Ps.2.3-Ps.2.4"], ["Ps150. 6:3-4", "Ps.150.6,Ps.150.3-Ps.150.4"], ["Ps151. 6:3-4", "Ps.151.6,Ps.151.3-Ps.151.4"], ["Ps151.1 verse 3-4", "Ps.151.3-Ps.151.4"], ["Ps151.1:3-4", "Ps.151.3-Ps.151.4"], ["Ps151.1 title", "Ps.151.1"], ["Ps151.1 title-3", "Ps.151.1-Ps.151.3"], ["Ps151.1 2", "Ps.151.2"], ["Ps151.1 2-3", "Ps.151.2-Ps.151.3"], ["Ps150.2-Ps151.1.3", "Ps.150.2-Ps.151.3"], ["Ps150.2-Ps151.1", "Ps.150.2-Ps.151.7"], ["Ps150.2-Ps151", "Ps.150.2-Ps.151.7"], ["ps151.1.3-ps151.1.4", "Ps.151.1,Ps.151.3,Ps.151.1,Ps.151.4"], ["ps151.1", "Ps.151.1"], ["psalms-39-789", "Ps.39-Ps.151"]];
      for (j = 0, len = tests.length; j < len; j++) {
        ref = tests[j], test = ref[0], result = ref[1];
        expect(p.parse(test).osis()).toEqual(result);
      }
      for (k = 0, len1 = tests.length; k < len1; k++) {
        ref1 = tests[k], test = ref1[0], result = ref1[1];
        expect(p.parse(test + " (KJV)").osis()).toEqual(result);
      }
      expect(p.parse("Ps 150 (151)").osis_and_indices()).toEqual([
        {
          osis: "Ps.150-Ps.151",
          translations: [""],
          indices: [0, 12]
        }
      ]);
      return expect(p.parse("Ps 150 (151) (KJV)").osis_and_indices()).toEqual([
        {
          osis: "Ps.150-Ps.151",
          translations: ["KJV"],
          indices: [0, 18]
        }
      ]);
    });
    return it("should handle Psalm 151 with the Apocrypha disabled (the default)", function() {
      var j, k, len, len1, ref, ref1, result, test, tests;
      p.set_options({
        osis_compaction_strategy: "bc",
        include_apocrypha: false
      });
      tests = [["Ps 149, 151, 2", "Ps.149,Ps.2"], ["Ps 150, 151, 2", "Ps.150,Ps.2"], ["Ps 151", ""], ["Ps 151:2", ""], ["Ps 151 title", ""], ["151st Psalm", ""], ["151st Psalm, verse 2", ""], ["Ps 119-150, 151, 2", "Ps.119-Ps.150,Ps.2"], ["Ps 151:2,3", ""], ["Ps 151:2,4", ""], ["Ps 151:2-4", ""], ["Ps 119, 151:2, 3", "Ps.119"], ["Ps 119, 151:2, 4", "Ps.119"], ["Ps 119, 151 title, 3", "Ps.119"], ["Job 3-Pr 3", "Job.3-Prov.3"], ["Ps 119-151 title", "Ps.119-Ps.150"], ["Ps 149ff", "Ps.149-Ps.150"], ["chapters 140 to 151 from Psalms", "Ps.140-Ps.150"], ["Ps 149:2-151:3", "Ps.149.2-Ps.150.6"], ["Ps 149-151", "Ps.149-Ps.150"], ["Ps 151-Proverbs 3", "Prov.3"], ["Ps 151:2-Proverbs 3:3", "Prov.3.3"], ["Ps 150:5-151:2", "Ps.150.5-Ps.150.6"], ["Ps 150:6-151:2", "Ps.150.6"], ["Ps 150-151", "Ps.150"], ["Ps 150, 151", "Ps.150"], ["Ps 149-Psalm 151", "Ps.149-Ps.150"], ["1 Maccabees 3 through Ps 151, 151:3", ""], ["Job 3-Ps 151", "Job.3-Ps.150"], ["Prov 3-Ps 151", "Prov.3"], ["Ps151.1", ""], ["Ps151.1.3", ""], ["Ps151.1.3-Ps151.1.4", ""], ["Ps151.1.3-4", ""], ["Ps151", ""], ["Ps151.1, 3-4", ""], ["Ps151, 2:3-4", "Ps.2.3-Ps.2.4"], ["Ps150. 6:3-4", "Ps.150.6,Ps.150.3-Ps.150.4"], ["Ps151. 6:3-4", ""], ["Ps151.1 verse 3-4", ""], ["Ps151.1:3-4", ""], ["Ps151.1 title", ""], ["Ps151.1 title-3", ""], ["Ps151.1 2", ""], ["Ps151.1 2-3", ""], ["Ps150.2-Ps151.1.3", "Ps.150.2-Ps.150.6"], ["Ps150.2-Ps151.1", "Ps.150.2-Ps.150.6"], ["Ps150.2-Ps151", "Ps.150.2-Ps.150.6"], ["psalms-39-789", "Ps.39-Ps.150"], ["ps151.1.3-ps151.1.4", ""], ["ps151.1", ""]];
      for (j = 0, len = tests.length; j < len; j++) {
        ref = tests[j], test = ref[0], result = ref[1];
        expect(p.parse(test).osis()).toEqual(result);
      }
      for (k = 0, len1 = tests.length; k < len1; k++) {
        ref1 = tests[k], test = ref1[0], result = ref1[1];
        expect(p.parse(test + " (KJV)").osis()).toEqual(result);
      }
      expect(p.parse("Ps 150 (151)").osis_and_indices()).toEqual([
        {
          osis: "Ps.150",
          translations: [""],
          indices: [0, 6]
        }
      ]);
      expect(p.parse("Ps 151, 2").osis_and_indices()).toEqual([
        {
          osis: "Ps.2",
          translations: [""],
          indices: [0, 9]
        }
      ]);
      expect(p.parse("Ps 150 (151) (KJV)").osis_and_indices()).toEqual([
        {
          osis: "Ps.150",
          translations: ["KJV"],
          indices: [0, 18]
        }
      ]);
      return expect(p.parse("Ps 151, 2 (KJV)").osis_and_indices()).toEqual([
        {
          osis: "Ps.2",
          translations: ["KJV"],
          indices: [0, 15]
        }
      ]);
    });
  });

  describe("Passage existence", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = new bcv_parser;
      return p.set_options({
        osis_compaction_strategy: "bc"
      });
    });
    it("should handle reversed ranges", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus 4 to Genesis 2", "Exodus 8 to Genesis 2:7", "Exodus 7:7 to Genesis 2", "Exodus 5:5 to Genesis 2:6", "Mark 2-Matthew 11ff"],
        b: ["Exod.4,Gen.2", "Exod.8,Gen.2.7", "Exod.7.7,Gen.2", "Exod.5.5,Gen.2.6", "Mark.2,Matt.11-Matt.999"],
        bc: ["Exod.4,Gen.2", "Exod.8,Gen.2.7", "Exod.7.7,Gen.2", "Exod.5.5,Gen.2.6", "Mark.2,Matt.11-Matt.28"],
        bcv: ["Exod.4,Gen.2", "Exod.8,Gen.2.7", "Exod.7.7,Gen.2", "Exod.5.5,Gen.2.6", "Mark.2,Matt.11-Matt.28"],
        bv: ["Exod.4,Gen.2", "Exod.8,Gen.2.7", "Exod.7.7,Gen.2", "Exod.5.5,Gen.2.6", "Mark.2,Matt.11-Matt.999"],
        c: ["Exod.4-Gen.2", "Exod.8.1-Gen.2.7", "Exod.7.7-Gen.2.999", "Exod.5.5-Gen.2.6", "Mark.2-Matt.28"],
        cv: ["Exod.4-Gen.2", "Exod.8.1-Gen.2.7", "Exod.7.7-Gen.2.25", "Exod.5.5-Gen.2.6", "Mark.2-Matt.28"],
        v: ["Exod.4-Gen.2", "Exod.8.1-Gen.2.7", "Exod.7.7-Gen.2.25", "Exod.5.5-Gen.2.6", "Mark.2-Matt.999"],
        none: ["Exod.4-Gen.2", "Exod.8.1-Gen.2.7", "Exod.7.7-Gen.2.999", "Exod.5.5-Gen.2.6", "Mark.2-Matt.999"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle start verses not existing", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 52", "Genesis 52:3", "Genesis 51-Exodus 5", "Genesis 51-Exodus 5:9", "Genesis 51:2-Exodus 3", "Genesis 51:2-Exodus 3:3"],
        b: ["Gen.52", "Gen.52.3", "Gen.51-Exod.5", "Gen.51.1-Exod.5.9", "Gen.51.2-Exod.3.999", "Gen.51.2-Exod.3.3"],
        bc: ["", "", "Exod.5", "Exod.5.9", "Exod.3", "Exod.3.3"],
        bcv: ["", "", "Exod.5", "Exod.5.9", "Exod.3", "Exod.3.3"],
        bv: ["Gen.52", "Gen.52.3", "Gen.51-Exod.5", "Gen.51.1-Exod.5.9", "Gen.51.2-Exod.3.22", "Gen.51.2-Exod.3.3"],
        c: ["", "", "Exod.5", "Exod.5.9", "Exod.3", "Exod.3.3"],
        cv: ["", "", "Exod.5", "Exod.5.9", "Exod.3", "Exod.3.3"],
        v: ["Gen.52", "Gen.52.3", "Gen.51-Exod.5", "Gen.51.1-Exod.5.9", "Gen.51.2-Exod.3.22", "Gen.51.2-Exod.3.3"],
        none: ["Gen.52", "Gen.52.3", "Gen.51-Exod.5", "Gen.51.1-Exod.5.9", "Gen.51.2-Exod.3.999", "Gen.51.2-Exod.3.3"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle end verses not existing", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 49-52", "Genesis 49-76", "Genesis 49-52:7", "Genesis 49:2-chapter 52", "Genesis 49:2-51:3"],
        b: ["Gen.49-Gen.52", "Gen.49-Gen.76", "Gen.49.1-Gen.52.7", "Gen.49.2-Gen.52.999", "Gen.49.2-Gen.51.3"],
        bc: ["Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49.2-Gen.50.999", "Gen.49.2-Gen.50.999"],
        bcv: ["Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49.2-Gen.50.26", "Gen.49.2-Gen.50.26"],
        bv: ["Gen.49-Gen.52", "Gen.49-Gen.76", "Gen.49.1-Gen.52.7", "Gen.49.2-Gen.52.999", "Gen.49.2-Gen.51.3"],
        c: ["Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49.2-Gen.50.999", "Gen.49.2-Gen.50.999"],
        cv: ["Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49-Gen.50", "Gen.49.2-Gen.50.26", "Gen.49.2-Gen.50.26"],
        v: ["Gen.49-Gen.52", "Gen.49-Gen.76", "Gen.49.1-Gen.52.7", "Gen.49.2-Gen.52.999", "Gen.49.2-Gen.51.3"],
        none: ["Gen.49-Gen.52", "Gen.49-Gen.76", "Gen.49.1-Gen.52.7", "Gen.49.2-Gen.52.999", "Gen.49.2-Gen.51.3"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          end_range_digits_strategy: "sequence"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle both start and end verses not existing", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 51-52", "Genesis 51-52:4", "Genesis 51:2-chapter 52", "Genesis 51:2-52:3", "Genesis 51:2-Exodus 41", "Genesis 51:2-Exodus 41:4", "Genesis 51-Exodus 41", "Genesis 51-Exodus 41:5"],
        b: ["Gen.51-Gen.52", "Gen.51.1-Gen.52.4", "Gen.51.2-Gen.52.999", "Gen.51.2-Gen.52.3", "Gen.51.2-Exod.41.999", "Gen.51.2-Exod.41.4", "Gen.51-Exod.41", "Gen.51.1-Exod.41.5"],
        bc: ["", "", "", "", "", "", "", ""],
        bcv: ["", "", "", "", "", "", "", ""],
        bv: ["Gen.51-Gen.52", "Gen.51.1-Gen.52.4", "Gen.51.2-Gen.52.999", "Gen.51.2-Gen.52.3", "Gen.51.2-Exod.41.999", "Gen.51.2-Exod.41.4", "Gen.51-Exod.41", "Gen.51.1-Exod.41.5"],
        c: ["", "", "", "", "", "", "", ""],
        cv: ["", "", "", "", "", "", "", ""],
        v: ["Gen.51-Gen.52", "Gen.51.1-Gen.52.4", "Gen.51.2-Gen.52.999", "Gen.51.2-Gen.52.3", "Gen.51.2-Exod.41.999", "Gen.51.2-Exod.41.4", "Gen.51-Exod.41", "Gen.51.1-Exod.41.5"],
        none: ["Gen.51-Gen.52", "Gen.51.1-Gen.52.4", "Gen.51.2-Gen.52.999", "Gen.51.2-Gen.52.3", "Gen.51.2-Exod.41.999", "Gen.51.2-Exod.41.4", "Gen.51-Exod.41", "Gen.51.1-Exod.41.5"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero verses with a `zero_verse_strategy: error`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus 6 to Genesis 2:0", "Exodus 6:5 to Genesis 2:0", "Exodus 6:0 to Genesis 2:0", "Genesis 52:0", "Genesis 49-Exodus 5:0", "Genesis 49-Exodus 41:0", "Genesis 49:3-Exodus 5:0", "Genesis 51-Exodus 5:0", "Genesis 51:0-Exodus 10", "Genesis 51:0-Exodus 3:6", "Genesis 51:2-Exodus 3:0", "Genesis 51:0-Exodus 41:0"],
        b: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "Gen.51", "Exod.10", "Exod.3.6", "Gen.51.2", ""],
        bc: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "", "Exod.10", "Exod.3.6", "", ""],
        bcv: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "", "Exod.10", "Exod.3.6", "", ""],
        bv: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "Gen.51", "Exod.10", "Exod.3.6", "Gen.51.2", ""],
        c: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "", "Exod.10", "Exod.3.6", "", ""],
        cv: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "", "Exod.10", "Exod.3.6", "", ""],
        v: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "Gen.51", "Exod.10", "Exod.3.6", "Gen.51.2", ""],
        none: ["Exod.6", "Exod.6.5", "", "", "Gen.49", "Gen.49", "Gen.49.3", "Gen.51", "Exod.10", "Exod.3.6", "Gen.51.2", ""]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_verse_strategy: "error"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero verses with a `zero_verse_strategy: upgrade`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus 7 to Genesis 2:0", "Exodus 6:5 to Genesis 2:0", "Exodus 6:0 to Genesis 2:0", "Genesis 52:0", "Genesis 49-Exodus 5:0", "Genesis 49-Exodus 41:0", "Genesis 49:3-Exodus 5:0", "Genesis 51-Exodus 5:0", "Genesis 51:0-Exodus 10", "Genesis 51:0-Exodus 3:6", "Genesis 51:2-Exodus 3:0", "Genesis 51:0-Exodus 41:0"],
        b: ["Exod.7,Gen.2.1", "Exod.6.5,Gen.2.1", "Exod.6.1,Gen.2.1", "Gen.52.1", "Gen.49.1-Exod.5.1", "Gen.49.1-Exod.41.1", "Gen.49.3-Exod.5.1", "Gen.51.1-Exod.5.1", "Gen.51-Exod.10", "Gen.51.1-Exod.3.6", "Gen.51.2-Exod.3.1", "Gen.51.1-Exod.41.1"],
        bc: ["Exod.7,Gen.2.1", "Exod.6.5,Gen.2.1", "Exod.6.1,Gen.2.1", "", "Gen.49.1-Exod.5.1", "Gen.49-Exod.40", "Gen.49.3-Exod.5.1", "Exod.5.1", "Exod.10", "Exod.3.6", "Exod.3.1", ""],
        bcv: ["Exod.7,Gen.2.1", "Exod.6.5,Gen.2.1", "Exod.6.1,Gen.2.1", "", "Gen.49.1-Exod.5.1", "Gen.49-Exod.40", "Gen.49.3-Exod.5.1", "Exod.5.1", "Exod.10", "Exod.3.6", "Exod.3.1", ""],
        bv: ["Exod.7,Gen.2.1", "Exod.6.5,Gen.2.1", "Exod.6.1,Gen.2.1", "Gen.52.1", "Gen.49.1-Exod.5.1", "Gen.49.1-Exod.41.1", "Gen.49.3-Exod.5.1", "Gen.51.1-Exod.5.1", "Gen.51-Exod.10", "Gen.51.1-Exod.3.6", "Gen.51.2-Exod.3.1", "Gen.51.1-Exod.41.1"],
        c: ["Exod.7.1-Gen.2.1", "Exod.6.5-Gen.2.1", "Exod.6.1-Gen.2.1", "", "Gen.49.1-Exod.5.1", "Gen.49-Exod.40", "Gen.49.3-Exod.5.1", "Exod.5.1", "Exod.10", "Exod.3.6", "Exod.3.1", ""],
        cv: ["Exod.7.1-Gen.2.1", "Exod.6.5-Gen.2.1", "Exod.6.1-Gen.2.1", "", "Gen.49.1-Exod.5.1", "Gen.49-Exod.40", "Gen.49.3-Exod.5.1", "Exod.5.1", "Exod.10", "Exod.3.6", "Exod.3.1", ""],
        v: ["Exod.7.1-Gen.2.1", "Exod.6.5-Gen.2.1", "Exod.6.1-Gen.2.1", "Gen.52.1", "Gen.49.1-Exod.5.1", "Gen.49.1-Exod.41.1", "Gen.49.3-Exod.5.1", "Gen.51.1-Exod.5.1", "Gen.51-Exod.10", "Gen.51.1-Exod.3.6", "Gen.51.2-Exod.3.1", "Gen.51.1-Exod.41.1"],
        none: ["Exod.7.1-Gen.2.1", "Exod.6.5-Gen.2.1", "Exod.6.1-Gen.2.1", "Gen.52.1", "Gen.49.1-Exod.5.1", "Gen.49.1-Exod.41.1", "Gen.49.3-Exod.5.1", "Gen.51.1-Exod.5.1", "Gen.51-Exod.10", "Gen.51.1-Exod.3.6", "Gen.51.2-Exod.3.1", "Gen.51.1-Exod.41.1"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_verse_strategy: "upgrade"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero verses with a `zero_verse_strategy: allow`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus 7 to Genesis 2:0", "Exodus 6:5 to Genesis 2:0", "Exodus 6:0 to Genesis 2:0", "Genesis 52:0", "Genesis 49-Exodus 5:0", "Genesis 49-Exodus 41:0", "Genesis 49:3-Exodus 5:0", "Genesis 51-Exodus 5:0", "Genesis 51:0-Exodus 10", "Genesis 51:0-Exodus 3:6", "Genesis 51:2-Exodus 3:0", "Genesis 51:0-Exodus 41:0"],
        b: ["Exod.7,Gen.2.0", "Exod.6.5,Gen.2.0", "Exod.6.0,Gen.2.0", "Gen.52.0", "Gen.49.1-Exod.5.0", "Gen.49.1-Exod.41.0", "Gen.49.3-Exod.5.0", "Gen.51.1-Exod.5.0", "Gen.51.0-Exod.10.999", "Gen.51.0-Exod.3.6", "Gen.51.2-Exod.3.0", "Gen.51.0-Exod.41.0"],
        bc: ["Exod.7,Gen.2.0", "Exod.6.5,Gen.2.0", "Exod.6.0,Gen.2.0", "", "Gen.49.1-Exod.5.0", "Gen.49-Exod.40", "Gen.49.3-Exod.5.0", "Exod.5.0", "Exod.10", "Exod.3.6", "Exod.3.0", ""],
        bcv: ["Exod.7,Gen.2.0", "Exod.6.5,Gen.2.0", "Exod.6.0,Gen.2.0", "", "Gen.49.1-Exod.5.0", "Gen.49-Exod.40", "Gen.49.3-Exod.5.0", "Exod.5.0", "Exod.10", "Exod.3.6", "Exod.3.0", ""],
        bv: ["Exod.7,Gen.2.0", "Exod.6.5,Gen.2.0", "Exod.6.0,Gen.2.0", "Gen.52.0", "Gen.49.1-Exod.5.0", "Gen.49.1-Exod.41.0", "Gen.49.3-Exod.5.0", "Gen.51.1-Exod.5.0", "Gen.51.0-Exod.10.29", "Gen.51.0-Exod.3.6", "Gen.51.2-Exod.3.0", "Gen.51.0-Exod.41.0"],
        c: ["Exod.7.1-Gen.2.0", "Exod.6.5-Gen.2.0", "Exod.6.0-Gen.2.0", "", "Gen.49.1-Exod.5.0", "Gen.49-Exod.40", "Gen.49.3-Exod.5.0", "Exod.5.0", "Exod.10", "Exod.3.6", "Exod.3.0", ""],
        cv: ["Exod.7.1-Gen.2.0", "Exod.6.5-Gen.2.0", "Exod.6.0-Gen.2.0", "", "Gen.49.1-Exod.5.0", "Gen.49-Exod.40", "Gen.49.3-Exod.5.0", "Exod.5.0", "Exod.10", "Exod.3.6", "Exod.3.0", ""],
        v: ["Exod.7.1-Gen.2.0", "Exod.6.5-Gen.2.0", "Exod.6.0-Gen.2.0", "Gen.52.0", "Gen.49.1-Exod.5.0", "Gen.49.1-Exod.41.0", "Gen.49.3-Exod.5.0", "Gen.51.1-Exod.5.0", "Gen.51.0-Exod.10.29", "Gen.51.0-Exod.3.6", "Gen.51.2-Exod.3.0", "Gen.51.0-Exod.41.0"],
        none: ["Exod.7.1-Gen.2.0", "Exod.6.5-Gen.2.0", "Exod.6.0-Gen.2.0", "Gen.52.0", "Gen.49.1-Exod.5.0", "Gen.49.1-Exod.41.0", "Gen.49.3-Exod.5.0", "Gen.51.1-Exod.5.0", "Gen.51.0-Exod.10.999", "Gen.51.0-Exod.3.6", "Gen.51.2-Exod.3.0", "Gen.51.0-Exod.41.0"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_verse_strategy: "allow"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters with a `zero_chapter_strategy: error`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-12", "Genesis 0-12:2", "Genesis 0-Exodus 2", "Genesis 0-Exodus 2:3", "Genesis 0-Exodus 0", "Genesis 0-Exodus 0:5", "Genesis 49-Exodus 0", "Genesis 49-Exodus 0:4", "Genesis 49:6-Exodus 0", "Genesis 49:5-Exodus 0:6", "Genesis 51-Exodus 0", "Genesis 51-Exodus 0:7", "Genesis 51:3-Exodus 0", "Genesis 51:4-Exodus 0:4"],
        b: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "Gen.51", "Gen.51", "Gen.51.3", "Gen.51.4"],
        bc: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "", "", "", ""],
        bcv: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "", "", "", ""],
        bv: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "Gen.51", "Gen.51", "Gen.51.3", "Gen.51.4"],
        c: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "", "", "", ""],
        cv: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "", "", "", ""],
        v: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "Gen.51", "Gen.51", "Gen.51.3", "Gen.51.4"],
        none: ["Gen.12", "Gen.12.2", "Exod.2", "Exod.2.3", "", "", "Gen.49", "Gen.49", "Gen.49.6", "Gen.49.5", "Gen.51", "Gen.51", "Gen.51.3", "Gen.51.4"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "error"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters with a `zero_chapter_strategy: upgrade`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-12", "Genesis 0-12:2", "Genesis 0-Exodus 2", "Genesis 0-Exodus 2:3", "Genesis 0-Exodus 0", "Genesis 0-Exodus 0:5", "Genesis 49-Exodus 0", "Genesis 49-Exodus 0:4", "Genesis 49:6-Exodus 0", "Genesis 49:5-Exodus 0:6", "Genesis 51-Exodus 0", "Genesis 51-Exodus 0:7", "Genesis 51:3-Exodus 0", "Genesis 51:4-Exodus 0:4"],
        b: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.999", "Gen.49.5-Exod.1.6", "Gen.51-Exod.1", "Gen.51.1-Exod.1.7", "Gen.51.3-Exod.1.999", "Gen.51.4-Exod.1.4"],
        bc: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.999", "Gen.49.5-Exod.1.6", "Exod.1", "Exod.1.7", "Exod.1", "Exod.1.4"],
        bcv: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.22", "Gen.49.5-Exod.1.6", "Exod.1", "Exod.1.7", "Exod.1", "Exod.1.4"],
        bv: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.22", "Gen.49.5-Exod.1.6", "Gen.51-Exod.1", "Gen.51.1-Exod.1.7", "Gen.51.3-Exod.1.22", "Gen.51.4-Exod.1.4"],
        c: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.999", "Gen.49.5-Exod.1.6", "Exod.1", "Exod.1.7", "Exod.1", "Exod.1.4"],
        cv: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.22", "Gen.49.5-Exod.1.6", "Exod.1", "Exod.1.7", "Exod.1", "Exod.1.4"],
        v: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.22", "Gen.49.5-Exod.1.6", "Gen.51-Exod.1", "Gen.51.1-Exod.1.7", "Gen.51.3-Exod.1.22", "Gen.51.4-Exod.1.4"],
        none: ["Gen.1-Gen.12", "Gen.1.1-Gen.12.2", "Gen.1-Exod.2", "Gen.1.1-Exod.2.3", "Gen.1-Exod.1", "Gen.1.1-Exod.1.5", "Gen.49-Exod.1", "Gen.49.1-Exod.1.4", "Gen.49.6-Exod.1.999", "Gen.49.5-Exod.1.6", "Gen.51-Exod.1", "Gen.51.1-Exod.1.7", "Gen.51.3-Exod.1.999", "Gen.51.4-Exod.1.4"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "upgrade"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters and verses with a `zero_chapter_strategy: error` and `zero_verse_strategy: error`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-Exodus 0:0", "Genesis 0:0-Exodus 0", "Genesis 0:0-14", "Genesis 0:0-chapter 14", "Genesis 0:0-Exodus 3", "Genesis 0:0-Exodus 3:0", "Genesis 0:0-Exodus 3:2", "Genesis 0:0-Exodus 0:0", "Genesis 47-Exodus 0:0", "Genesis 48:0-Exodus 0:0", "Genesis 49:6-Exodus 0:0", "Genesis 51-Exodus 0:0", "Genesis 51:0-Exodus 0:0", "Genesis 52:5-Exodus 0:0"],
        b: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"],
        bc: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        bcv: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        bv: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"],
        c: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        cv: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        v: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"],
        none: ["", "", "", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "error",
          zero_verse_strategy: "error"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters and verses with a `zero_chapter_strategy: error` and `zero_verse_strategy: allow`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-Exodus 0:0", "Genesis 0:0-Exodus 0", "Genesis 0:0-14", "Genesis 0:0-chapter 14", "Genesis 0:0-Exodus 3", "Genesis 0:0-Exodus 3:0", "Genesis 0:0-Exodus 3:2", "Genesis 0:0-Exodus 0:0", "Genesis 47-Exodus 0:0", "Genesis 48:0-Exodus 0:0", "Genesis 49:6-Exodus 0:0", "Genesis 51-Exodus 0:0", "Genesis 51:0-Exodus 0:0", "Genesis 52:5-Exodus 0:0"],
        b: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "Gen.51", "Gen.51.0", "Gen.52.5"],
        bc: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "", "", ""],
        bcv: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "", "", ""],
        bv: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "Gen.51", "Gen.51.0", "Gen.52.5"],
        c: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "", "", ""],
        cv: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "", "", ""],
        v: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "Gen.51", "Gen.51.0", "Gen.52.5"],
        none: ["", "", "", "Gen.14", "Exod.3", "Exod.3.0", "Exod.3.2", "", "Gen.47", "Gen.48.0", "Gen.49.6", "Gen.51", "Gen.51.0", "Gen.52.5"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "error",
          zero_verse_strategy: "allow"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters and verses with a `zero_chapter_strategy: error` and `zero_verse_strategy: upgrade`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-Exodus 0:0", "Genesis 0:0-Exodus 0", "Genesis 0:0-14", "Genesis 0:0-chapter 14", "Genesis 0:0-Exodus 3", "Genesis 0:0-Exodus 3:0", "Genesis 0:0-Exodus 3:2", "Genesis 0:0-Exodus 0:0", "Genesis 47-Exodus 0:0", "Genesis 48:0-Exodus 0:0", "Genesis 49:6-Exodus 0:0", "Genesis 51-Exodus 0:0", "Genesis 51:0-Exodus 0:0", "Genesis 52:5-Exodus 0:0"],
        b: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "Gen.51", "Gen.51.1", "Gen.52.5"],
        bc: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "", "", ""],
        bcv: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "", "", ""],
        bv: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "Gen.51", "Gen.51.1", "Gen.52.5"],
        c: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "", "", ""],
        cv: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "", "", ""],
        v: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "Gen.51", "Gen.51.1", "Gen.52.5"],
        none: ["", "", "", "Gen.14", "Exod.3", "Exod.3.1", "Exod.3.2", "", "Gen.47", "Gen.48.1", "Gen.49.6", "Gen.51", "Gen.51.1", "Gen.52.5"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "error",
          zero_verse_strategy: "upgrade"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters and verses with a `zero_chapter_strategy: upgrade` and `zero_verse_strategy: error`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-Exodus 0:0", "Genesis 0:0-Exodus 0", "Genesis 0:0-14", "Genesis 0:0-chapter 14", "Genesis 0:0-Exodus 3", "Genesis 0:0-Exodus 3:0", "Genesis 0:0-Exodus 3:2", "Genesis 0:0-Exodus 0:0", "Genesis 47-Exodus 0:0", "Genesis 48:0-Exodus 0:0", "Genesis 49:6-Exodus 0:0", "Genesis 51-Exodus 0:0", "Genesis 51:0-Exodus 0:0", "Genesis 52:5-Exodus 0:0"],
        b: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"],
        bc: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        bcv: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        bv: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"],
        c: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        cv: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "", "", ""],
        v: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"],
        none: ["Gen.1", "Exod.1", "Gen.1.14", "Gen.14", "Exod.3", "", "Exod.3.2", "", "Gen.47", "", "Gen.49.6", "Gen.51", "", "Gen.52.5"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "upgrade",
          zero_verse_strategy: "error"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters and verses with a `zero_chapter_strategy: upgrade` and `zero_verse_strategy: allow`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-Exodus 0:0", "Genesis 0:0-Exodus 0", "Genesis 0:0-14", "Genesis 0:0-chapter 14", "Genesis 0:0-Exodus 3", "Genesis 0:0-Exodus 3:0", "Genesis 0:0-Exodus 3:2", "Genesis 0:0-Exodus 0:0", "Genesis 47-Exodus 0:0", "Genesis 48:0-Exodus 0:0", "Genesis 49:6-Exodus 0:0", "Genesis 51-Exodus 0:0", "Genesis 51:0-Exodus 0:0", "Genesis 52:5-Exodus 0:0"],
        b: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.999", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.999", "Gen.1.0-Exod.3.999", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Gen.51.1-Exod.1.0", "Gen.51.0-Exod.1.0", "Gen.52.5-Exod.1.0"],
        bc: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.999", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.999", "Gen.1.0-Exod.3.999", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Exod.1.0", "Exod.1.0", "Exod.1.0"],
        bcv: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.22", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.24", "Gen.1.0-Exod.3.22", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Exod.1.0", "Exod.1.0", "Exod.1.0"],
        bv: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.22", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.24", "Gen.1.0-Exod.3.22", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Gen.51.1-Exod.1.0", "Gen.51.0-Exod.1.0", "Gen.52.5-Exod.1.0"],
        c: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.999", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.999", "Gen.1.0-Exod.3.999", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Exod.1.0", "Exod.1.0", "Exod.1.0"],
        cv: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.22", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.24", "Gen.1.0-Exod.3.22", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Exod.1.0", "Exod.1.0", "Exod.1.0"],
        v: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.22", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.24", "Gen.1.0-Exod.3.22", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Gen.51.1-Exod.1.0", "Gen.51.0-Exod.1.0", "Gen.52.5-Exod.1.0"],
        none: ["Gen.1.1-Exod.1.0", "Gen.1.0-Exod.1.999", "Gen.1.0-Gen.1.14", "Gen.1.0-Gen.14.999", "Gen.1.0-Exod.3.999", "Gen.1.0-Exod.3.0", "Gen.1.0-Exod.3.2", "Gen.1.0-Exod.1.0", "Gen.47.1-Exod.1.0", "Gen.48.0-Exod.1.0", "Gen.49.6-Exod.1.0", "Gen.51.1-Exod.1.0", "Gen.51.0-Exod.1.0", "Gen.52.5-Exod.1.0"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "upgrade",
          zero_verse_strategy: "allow"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle zero chapters and verses with a `zero_chapter_strategy: upgrade` and `zero_verse_strategy: upgrade`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 0-Exodus 0:0", "Genesis 0:0-Exodus 0", "Genesis 0:0-14", "Genesis 0:0-chapter 14", "Genesis 0:0-Exodus 3", "Genesis 0:0-Exodus 3:0", "Genesis 0:0-Exodus 3:2", "Genesis 0:0-Exodus 0:0", "Genesis 47-Exodus 0:0", "Genesis 48:0-Exodus 0:0", "Genesis 49:6-Exodus 0:0", "Genesis 51-Exodus 0:0", "Genesis 51:0-Exodus 0:0", "Genesis 52:5-Exodus 0:0"],
        b: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.52.5-Exod.1.1"],
        bc: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Exod.1.1", "Exod.1.1", "Exod.1.1"],
        bcv: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Exod.1.1", "Exod.1.1", "Exod.1.1"],
        bv: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.52.5-Exod.1.1"],
        c: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Exod.1.1", "Exod.1.1", "Exod.1.1"],
        cv: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Exod.1.1", "Exod.1.1", "Exod.1.1"],
        v: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.52.5-Exod.1.1"],
        none: ["Gen.1.1-Exod.1.1", "Gen.1-Exod.1", "Gen.1.1-Gen.1.14", "Gen.1-Gen.14", "Gen.1-Exod.3", "Gen.1.1-Exod.3.1", "Gen.1.1-Exod.3.2", "Gen.1.1-Exod.1.1", "Gen.47.1-Exod.1.1", "Gen.48.1-Exod.1.1", "Gen.49.6-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.51.1-Exod.1.1", "Gen.52.5-Exod.1.1"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          zero_chapter_strategy: "upgrade",
          zero_verse_strategy: "upgrade"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: ignore`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Genesis to Obadiah", "Obadiah to Genesis", "Genesis to Revelation (KJV)"],
        b: ["", "", "", "", ""],
        bc: ["", "", "", "", ""],
        bcv: ["", "", "", "", ""],
        bv: ["", "", "", "", ""],
        c: ["", "", "", "", ""],
        cv: ["", "", "", "", ""],
        v: ["", "", "", "", ""],
        none: ["", "", "", "", ""]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "ignore"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: first_chapter` and `book_sequence_strategy: ignore` and `book_range_strategy: ignore`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["", "", "", "", ""],
        bc: ["", "", "", "", ""],
        bcv: ["", "", "", "", ""],
        bv: ["", "", "", "", ""],
        c: ["", "", "", "", ""],
        cv: ["", "", "", "", ""],
        v: ["", "", "", "", ""],
        none: ["", "", "", "", ""]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "first_chapter",
          book_sequence_strategy: "ignore",
          book_range_strategy: "ignore"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: first_chapter`, `book_sequence_strategy: ignore` and `book_range_strategy: include`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["", "Gen.1-Exod.999", "", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        bc: ["", "Gen.1-Exod.40", "", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bcv: ["", "Gen.1-Exod.40", "", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bv: ["", "Gen.1-Exod.999", "", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        c: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        cv: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        v: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        none: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "first_chapter",
          book_sequence_strategy: "ignore",
          book_range_strategy: "include"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: first_chapter`, `book_sequence_strategy: include` and `book_range_strategy: ignore", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["Exod.1,Gen.1", "", "Obad.1,Gen.1", "", ""],
        bc: ["Exod.1,Gen.1", "", "Obad.1,Gen.1", "", ""],
        bcv: ["Exod.1,Gen.1", "", "Obad.1,Gen.1", "", ""],
        bv: ["Exod.1,Gen.1", "", "Obad.1,Gen.1", "", ""],
        c: ["", "", "", "", ""],
        cv: ["", "", "", "", ""],
        v: ["", "", "", "", ""],
        none: ["", "", "", "", ""]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "first_chapter",
          book_sequence_strategy: "include",
          book_range_strategy: "ignore"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: first_chapter` and `book_sequence_strategy: include` and `book_range_strategy: include", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["Exod.1,Gen.1", "Gen.1-Exod.999", "Obad.1,Gen.1", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        bc: ["Exod.1,Gen.1", "Gen.1-Exod.40", "Obad.1,Gen.1", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bcv: ["Exod.1,Gen.1", "Gen.1-Exod.40", "Obad.1,Gen.1", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bv: ["Exod.1,Gen.1", "Gen.1-Exod.999", "Obad.1,Gen.1", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        c: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        cv: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        v: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        none: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "first_chapter",
          book_sequence_strategy: "include",
          book_range_strategy: "include"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: full`, `book_sequence_strategy: ignore`, and `book_range_strategy: ignore`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["", "", "", "", ""],
        bc: ["", "", "", "", ""],
        bcv: ["", "", "", "", ""],
        bv: ["", "", "", "", ""],
        c: ["", "", "", "", ""],
        cv: ["", "", "", "", ""],
        v: ["", "", "", "", ""],
        none: ["", "", "", "", ""]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "full",
          book_sequence_strategy: "ignore",
          book_range_strategy: "ignore"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: full`, `book_sequence_strategy: ignore`, and `book_range_strategy: include`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["", "Gen.1-Exod.999", "", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        bc: ["", "Gen.1-Exod.40", "", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bcv: ["", "Gen.1-Exod.40", "", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bv: ["", "Gen.1-Exod.999", "", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        c: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        cv: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        v: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        none: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "full",
          book_sequence_strategy: "ignore",
          book_range_strategy: "include"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: full`, `book_sequence_strategy: include`, and `book_range_strategy: ignore`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["Exod.1-Exod.999,Gen.1-Gen.999", "", "Obad.1,Gen.1-Gen.999", "", ""],
        bc: ["Exod.1-Exod.40,Gen.1-Gen.50", "", "Obad.1,Gen.1-Gen.50", "", ""],
        bcv: ["Exod.1-Exod.40,Gen.1-Gen.50", "", "Obad.1,Gen.1-Gen.50", "", ""],
        bv: ["Exod.1-Exod.999,Gen.1-Gen.999", "", "Obad.1,Gen.1-Gen.999", "", ""],
        c: ["", "", "", "", ""],
        cv: ["", "", "", "", ""],
        v: ["", "", "", "", ""],
        none: ["", "", "", "", ""]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "full",
          book_sequence_strategy: "include",
          book_range_strategy: "ignore"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle book-only ranges with `book_alone_strategy: full`, `book_sequence_strategy: include`, and `book_range_strategy: include`", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Exodus to Genesis", "Genesis to Exodus", "Obadiah to Genesis", "Genesis to Obadiah", "Genesis to Revelation (KJV)"],
        b: ["Exod.1-Exod.999,Gen.1-Gen.999", "Gen.1-Exod.999", "Obad.1,Gen.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        bc: ["Exod.1-Exod.40,Gen.1-Gen.50", "Gen.1-Exod.40", "Obad.1,Gen.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bcv: ["Exod.1-Exod.40,Gen.1-Gen.50", "Gen.1-Exod.40", "Obad.1,Gen.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        bv: ["Exod.1-Exod.999,Gen.1-Gen.999", "Gen.1-Exod.999", "Obad.1,Gen.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        c: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        cv: ["Exod.1-Gen.50", "Gen.1-Exod.40", "Obad.1-Gen.50", "Gen.1-Obad.1", "Gen.1-Rev.22"],
        v: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"],
        none: ["Exod.1-Gen.999", "Gen.1-Exod.999", "Obad.1-Gen.999", "Gen.1-Obad.1", "Gen.1-Rev.999"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy,
          book_alone_strategy: "full",
          book_sequence_strategy: "include",
          book_range_strategy: "include"
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle single-chapter start books", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Obadiah 1-Malachi 5", "Obadiah 1-Malachi 5:8", "Obadiah 1:4-Malachi 5", "Obadiah 1:5-Malachi 5:8", "Obadiah 8-Malachi 5", "Obadiah 9-Malachi 5:8", "Obadiah 24-Malachi 5", "Obadiah 25-Malachi 5:8", "Obadiah 1:28-Malachi 5", "Obadiah 1:29-Malachi 5:8"],
        b: ["Obad.1-Mal.5", "Obad.1.1-Mal.5.8", "Obad.1.4-Mal.5.999", "Obad.1.5-Mal.5.8", "Obad.1.8-Mal.5.999", "Obad.1.9-Mal.5.8", "Obad.1.24-Mal.5.999", "Obad.1.25-Mal.5.8", "Obad.1.28-Mal.5.999", "Obad.1.29-Mal.5.8"],
        bc: ["Obad.1-Mal.4", "Obad.1-Mal.4", "Obad.1.4-Mal.4.999", "Obad.1.5-Mal.4.999", "Obad.1.8-Mal.4.999", "Obad.1.9-Mal.4.999", "Obad.1.24-Mal.4.999", "Obad.1.25-Mal.4.999", "Obad.1.28-Mal.4.999", "Obad.1.29-Mal.4.999"],
        bcv: ["Obad.1-Mal.4", "Obad.1-Mal.4", "Obad.1.4-Mal.4.6", "Obad.1.5-Mal.4.6", "Obad.1.8-Mal.4.6", "Obad.1.9-Mal.4.6", "", "", "", ""],
        bv: ["Obad.1-Mal.5", "Obad.1.1-Mal.5.8", "Obad.1.4-Mal.5.999", "Obad.1.5-Mal.5.8", "Obad.1.8-Mal.5.999", "Obad.1.9-Mal.5.8", "Mal.5", "Mal.5.8", "Mal.5", "Mal.5.8"],
        c: ["Obad.1-Mal.4", "Obad.1-Mal.4", "Obad.1.4-Mal.4.999", "Obad.1.5-Mal.4.999", "Obad.1.8-Mal.4.999", "Obad.1.9-Mal.4.999", "Obad.1.24-Mal.4.999", "Obad.1.25-Mal.4.999", "Obad.1.28-Mal.4.999", "Obad.1.29-Mal.4.999"],
        cv: ["Obad.1-Mal.4", "Obad.1-Mal.4", "Obad.1.4-Mal.4.6", "Obad.1.5-Mal.4.6", "Obad.1.8-Mal.4.6", "Obad.1.9-Mal.4.6", "", "", "", ""],
        v: ["Obad.1-Mal.5", "Obad.1.1-Mal.5.8", "Obad.1.4-Mal.5.999", "Obad.1.5-Mal.5.8", "Obad.1.8-Mal.5.999", "Obad.1.9-Mal.5.8", "Mal.5", "Mal.5.8", "Mal.5", "Mal.5.8"],
        none: ["Obad.1-Mal.5", "Obad.1.1-Mal.5.8", "Obad.1.4-Mal.5.999", "Obad.1.5-Mal.5.8", "Obad.1.8-Mal.5.999", "Obad.1.9-Mal.5.8", "Obad.1.24-Mal.5.999", "Obad.1.25-Mal.5.8", "Obad.1.28-Mal.5.999", "Obad.1.29-Mal.5.8"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });
    it("should handle single-chapter end books", function() {
      var i, j, len, ref, results, strategies, strategy;
      strategies = {
        strings: ["Genesis 49-Obadiah 1", "Genesis 49-Obadiah 32", "Genesis 49-Obadiah 1:1", "Genesis 49-Obadiah 1:33", "Genesis 49-Obadiah 34:1", "Genesis 49:2-Obadiah 1", "Genesis 49:3-Obadiah 35", "Genesis 49:4-Obadiah 1:1", "Genesis 49:5-Obadiah 1:36", "Genesis 49:6-Obadiah 37:1", "Genesis 51-Obadiah 1", "Genesis 51-Obadiah 38", "Genesis 51-Obadiah 1:1", "Genesis 51-Obadiah 1:39", "Genesis 51-Obadiah 40:1", "Genesis 51:2-Obadiah 1", "Genesis 51:3-Obadiah 41", "Genesis 51:4-Obadiah 1:1", "Genesis 51:5-Obadiah 1:42", "Genesis 51:6-Obadiah 43:1"],
        b: ["Gen.49-Obad.1", "Gen.49.1-Obad.1.32", "Gen.49.1-Obad.1.1", "Gen.49.1-Obad.1.33", "Gen.49-Obad.1", "Gen.49.2-Obad.1.999", "Gen.49.3-Obad.1.35", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.36", "Gen.49.6-Obad.1.999", "Gen.51-Obad.1", "Gen.51.1-Obad.1.38", "Gen.51.1-Obad.1.1", "Gen.51.1-Obad.1.39", "Gen.51-Obad.1", "Gen.51.2-Obad.1.999", "Gen.51.3-Obad.1.41", "Gen.51.4-Obad.1.1", "Gen.51.5-Obad.1.42", "Gen.51.6-Obad.1.999"],
        bc: ["Gen.49-Obad.1", "Gen.49.1-Obad.1.32", "Gen.49.1-Obad.1.1", "Gen.49.1-Obad.1.33", "Gen.49-Obad.1", "Gen.49.2-Obad.1.999", "Gen.49.3-Obad.1.35", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.36", "Gen.49.6-Obad.1.999", "Obad.1", "Obad.1.38", "Obad.1.1", "Obad.1.39", "", "Obad.1", "Obad.1.41", "Obad.1.1", "Obad.1.42", ""],
        bcv: ["Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.1-Obad.1.1", "Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.2-Obad.1.21", "Gen.49.3-Obad.1.21", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.21", "Gen.49.6-Obad.1.21", "Obad.1", "", "Obad.1.1", "", "", "Obad.1", "", "Obad.1.1", "", ""],
        bv: ["Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.1-Obad.1.1", "Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.2-Obad.1.21", "Gen.49.3-Obad.1.21", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.21", "Gen.49.6-Obad.1.21", "Gen.51-Obad.1", "Gen.51-Obad.1", "Gen.51.1-Obad.1.1", "Gen.51-Obad.1", "Gen.51-Obad.1", "Gen.51.2-Obad.1.21", "Gen.51.3-Obad.1.21", "Gen.51.4-Obad.1.1", "Gen.51.5-Obad.1.21", "Gen.51.6-Obad.1.21"],
        c: ["Gen.49-Obad.1", "Gen.49.1-Obad.1.32", "Gen.49.1-Obad.1.1", "Gen.49.1-Obad.1.33", "Gen.49-Obad.1", "Gen.49.2-Obad.1.999", "Gen.49.3-Obad.1.35", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.36", "Gen.49.6-Obad.1.999", "Obad.1", "Obad.1.38", "Obad.1.1", "Obad.1.39", "", "Obad.1", "Obad.1.41", "Obad.1.1", "Obad.1.42", ""],
        cv: ["Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.1-Obad.1.1", "Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.2-Obad.1.21", "Gen.49.3-Obad.1.21", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.21", "Gen.49.6-Obad.1.21", "Obad.1", "", "Obad.1.1", "", "", "Obad.1", "", "Obad.1.1", "", ""],
        v: ["Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.1-Obad.1.1", "Gen.49-Obad.1", "Gen.49-Obad.1", "Gen.49.2-Obad.1.21", "Gen.49.3-Obad.1.21", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.21", "Gen.49.6-Obad.1.21", "Gen.51-Obad.1", "Gen.51-Obad.1", "Gen.51.1-Obad.1.1", "Gen.51-Obad.1", "Gen.51-Obad.1", "Gen.51.2-Obad.1.21", "Gen.51.3-Obad.1.21", "Gen.51.4-Obad.1.1", "Gen.51.5-Obad.1.21", "Gen.51.6-Obad.1.21"],
        none: ["Gen.49-Obad.1", "Gen.49.1-Obad.1.32", "Gen.49.1-Obad.1.1", "Gen.49.1-Obad.1.33", "Gen.49-Obad.1", "Gen.49.2-Obad.1.999", "Gen.49.3-Obad.1.35", "Gen.49.4-Obad.1.1", "Gen.49.5-Obad.1.36", "Gen.49.6-Obad.1.999", "Gen.51-Obad.1", "Gen.51.1-Obad.1.38", "Gen.51.1-Obad.1.1", "Gen.51.1-Obad.1.39", "Gen.51-Obad.1", "Gen.51.2-Obad.1.999", "Gen.51.3-Obad.1.41", "Gen.51.4-Obad.1.1", "Gen.51.5-Obad.1.42", "Gen.51.6-Obad.1.999"]
      };
      ref = ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"];
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        strategy = ref[j];
        if (strategies[strategy] == null) {
          continue;
        }
        p.set_options({
          "passage_existence_strategy": strategy
        });
        results.push((function() {
          var k, ref1, results1;
          results1 = [];
          for (i = k = 0, ref1 = strategies.strings.length; 0 <= ref1 ? k < ref1 : k > ref1; i = 0 <= ref1 ? ++k : --k) {
            results1.push(expect(p.parse(strategies.strings[i]).osis()).toEqual(strategies[strategy][i]));
          }
          return results1;
        })());
      }
      return results;
    });

    /*
    	xit "should handle ...template", ->
    		strategies =
    			strings:	["",	"",	"",	"",	]
    			b:			["",			"",			"",			]
    			bc:			["",			"",			"",			]
    			bcv:		["",			"",			"",			]
    			bv:			["",			"",			"",			]
    			c:			["",			"",			"",			]
    			cv:			["",			"",			"",			]
    			v:			["",			"",			"",			]
    			none:		["",			"",			"",			]
    		for strategy in ["b", "bc", "bcv", "bv", "c", "cv", "v", "none"]
    			continue unless strategies[strategy]?
    			p.set_options "passage_existence_strategy": strategy
    			for i in [0 ... strategies.strings.length]
    				expect(p.parse(strategies.strings[i]).osis()).toEqual strategies[strategy][i]
     */
    it("should handle full books with `passage_existence_strategy = b`", function() {
      p.set_options({
        osis_compaction_strategy: "b",
        book_alone_strategy: "full"
      }, p.set_options({
        passage_existence_strategy: "b"
      }));
      expect(p.parse("Genesis").osis()).toEqual("Gen");
      expect(p.parse("Genesis 1-50").osis()).toEqual("Gen.1-Gen.50");
      expect(p.parse("Genesis 1-50:26").osis()).toEqual("Gen.1.1-Gen.50.26");
      expect(p.parse("Genesis 1-50:998").osis()).toEqual("Gen.1.1-Gen.50.998");
      return expect(p.parse("Genesis 1-50:999").osis()).toEqual("Gen.1-Gen.50");
    });
    it("should handle full books with `passage_existence_strategy = bc`", function() {
      p.set_options({
        osis_compaction_strategy: "b",
        book_alone_strategy: "full",
        passage_existence_strategy: "bc"
      });
      expect(p.parse("Genesis").osis()).toEqual("Gen");
      expect(p.parse("Genesis 1-50").osis()).toEqual("Gen");
      expect(p.parse("Genesis 1-50:26").osis()).toEqual("Gen.1.1-Gen.50.26");
      expect(p.parse("Genesis 1-50:998").osis()).toEqual("Gen.1.1-Gen.50.998");
      return expect(p.parse("Genesis 1-50:999").osis()).toEqual("Gen");
    });
    it("should handle full single-chapter books with `passage_existence_strategy = b`", function() {
      p.set_options({
        osis_compaction_strategy: "b",
        book_alone_strategy: "full",
        passage_existence_strategy: "b"
      });
      expect(p.parse("Jude").osis()).toEqual("Jude.1");
      expect(p.parse("Jude 1-25").osis()).toEqual("Jude.1.1-Jude.1.25");
      expect(p.parse("Jude 1:1-26").osis()).toEqual("Jude.1.1-Jude.1.26");
      expect(p.parse("Jude 1-998").osis()).toEqual("Jude.1.1-Jude.1.998");
      expect(p.parse("Jude 1:1-998").osis()).toEqual("Jude.1.1-Jude.1.998");
      expect(p.parse("Jude 1:1-999").osis()).toEqual("Jude.1");
      expect(p.parse("Jude 1-2:2").osis()).toEqual("Jude.1");
      return expect(p.parse("Jude 1-50:999").osis()).toEqual("Jude.1");
    });
    return it("should handle full single-chapter books with `passage_existence_strategy = bc`", function() {
      p.set_options({
        osis_compaction_strategy: "b",
        book_alone_strategy: "full",
        passage_existence_strategy: "bc"
      });
      expect(p.parse("Jude").osis()).toEqual("Jude");
      expect(p.parse("Jude 1-25").osis()).toEqual("Jude.1.1-Jude.1.25");
      expect(p.parse("Jude 1:1-26").osis()).toEqual("Jude.1.1-Jude.1.26");
      expect(p.parse("Jude 1-998").osis()).toEqual("Jude.1.1-Jude.1.998");
      expect(p.parse("Jude 1:1-998").osis()).toEqual("Jude.1.1-Jude.1.998");
      expect(p.parse("Jude 1:1-999").osis()).toEqual("Jude");
      expect(p.parse("Jude 1-2:2").osis()).toEqual("Jude");
      return expect(p.parse("Jude 1-50:999").osis()).toEqual("Jude");
    });
  });

  describe("Documentation compatibility", function() {
    var bcv;
    bcv = {};
    beforeEach(function() {
      bcv = {};
      return bcv = new bcv_parser;
    });
    it("should match `osis()`", function() {
      expect(bcv.parse("John 3:16 NIV").osis()).toEqual("John.3.16");
      expect(bcv.parse("John 3:16-17").osis()).toEqual("John.3.16-John.3.17");
      expect(bcv.parse("John 3:16,18").osis()).toEqual("John.3.16,John.3.18");
      return expect(bcv.parse("John 3:16,18. ### Matthew 1 (NIV, ESV)").osis()).toEqual("John.3.16,John.3.18,Matt.1");
    });
    it("should match `osis_and_translations()`", function() {
      expect(bcv.parse("John 3:16 NIV").osis_and_translations()).toEqual([["John.3.16", "NIV"]]);
      expect(bcv.parse("John 3:16-17").osis_and_translations()).toEqual([["John.3.16-John.3.17", ""]]);
      expect(bcv.parse("John 3:16,18").osis_and_translations()).toEqual([["John.3.16,John.3.18", ""]]);
      return expect(bcv.parse("John 3:16,18. ### Matthew 1 (NIV, ESV)").osis_and_translations()).toEqual([["John.3.16,John.3.18", ""], ["Matt.1", "NIV,ESV"]]);
    });
    it("should match `osis_and_indices()`", function() {
      expect(bcv.parse("John 3:16 NIV").osis_and_indices()).toEqual([
        {
          "osis": "John.3.16",
          "translations": ["NIV"],
          "indices": [0, 13]
        }
      ]);
      expect(bcv.parse("John 3:16-17").osis_and_indices()).toEqual([
        {
          "osis": "John.3.16-John.3.17",
          "translations": [""],
          "indices": [0, 12]
        }
      ]);
      expect(bcv.parse("John 3:16,18").osis_and_indices()).toEqual([
        {
          "osis": "John.3.16,John.3.18",
          "translations": [""],
          "indices": [0, 12]
        }
      ]);
      return expect(bcv.parse("John 3:16,18. ### Matthew 1 (NIV, ESV)").osis_and_indices()).toEqual([
        {
          "osis": "John.3.16,John.3.18",
          "translations": [""],
          "indices": [0, 12]
        }, {
          "osis": "Matt.1",
          "translations": ["NIV", "ESV"],
          "indices": [18, 38]
        }
      ]);
    });
    it("should match `parsed_entities()`", function() {
      bcv.set_options({
        "invalid_passage_strategy": "include",
        "invalid_sequence_strategy": "include"
      });
      return expect(bcv.parse("John 3, 99").parsed_entities()).toEqual([
        {
          "osis": "John.3",
          "indices": [0, 10],
          "translations": [""],
          "entity_id": 0,
          "entities": [
            {
              "osis": "John.3",
              "type": "bc",
              "indices": [0, 6],
              "translations": [""],
              "start": {
                "b": "John",
                "c": 3,
                "v": 1
              },
              "end": {
                "b": "John",
                "c": 3,
                "v": 36
              },
              "enclosed_indices": [-1, -1],
              "entity_id": 0,
              "entities": [
                {
                  "start": {
                    "b": "John",
                    "c": 3,
                    "v": 1
                  },
                  "end": {
                    "b": "John",
                    "c": 3,
                    "v": 36
                  },
                  "valid": {
                    "valid": true,
                    "messages": {}
                  },
                  "type": "bc",
                  "absolute_indices": [0, 6],
                  "enclosed_absolute_indices": [-1, -1]
                }
              ]
            }, {
              "osis": "",
              "type": "integer",
              "indices": [8, 10],
              "translations": [""],
              "start": {
                "b": "John",
                "c": 99
              },
              "end": {
                "b": "John",
                "c": 99
              },
              "enclosed_indices": [-1, -1],
              "entity_id": 0,
              "entities": [
                {
                  "start": {
                    "b": "John",
                    "c": 99
                  },
                  "end": {
                    "b": "John",
                    "c": 99
                  },
                  "valid": {
                    "valid": false,
                    "messages": {
                      "start_chapter_not_exist": 21
                    }
                  },
                  "type": "integer",
                  "absolute_indices": [8, 10],
                  "enclosed_absolute_indices": [-1, -1]
                }
              ]
            }
          ]
        }
      ]);
    });
    it("should match `include_apocrypha()`", function() {
      expect(bcv.parse("Tobit 1").osis()).toEqual("");
      bcv.include_apocrypha(true);
      return expect(bcv.parse("Tobit 1").osis()).toEqual("Tob.1");
    });
    it("should match `set_options()`", function() {
      bcv.set_options({
        "osis_compaction_strategy": "bcv"
      });
      return expect(bcv.parse("Genesis 1").osis()).toEqual("Gen.1.1-Gen.1.31");
    });
    return it("should handle `punctuation_strategy` examples in the documentation", function() {
      bcv.set_options({
        punctuation_strategy: "us"
      });
      expect(bcv.parse("Matt 1, 2. 4").osis()).toEqual("Matt.1,Matt.2.4");
      bcv.set_options({
        punctuation_strategy: "eu"
      });
      return expect(bcv.parse("Matt 1, 2. 4").osis()).toEqual("Matt.1.2,Matt.1.4");
    });
  });

  describe("Administrative behavior", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = {};
      return p = new bcv_parser;
    });
    it("should handle `translation_info` given known inputs", function() {
      var esv, nab, niv;
      niv = p.translation_info("niv");
      expect(niv.order["1Esd"]).toEqual(82);
      expect(niv.books[65]).toEqual("Rev");
      expect(niv.books.length).toEqual(84);
      expect(niv.chapters["3John"][0]).toEqual(14);
      expect(p.options.versification_system).toEqual("default");
      expect(niv.alias).toEqual("kjv");
      esv = p.translation_info("esv");
      expect(esv.order["1Esd"]).toEqual(82);
      expect(esv.books[65]).toEqual("Rev");
      expect(esv.books.length).toEqual(84);
      expect(esv.chapters["3John"][0]).toEqual(15);
      expect(p.options.versification_system).toEqual("default");
      expect(esv.alias).toEqual("default");
      nab = p.translation_info("nabre");
      expect(nab.order["1Esd"]).toEqual(18);
      expect(nab.books[65]).toEqual("Gal");
      expect(nab.books.length).toEqual(84);
      expect(nab.chapters["3John"][0]).toEqual(15);
      expect(p.options.versification_system).toEqual("default");
      expect(nab.alias).toEqual("nab");
      nab.order["Gen"] = 15;
      return expect(p.translations["default"].order["Gen"]).toEqual(1);
    });
    it("should handle `translation_info` given unknown inputs", function() {
      var array_response, null_response;
      p.set_options({
        versification_system: "nab"
      });
      array_response = p.translation_info([]);
      null_response = p.translation_info(null);
      expect(array_response.chapters["3John"][0]).toEqual(15);
      return expect(null_response.chapters["3John"][0]).toEqual(15);
    });
    return it("should return `.languages`", function() {
      return expect(p.languages).toEqual(["en"]);
    });
  });

  describe("Real-world parsing", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = {};
      p = new bcv_parser;
      p.options.book_alone_strategy = "ignore";
      p.options.book_sequence_strategy = "ignore";
      p.options.osis_compaction_strategy = "bcv";
      return p.options.captive_end_digits_strategy = "delete";
    });
    return it("should handle sample tweets", function() {
      expect(p.parse("Deut 28:21-65 lists sicknesses that are part of the curse").osis()).toEqual("Deut.28.21-Deut.28.65");
      expect(p.parse("The Bible is awesome! Great noticing the commonalities between Revelation 4 and Isaiah 6! Done work for now.").osis()).toEqual("Rev.4.1-Rev.4.11,Isa.6.1-Isa.6.13");
      expect(p.parse("Verse of the Day: Romans 5:10 - just a few days until Easter (see you at the Rave!)").osis()).toEqual("Rom.5.10");
      expect(p.parse("\"For who is God besides the Lord? And who is a rock? Only our God.\" 2 Sam 22:32 Good word to remember today.").osis()).toEqual("2Sam.22.32");
      expect(p.parse("Reading and reflecting on Philippians 1 & 2. ").osis()).toEqual("Phil.1.1-Phil.2.30");
      expect(p.parse("Reading Numbers 12 & John 11 this morning.").osis()).toEqual("Num.12.1-Num.12.16,John.11.1-John.11.57");
      expect(p.parse("Prov 14:1- The wise woman builds her house, but with her own hands the foolish one tears hers down").osis()).toEqual("Prov.14.1");
      expect(p.parse("Prov 14:1-The wise woman builds her house, but with her own hands the foolish one tears hers down").osis()).toEqual("Prov.14.1");
      expect(p.parse("Prov 14:12- The wise woman builds her house, but with her own hands the foolish one tears hers down").osis()).toEqual("Prov.14.12");
      expect(p.parse("daily Bible reading: Num 20-22; Mark 7:1-13").osis()).toEqual("Num.20.1-Num.22.41,Mark.7.1-Mark.7.13");
      expect(p.parse("later in the week...(Matt 5 and Ex 20)").osis()).toEqual("Matt.5.1-Matt.5.48,Exod.20.1-Exod.20.26");
      expect(p.parse("Answer: Rev 19, sword in mouth, Zech 14, it's over.").osis()).toEqual("Rev.19.1-Rev.19.21,Zech.14.1-Zech.14.21");
      expect(p.parse("LACK of faith. Matthew 13:58....  <3").osis()).toEqual("Matt.13.58");
      expect(p.parse("Matthew 6 : 25-34").osis()).toEqual("Matt.6.25-Matt.6.34");
      expect(p.parse("~~Psalm 17:6a, 8").osis()).toEqual("Ps.17.6,Ps.17.8");
      expect(p.parse("Deut. 32/4 says").osis()).toEqual("Deut.32.1-Deut.32.52,Deut.4.1-Deut.4.49");
      expect(p.parse("Isaiah 50:4-9a Hebrews 12:1-3  John 13..  ").osis()).toEqual("Isa.50.4-Isa.50.9,Heb.12.1-3John.1.13");
      expect(p.parse("speaking from 1 Corinthians 15:22 and this 2 Corinthians 12:9-11 2nite at 7.15pm").osis()).toEqual("1Cor.15.22,2Cor.12.9-2Cor.12.11");
      expect(p.parse("Matt. 5 thru 7...").osis()).toEqual("Matt.5.1-Matt.7.29");
      expect(p.parse("ROM 9 0 9 4").osis()).toEqual("Rom.9.4");
      expect(p.parse("\"For it is by grace you have been saved, through faith--and this not from yourslelves, it is the gift of God...\" Ephesians 2:8,0 NIV").osis()).toEqual("Eph.2.8");
      expect(p.parse("Matthew 13:10-16 10And the disciples came").osis()).toEqual("Matt.13.10-Matt.13.16");
      expect(p.parse("\"Why do you seek the living One among the dead?  He is not here, but He has risen.\" Luke 24:5b-6a").osis()).toEqual("Luke.24.5-Luke.24.6");
      expect(p.parse("Luke 24*5b Resurrection Is Coming").osis()).toEqual("Luke.24.5");
      expect(p.parse("You have to have wisdom and understanding and that comes from God (proverbs 1&2) then you increase your knowledge.").osis()).toEqual("Prov.1.1-Prov.2.22");
      expect(p.parse("\"How shall I repay the Lord for all the good things he has done for me?\"  Psalm 116: Verse 10.  I am reflecting on this on Maundy Thursday.").osis()).toEqual("Ps.116.10");
      expect(p.parse("Happy Good Friday people! Isaiah 54 Verse 15-17 is my personal mantra.  \"No weapon against you will prevail\"").osis()).toEqual("Isa.54.15-Isa.54.17");
      expect(p.parse("  Cant sleep? Check out Isaiah 26:3. Hope this helps. Then read Proverbs Chap 10. The whole chapter. Good night.").osis()).toEqual("Isa.26.3,Prov.10.1-Prov.10.32");
      expect(p.parse("  john 3:16 i memorized it when i was 5.  now i like john 3:16-18..  vs 17 and 18 go with it too. they kinda help/clarify vs 16.").osis()).toEqual("John.3.16,John.3.16-John.3.18,John.3.17-John.3.18");
      expect(p.parse("Matt 4:8/9.").osis()).toEqual("Matt.4.8-Matt.4.9");
      expect(p.parse("Isa41.10ESV fear not for I am with you").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10",
          indices: [0, 11],
          translations: ["ESV"]
        }
      ]);
      expect(p.parse("studying Acts 1:1-14 for a sermon next Sunday... learning more and more about Luke-Acts").osis()).toEqual("Acts.1.1-Acts.1.14");
      expect(p.parse("Matthew 28  1: Now after").osis()).toEqual("Matt.28.1");
      expect(p.parse("EASTER SUNDAY READINGS: Acts of the Apostles 10:34. 37-43; RESPONSORIAL PSALM: Ps 117; Colossians 3:1-4; John 20:1-9.").osis()).toEqual("Acts.10.34,Acts.10.37-Acts.10.43,Ps.117.1-Ps.117.2,Col.3.1-Col.3.4,John.20.1-John.20.9");
      expect(p.parse("1 Thessalonians 3:11-1311Now may our God and Father himself and our Lord Jesus clear the way for us to come to you.").osis()).toEqual("1Thess.3.11");
      expect(p.parse("Acts 10:34, 37-43Psalms 118:1-2").osis()).toEqual("Acts.10.34,Acts.10.37-Acts.10.43,Ps.118.1-Ps.118.2");
      expect(p.parse("Second Reading - Gen 22:1-2, 9a, 10-13, 15-18 ...   ").osis()).toEqual("Gen.22.1-Gen.22.2,Gen.22.9-Gen.22.13,Gen.22.15-Gen.22.18");
      expect(p.parse("Luv Deut 8 Especially Deu 8:18. 4 thou").osis()).toEqual("Deut.8.1-Deut.8.20,Deut.8.18,Deut.8.4");
      expect(p.parse("His ride into Jerusalem ~480 years before the day(Zech 9:9)... his death ~600 years before he spoke his final words on the cross(Ps 22).").osis()).toEqual("Zech.9.9,Ps.22.1-Ps.22.31");
      expect(p.parse(" John 4 \u2013 v22").osis()).toEqual("John.4.22");
      expect(p.parse("Verse of the Week ~ Psalm 89 - 2009.04.11  ").osis()).toEqual("Ps.89.1-Ps.89.52");
      expect(p.parse("Col1:18, 1Th 4:16").osis()).toEqual("Col.1.18,1Thess.4.16");
      expect(p.parse("Matthew 26:28.5").osis()).toEqual("Matt.26.28,Matt.26.5");
      expect(p.parse("1\u00a0Cor\u00a02\u00a01").osis()).toEqual("1Cor.2.1");
      expect(p.parse("Mark \t\u00a0\r\n 9").osis_and_indices()).toEqual([
        {
          osis: "Mark.9.1-Mark.9.50",
          indices: [0, 11],
          translations: [""]
        }
      ]);
      expect(p.parse("He has given proof of ths 2 all men by raising Him from the dead. Acts 17:31").osis()).toEqual("Acts.17.31");
      expect(p.parse("John 3:16~17").osis()).toEqual("John.3.16-John.3.17");
      expect(p.parse("*Romans*8:38-39").osis()).toEqual("Rom.8.38-Rom.8.39");
      expect(p.parse("rev.1:4. \"7 spirits before the throne.\"").osis()).toEqual("Rev.1.4");
      expect(p.parse("April 14:  Deut. 34:1-Joshua 2:24; Psalm 79; Proverbs 12:26; Joshua 2:8-14 The sheer variety of pe..  ").osis()).toEqual("Deut.34.1-Josh.2.24,Ps.79.1-Ps.79.13,Prov.12.26,Josh.2.8-Josh.2.14");
      expect(p.parse("Wednesday's Bible Reading: Proverbs 15, Mark 7,8 and 9  ").osis()).toEqual("Prov.15.1-Prov.15.33,Mark.7.1-Mark.9.50");
      expect(p.parse("Prov.1:20-33 vs.33But whoever").osis()).toEqual("Prov.1.20-Prov.31.31");
      expect(p.parse("read Gal 5:22-25 and1 Cor 13:4-13").osis()).toEqual("Gal.5.22-Gal.5.25,Gal.5.1");
      expect(p.parse("Psalm91-1:2 (1 of my faves)").osis()).toEqual("Ps.91.1-Ps.91.16,Ps.1.2");
      expect(p.parse("Ezekiel 25-16").osis()).toEqual("Ezek.25.16");
      expect(p.parse("Proverbs 22:9;28:27A - 700 Club").osis()).toEqual("Prov.22.9,Prov.28.27");
      expect(p.parse("Psalm 125-1 Love it!").osis()).toEqual("Ps.125.1");
      expect(p.parse("challenged by Eph 4:11-16. Verse 16 is really speaking to me").osis()).toEqual("Eph.4.11-Eph.4.16,Eph.4.16");
      expect(p.parse("John - 4/18/2009 9:20:10 PM").osis()).toEqual("John.4.1-John.4.54,John.18.1-John.18.40");
      expect(p.parse("-Job 32:21-22-Col 3:25-Deut 10:17-Ja 2:1-4-Lev 19:15-Rom 2:9-11-Acts 10:34-35-Dt 1:17").osis()).toEqual("Job.32.21-Job.32.22,Col.3.25,Deut.10.17,Jas.2.1-Jas.2.4,Lev.19.15-Rom.2.9,Rom.2.11,Acts.10.34-Acts.10.35,Deut.1.17");
      expect(p.parse("Revelation 13:11:18").osis()).toEqual("Rev.13.11,Rev.13.18");
      expect(p.parse("===Read Mark chapter 5========Mark 6:30-32 NKJV 30 Then the apostles gathered").osis_and_translations()).toEqual([["Mark.5.1-Mark.5.43", "NKJV"], ["Mark.6.30-Mark.6.32", "NKJV"]]);
      expect(p.parse("look at psalms 42:1, hebrews 13-15, jeremiah 33-11").osis()).toEqual("Ps.42.1,Heb.13.15,Jer.33.11");
      expect(p.parse("Though he fall, he shall not be utterly cast down: for the LORD upholdeth him with his hand. (Psalm 37:,24)").osis()).toEqual("Ps.37.1-Ps.37.40,Ps.24.1-Ps.24.10");
      expect(p.parse("gal?: 4 People").osis()).toEqual("");
      expect(p.parse("1 peter 1-7 1 peter 8-22 Always").osis()).toEqual("1Pet.1.7");
      expect(p.parse("(Psalm 19:1.8)").osis()).toEqual("Ps.19.1,Ps.19.8");
      expect(p.parse("1John3v21,22; 1John5v14,15 #prayer #bibleStudy").osis()).toEqual("1John.3.21-1John.3.22,1John.5.14-1John.5.15");
      expect(p.parse("2 Peter 1:1-11 1 Simon Peter").osis()).toEqual("2Pet.1.1-2Pet.1.11,2Pet.1.1");
      expect(p.parse("2 Corinthians 12-9-10-11").osis()).toEqual("2Cor.12.9-2Cor.12.10,2Cor.12.11");
      expect(p.parse("Philippians 4~6-7").osis()).toEqual("Phil.4.1-Phil.4.23");
      expect(p.parse("Eccl11.7msg").osis_and_translations()).toEqual([["Eccl.11.7", "MSG"]]);
      expect(p.parse("Matthew 12.15_32, rainy").osis()).toEqual("Matt.12.15");
      expect(p.parse("From the Bible,1stTim.4:1-2,1st.John4:1-6.there").osis()).toEqual("1Tim.4.1-1Tim.4.2,1John.4.1-1John.4.6");
      expect(p.parse("for Exodus 20 7th Day of rest.").osis()).toEqual("Exod.20.1-Exod.20.26");
      expect(p.parse("Devotions: John 8:12-30,Luke: 8:4-11,Romans 3:21-26").osis()).toEqual("John.8.12-John.8.30,Luke.8.4-Luke.8.11,Rom.3.21-Rom.3.26");
      expect(p.parse("read isaiah 1-thru-7").osis()).toEqual("Isa.1.1-Isa.7.25");
      expect(p.parse("psalm37::5").osis()).toEqual("Ps.37.5");
      expect(p.parse("Deuteronomy 6,7Ecclesiastes 2John 19").osis()).toEqual("Deut.6.1-Deut.7.26");
      expect(p.parse("Bible study tonight on Colossians 1:13-14 and 1:20+.").osis()).toEqual("Col.1.13-Col.1.14,Col.1.20");
      expect(p.parse("(Heb 11.1nrsv)").osis_and_indices()).toEqual([
        {
          osis: "Heb.11.1",
          indices: [1, 13],
          translations: ["NRSV"]
        }
      ]);
      expect(p.parse("my mouth (HCSB) Psalm 119-103").osis_and_indices()).toEqual([
        {
          osis: "Ps.119.103",
          indices: [16, 29],
          translations: [""]
        }
      ]);
      expect(p.parse("2 Timothy 3;1-5").osis()).toEqual("2Tim.3.1-2Tim.3.17,2Tim.1.5");
      expect(p.parse("2 Timothy 3; NIV, 1-5 ESV").osis_and_translations()).toEqual([["2Tim.3.1-2Tim.3.17", "NIV"], ["2Tim.1.5", "ESV"]]);
      expect(p.parse("2 Timothy 3; NIV, ch. 1 ESV").osis_and_translations()).toEqual([["2Tim.3.1-2Tim.3.17", "NIV"], ["2Tim.1.1-2Tim.1.18", "ESV"]]);
      expect(p.parse("2 Timothy 3; NIV, vv 1-5 ESV").osis_and_indices()).toEqual([
        {
          osis: "2Tim.3.1-2Tim.3.17",
          indices: [0, 16],
          translations: ["NIV"]
        }, {
          osis: "2Tim.3.1-2Tim.3.5",
          indices: [18, 28],
          translations: ["ESV"]
        }
      ]);
      expect(p.parse("2nd Reading: Ecc 6 \u2013 v12 James 4:14.").osis()).toEqual("Eccl.6.12,Jas.4.14");
      expect(p.parse("Jas 1:26,27. Vs 26- bridle.").osis()).toEqual("Jas.1.26-Jas.1.27,Jas.1.26");
      expect(p.parse("Ezekiel - 25-17.mp3").osis()).toEqual("Ezek.25.17");
      expect(p.parse("2 CORITHIANS VERSE 3-11 EPHESIANS 6 -10").osis()).toEqual("2Cor.1.3-2Cor.1.11,Eph.6.10");
      expect(p.parse("1Samuel 16:13 e 16:7! :)").osis()).toEqual("1Sam.16.13,1Sam.16.7");
      expect(p.parse("proverbs 5/18-23").osis()).toEqual("Prov.5.1-Prov.5.23,Prov.18.1-Prov.23.35");
      expect(p.parse("1 Corinthians 4-7 and 8.").osis()).toEqual("1Cor.4.1-1Cor.8.13");
      expect(p.parse("1 Corinthians 12:28,Ephesians 4:7-8, 11-Revelation 18:20").osis()).toEqual("1Cor.12.28,Eph.4.7-Eph.4.8,Eph.4.11-Rev.18.20");
      expect(p.parse("Deut 15 \u2013 v19-23").osis()).toEqual("Deut.15.19-Deut.15.23");
      expect(p.parse("(2Ch 26:15).").osis()).toEqual("2Chr.26.15");
      expect(p.parse("James 1. Vv 2 thru 4.").osis()).toEqual("Jas.1.1-Jas.1.27,Jas.1.2-Jas.1.4");
      expect(p.parse("Num6.25-26also look@ Philipp2.15hav warm day").osis()).toEqual("Num.6.25-Num.6.26,Phil.2.15");
      expect(p.parse("Mark3.4.5.6.7.8.9.10.11").osis()).toEqual("Mark.3.4,Mark.5.6,Mark.7.8,Mark.9.10-Mark.9.11");
      expect(p.parse("Daily Scripture Reading: 2 Sam. 23-1 Kgs. 1 and Luke 22:39-71.").osis()).toEqual("2Sam.23.1-1Kgs.1.53,Luke.22.39-Luke.22.71");
      expect(p.parse("read matthew 24 and luke 21 and see 4 yourself!!!!").osis()).toEqual("Matt.24.1-Matt.24.51,Luke.21.1-Luke.21.38,Luke.4.1-Luke.4.44");
      expect(p.parse("Proverbs 1'20-24").osis()).toEqual("Prov.1.20-Prov.1.24");
      expect(p.parse("Devotions: John 10:22-42  vs 27 \"My sheep hear my voice").osis_and_indices()).toEqual([
        {
          osis: "John.10.22-John.21.25",
          indices: [11, 31],
          translations: [""]
        }
      ]);
      expect(p.parse("Mark 16:2-17:3").osis()).toEqual("Mark.16.2-Mark.16.20");
      expect(p.parse("Leviticus 26.8. '5 shall chase a 100'.").osis()).toEqual("Lev.26.8");
      expect(p.parse("Leviticus 26.8. \"5 shall chase a 100'.").osis()).toEqual("Lev.26.8");
      expect(p.parse("Deuteronomy 6:4-9 and Matthew 22-34-40").osis()).toEqual("Deut.6.4-Deut.6.9,Matt.22.34-Matt.22.40");
      expect(p.parse("Psalm 40 - 12:02 AM").osis()).toEqual("Ps.40.1-Ps.40.17,Ps.12.2");
      expect(p.parse("Psalm 40 - 09:27 AM").osis()).toEqual("Ps.40.1-Ps.40.17");
      expect(p.parse("We lost a few judges... 5:00Pm").osis()).toEqual("");
      expect(p.parse("We lost a few judges... 5:01Pm").osis()).toEqual("");
      expect(p.parse("We lost a few judges. 5:01Pm").osis()).toEqual("Judg.5.1");
      expect(p.parse("Memorizing 2Cor 3:4.-6 this week. Quiz me!").osis()).toEqual("2Cor.3.4,2Cor.3.6");
      expect(p.parse("Isaiah 5;20b.").osis()).toEqual("Isa.5.1-Isa.5.30,Isa.5.20");
      expect(p.parse("1 Tim 2:2:11-15").osis()).toEqual("1Tim.2.2,1Tim.2.11-1Tim.2.15");
      expect(p.parse("in Ezek 34. Love how the Lectionary pulled together Ps 23, Ez, and John 10 on one day.").osis()).toEqual("Ezek.34.1-Ezek.34.31,Ps.23.1-Ps.23.6,John.10.1-John.10.42");
      expect(p.parse("Rom12?11").osis()).toEqual("Rom.12.1-Rom.12.21");
      expect(p.parse("MATTHEW 7 VS1-").osis()).toEqual("Matt.7.1");
      expect(p.parse("1 Kings 4:25 - Micah 4:4 - Zechariah 3:10‏").osis()).toEqual("1Kgs.4.25-Mic.4.4,Zech.3.10");
      expect(p.parse("Ephesians 4:5-6 (NKJV)  5 one Lord").osis()).toEqual("Eph.4.5-Eph.4.6");
      expect(p.parse("Judges 21:1-Ruth 1:22; John 4:4-42; Psalm 105:1-15; Proverbs 14:25 -  ").osis()).toEqual("Judg.21.1-Ruth.1.22,John.4.4-John.4.42,Ps.105.1-Ps.105.15,Prov.14.25");
      expect(p.parse("encourages Thes.5:11. 5Be a mom who laughs Prov.17:22. 6Be a mom who hugsLuke18:15").osis()).toEqual("Prov.17.22");
      expect(p.parse("...Whoever does these things will never be shaken.\" Psalm 15:2, 5b").osis()).toEqual("Ps.15.2,Ps.15.5");
      expect(p.parse("Colossians 2:6-7 ... 6 Therefore)  ").osis()).toEqual("Col.2.6-Col.2.7");
      expect(p.parse("Colossians 2:6-7:6").osis()).toEqual("Col.2.6-Col.4.18");
      expect(p.parse("1Samuel 28:20- 2Samuel 12:10").osis()).toEqual("1Sam.28.20-2Sam.12.10");
      expect(p.parse("Isaiah 53. 700 years before Jesus").osis()).toEqual("Isa.53.1-Isa.53.12");
      expect(p.parse("John.2.1-John.2.25").osis()).toEqual("John.2.1-John.2.25");
      expect(p.parse("1-John 2:25").osis()).toEqual("John.2.25");
      expect(p.parse("ROMANS 8 24_30").osis()).toEqual("Rom.8.1-Rom.8.39");
      expect(p.parse("(2.Chronicles 15.7 - NIV)").osis()).toEqual("2Chr.15.7");
      expect(p.parse("\"God So Loved the World, Part 1\" John 3:9-18  ").osis()).toEqual("John.3.9-John.3.18");
      expect(p.parse("Romans 5:12-21 0. Prelude").osis()).toEqual("Rom.5.12-Rom.5.21");
      expect(p.parse("Proverbs 6:/9-15").osis()).toEqual("Prov.6.1-Prov.6.35,Prov.9.1-Prov.15.33");
      expect(p.parse("origin of man in Genesis 1:27 vs 2:7.").osis()).toEqual("Gen.1.27,Gen.2.7");
      expect(p.parse("Genesis verse 6:4 and Numbers 13:33? ( ").osis()).toEqual("Gen.6.4,Num.13.33");
      expect(p.parse("2 corinthians 4~16").osis()).toEqual("2Cor.4.1-2Cor.4.18");
      expect(p.parse("OUR job is to 1 humble").osis()).toEqual("");
      expect(p.parse("Isa 1'18.\"Come").osis()).toEqual("Isa.1.18");
      expect(p.parse("Judges 21-Ruth 1; Psalm 105:1-15; Proverbs 14:25; Judges 21:25").osis()).toEqual("Judg.21.1-Ruth.1.22,Ps.105.1-Ps.105.15,Prov.14.25,Judg.21.25");
      expect(p.parse("Ps 34:1-4 Verse 4 reads").osis()).toEqual("Ps.34.1,Ps.4.4");
      expect(p.parse("is2prosper").osis()).toEqual("Isa.2.1-Isa.2.22");
      expect(p.parse("read THE PSALMS 5/ 29/ 95/ 1 CHRONICLES 29:10-13 LUKE 1:68-79").osis()).toEqual("Ps.5.1-Ps.5.12,Ps.29.1-Ps.29.11,Ps.95.1-Ps.95.11,1Chr.29.10-1Chr.29.13,Luke.1.68-Luke.1.79");
      expect(p.parse("Scripture Proverbs 31:10-31 (KJV)10Who can find").osis()).toEqual("Prov.31.10-Prov.31.31");
      expect(p.parse("Deut 28 - v66-67 is a real").osis()).toEqual("Deut.28.66-Deut.28.67");
      expect(p.parse("Josh 24, Duet 28!").osis()).toEqual("Josh.24.1-Josh.24.33,Deut.28.1-Deut.28.68");
      expect(p.parse("ph2o").osis()).toEqual("Phil.2.1-Phil.2.30");
      expect(p.parse("luke-111-13-").osis()).toEqual("Luke.13.1-Luke.13.35");
      expect(p.parse("IC4").osis()).toEqual("");
      expect(p.parse("Acts 14:19-28; Ps 145:10-11, 12-13ab, 21; Jn 14:27-31a").osis()).toEqual("Acts.14.19-Acts.14.28,Ps.145.10-Ps.145.13,John.14.27-John.14.31");
      expect(p.parse("Romans 1:16. 1 luv").osis()).toEqual("Rom.1.16,Rom.1.1");
      expect(p.parse("2nd Chapter of Acts - 8.25 USD").osis()).toEqual("Acts.2.1-Acts.8.25");
      expect(p.parse("John<3").osis()).toEqual("");
      expect(p.parse("Compare Is 59:16ff to Eph 6.").osis()).toEqual("Isa.59.16-Isa.59.21,Eph.6.1-Eph.6.24");
      expect(p.parse("Isaiah 54:10, 32:17. 55.12, 57:12").osis()).toEqual("Isa.54.10,Isa.32.17,Isa.55.12,Isa.57.12");
      expect(p.parse("John 12:20-13:20 compare verses 12:45 And whoever").osis()).toEqual("John.12.20-John.13.20,John.12.45");
      expect(p.parse("Numbers 15:37 - Malachi 4:2 - Mark 5:25").osis()).toEqual("Num.15.37-Mal.4.2,Mark.5.25");
      expect(p.parse("John 13:1-17, 31b-35Have").osis()).toEqual("John.13.1-John.13.17,John.13.31-John.13.35");
      expect(p.parse("Acts 2 Revelation: v1. Seven days").osis()).toEqual("Acts.2.1-Acts.2.47,Rev.1.1");
      expect(p.parse("Psalms 11 to 15 and Proverbs 3 . . . 5 chapters of Psalms and 1 chapter of Proverbs").osis()).toEqual("Ps.11.1-Ps.15.5,Prov.3.1-Prov.3.35,Ps.1.1-Ps.1.6");
      expect(p.parse("proverbs 31~ :30").osis()).toEqual("Prov.31.1-Prov.31.31,Prov.30.1-Prov.30.33");
      expect(p.parse("Finished translating Genesis 1 through verse 25.").osis()).toEqual("Gen.1.25");
      expect(p.parse("Luke 9..56").osis()).toEqual("Luke.9.1-Luke.9.62");
      expect(p.parse("Ecclesiastes 5:2 <-- 3").osis()).toEqual("Eccl.5.2");
      expect(p.parse("Deal with it: Matthew 10:32. 33").osis()).toEqual("Matt.10.32-Matt.10.33");
      expect(p.parse("Prov.28:5   6/25").osis()).toEqual("Prov.28.5-Prov.28.6,Prov.28.25");
      expect(p.parse("rev8:1.5, and there").osis()).toEqual("Rev.8.1,Rev.8.5");
      expect(p.parse("*ROM 11 *TO 29").osis()).toEqual("Rom.11.29");
      expect(p.parse("Ps 62:1-2 verse 2").osis()).toEqual("Ps.62.1,Ps.2.2");
      expect(p.parse("Psalm 109:30 ;0)").osis()).toEqual("Ps.109.30");
      expect(p.parse("a king 6-9").osis()).toEqual("");
      expect(p.parse("1Thes 3-4 \u2013 4:13-16").osis()).toEqual("1Thess.3.1-1Thess.4.18,1Thess.4.13-1Thess.4.16");
      expect(p.parse("Ps 26/40/58/61-62/64: Psalm 26:").osis()).toEqual("Ps.26.1-Ps.26.12,Ps.40.1-Ps.40.17,Ps.58.1-Ps.58.11,Ps.61.1-Ps.62.12,Ps.64.1-Ps.64.10,Ps.26.1-Ps.26.12");
      expect(p.parse("portrayed by Luke - Acts 11,13").osis()).toEqual("Acts.11.1-Acts.11.30,Acts.13.1-Acts.13.52");
      expect(p.parse("Today's meditation. Psalm 1, 3, 8, 15 16, 18").osis()).toEqual("Ps.1.1-Ps.1.6,Ps.3.1-Ps.3.8,Ps.8.1-Ps.8.9");
      expect(p.parse("matt 22:37,2nd part").osis()).toEqual("Matt.22.37,Matt.22.2");
      expect(p.parse("John 13:15, 34b").osis()).toEqual("John.13.15,John.13.34");
      expect(p.parse("John 13:15, 34began").osis()).toEqual("John.13.15");
      expect(p.parse("John 13:15, 34 began").osis_and_indices()).toEqual([
        {
          osis: "John.13.15,John.13.34",
          indices: [0, 14],
          translations: [""]
        }
      ]);
      expect(p.parse("Eph. 4:26-27.30. NIV.").osis()).toEqual("Eph.4.26-Eph.6.24");
      expect(p.parse("so. See 3 John 5-8.").osis_and_indices()).toEqual([
        {
          osis: "3John.1.5-3John.1.8",
          indices: [8, 18],
          translations: [""]
        }
      ]);
      expect(p.parse("Dan, verse 14").osis_and_indices()).toEqual([
        {
          osis: "Dan.1.14",
          indices: [0, 13],
          translations: [""]
        }
      ]);
      expect(p.parse("Isaiah 41:10 is my").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10",
          indices: [0, 12],
          translations: [""]
        }
      ]);
      expect(p.parse("Isaiah 41:10 ha ha ha").osis_and_indices()).toEqual([
        {
          osis: "Isa.41.10",
          indices: [0, 12],
          translations: [""]
        }
      ]);
      expect(p.parse("see Isaiah 47:148:22 - Ps 117:7-10 - Gal 3:2").osis_and_indices()).toEqual([
        {
          osis: "Gal.3.2",
          indices: [37, 44],
          translations: [""]
        }
      ]);
      expect(p.parse("matt CHAPTER 1, verse 9 NIV").osis()).toEqual("Matt.1.9");
      expect(p.parse("Jude chapter 1, verse 9 NIV").osis()).toEqual("Jude.1.9");
      expect(p.parse("Jdg 12:11 break Judges 99,KJV").osis_and_indices()).toEqual([
        {
          osis: "Judg.12.11",
          indices: [0, 9],
          translations: [""]
        }
      ]);
      expect(p.parse("Jdg 12:11 break Judges,chapter,12,KJV").osis_and_indices()).toEqual([
        {
          osis: "Judg.12.11",
          indices: [0, 9],
          translations: [""]
        }
      ]);
      expect(p.parse("Jdg 12:11 break Judges 99,2,KJV").osis_and_indices()).toEqual([
        {
          osis: "Judg.12.11",
          indices: [0, 9],
          translations: [""]
        }, {
          osis: "Judg.2.1-Judg.2.23",
          indices: [16, 31],
          translations: ["KJV"]
        }
      ]);
      expect(p.parse("Jdg 12:11 break Judges 2,99, KJV").osis_and_indices()).toEqual([
        {
          osis: "Judg.12.11",
          indices: [0, 9],
          translations: [""]
        }, {
          osis: "Judg.2.1-Judg.2.23",
          indices: [16, 32],
          translations: ["KJV"]
        }
      ]);
      expect(p.parse("Gen 1;1:2 The earth").osis()).toEqual("Gen.1.1-Gen.1.31,Gen.1.2");
      expect(p.parse("Proverbs 4:25-27. 218 ").osis_and_indices()).toEqual([
        {
          osis: "Prov.4.25-Prov.4.27",
          indices: [0, 16],
          translations: [""]
        }
      ]);
      expect(p.parse("Proverbs 4:25-27. 218 is").osis_and_indices()).toEqual([
        {
          osis: "Prov.4.25-Prov.27.27",
          indices: [0, 21],
          translations: [""]
        }
      ]);
      expect(p.parse("Numbers 2-999").osis_and_indices()).toEqual([
        {
          osis: "Num.2.1-Num.36.13",
          indices: [0, 13],
          translations: [""]
        }
      ]);
      expect(p.parse("Numbers 2- 999").osis_and_indices()).toEqual([
        {
          osis: "Num.2.1-Num.2.34",
          indices: [0, 9],
          translations: [""]
        }
      ]);
      expect(p.parse("Ezk 1,4:5, 6 365").osis_and_indices()).toEqual([
        {
          osis: "Ezek.1.1-Ezek.1.28,Ezek.4.5-Ezek.4.6",
          indices: [0, 12],
          translations: [""]
        }
      ]);
      expect(p.parse("is 15-14-12-25-7-15-4").osis_and_indices()).toEqual([
        {
          osis: "Isa.15.7,Isa.15.4",
          indices: [12, 21],
          translations: [""]
        }
      ]);
      expect(p.parse("job is 2 f").osis_and_indices()).toEqual([
        {
          osis: "Isa.2.1-Isa.66.24",
          indices: [4, 10],
          translations: [""]
        }
      ]);
      expect(p.parse("Ps. 78:24").osis()).toEqual("Ps.78.24");
      expect(p.parse("Father and the Son. (John 1 2:22)").osis_and_indices()).toEqual([
        {
          osis: "John.1.1-John.1.51,John.2.22",
          indices: [21, 32],
          translations: [""]
        }
      ]);
      expect(p.parse("Readings from Ezekiel 25 and 26, Proverbs 23 and II Timothy 1 (KJV)").osis()).toEqual("Ezek.25.1-Ezek.26.21,Prov.23.1-Prov.23.35,2Tim.1.1-2Tim.1.18");
      expect(p.parse("firsts 3.1").osis()).toEqual("");
      expect(p.parse("seconds 3.1").osis()).toEqual("");
      expect(p.parse("1s. 3.1").osis()).toEqual("1Sam.3.1");
      expect(p.parse("2s. 3.1").osis()).toEqual("2Sam.3.1");
      expect(p.parse("help (1 Corinthians 12:1ff). The ").osis_and_indices()).toEqual([
        {
          osis: "1Cor.12.1-1Cor.12.31",
          indices: [6, 26],
          translations: [""]
        }
      ]);
      expect(p.parse("PSALM 41 F-1-3 O LORD").osis_and_indices()).toEqual([
        {
          osis: "Ps.41.1-Ps.150.6,Ps.1.1-Ps.3.8",
          indices: [0, 14],
          translations: [""]
        }
      ]);
      expect(p.parse("Luke 8:1-3; 24:10 (and Matthew 14:1-12 and Luke 23:7-12 for background)").osis_and_indices()).toEqual([
        {
          osis: "Luke.8.1-Luke.8.3,Luke.24.10",
          translations: [""],
          indices: [0, 17]
        }, {
          osis: "Matt.14.1-Matt.14.12,Luke.23.7-Luke.23.12",
          translations: [""],
          indices: [23, 55]
        }
      ]);
      expect(p.parse("Ti 8- Nu 9- Ma 10- Re").osis()).toEqual("Num.9.1-Num.9.23,Matt.10.1-Matt.10.42");
      expect(p.parse("EX34 9PH to CO7").osis()).toEqual("Exod.34.9,Col.4.1-Col.4.18");
      expect(p.parse("Rom amp A 2 amp 3").parsed_entities()).toEqual([]);
      return expect(p.parse("chapt. 11-1040 of II Kings").osis()).toEqual("");
    });
  });

  describe("Adding new translations", function() {
    var p;
    p = {};
    beforeEach(function() {
      p = {};
      p = new bcv_parser;
      p.set_options({
        book_alone_strategy: "full"
      });
      p.regexps.translations = /\b(?:niv|comp|notrans|noalias)\b/gi;
      p.translations.aliases.comp = {
        osis: "COMP",
        alias: "comp"
      };
      p.translations.aliases.notrans = {
        alias: "no_translation_alias"
      };
      p.translations.comp = {
        order: {
          "Matt": 1,
          "Gen": 2
        }
      };
      return p.translations.comp.chapters = {
        "Matt": p.translations["default"].chapters.Matt,
        "Gen": p.translations["default"].chapters.Gen
      };
    });
    it("should handle a nonexistent book", function() {
      expect(p.parse("Psalm 23 COMP").osis_and_translations()).toEqual([]);
      expect(p.parse("Psalms NIV").osis_and_translations()).toEqual([["Ps", "NIV"]]);
      return expect(p.parse("Psalms COMP").osis_and_translations()).toEqual([]);
    });
    return it("should handle reparsing when given a new translation", function() {
      expect(p.parse("Matt 2-Gen3 NIV").osis_and_translations()).toEqual([["Matt.2,Gen.3", "NIV"]]);
      expect(p.parse("Matt 2-Gen3 COMP").osis_and_translations()).toEqual([["Matt.2-Gen.3", "COMP"]]);
      expect(p.parse("Exodus 3, Matt 5 COMP").osis_and_translations()).toEqual([["Matt.5", "COMP"]]);
      expect(p.parse("Exodus 3-Matt 5 COMP").osis_and_translations()).toEqual([["Matt.5", "COMP"]]);
      expect(p.parse("Exodus 3-Matt 5 NOTRANS").osis_and_translations()).toEqual([["Exod.3-Matt.5", "NOTRANS"]]);
      return expect(p.parse("Exodus 3-Matt 5 NOALIAS").osis_and_translations()).toEqual([["Exod.3-Matt.5", "NOALIAS"]]);
    });
  });

}).call(this);
