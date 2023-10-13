bcv_parser = require("../../js/mr_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (mr)", ->
		`
		expect(p.parse("उत्पत्ति 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("utpatti 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("उत्पति 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("उत्पत्ति 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("UTPATTI 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("उत्पति 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (mr)", ->
		`
		expect(p.parse("nirgam 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("निर्गम 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NIRGAM 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("निर्गम 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (mr)", ->
		`
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (mr)", ->
		`
		expect(p.parse("lewiy 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("lewīy 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवीय 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LEWIY 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEWĪY 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवीय 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (mr)", ->
		`
		expect(p.parse("ganana 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("gananā 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("gaṇana 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("gaṇanā 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गणना 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GANANA 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("GANANĀ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("GAṆANA 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("GAṆANĀ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गणना 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (mr)", ->
		`
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (mr)", ->
		`
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (mr)", ->
		`
		expect(p.parse("wilapgit 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("wilapgīt 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("wilāpgit 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("wilāpgīt 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("विलापगीत 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("WILAPGIT 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("WILAPGĪT 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("WILĀPGIT 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("WILĀPGĪT 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("विलापगीत 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (mr)", ->
		`
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (mr)", ->
		`
		expect(p.parse("yohanala ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanala ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanalā ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanāla ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohanālā ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānala ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānalā ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānāla ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰalele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yohānālā ǳʰālele prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("योहानाला झालेले प्रकटीकरण 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakatikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakatikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakatīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakatīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakaṭikaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakaṭikaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakaṭīkaran 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("prakaṭīkaraṇ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("प्रकटीकरण 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YOHANALA ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALA ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANALĀ ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLA ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHANĀLĀ ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALA ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNALĀ ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLA ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰALELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YOHĀNĀLĀ ǱʰĀLELE PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("योहानाला झालेले प्रकटीकरण 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKATIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKATIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKATĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKATĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKAṬIKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKAṬIKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKAṬĪKARAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("PRAKAṬĪKARAṆ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("प्रकटीकरण 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (mr)", ->
		`
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (mr)", ->
		`
		expect(p.parse("anuwad 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("anuwād 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("अनुवाद 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANUWAD 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ANUWĀD 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("अनुवाद 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (mr)", ->
		`
		expect(p.parse("yahosawa 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahosawā 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahoŝawa 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahoŝawā 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशवा 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAHOSAWA 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOSAWĀ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOŜAWA 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOŜAWĀ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशवा 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (mr)", ->
		`
		expect(p.parse("शास्ते 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("saste 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("sāste 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ŝaste 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ŝāste 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("शास्ते 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("SASTE 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("SĀSTE 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ŜASTE 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ŜĀSTE 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (mr)", ->
		`
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("rutʰ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("rūtʰ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथ 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUTʰ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RŪTʰ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथ 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (mr)", ->
		`
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (mr)", ->
		`
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (mr)", ->
		`
		expect(p.parse("yasaya 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yasayā 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yaŝaya 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yaŝayā 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशया 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशाय 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YASAYA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YASAYĀ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YAŜAYA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YAŜAYĀ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशया 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशाय 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (mr)", ->
		`
		expect(p.parse("दुसरे शमुवेल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 samuwel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 ŝamuwel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शमुवेल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("दुसरे शमुवेल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUWEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 ŜAMUWEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शमुवेल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (mr)", ->
		`
		expect(p.parse("पहिले शमुवेल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 samuwel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 ŝamuwel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शमुवेल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पहिले शमुवेल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUWEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 ŜAMUWEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शमुवेल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (mr)", ->
		`
		expect(p.parse("दुसरे राजे 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 raǳe 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 rāǳe 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 राजे 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("दुसरे राजे 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RAǱE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RĀǱE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 राजे 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (mr)", ->
		`
		expect(p.parse("पहिले राजे 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 raǳe 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 rāǳe 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 राजे 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पहिले राजे 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RAǱE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RĀǱE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 राजे 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (mr)", ->
		`
		expect(p.parse("दुसरे इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 itihas 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 itihās 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("दुसरे इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ITIHAS 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ITIHĀS 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (mr)", ->
		`
		expect(p.parse("पहिले इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 itihas 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 itihās 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पहिले इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ITIHAS 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ITIHĀS 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (mr)", ->
		`
		expect(p.parse("edzra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("edzrā 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("एज्रा 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("eǳra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("eǳrā 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EDZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EDZRĀ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("एज्रा 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EǱRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EǱRĀ 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (mr)", ->
		`
		expect(p.parse("nahemya 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("nahemyā 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्या 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHEMYA 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NAHEMYĀ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्या 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (mr)", ->
		`
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (mr)", ->
		`
		expect(p.parse("एस्तेर 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ester 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("एस्तेर 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTER 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (mr)", ->
		`
		expect(p.parse("iyob 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("īyob 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("इयोब 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ईयोब 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("IYOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ĪYOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("इयोब 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ईयोब 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (mr)", ->
		`
		expect(p.parse("स्त्रोत्रसंहिता 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("stotrasamhita 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("stotrasamhitā 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("stotrasaṃhita 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("stotrasaṃhitā 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("स्तोत्रसंहिता 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("स्तोत्र 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("स्त्रोत्रसंहिता 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("STOTRASAMHITA 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("STOTRASAMHITĀ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("STOTRASAṂHITA 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("STOTRASAṂHITĀ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("स्तोत्रसंहिता 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("स्तोत्र 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (mr)", ->
		`
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (mr)", ->
		`
		expect(p.parse("नीतिसूत्रें 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("नीतिसूत्रे 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("nitisutre 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("nitisūtre 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("nītisutre 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("nītisūtre 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("नीतिसूत्रें 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("नीतिसूत्रे 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("NITISUTRE 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("NITISŪTRE 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("NĪTISUTRE 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("NĪTISŪTRE 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (mr)", ->
		`
		expect(p.parse("upadesak 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("upadeŝak 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशक 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("UPADESAK 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("UPADEŜAK 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशक 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (mr)", ->
		`
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (mr)", ->
		`
		expect(p.parse("gitratna 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("gītratna 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("गीतरत्न 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GITRATNA 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("GĪTRATNA 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("गीतरत्न 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (mr)", ->
		`
		expect(p.parse("yirmaya 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("yirmayā 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यिर्मया 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YIRMAYA 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("YIRMAYĀ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यिर्मया 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (mr)", ->
		`
		expect(p.parse("yahedzkel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("yaheǳkel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("यहेज्केल 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAHEDZKEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("YAHEǱKEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("यहेज्केल 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (mr)", ->
		`
		expect(p.parse("दानीएल्र 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("daniel 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("danīel 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("dāniel 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("dānīel 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानीएल 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("दानीएल्र 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DANIEL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DANĪEL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DĀNIEL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DĀNĪEL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानीएल 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (mr)", ->
		`
		expect(p.parse("hosey 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("hoŝey 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("होशेय 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HOSEY 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOŜEY 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("होशेय 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (mr)", ->
		`
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("yoel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("योएल 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("YOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("योएल 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (mr)", ->
		`
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("āmos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("अमोस 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("आमोस 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ĀMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("अमोस 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("आमोस 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (mr)", ->
		`
		expect(p.parse("obadʰa 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("obadʰā 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ओबद्या 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ओबधा 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("OBADʰA 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBADʰĀ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ओबद्या 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ओबधा 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (mr)", ->
		`
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("yona 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("yonā 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("योना 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("YONA 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("YONĀ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("योना 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (mr)", ->
		`
		expect(p.parse("mikʰa 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mikʰā 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mīkʰa 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mīkʰā 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("मीखा 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MIKʰA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIKʰĀ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MĪKʰA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MĪKʰĀ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("मीखा 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (mr)", ->
		`
		expect(p.parse("nahum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("nahūm 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("नहूम 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAHŪM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("नहूम 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (mr)", ->
		`
		expect(p.parse("habakkuk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("habakkūk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("हबक्कूक 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("हबक्कू 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HABAKKUK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAKKŪK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("हबक्कूक 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("हबक्कू 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (mr)", ->
		`
		expect(p.parse("sapʰanya 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("sapʰanyā 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("सफन्या 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SAPʰANYA 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SAPʰANYĀ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("सफन्या 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (mr)", ->
		`
		expect(p.parse("haggay 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("hāggay 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("हाग्गय 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HAGGAY 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HĀGGAY 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("हाग्गय 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (mr)", ->
		`
		expect(p.parse("jakʰarya 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("jakʰaryā 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("जखर्या 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("जखऱ्या 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JAKʰARYA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("JAKʰARYĀ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("जखर्या 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("जखऱ्या 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (mr)", ->
		`
		expect(p.parse("malakʰi 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("malakʰī 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("malākʰi 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("malākʰī 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("मलाखी 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MALAKʰI 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALAKʰĪ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALĀKʰI 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALĀKʰĪ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("मलाखी 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (mr)", ->
		`
		expect(p.parse("mattayane lihilele subʰavartaman 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayane lihilele subʰavartamān 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayane lihilele ŝubʰavartaman 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayane lihilele ŝubʰavartamān 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayāne lihilele subʰavartaman 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayāne lihilele subʰavartamān 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayāne lihilele ŝubʰavartaman 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayāne lihilele ŝubʰavartamān 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तयाने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayane 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattayāne 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तयाने 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तय 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MATTAYANE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYANE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYANE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYANE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYĀNE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYĀNE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYĀNE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYĀNE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तयाने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYANE 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTAYĀNE 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तयाने 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तय 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (mr)", ->
		`
		expect(p.parse("markane lihilele subʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markane lihilele subʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markane lihilele ŝubʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markane lihilele ŝubʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markāne lihilele subʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markāne lihilele subʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markāne lihilele ŝubʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markāne lihilele ŝubʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkane lihilele subʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkane lihilele subʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkane lihilele ŝubʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkane lihilele ŝubʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkāne lihilele subʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkāne lihilele subʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkāne lihilele ŝubʰavartaman 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkāne lihilele ŝubʰavartamān 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मार्काने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मार्काने 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markane 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markāne 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkane 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("mārkāne 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मार्क 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MARKANE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKANE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKANE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKANE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKĀNE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKĀNE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKĀNE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKĀNE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKANE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKANE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKANE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKANE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKĀNE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKĀNE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKĀNE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKĀNE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मार्काने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मार्काने 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKANE 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKĀNE 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKANE 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MĀRKĀNE 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मार्क 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (mr)", ->
		`
		expect(p.parse("lukane lihilele subʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukane lihilele subʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukane lihilele ŝubʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukane lihilele ŝubʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāne lihilele subʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāne lihilele subʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāne lihilele ŝubʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāne lihilele ŝubʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkane lihilele subʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkane lihilele subʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkane lihilele ŝubʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkane lihilele ŝubʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāne lihilele subʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāne lihilele subʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāne lihilele ŝubʰavartaman 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāne lihilele ŝubʰavartamān 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukane 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāne 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkane 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāne 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाने 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूका 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूक 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LUKANE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKANE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKANE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKANE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀNE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀNE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀNE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀNE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKANE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKANE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKANE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKANE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀNE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀNE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀNE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀNE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKANE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀNE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKANE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀNE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाने 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूका 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूक 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (mr)", ->
		`
		expect(p.parse("yohanacem pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yohanaceṃ pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yohanācem pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yohanāceṃ pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yohānacem pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yohānaceṃ pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yohānācem pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yohānāceṃ pahile patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("योहानाचें पहिले पत्र 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohanacem 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohanaceṃ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohanācem 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohanāceṃ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohānacem 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohānaceṃ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohānācem 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yohānāceṃ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 योहानाच 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 योहान 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YOHANACEM PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YOHANACEṂ PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YOHANĀCEM PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YOHANĀCEṂ PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YOHĀNACEM PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YOHĀNACEṂ PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YOHĀNĀCEM PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YOHĀNĀCEṂ PAHILE PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("योहानाचें पहिले पत्र 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHANACEM 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHANACEṂ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHANĀCEM 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHANĀCEṂ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHĀNACEM 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHĀNACEṂ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHĀNĀCEM 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YOHĀNĀCEṂ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 योहानाच 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 योहान 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (mr)", ->
		`
		expect(p.parse("yohanacem dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yohanaceṃ dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yohanācem dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yohanāceṃ dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yohānacem dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yohānaceṃ dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yohānācem dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yohānāceṃ dusre patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("योहानाचें दुसरे पत्र 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohanacem 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohanaceṃ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohanācem 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohanāceṃ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohānacem 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohānaceṃ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohānācem 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yohānāceṃ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 योहानाच 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 योहान 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YOHANACEM DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YOHANACEṂ DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YOHANĀCEM DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YOHANĀCEṂ DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YOHĀNACEM DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YOHĀNACEṂ DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YOHĀNĀCEM DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YOHĀNĀCEṂ DUSRE PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("योहानाचें दुसरे पत्र 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHANACEM 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHANACEṂ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHANĀCEM 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHANĀCEṂ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHĀNACEM 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHĀNACEṂ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHĀNĀCEM 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YOHĀNĀCEṂ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 योहानाच 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 योहान 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (mr)", ->
		`
		expect(p.parse("yohanacem tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yohanaceṃ tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yohanācem tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yohanāceṃ tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yohānacem tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yohānaceṃ tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yohānācem tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yohānāceṃ tisre patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("योहानाचें तिसरे पत्र 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohanacem 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohanaceṃ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohanācem 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohanāceṃ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohānacem 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohānaceṃ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohānācem 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yohānāceṃ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 योहानाच 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 योहान 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YOHANACEM TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YOHANACEṂ TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YOHANĀCEM TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YOHANĀCEṂ TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YOHĀNACEM TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YOHĀNACEṂ TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YOHĀNĀCEM TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YOHĀNĀCEṂ TISRE PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("योहानाचें तिसरे पत्र 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHANACEM 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHANACEṂ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHANĀCEM 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHANĀCEṂ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHĀNACEM 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHĀNACEṂ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHĀNĀCEM 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YOHĀNĀCEṂ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 योहानाच 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 योहान 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (mr)", ->
		`
		expect(p.parse("yohanane lihilele subʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanane lihilele subʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanane lihilele ŝubʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanane lihilele ŝubʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanāne lihilele subʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanāne lihilele subʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanāne lihilele ŝubʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanāne lihilele ŝubʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānane lihilele subʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānane lihilele subʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānane lihilele ŝubʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānane lihilele ŝubʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānāne lihilele subʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānāne lihilele subʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānāne lihilele ŝubʰavartaman 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānāne lihilele ŝubʰavartamān 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("योहानाने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanane 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohanāne 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānane 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yohānāne 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("योहानाने 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("योहान 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YOHANANE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANANE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANANE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANANE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANĀNE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANĀNE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANĀNE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANĀNE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNANE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNANE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNANE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNANE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNĀNE LIHILELE SUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNĀNE LIHILELE SUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNĀNE LIHILELE ŜUBʰAVARTAMAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNĀNE LIHILELE ŜUBʰAVARTAMĀN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("योहानाने लिहिलेले शुभवर्तमान 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANANE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHANĀNE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNANE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YOHĀNĀNE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("योहानाने 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("योहान 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (mr)", ->
		`
		expect(p.parse("प्रेषितांचीं कृत्यें 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitamcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitaṃcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāmcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("presitāṃcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitamcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitaṃcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāmcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃcim kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃcim kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃciṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃciṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃcīm kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃcīm kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃcīṃ kr̥tyem 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("prešitāṃcīṃ kr̥tyeṃ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेषितांची कृत्यें 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेषितांचीं कृत्ये 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("प्रेषितांचीं कृत्यें 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAMCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITAṂCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀMCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRESITĀṂCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAMCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITAṂCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀMCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCIM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCIM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCIṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCIṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCĪM KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCĪM KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCĪṂ KR̥TYEM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PREŠITĀṂCĪṂ KR̥TYEṂ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेषितांची कृत्यें 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेषितांचीं कृत्ये 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (mr)", ->
		`
		expect(p.parse("पौलाचे रोमकरांस पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkarams patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkaraṃs patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkarāms patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkarāṃs patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमकरांस पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkarams 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkaraṃs 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkarāms 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romkarāṃs 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमकंरास 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमकरांस 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे रोमकरांस पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARAMS PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARAṂS PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARĀMS PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARĀṂS PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमकरांस पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARAMS 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARAṂS 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARĀMS 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMKARĀṂS 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमकंरास 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमकरांस 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (mr)", ->
		`
		expect(p.parse("पौलाचे करिंथकरांस दूसरे पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("karimtʰkarams dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("karimtʰkaraṃs dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("karimtʰkarāms dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("karimtʰkarāṃs dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("kariṃtʰkarams dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("kariṃtʰkaraṃs dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("kariṃtʰkarāms dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("kariṃtʰkarāṃs dusre patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("करिंथकरांस दुसरे पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 karimtʰkarams 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 karimtʰkaraṃs 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 karimtʰkarāms 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 karimtʰkarāṃs 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 kariṃtʰkarams 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 kariṃtʰkaraṃs 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 kariṃtʰkarāms 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 kariṃtʰkarāṃs 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 करिंथकरांस 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे करिंथकरांस दूसरे पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIMTʰKARAMS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIMTʰKARAṂS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIMTʰKARĀMS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIMTʰKARĀṂS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIṂTʰKARAMS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIṂTʰKARAṂS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIṂTʰKARĀMS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KARIṂTʰKARĀṂS DUSRE PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("करिंथकरांस दुसरे पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIMTʰKARAMS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIMTʰKARAṂS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIMTʰKARĀMS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIMTʰKARĀṂS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIṂTʰKARAMS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIṂTʰKARAṂS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIṂTʰKARĀMS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KARIṂTʰKARĀṂS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 करिंथकरांस 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (mr)", ->
		`
		expect(p.parse("पौलाचे करिंथकरांस पहिले पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("karimtʰkarams pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("karimtʰkaraṃs pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("karimtʰkarāms pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("karimtʰkarāṃs pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("kariṃtʰkarams pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("kariṃtʰkaraṃs pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("kariṃtʰkarāms pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("kariṃtʰkarāṃs pahile patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("करिंथकरांस पहिले पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 karimtʰkarams 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 karimtʰkaraṃs 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 karimtʰkarāms 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 karimtʰkarāṃs 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 kariṃtʰkarams 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 kariṃtʰkaraṃs 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 kariṃtʰkarāms 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 kariṃtʰkarāṃs 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 करिंथकरांस 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे करिंथकरांस पहिले पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIMTʰKARAMS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIMTʰKARAṂS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIMTʰKARĀMS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIMTʰKARĀṂS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIṂTʰKARAMS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIṂTʰKARAṂS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIṂTʰKARĀMS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KARIṂTʰKARĀṂS PAHILE PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("करिंथकरांस पहिले पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIMTʰKARAMS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIMTʰKARAṂS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIMTʰKARĀMS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIMTʰKARĀṂS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIṂTʰKARAMS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIṂTʰKARAṂS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIṂTʰKARĀMS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KARIṂTʰKARĀṂS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 करिंथकरांस 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (mr)", ->
		`
		expect(p.parse("पौलाचे गलतीकरांस पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikarams patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikaraṃs patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikarāms patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikarāṃs patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkarams patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkaraṃs patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkarāms patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkarāṃs patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलतीकरांस पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikarams 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikaraṃs 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikarāms 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatikarāṃs 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkarams 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkaraṃs 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkarāms 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīkarāṃs 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलतीकरांस 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे गलतीकरांस पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARAMS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARAṂS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARĀMS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARĀṂS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARAMS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARAṂS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARĀMS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARĀṂS PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलतीकरांस पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARAMS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARAṂS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARĀMS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIKARĀṂS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARAMS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARAṂS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARĀMS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪKARĀṂS 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलतीकरांस 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (mr)", ->
		`
		expect(p.parse("पौलाचे इफिसकरांस पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskarams patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskaraṃs patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskarāms patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskarāṃs patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("इफिसकरांस पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskarams 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskaraṃs 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskarāms 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ipʰiskarāṃs 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("इफिसकरांस 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे इफिसकरांस पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARAMS PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARAṂS PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARĀMS PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARĀṂS PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("इफिसकरांस पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARAMS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARAṂS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARĀMS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IPʰISKARĀṂS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("इफिसकरांस 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (mr)", ->
		`
		expect(p.parse("पौलाचे फिलिप्पैकरांस पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikarams patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikaraṃs patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikarāms patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikarāṃs patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पैकरांस पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikarams 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikaraṃs 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikarāms 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippaikarāṃs 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पैकरांस 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे फिलिप्पैकरांस पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARAMS PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARAṂS PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARĀMS PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARĀṂS PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पैकरांस पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARAMS 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARAṂS 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARĀMS 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPAIKARĀṂS 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पैकरांस 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (mr)", ->
		`
		expect(p.parse("पौलाचे कलस्सैकरांस पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikarams patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikaraṃs patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikarāms patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikarāṃs patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सैकरांस पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikarams 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikaraṃs 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikarāms 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassaikarāṃs 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सैकरांस 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलसैकरांस 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे कलस्सैकरांस पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARAMS PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARAṂS PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARĀMS PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARĀṂS PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सैकरांस पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARAMS 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARAṂS 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARĀMS 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSAIKARĀṂS 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सैकरांस 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलसैकरांस 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (mr)", ->
		`
		expect(p.parse("पौलाचे थेस्सलनीकाकरांस दुसरे पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikakarams dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikakaraṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikakarāms dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikakarāṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikākarams dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikākaraṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikākarāms dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanikākarāṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkakarams dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkakaraṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkakarāms dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkakarāṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkākarams dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkākaraṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkākarāms dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰessalanīkākarāṃs dusre patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("थेस्सलनीकाकरांस दुसरे पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikakarams 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikakaraṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikakarāms 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikakarāṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikākarams 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikākaraṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikākarāms 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanikākarāṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkakarams 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkakaraṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkakarāms 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkakarāṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkākarams 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkākaraṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkākarāms 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰessalanīkākarāṃs 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 थेस्सलनीकाकरांस 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे थेस्सलनीकाकरांस दुसरे पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARAMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARAṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARĀMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARĀṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARAMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARAṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARĀMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARĀṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARAMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARAṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARĀMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARĀṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARAMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARAṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARĀMS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARĀṂS DUSRE PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("थेस्सलनीकाकरांस दुसरे पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKAKARAMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKAKARAṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKAKARĀMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKAKARĀṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKĀKARAMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKĀKARAṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKĀKARĀMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANIKĀKARĀṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKAKARAMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKAKARAṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKAKARĀMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKAKARĀṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKĀKARAMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKĀKARAṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKĀKARĀMS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰESSALANĪKĀKARĀṂS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 थेस्सलनीकाकरांस 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (mr)", ->
		`
		expect(p.parse("पौलाचे थेस्सलनीकाकरांस पहिले पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikakarams pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikakaraṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikakarāms pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikakarāṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikākarams pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikākaraṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikākarāms pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanikākarāṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkakarams pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkakaraṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkakarāms pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkakarāṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkākarams pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkākaraṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkākarāms pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰessalanīkākarāṃs pahile patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("थेस्सलनीकाकरांस पहिले पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikakarams 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikakaraṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikakarāms 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikakarāṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikākarams 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikākaraṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikākarāms 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanikākarāṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkakarams 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkakaraṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkakarāms 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkakarāṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkākarams 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkākaraṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkākarāms 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰessalanīkākarāṃs 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 थेस्सलनीकाकरांस 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे थेस्सलनीकाकरांस पहिले पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARAMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARAṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARĀMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKAKARĀṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARAMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARAṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARĀMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANIKĀKARĀṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARAMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARAṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARĀMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKAKARĀṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARAMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARAṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARĀMS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰESSALANĪKĀKARĀṂS PAHILE PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("थेस्सलनीकाकरांस पहिले पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKAKARAMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKAKARAṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKAKARĀMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKAKARĀṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKĀKARAMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKĀKARAṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKĀKARĀMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANIKĀKARĀṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKAKARAMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKAKARAṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKAKARĀMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKAKARĀṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKĀKARAMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKĀKARAṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKĀKARĀMS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰESSALANĪKĀKARĀṂS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 थेस्सलनीकाकरांस 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (mr)", ->
		`
		expect(p.parse("पौलाचे तीमथ्थाला दुसरे पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timatʰtʰala dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timatʰtʰalā dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timatʰtʰāla dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timatʰtʰālā dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("tīmatʰtʰala dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("tīmatʰtʰalā dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("tīmatʰtʰāla dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("tīmatʰtʰālā dusre patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("तीमथ्थाला दुसरे पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timatʰtʰala 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timatʰtʰalā 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timatʰtʰāla 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timatʰtʰālā 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 tīmatʰtʰala 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 tīmatʰtʰalā 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 tīmatʰtʰāla 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 tīmatʰtʰālā 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 तीमथ्थाला 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे तीमथ्थाला दुसरे पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMATʰTʰALA DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMATʰTʰALĀ DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMATʰTʰĀLA DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMATʰTʰĀLĀ DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TĪMATʰTʰALA DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TĪMATʰTʰALĀ DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TĪMATʰTʰĀLA DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TĪMATʰTʰĀLĀ DUSRE PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("तीमथ्थाला दुसरे पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMATʰTʰALA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMATʰTʰALĀ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMATʰTʰĀLA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMATʰTʰĀLĀ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TĪMATʰTʰALA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TĪMATʰTʰALĀ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TĪMATʰTʰĀLA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TĪMATʰTʰĀLĀ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 तीमथ्थाला 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (mr)", ->
		`
		expect(p.parse("पौलाचे तीमथ्याला पहिले पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timatʰtʰala pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timatʰtʰalā pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timatʰtʰāla pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timatʰtʰālā pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("tīmatʰtʰala pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("tīmatʰtʰalā pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("tīmatʰtʰāla pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("tīmatʰtʰālā pahile patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("तीमथ्थाला पहिले पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timatʰtʰala 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timatʰtʰalā 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timatʰtʰāla 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timatʰtʰālā 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 tīmatʰtʰala 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 tīmatʰtʰalā 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 tīmatʰtʰāla 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 tīmatʰtʰālā 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तीमथ्थाला 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तीमथ्याला 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे तीमथ्याला पहिले पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMATʰTʰALA PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMATʰTʰALĀ PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMATʰTʰĀLA PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMATʰTʰĀLĀ PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TĪMATʰTʰALA PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TĪMATʰTʰALĀ PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TĪMATʰTʰĀLA PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TĪMATʰTʰĀLĀ PAHILE PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("तीमथ्थाला पहिले पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMATʰTʰALA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMATʰTʰALĀ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMATʰTʰĀLA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMATʰTʰĀLĀ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TĪMATʰTʰALA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TĪMATʰTʰALĀ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TĪMATʰTʰĀLA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TĪMATʰTʰĀLĀ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तीमथ्थाला 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तीमथ्याला 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (mr)", ->
		`
		expect(p.parse("पौलाचे तीताला पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titala patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titalā patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titāla patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titālā patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītala patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītalā patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītāla patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītālā patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीताला पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titala 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titalā 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titāla 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titālā 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītala 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītalā 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītāla 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītālā 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीताला 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे तीताला पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITALA PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITALĀ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITĀLA PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITĀLĀ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTALA PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTALĀ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTĀLA PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTĀLĀ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीताला पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITALA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITALĀ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITĀLA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITĀLĀ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTALA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTALĀ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTĀLA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTĀLĀ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीताला 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (mr)", ->
		`
		expect(p.parse("पौलाचे फिलेमोनाला पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonala patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonalā patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonāla patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonālā patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनाला पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonala 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonalā 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonāla 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonālā 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनाला 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोना 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पौलाचे फिलेमोनाला पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONALA PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONALĀ PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONĀLA PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONĀLĀ PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनाला पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONALA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONALĀ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONĀLA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONĀLĀ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनाला 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोना 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (mr)", ->
		`
		expect(p.parse("ibri lokams patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibri lokaṃs patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibri lokāms patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibri lokāṃs patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokams patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokaṃs patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokāms patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokāṃs patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("इब्री लोकांस पत्र 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("इब्री लोकांस 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibri lokams 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibri lokaṃs 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibri lokāms 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibri lokāṃs 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokams 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokaṃs 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokāms 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ibrī lokāṃs 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("इब्री 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("IBRI LOKAMS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRI LOKAṂS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRI LOKĀMS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRI LOKĀṂS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKAMS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKAṂS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKĀMS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKĀṂS PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("इब्री लोकांस पत्र 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("इब्री लोकांस 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRI LOKAMS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRI LOKAṂS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRI LOKĀMS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRI LOKĀṂS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKAMS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKAṂS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKĀMS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("IBRĪ LOKĀṂS 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("इब्री 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (mr)", ->
		`
		expect(p.parse("yakobacem patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakobaceṃ patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakobācem patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakobāceṃ patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobacem patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobaceṃ patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobācem patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobāceṃ patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकोबाचें पत्र 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakobacem 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakobaceṃ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakobācem 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakobāceṃ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobacem 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobaceṃ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobācem 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākobāceṃ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकोबाचें 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकोब 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAKOBACEM PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKOBACEṂ PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKOBĀCEM PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKOBĀCEṂ PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBACEM PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBACEṂ PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBĀCEM PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBĀCEṂ PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकोबाचें पत्र 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKOBACEM 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKOBACEṂ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKOBĀCEM 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKOBĀCEṂ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBACEM 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBACEṂ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBĀCEM 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKOBĀCEṂ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकोबाचें 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकोब 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (mr)", ->
		`
		expect(p.parse("petracem dusre patra 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("petraceṃ dusre patra 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("petrācem dusre patra 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("petrāceṃ dusre patra 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("पेत्राचें दुसरे पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("पौलाचें दुसरे पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पेत्राचें 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 petracem 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 petraceṃ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 petrācem 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 petrāceṃ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पेत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PETRACEM DUSRE PATRA 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("PETRACEṂ DUSRE PATRA 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("PETRĀCEM DUSRE PATRA 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("PETRĀCEṂ DUSRE PATRA 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("पेत्राचें दुसरे पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("पौलाचें दुसरे पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पेत्राचें 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETRACEM 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETRACEṂ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETRĀCEM 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETRĀCEṂ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पेत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (mr)", ->
		`
		expect(p.parse("petracem pahile patra 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("petraceṃ pahile patra 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("petrācem pahile patra 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("petrāceṃ pahile patra 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("पेत्राचें पहिले पत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("पेत्राचे पहिले पत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पेत्राचें 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 petracem 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 petraceṃ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 petrācem 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 petrāceṃ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पेत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PETRACEM PAHILE PATRA 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PETRACEṂ PAHILE PATRA 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PETRĀCEM PAHILE PATRA 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PETRĀCEṂ PAHILE PATRA 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("पेत्राचें पहिले पत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("पेत्राचे पहिले पत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पेत्राचें 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETRACEM 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETRACEṂ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETRĀCEM 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETRĀCEṂ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पेत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (mr)", ->
		`
		expect(p.parse("yahudacem patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudaceṃ patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudācem patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudāceṃ patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdacem patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdaceṃ patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdācem patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdāceṃ patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाचें पत्र 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudacem 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudaceṃ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudācem 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudāceṃ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdacem 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdaceṃ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdācem 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdāceṃ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाचें 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदा 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAHUDACEM PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDACEṂ PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDĀCEM PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDĀCEṂ PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDACEM PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDACEṂ PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDĀCEM PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDĀCEṂ PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाचें पत्र 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDACEM 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDACEṂ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDĀCEM 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDĀCEṂ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDACEM 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDACEṂ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDĀCEM 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDĀCEṂ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाचें 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदा 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (mr)", ->
		`
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (mr)", ->
		`
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (mr)", ->
		`
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (mr)", ->
		`
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (mr)", ->
		`
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (mr)", ->
		`
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (mr)", ->
		`
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (mr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (mr)", ->
		`
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
		expect(p.languages).toEqual ["mr"]

	it "should handle ranges (mr)", ->
		expect(p.parse("Titus 1:1 to 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1to2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 TO 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (mr)", ->
		expect(p.parse("Titus 1:1, chapter 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHAPTER 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (mr)", ->
		expect(p.parse("Exod 1:1 verse 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSE 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (mr)", ->
		expect(p.parse("Exod 1:1 and 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 AND 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (mr)", ->
		expect(p.parse("Ps 3 title, 4:2, 5:title").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 TITLE, 4:2, 5:TITLE").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (mr)", ->
		expect(p.parse("Rev 3ff, 4:2ff").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 FF, 4:2 FF").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (mr)", ->
		expect(p.parse("Lev 1 (ERV)").osis_and_translations()).toEqual [["Lev.1", "ERV"]]
		expect(p.parse("lev 1 erv").osis_and_translations()).toEqual [["Lev.1", "ERV"]]
	it "should handle boundaries (mr)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
