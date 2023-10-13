bcv_parser = require("../../js/sv_bcv_parser.js").bcv_parser

describe "Parsing", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.options.osis_compaction_strategy = "b"
		p.options.sequence_combination_strategy = "combine"

	it "should round-trip OSIS references", ->
		p.set_options osis_compaction_strategy: "bc"
		books = ["Gen","Exod","Lev","Num","Deut","Josh","Judg","Ruth","1Sam","2Sam","1Kgs","2Kgs","1Chr","2Chr","Ezra","Neh","Esth","Job","Ps","Prov","Eccl","Song","Isa","Jer","Lam","Ezek","Dan","Hos","Joel","Amos","Obad","Jonah","Mic","Nah","Hab","Zeph","Hag","Zech","Mal","Matt","Mark","Luke","John","Acts","Rom","1Cor","2Cor","Gal","Eph","Phil","Col","1Thess","2Thess","1Tim","2Tim","Titus","Phlm","Heb","Jas","1Pet","2Pet","1John","2John","3John","Jude","Rev"]
		for book in books
			bc = book + ".1"
			bcv = bc + ".1"
			bcv_range = bcv + "-" + bc + ".2"
			expect(p.parse(bc).osis()).toEqual bc
			expect(p.parse(bcv).osis()).toEqual bcv
			expect(p.parse(bcv_range).osis()).toEqual bcv_range

	it "should round-trip OSIS Apocrypha references", ->
		p.set_options osis_compaction_strategy: "bc", ps151_strategy: "b"
		p.include_apocrypha true
		books = ["Tob","Jdt","GkEsth","Wis","Sir","Bar","PrAzar","Sus","Bel","SgThree","EpJer","1Macc","2Macc","3Macc","4Macc","1Esd","2Esd","PrMan","Ps151"]
		for book in books
			bc = book + ".1"
			bcv = bc + ".1"
			bcv_range = bcv + "-" + bc + ".2"
			expect(p.parse(bc).osis()).toEqual bc
			expect(p.parse(bcv).osis()).toEqual bcv
			expect(p.parse(bcv_range).osis()).toEqual bcv_range
		p.set_options ps151_strategy: "bc"
		expect(p.parse("Ps151.1").osis()).toEqual "Ps.151"
		expect(p.parse("Ps151.1.1").osis()).toEqual "Ps.151.1"
		expect(p.parse("Ps151.1-Ps151.2").osis()).toEqual "Ps.151.1-Ps.151.2"
		p.include_apocrypha false
		for book in books
			bc = book + ".1"
			expect(p.parse(bc).osis()).toEqual ""

	it "should handle a preceding character", ->
		expect(p.parse(" Gen 1").osis()).toEqual "Gen.1"
		expect(p.parse("Matt5John3").osis()).toEqual "Matt.5,John.3"
		expect(p.parse("1Ps 1").osis()).toEqual ""
		expect(p.parse("11Sam 1").osis()).toEqual ""

describe "Localized book Gen (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (sv)", ->
		`
		expect(p.parse("Forsta Moseboken 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Första Moseboken 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Forsta Mosebok 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Första Mosebok 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. Moseboken 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 Moseboken 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. Mosebok 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 Mosebok 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Genesis 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 Mos 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA MOSEBOKEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("FÖRSTA MOSEBOKEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("FORSTA MOSEBOK 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("FÖRSTA MOSEBOK 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. MOSEBOKEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 MOSEBOKEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. MOSEBOK 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 MOSEBOK 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GENESIS 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 MOS 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (sv)", ->
		`
		expect(p.parse("Andra Moseboken 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Andra Mosebok 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. Moseboken 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 Moseboken 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. Mosebok 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 Mosebok 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exodus 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 Mos 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA MOSEBOKEN 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ANDRA MOSEBOK 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. MOSEBOKEN 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 MOSEBOKEN 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. MOSEBOK 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 MOSEBOK 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXODUS 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 MOS 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (sv)", ->
		`
		expect(p.parse("Bel och Ormguden 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (sv)", ->
		`
		expect(p.parse("Tredje Moseboken 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Tredje Mosebok 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3e. Moseboken 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. Moseboken 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3e Moseboken 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 Moseboken 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3e. Mosebok 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. Mosebok 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3e Mosebok 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 Mosebok 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Leviticus 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 Mos 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TREDJE MOSEBOKEN 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("TREDJE MOSEBOK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3E. MOSEBOKEN 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. MOSEBOKEN 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3E MOSEBOKEN 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 MOSEBOKEN 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3E. MOSEBOK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. MOSEBOK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3E MOSEBOK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 MOSEBOK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVITICUS 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 MOS 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (sv)", ->
		`
		expect(p.parse("Fjarde Moseboken 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Fjärde Moseboken 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Fjarde Mosebok 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Fjärde Mosebok 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. Moseboken 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 Moseboken 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. Mosebok 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 Mosebok 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Numeri 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 Mos 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FJARDE MOSEBOKEN 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("FJÄRDE MOSEBOKEN 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("FJARDE MOSEBOK 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("FJÄRDE MOSEBOK 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. MOSEBOKEN 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 MOSEBOKEN 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. MOSEBOK 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 MOSEBOK 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUMERI 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 MOS 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (sv)", ->
		`
		expect(p.parse("Jesus Syraks vishet 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Ecclesiasticus 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Ben Sira 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Syrak 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Syr 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (sv)", ->
		`
		expect(p.parse("Salomos vishet 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Vishetens bok 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Visheten 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Vish 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (sv)", ->
		`
		expect(p.parse("Klagovisorna 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Klag 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("KLAGOVISORNA 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("KLAG 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (sv)", ->
		`
		expect(p.parse("Jeremias brev 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Jer br 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (sv)", ->
		`
		expect(p.parse("Johannes Uppenbarelse 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johannes apokalyps 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Uppenbarelseboken 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Upp 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOHANNES UPPENBARELSE 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHANNES APOKALYPS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("UPPENBARELSEBOKEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("UPP 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (sv)", ->
		`
		expect(p.parse("Manasses’ bon 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Manasses’ bön 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Manasses bon 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Manasses bön 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Manasse bon 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Manasse bön 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Man 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (sv)", ->
		`
		expect(p.parse("Femte Moseboken 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deuteronomium 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Femte Mosebok 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. Moseboken 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 Moseboken 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. Mosebok 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 Mosebok 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 Mos 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FEMTE MOSEBOKEN 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUTERONOMIUM 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("FEMTE MOSEBOK 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. MOSEBOKEN 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 MOSEBOKEN 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. MOSEBOK 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 MOSEBOK 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 MOS 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (sv)", ->
		`
		expect(p.parse("Josua 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Jos 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOSUA 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOS 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (sv)", ->
		`
		expect(p.parse("Domarboken 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Dom 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DOMARBOKEN 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("DOM 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (sv)", ->
		`
		expect(p.parse("Ruts bok 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Rut 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTS BOK 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUT 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (sv)", ->
		`
		expect(p.parse("Forsta Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Första Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Tredje Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3e. Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1. Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3. Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3e Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3 Esra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (sv)", ->
		`
		expect(p.parse("Fjarde Esra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Fjärde Esra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Andra Esra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2. Esra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4. Esra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4 Esra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (sv)", ->
		`
		expect(p.parse("Jesajas bok 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Jesaja 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Jes 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JESAJAS BOK 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("JESAJA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("JES 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (sv)", ->
		`
		expect(p.parse("Andra Samuelsboken 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Samuelsboken 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Samuelsboken 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA SAMUELSBOKEN 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMUELSBOKEN 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUELSBOKEN 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (sv)", ->
		`
		expect(p.parse("Forsta Samuelsboken 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Första Samuelsboken 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Samuelsboken 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Samuelsboken 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA SAMUELSBOKEN 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("FÖRSTA SAMUELSBOKEN 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMUELSBOKEN 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUELSBOKEN 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (sv)", ->
		`
		expect(p.parse("Andra Konungaboken 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Andra Kungaboken 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Konungaboken 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Konungaboken 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Kungaboken 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Kungaboken 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Kung 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Kon 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA KONUNGABOKEN 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ANDRA KUNGABOKEN 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. KONUNGABOKEN 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 KONUNGABOKEN 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. KUNGABOKEN 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 KUNGABOKEN 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 KUNG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 KON 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (sv)", ->
		`
		expect(p.parse("Forsta Konungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Första Konungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Forsta Kungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Första Kungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Konungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Konungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Kungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Kungaboken 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Kung 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Kon 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA KONUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("FÖRSTA KONUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("FORSTA KUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("FÖRSTA KUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. KONUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 KONUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. KUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 KUNGABOKEN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 KUNG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 KON 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (sv)", ->
		`
		expect(p.parse("Andra Kronikeboken 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Andra Krönikeboken 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Kronikeboken 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Krönikeboken 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Kronikeboken 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Krönikeboken 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Kron 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Krön 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA KRONIKEBOKEN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ANDRA KRÖNIKEBOKEN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. KRONIKEBOKEN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. KRÖNIKEBOKEN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRONIKEBOKEN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRÖNIKEBOKEN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRON 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRÖN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (sv)", ->
		`
		expect(p.parse("Forsta Kronikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Forsta Krönikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Första Kronikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Första Krönikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Kronikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Krönikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Kronikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Krönikeboken 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Kron 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Krön 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA KRONIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("FORSTA KRÖNIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("FÖRSTA KRONIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("FÖRSTA KRÖNIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. KRONIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. KRÖNIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRONIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRÖNIKEBOKEN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRON 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRÖN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (sv)", ->
		`
		expect(p.parse("Esra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Esr 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ESR 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (sv)", ->
		`
		expect(p.parse("Nehemia 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Nehemja 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NEHEMIA 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEHEMJA 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (sv)", ->
		`
		expect(p.parse("Ester enligt den grekiska texten 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Est gr 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (sv)", ->
		`
		expect(p.parse("Esters bok 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Ester 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Est 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESTERS BOK 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTER 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("EST 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (sv)", ->
		`
		expect(p.parse("Jobs bok 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOBS BOK 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (sv)", ->
		`
		expect(p.parse("Psaltaren 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Psalmen 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Psalm 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PSALTAREN 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PSALMEN 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PSALM 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (sv)", ->
		`
		expect(p.parse("Asarias’ bon 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Asarias’ bön 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Asarjas’ bon 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Asarjas’ bön 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Asarias bon 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Asarias bön 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Asarjas bon 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Asarjas bön 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (sv)", ->
		`
		expect(p.parse("Ordspraksboken 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Ordspråksboken 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Ords 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ORDSPRAKSBOKEN 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ORDSPRÅKSBOKEN 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ORDS 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (sv)", ->
		`
		expect(p.parse("Predikarens bok 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Predikarboken 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Predikaren 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Pred 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREDIKARENS BOK 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("PREDIKARBOKEN 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("PREDIKAREN 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("PRED 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (sv)", ->
		`
		expect(p.parse("De tre mannens lovsang 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("De tre mannens lovsång 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("De tre männens lovsang 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("De tre männens lovsång 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (sv)", ->
		`
		expect(p.parse("Hoga visan 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Höga Visan 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Höga visan 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Hoga V 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Hoga v 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Höga V 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Hogav 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Högav 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Hoga 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Höga 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HOGA VISAN 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HÖGA VISAN 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HÖGA VISAN 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HOGA V 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HOGA V 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HÖGA V 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HOGAV 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HÖGAV 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HOGA 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HÖGA 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (sv)", ->
		`
		expect(p.parse("Jeremias 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jeremia 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JEREMIAS 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JEREMIA 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (sv)", ->
		`
		expect(p.parse("Hesekiels bok 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Hesekiel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Hes 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HESEKIELS BOK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("HESEKIEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("HES 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (sv)", ->
		`
		expect(p.parse("Daniels bok 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Daniel 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DANIELS BOK 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DANIEL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (sv)", ->
		`
		expect(p.parse("Hoseas bok 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hosea 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HOSEAS BOK 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOSEA 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (sv)", ->
		`
		expect(p.parse("Joels bok 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOELS BOK 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (sv)", ->
		`
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Am 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AM 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (sv)", ->
		`
		expect(p.parse("Obadjas bok 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obadja 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Ob 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("OBADJAS BOK 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBADJA 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OB 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (sv)", ->
		`
		expect(p.parse("Jonas bok 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jona bok 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jona 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jon 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JONAS BOK 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONA BOK 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONA 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JON 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (sv)", ->
		`
		expect(p.parse("Mikas bok 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mika 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mik 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MIKAS BOK 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIKA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIK 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (sv)", ->
		`
		expect(p.parse("Nahum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (sv)", ->
		`
		expect(p.parse("Habackuk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Habakuk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HABACKUK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAKUK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (sv)", ->
		`
		expect(p.parse("Sefanjas bok 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zefanias 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Sefanja 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Sef 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SEFANJAS BOK 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEFANIAS 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SEFANJA 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SEF 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (sv)", ->
		`
		expect(p.parse("Haggai 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Haggaj 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hagg 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HAGGAI 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAGGAJ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAGG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (sv)", ->
		`
		expect(p.parse("Sakaria 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Sakarja 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Sak 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SAKARIA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("SAKARJA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("SAK 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (sv)", ->
		`
		expect(p.parse("Malakias 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Malaki 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MALAKIAS 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALAKI 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (sv)", ->
		`
		expect(p.parse("Mattei evangelium 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matteusevangeliet 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matteus 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Mt 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MATTEI EVANGELIUM 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTEUSEVANGELIET 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTEUS 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MT 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (sv)", ->
		`
		expect(p.parse("Markus evangelium 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Markusevangeliet 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Markus 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mk 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MARKUS EVANGELIUM 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKUSEVANGELIET 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKUS 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MK 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (sv)", ->
		`
		expect(p.parse("Lukas evangelium 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lukasevangeliet 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lukas 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luk 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lk 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LUKAS EVANGELIUM 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKASEVANGELIET 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKAS 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUK 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LK 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (sv)", ->
		`
		expect(p.parse("Forsta Johannesbrevet 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Första Johannesbrevet 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes forsta brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes första brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Johannesbrevet 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Johannesbrevet 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Joh 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA JOHANNESBREVET 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("FÖRSTA JOHANNESBREVET 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES FORSTA BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES FÖRSTA BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. JOHANNESBREVET 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JOHANNESBREVET 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JOH 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (sv)", ->
		`
		expect(p.parse("Andra Johannesbrevet 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Johannes andra brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Johannesbrevet 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Johannesbrevet 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Joh 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA JOHANNESBREVET 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("JOHANNES ANDRA BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. JOHANNESBREVET 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JOHANNESBREVET 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JOH 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (sv)", ->
		`
		expect(p.parse("Tredje Johannesbrevet 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Johannes tredje brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3e. Johannesbrevet 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Johannesbrevet 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3e Johannesbrevet 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Johannesbrevet 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Joh 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TREDJE JOHANNESBREVET 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("JOHANNES TREDJE BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3E. JOHANNESBREVET 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. JOHANNESBREVET 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3E JOHANNESBREVET 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JOHANNESBREVET 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JOH 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (sv)", ->
		`
		expect(p.parse("Johannis evangelium 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Johannesevangeliet 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Johannes 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Joh 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Jh 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOHANNIS EVANGELIUM 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHANNESEVANGELIET 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHANNES 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOH 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JH 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (sv)", ->
		`
		expect(p.parse("Apostlagarningarna 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Apostlagärningarna 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Apg 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("APOSTLAGARNINGARNA 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("APOSTLAGÄRNINGARNA 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("APG 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (sv)", ->
		`
		expect(p.parse("Romarbrevet 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ROMARBREVET 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (sv)", ->
		`
		expect(p.parse("Andra Korinthierbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Andra Korintherbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Andra Korintierbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Andra Korinterbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korinthierbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korinthierbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korintherbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korintierbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korintherbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korintierbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korinterbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korinterbrevet 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Kor 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA KORINTHIERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDRA KORINTHERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDRA KORINTIERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDRA KORINTERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTHIERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTHIERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTHERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTIERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTHERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTIERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTERBREVET 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KOR 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (sv)", ->
		`
		expect(p.parse("Forsta Korinthierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Första Korinthierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Forsta Korintherbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Forsta Korintierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Första Korintherbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Första Korintierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Forsta Korinterbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Första Korinterbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korinthierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korinthierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korintherbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korintierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korintherbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korintierbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korinterbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korinterbrevet 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Kor 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA KORINTHIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FÖRSTA KORINTHIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FORSTA KORINTHERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FORSTA KORINTIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FÖRSTA KORINTHERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FÖRSTA KORINTIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FORSTA KORINTERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FÖRSTA KORINTERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTHIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTHIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTHERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTHERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTIERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTERBREVET 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KOR 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (sv)", ->
		`
		expect(p.parse("Galaterbrefvet 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Galaterbrevet 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GALATERBREFVET 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATERBREVET 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (sv)", ->
		`
		expect(p.parse("Efesierbrevet 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Efeserbrevet 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ef 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EFESIERBREVET 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EFESERBREVET 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EF 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (sv)", ->
		`
		expect(p.parse("Filipperbrevet 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Fil 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FILIPPERBREVET 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FIL 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (sv)", ->
		`
		expect(p.parse("Kolosserbrevet 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Kol 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("KOLOSSERBREVET 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KOL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (sv)", ->
		`
		expect(p.parse("Andra Thessalonikerbrevet 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Andra Tessalonikerbrevet 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Thessalonikerbrevet 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thessalonikerbrevet 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Tessalonikerbrevet 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Tessalonikerbrevet 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Tess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA THESSALONIKERBREVET 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ANDRA TESSALONIKERBREVET 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. THESSALONIKERBREVET 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESSALONIKERBREVET 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TESSALONIKERBREVET 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TESSALONIKERBREVET 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (sv)", ->
		`
		expect(p.parse("Forsta Thessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Första Thessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Forsta Tessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Första Tessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Thessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Tessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Tessalonikerbrevet 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Tess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA THESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("FÖRSTA THESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("FORSTA TESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("FÖRSTA TESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. THESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TESSALONIKERBREVET 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (sv)", ->
		`
		expect(p.parse("Andra Timotheosbrevet 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Andra Timoteusbrevet 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timotheosbrevet 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timotheosbrevet 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timoteusbrevet 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timoteusbrevet 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA TIMOTHEOSBREVET 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ANDRA TIMOTEUSBREVET 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTHEOSBREVET 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTHEOSBREVET 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTEUSBREVET 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTEUSBREVET 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (sv)", ->
		`
		expect(p.parse("Forsta Timotheosbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Första Timotheosbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Forsta Timoteusbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Första Timoteusbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timotheosbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timotheosbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timoteusbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timoteusbrevet 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA TIMOTHEOSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("FÖRSTA TIMOTHEOSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("FORSTA TIMOTEUSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("FÖRSTA TIMOTEUSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTHEOSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTHEOSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTEUSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTEUSBREVET 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (sv)", ->
		`
		expect(p.parse("Brevet till Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titusbrevet 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tit 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("BREVET TILL TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUSBREVET 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TIT 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (sv)", ->
		`
		expect(p.parse("Brevet till Filemon 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filemonbrevet 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filem 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("BREVET TILL FILEMON 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILEMONBREVET 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILEM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (sv)", ->
		`
		expect(p.parse("Hebreerbrevet 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hebréerbrevet 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hebr 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Ebr 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HEBREERBREVET 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEBRÉERBREVET 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEBR 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("EBR 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (sv)", ->
		`
		expect(p.parse("Jakobs epistel 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jakobsbrevet 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jakobs brev 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jak 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JAKOBS EPISTEL 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAKOBSBREVET 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAKOBS BREV 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAK 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (sv)", ->
		`
		expect(p.parse("Andra Petrusbrevet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Petrus andra brev 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Petrusbrevet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Petrusbrevet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Petr 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDRA PETRUSBREVET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("PETRUS ANDRA BREV 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PETRUSBREVET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETRUSBREVET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETR 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (sv)", ->
		`
		expect(p.parse("Forsta Petrusbrevet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Första Petrusbrevet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Petrus forsta brev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Petrus första brev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Petrusbrevet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Petrusbrevet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Petr 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FORSTA PETRUSBREVET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("FÖRSTA PETRUSBREVET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PETRUS FORSTA BREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PETRUS FÖRSTA BREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PETRUSBREVET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETRUSBREVET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETR 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (sv)", ->
		`
		expect(p.parse("Judas epistel 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Judasbrevet 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Judas brev 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jud 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JUDAS EPISTEL 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDASBREVET 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDAS BREV 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUD 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (sv)", ->
		`
		expect(p.parse("Tobits bok 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tobit 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (sv)", ->
		`
		expect(p.parse("Judit 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (sv)", ->
		`
		expect(p.parse("Baruks bok 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Baruk 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (sv)", ->
		`
		expect(p.parse("Susanna i badet 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Susanna 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (sv)", ->
		`
		expect(p.parse("Andra Mackabeerboken 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Andra Mackabéerboken 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Mackabeerboken 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Mackabéerboken 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Mackabeerboken 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Mackabéerboken 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Mack 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (sv)", ->
		`
		expect(p.parse("Tredje Mackabeerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Tredje Mackabéerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e. Mackabeerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e. Mackabéerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Mackabeerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Mackabéerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e Mackabeerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e Mackabéerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Mackabeerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Mackabéerboken 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Mack 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (sv)", ->
		`
		expect(p.parse("Fjarde Mackabeerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Fjarde Mackabéerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Fjärde Mackabeerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Fjärde Mackabéerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Mackabeerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Mackabéerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Mackabeerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Mackabéerboken 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Mack 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (sv)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (sv)", ->
		`
		expect(p.parse("Forsta Mackabeerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Forsta Mackabéerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Första Mackabeerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Första Mackabéerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Mackabeerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Mackabéerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Mackabeerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Mackabéerboken 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Mack 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1Macc 1:1").osis()).toEqual("1Macc.1.1")
		`
		true

describe "Miscellaneous tests", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore", book_sequence_strategy: "ignore", osis_compaction_strategy: "bc", captive_end_digits_strategy: "delete"
		p.include_apocrypha true

	it "should return the expected language", ->
		expect(p.languages).toEqual ["sv"]

	it "should handle ranges (sv)", ->
		expect(p.parse("Titus 1:1 till 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1till2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 TILL 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (sv)", ->
		expect(p.parse("Titus 1:1, kapitlen 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAPITLEN 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, kapitlet 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAPITLET 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, kapitel 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAPITEL 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, kap. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAP. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, kap 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAP 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (sv)", ->
		expect(p.parse("Exod 1:1 verser 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSER 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (sv)", ->
		expect(p.parse("Exod 1:1 och 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 OCH 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 jfr. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 JFR. 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 jfr 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 JFR 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (sv)", ->
		expect(p.parse("Ps 3 rubrik, 4:2, 5:rubrik").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 RUBRIK, 4:2, 5:RUBRIK").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (sv)", ->
		expect(p.parse("Rev 3ff., 4:2ff.").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 FF., 4:2 FF.").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("Rev 3ff, 4:2ff").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 FF, 4:2 FF").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("Rev 3f., 4:2f.").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 F., 4:2 F.").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("Rev 3f, 4:2f").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 F, 4:2 F").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (sv)", ->
		expect(p.parse("Lev 1 (B1917)").osis_and_translations()).toEqual [["Lev.1", "B1917"]]
		expect(p.parse("lev 1 b1917").osis_and_translations()).toEqual [["Lev.1", "B1917"]]
		expect(p.parse("Lev 1 (B2000)").osis_and_translations()).toEqual [["Lev.1", "B2000"]]
		expect(p.parse("lev 1 b2000").osis_and_translations()).toEqual [["Lev.1", "B2000"]]
		expect(p.parse("Lev 1 (SFB)").osis_and_translations()).toEqual [["Lev.1", "SFB"]]
		expect(p.parse("lev 1 sfb").osis_and_translations()).toEqual [["Lev.1", "SFB"]]
		expect(p.parse("Lev 1 (SFB15)").osis_and_translations()).toEqual [["Lev.1", "SFB15"]]
		expect(p.parse("lev 1 sfb15").osis_and_translations()).toEqual [["Lev.1", "SFB15"]]
	it "should handle book ranges (sv)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("Första till Tredje  Johannesbrevet").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (sv)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
