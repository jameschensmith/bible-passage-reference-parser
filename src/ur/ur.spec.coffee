bcv_parser = require("../../js/ur_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (ur)", ->
		`
		expect(p.parse("pīdāyiš 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پَیدایش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پيدائش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پیدائش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پیدایش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PĪDĀYIŠ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پَیدایش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پيدائش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پیدائش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("پیدایش 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (ur)", ->
		`
		expect(p.parse("خُرُوج 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ḫurūj 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("خروج 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("خُرُوج 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ḪURŪJ 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("خروج 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (ur)", ->
		`
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (ur)", ->
		`
		expect(p.parse("iḥbār 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("احبار 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("IḤBĀR 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("احبار 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (ur)", ->
		`
		expect(p.parse("gintī 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("گِنتی 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("گنتی 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GINTĪ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("گِنتی 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("گنتی 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (ur)", ->
		`
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (ur)", ->
		`
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (ur)", ->
		`
		expect(p.parse("نَوحہ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("nūḥâ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("نوحہ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("نَوحہ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("NŪḤÂ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("نوحہ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (ur)", ->
		`
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (ur)", ->
		`
		expect(p.parse("yūḥannā ʿārif kā mukāšafâ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("یُو حنّا عارِف کا مُکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("یو حنا عارف کا مکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("یُوحنا عارف کا مکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("مُکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("مکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YŪḤANNĀ ʿĀRIF KĀ MUKĀŠAFÂ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("یُو حنّا عارِف کا مُکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("یو حنا عارف کا مکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("یُوحنا عارف کا مکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("مُکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("مکاشفہ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (ur)", ->
		`
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (ur)", ->
		`
		expect(p.parse("istis̱nā 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("اِستِثنا 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("استثناء 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("استثنا 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ISTIS̱NĀ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("اِستِثنا 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("استثناء 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("استثنا 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (ur)", ->
		`
		expect(p.parse("yašūʿ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("یشُوع 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("یشوع 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAŠŪʿ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("یشُوع 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("یشوع 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (ur)", ->
		`
		expect(p.parse("qużāh 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قُضاۃ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قضاة 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قضاہ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قضاۃ 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("QUŻĀH 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قُضاۃ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قضاة 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قضاہ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("قضاۃ 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (ur)", ->
		`
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("رُوت 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("rūt 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("روت 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("رُوت 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RŪT 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("روت 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (ur)", ->
		`
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (ur)", ->
		`
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (ur)", ->
		`
		expect(p.parse("yasaʿyāh 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("یسعیاہ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("یعسیاہ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YASAʿYĀH 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("یسعیاہ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("یعسیاہ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (ur)", ->
		`
		expect(p.parse("دوم سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("دوم-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("دوم۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 samūʾīl 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2.-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2.۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲ سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2Sam (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("دوم سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("دوم-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("دوم۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 samūʾīl 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2.-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2.۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲ سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("دوم سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("دوم-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("دوم۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMŪʾĪL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2.-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2.۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲ سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲-سموئیل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("۲۔سموایل 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (ur)", ->
		`
		expect(p.parse("اوّل سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 samūʾīl 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1.-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1.۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱ سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱ سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1Sam (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("اوّل سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 samūʾīl 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1.-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1.۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱ سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱ سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("اوّل سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("اوّل۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMŪʾĪL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1.-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1.۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱ سموئيل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱ سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱-سموئیل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("۱۔سموایل 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (ur)", ->
		`
		expect(p.parse("دوم-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2.-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("دوم سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("دوم۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 salāṭīn 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2.۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲ سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2Kgs (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("دوم-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2.-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("دوم سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("دوم۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 salāṭīn 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2.۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲ سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("دوم-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2.-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("دوم سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("دوم۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 SALĀṬĪN 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2.۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲-سلاطِین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲ سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("۲۔سلاطین 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (ur)", ->
		`
		expect(p.parse("اوّل-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("اوّل سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("اوّل۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1.-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 salāṭīn 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1.۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱ سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1Kgs (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("اوّل-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("اوّل سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("اوّل۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1.-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 salāṭīn 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1.۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱ سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("اوّل-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("اوّل سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("اوّل۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1.-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 SALĀṬĪN 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1.۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱-سلاطِین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱ سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("۱۔سلاطین 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (ur)", ->
		`
		expect(p.parse("دوم- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2.- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("دوم تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("دوم۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 tavārīḫ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2.۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲ تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2Chr (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("دوم- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2.- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("دوم تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("دوم۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 tavārīḫ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2.۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲ تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("دوم- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2.- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("دوم تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("دوم۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲- توارِیخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 TAVĀRĪḪ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2.۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲ تو اریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("۲۔تواریخ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (ur)", ->
		`
		expect(p.parse("اوّل-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("اوّل تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("اوّل۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1.-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 tavārīḫ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1.۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱ تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1Chr (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("اوّل-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("اوّل تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("اوّل۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1.-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 tavārīḫ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1.۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱ تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("اوّل-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("اوّل تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("اوّل۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1.-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 TAVĀRĪḪ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1.۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱-توارِیخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱ تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("۱۔تواریخ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (ur)", ->
		`
		expect(p.parse("ʿizrā 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("عز را 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("عزرا 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ʿIZRĀ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("عز را 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("عزرا 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (ur)", ->
		`
		expect(p.parse("niḥimyāh 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("نحمیاہ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NIḤIMYĀH 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("نحمیاہ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (ur)", ->
		`
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (ur)", ->
		`
		expect(p.parse("āstar 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ایستر 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("آستر 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ĀSTAR 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ایستر 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("آستر 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (ur)", ->
		`
		expect(p.parse("ایُّوب 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ayyūb 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ایّوب 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ایوب 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ایُّوب 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("AYYŪB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ایّوب 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ایوب 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (ur)", ->
		`
		expect(p.parse("zabūr 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("زبُور 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("زبور 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("زبُو 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZABŪR 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("زبُور 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("زبور 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("زبُو 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (ur)", ->
		`
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (ur)", ->
		`
		expect(p.parse("ams̱āl 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("اَمثال 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("امثال 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMS̱ĀL 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("اَمثال 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("امثال 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (ur)", ->
		`
		expect(p.parse("واعِظ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("vāʿẓ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("واعظ 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("واعِظ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("VĀʿẒ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("واعظ 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (ur)", ->
		`
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (ur)", ->
		`
		expect(p.parse("ġazalu l-ġazalāt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("غزلُ الغزلات 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("غزل الغزلات 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ĠAZALU L-ĠAZALĀT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("غزلُ الغزلات 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("غزل الغزلات 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (ur)", ->
		`
		expect(p.parse("yirmayāh 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("یرمِیاہ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("یرمیاہ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YIRMAYĀH 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("یرمِیاہ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("یرمیاہ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (ur)", ->
		`
		expect(p.parse("حِزقی ایل 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ḥiziqīʾīl 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("حزقی ایل 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("حزقی‌ایل 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("حِزقی ایل 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ḤIZIQĪʾĪL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("حزقی ایل 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("حزقی‌ایل 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (ur)", ->
		`
		expect(p.parse("دانی ایل 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("دانی‌ایل 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("dānīʾīl 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("دانیال 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("دانی ایل 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("دانی‌ایل 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DĀNĪʾĪL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("دانیال 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (ur)", ->
		`
		expect(p.parse("ہو سیعاہ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ہوسیعَِ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("hūsīʿ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ہوسیع 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ہو سیعاہ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ہوسیعَِ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HŪSĪʿ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ہوسیع 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (ur)", ->
		`
		expect(p.parse("یُوایل 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("yōʾīl 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("یوایل 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("یُوایل 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("YŌʾĪL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("یوایل 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (ur)", ->
		`
		expect(p.parse("عامُوس 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ʿāmōs 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("عاموس 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("عامُوس 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ʿĀMŌS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("عاموس 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (ur)", ->
		`
		expect(p.parse("ʿabadiyāh 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("عبدیاہ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ʿABADIYĀH 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("عبدیاہ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (ur)", ->
		`
		expect(p.parse("یُوناہ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("yūnas 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("یونس 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("یُوناہ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("YŪNAS 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("یونس 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (ur)", ->
		`
		expect(p.parse("مِیکاہ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mīkāh 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("میکاہ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("مِیکاہ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MĪKĀH 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("میکاہ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (ur)", ->
		`
		expect(p.parse("نا حُوم 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ناحُوم 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("nāḥūm 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ناحوم 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("نا حُوم 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ناحُوم 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NĀḤŪM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ناحوم 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (ur)", ->
		`
		expect(p.parse("ḥabaqqūq 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("حبقُّوق 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("حبقّوق 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("حبقوق 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ḤABAQQŪQ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("حبقُّوق 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("حبقّوق 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("حبقوق 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (ur)", ->
		`
		expect(p.parse("ṣafaniyāh 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("صفنیاہ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ṢAFANIYĀH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("صفنیاہ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (ur)", ->
		`
		expect(p.parse("ḥajjai 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("حجَّی 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("حجيّ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("حجی 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ḤAJJAI 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("حجَّی 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("حجيّ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("حجی 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (ur)", ->
		`
		expect(p.parse("zakariyāh 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("زکریاہ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("زکریا 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZAKARIYĀH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("زکریاہ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("زکریا 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (ur)", ->
		`
		expect(p.parse("malākī 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("ملاکی 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MALĀKĪ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("ملاکی 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (ur)", ->
		`
		expect(p.parse("mattī kī injīl 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متّی کی انجیل 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متی کی انجیل 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متّی 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متی 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MATTĪ KĪ INJĪL 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متّی کی انجیل 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متی کی انجیل 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متّی 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("متی 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (ur)", ->
		`
		expect(p.parse("marqus kī injīl 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("مرقُس کی انجیل 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("مرقس کی انجیل 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("مرقس 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MARQUS KĪ INJĪL 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("مرقُس کی انجیل 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("مرقس کی انجیل 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("مرقس 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (ur)", ->
		`
		expect(p.parse("لُوقا کی انجیل 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūqā kī injīl 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("لوقا کی انجیل 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("لُوقا 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("لوقا 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("لُوقا کی انجیل 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪQĀ KĪ INJĪL 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("لوقا کی انجیل 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("لُوقا 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("لوقا 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 2John (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (ur)", ->
		`
		expect(p.parse("yūḥannā kā dūsrā ʿām ḫaṭ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یُوحنّا کا دوسرا عام خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یوحنا کا دوسرا عام خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یوحنّا کا دوسرا خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2.-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲ یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2.۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲ یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2John (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("yūḥannā kā dūsrā ʿām ḫaṭ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یُوحنّا کا دوسرا عام خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یوحنا کا دوسرا عام خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یوحنّا کا دوسرا خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2.-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲ یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2.۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲ یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YŪḤANNĀ KĀ DŪSRĀ ʿĀM ḪAṬ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یُوحنّا کا دوسرا عام خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یوحنا کا دوسرا عام خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("یوحنّا کا دوسرا خط 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2.-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("دوم۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲ یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲-یُوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2.۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲ یوحنّا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("۲۔یوحنا 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (ur)", ->
		`
		expect(p.parse("yūḥannā kā tīsrā ʿām ḫaṭ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یُوحنّا کا تیسرا عام خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنا کا تیسرا عام خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا تیسرا خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا 3. خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا 3 خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا ۳ خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3.-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳ یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3.۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳ یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		`
		true
	it "should handle non-Latin digits in book: 3John (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("yūḥannā kā tīsrā ʿām ḫaṭ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یُوحنّا کا تیسرا عام خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنا کا تیسرا عام خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا تیسرا خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا 3. خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا 3 خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا ۳ خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3.-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳ یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3.۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳ یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YŪḤANNĀ KĀ TĪSRĀ ʿĀM ḪAṬ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یُوحنّا کا تیسرا عام خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنا کا تیسرا عام خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا تیسرا خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا 3. خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا 3 خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("یوحنّا کا ۳ خط 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("تیسرا۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3.-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳ یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳-یُوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3.۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳ یوحنّا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("۳۔یوحنا 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book 1John (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (ur)", ->
		`
		expect(p.parse("yūḥannā kā pahlā ʿām ḫaṭ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یُوحنّا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یوحنّا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یوحنا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1.-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱ یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1.۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱ یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1John (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("yūḥannā kā pahlā ʿām ḫaṭ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یُوحنّا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یوحنّا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یوحنا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1.-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱ یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1.۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱ یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YŪḤANNĀ KĀ PAHLĀ ʿĀM ḪAṬ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یُوحنّا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یوحنّا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("یوحنا کا پہلا عام خط 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1.-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("اوّل۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱ یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱-یُوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1.۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱ یوحنّا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("۱۔یوحنا 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book John (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (ur)", ->
		`
		expect(p.parse("yūḥannā kī injīl 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یُوحنّا کی انجیل 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یوحنا کی انجیل 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یُوحنّا 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یوحنا 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YŪḤANNĀ KĪ INJĪL 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یُوحنّا کی انجیل 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یوحنا کی انجیل 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یُوحنّا 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("یوحنا 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (ur)", ->
		`
		expect(p.parse("rasūlōṅ ke aʿmāl 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("رسُولوں کے اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("رسولوں کے اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("یوحنا کے اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("اَعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("رسولوں 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RASŪLŌṄ KE AʿMĀL 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("رسُولوں کے اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("رسولوں کے اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("یوحنا کے اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("اَعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("رسولوں 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("اعمال 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (ur)", ->
		`
		expect(p.parse("رومیوں کے نام پولس رسول کا خط 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("rōmiyōṅ ke nām kā ḫaṭ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("رومیوں کے نام کا خط 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("رُومِیوں 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("رومیوں 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("رومیوں کے نام پولس رسول کا خط 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("RŌMIYŌṄ KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("رومیوں کے نام کا خط 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("رُومِیوں 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("رومیوں 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (ur)", ->
		`
		expect(p.parse("کرنتھِیُوں کے نام پولس رسول کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("kurintʰiyōṅ ke nām kā dūsrā ḫaṭ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("کُرِنتھِیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("کرنتھیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2.-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2.۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2Cor (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("کرنتھِیُوں کے نام پولس رسول کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("kurintʰiyōṅ ke nām kā dūsrā ḫaṭ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("کُرِنتھِیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("کرنتھیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2.-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2.۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("کرنتھِیُوں کے نام پولس رسول کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KURINTʰIYŌṄ KE NĀM KĀ DŪSRĀ ḪAṬ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("کُرِنتھِیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("کرنتھیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2.-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲-کُرِنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("دوم۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کرنتھِیُوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کُرنتھِیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2.۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲ کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("۲۔کرنتھیوں 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (ur)", ->
		`
		expect(p.parse("کرنتھِیُوں کے نام پولس رسول کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("kurintʰiyōṅ ke nām kā pahlā ḫaṭ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("کُرِنتھِیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("کرنتھیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1.-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱ کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱ کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1.۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1Cor (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("کرنتھِیُوں کے نام پولس رسول کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("kurintʰiyōṅ ke nām kā pahlā ḫaṭ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("کُرِنتھِیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("کرنتھیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1.-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱ کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱ کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1.۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("کرنتھِیُوں کے نام پولس رسول کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KURINTʰIYŌṄ KE NĀM KĀ PAHLĀ ḪAṬ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("کُرِنتھِیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("کرنتھیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1.-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("اوّل۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱-کُرِنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱ کرنتھِیُوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱ کُرنتھِیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1.۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("۱۔کرنتھیوں 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (ur)", ->
		`
		expect(p.parse("گلتیوں کے نام پولُس رسول کا خط 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiyōṅ ke nām kā ḫaṭ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتِیوں کے نام کا خط 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتیوں کے نام کا خط 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتِیوں 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتیوں 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("گلتیوں کے نام پولُس رسول کا خط 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIYŌṄ KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتِیوں کے نام کا خط 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتیوں کے نام کا خط 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتِیوں 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("گلتیوں 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (ur)", ->
		`
		expect(p.parse("افسیوں کے نام پو لس رسول کا خط 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ifisiyōṅ ke nām kā ḫaṭ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("اِفِسِیوں کے نام کا خط 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("افسیوں کے نام کا خط 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("اِفسِیوں 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("اِفسیوں 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("افسیوں 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("افسیوں کے نام پو لس رسول کا خط 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("IFISIYŌṄ KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("اِفِسِیوں کے نام کا خط 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("افسیوں کے نام کا خط 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("اِفسِیوں 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("اِفسیوں 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("افسیوں 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (ur)", ->
		`
		expect(p.parse("فِلِپّیُوں کے نام پو لس رسُول کا خط 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("filippiyōṅ ke nām kā ḫaṭ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فِلِپِّیوں کے نام کا خط 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فلپیوں کے نام کا خط 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فِلِپّیُوں 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فِلپّیوں 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فلپیوں 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("فِلِپّیُوں کے نام پو لس رسُول کا خط 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FILIPPIYŌṄ KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فِلِپِّیوں کے نام کا خط 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فلپیوں کے نام کا خط 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فِلِپّیُوں 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فِلپّیوں 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("فلپیوں 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (ur)", ->
		`
		expect(p.parse("کُلِسّیوں کے نام پولُس رسُول کا خط 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kulussiyōṅ ke nām kā ḫaṭ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلُسِّیوں کے نام کا خط 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کلسیوں کے نام کا خط 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلِسّیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلسِیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلسّیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کلسیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("کُلِسّیوں کے نام پولُس رسُول کا خط 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KULUSSIYŌṄ KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلُسِّیوں کے نام کا خط 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کلسیوں کے نام کا خط 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلِسّیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلسِیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کُلسّیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("کلسیوں 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (ur)", ->
		`
		expect(p.parse("تھسلنیکوں کے نام پو لس رسول کادوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalunīkiyōṅ ke nām kā dūsrā ḫaṭ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("تھِسّلُنیکیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("تھسلنیکیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2.-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2.۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2Thess (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("تھسلنیکوں کے نام پو لس رسول کادوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalunīkiyōṅ ke nām kā dūsrā ḫaṭ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("تھِسّلُنیکیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("تھسلنیکیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2.-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2.۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("تھسلنیکوں کے نام پو لس رسول کادوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALUNĪKIYŌṄ KE NĀM KĀ DŪSRĀ ḪAṬ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("تھِسّلُنیکیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("تھسلنیکیوں کے نام کا دوسرا خط 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2.-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲-تھِسّلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھِسلُنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2.۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("دوم تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھسّلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲۔تھسلنیکیوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("۲ تھسلنیکوں 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (ur)", ->
		`
		expect(p.parse("تھسّلنیکیوں کے نام پولس رسول کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalunīkiyōṅ ke nām kā pahlā ḫaṭ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("تھِسّلُنیکیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("تھسلنیکیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1.-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱ تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1.۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱ تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1Thess (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("تھسّلنیکیوں کے نام پولس رسول کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalunīkiyōṅ ke nām kā pahlā ḫaṭ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("تھِسّلُنیکیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("تھسلنیکیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1.-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱ تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1.۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱ تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("تھسّلنیکیوں کے نام پولس رسول کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALUNĪKIYŌṄ KE NĀM KĀ PAHLĀ ḪAṬ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("تھِسّلُنیکیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("تھسلنیکیوں کے نام کا پہلا خط 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1.-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("اوّل۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱-تھِسّلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱ تھِسلُنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1.۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱ تھسّلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("۱۔تھسلنیکیوں 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (ur)", ->
		`
		expect(p.parse("تیِمُتھِیُس کے نام پولس رسول کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("tīmutʰiyus ke nām kā dūsrā ḫaṭ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("تِیمُتھِیُس کے نام کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("تیمتھیس کے نام کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2.-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2.۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2Tim (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("تیِمُتھِیُس کے نام پولس رسول کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("tīmutʰiyus ke nām kā dūsrā ḫaṭ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("تِیمُتھِیُس کے نام کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("تیمتھیس کے نام کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2.-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2.۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("تیِمُتھِیُس کے نام پولس رسول کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TĪMUTʰIYUS KE NĀM KĀ DŪSRĀ ḪAṬ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("تِیمُتھِیُس کے نام کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("تیمتھیس کے نام کا دوسرا خط 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2.-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تیِمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲-تِیمُتھِیُس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("دوم۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲ تیمِتھُیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2.۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("۲۔تیمتھیس 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (ur)", ->
		`
		expect(p.parse("تِیمُتھِیُس کے نام پولُس رسول کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("tīmutʰiyus ke nām kā pahlā ḫaṭ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("تِیمُتھِیُس کے نام کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("تیمتھیس کے نام کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1.-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱ تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱ تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1.۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1Tim (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("تِیمُتھِیُس کے نام پولُس رسول کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("tīmutʰiyus ke nām kā pahlā ḫaṭ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("تِیمُتھِیُس کے نام کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("تیمتھیس کے نام کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1.-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱ تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱ تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1.۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("تِیمُتھِیُس کے نام پولُس رسول کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TĪMUTʰIYUS KE NĀM KĀ PAHLĀ ḪAṬ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("تِیمُتھِیُس کے نام کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("تیمتھیس کے نام کا پہلا خط 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1.-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱ تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱-تِیمُتھِیُس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("اوّل۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱ تیمِتھُیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1.۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("۱۔تیمتھیس 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (ur)", ->
		`
		expect(p.parse("طِطُس کے نام پولس رسُول کا خط 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ṭiṭus ke nām kā ḫaṭ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("طِطُس کے نام کا خط 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ططس کے نام کا خط 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("طِطُس 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ططس 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("طِطُس کے نام پولس رسُول کا خط 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ṬIṬUS KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("طِطُس کے نام کا خط 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ططس کے نام کا خط 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("طِطُس 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ططس 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (ur)", ->
		`
		expect(p.parse("فلیمون کے نام پولس رسُول کا خط 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("filēmōn ke nām kā ḫaṭ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فِلیمون کے نام کا خط 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فلیمون کے نام کا خط 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فِلیمون 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فلیمون 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("فلیمون کے نام پولس رسُول کا خط 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILĒMŌN KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فِلیمون کے نام کا خط 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فلیمون کے نام کا خط 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فِلیمون 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("فلیمون 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (ur)", ->
		`
		expect(p.parse("عبرانیوں کے نام پولس رسول کا خط 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ʿibrāniyōṅ ke nām kā ḫaṭ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عِبرانیوں کے نام کا خط 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عبرانیوں کے نام کا خط 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عِبرانیوں 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عبرانیوں 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("عبرانیوں کے نام پولس رسول کا خط 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ʿIBRĀNIYŌṄ KE NĀM KĀ ḪAṬ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عِبرانیوں کے نام کا خط 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عبرانیوں کے نام کا خط 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عِبرانیوں 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("عبرانیوں 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (ur)", ->
		`
		expect(p.parse("yaʿqūb kā ʿām ḫaṭ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقوب کا عا م خط 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقُوب کا عام خط 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقوب کا عام خط 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقُوب 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("يعقوب 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقوب 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAʿQŪB KĀ ʿĀM ḪAṬ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقوب کا عا م خط 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقُوب کا عام خط 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقوب کا عام خط 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقُوب 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("يعقوب 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("یعقوب 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (ur)", ->
		`
		expect(p.parse("paṭras kā dūsrā ʿām ḫaṭ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("پطرس کا دوسرا عام خط 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2.-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2.۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲ پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲ پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
	it "should handle non-Latin digits in book: 2Pet (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("paṭras kā dūsrā ʿām ḫaṭ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("پطرس کا دوسرا عام خط 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2.-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2.۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲ پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲ پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAṬRAS KĀ DŪSRĀ ʿĀM ḪAṬ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("پطرس کا دوسرا عام خط 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("دوم۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2.-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2.۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲ پطر س 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲ پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲-پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("۲۔پطرس 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (ur)", ->
		`
		expect(p.parse("paṭras kā pahlā ʿām ḫaṭ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("پطر س کاپہلا عا م خط 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("پطرس کا پہلا عام خط 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1.-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1.۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱ پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱ پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
	it "should handle non-Latin digits in book: 1Pet (ur)", ->
		p.set_options non_latin_digits_strategy: "replace"
		`
		expect(p.parse("paṭras kā pahlā ʿām ḫaṭ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("پطر س کاپہلا عا م خط 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("پطرس کا پہلا عام خط 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1.-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1.۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱ پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱ پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAṬRAS KĀ PAHLĀ ʿĀM ḪAṬ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("پطر س کاپہلا عا م خط 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("پطرس کا پہلا عام خط 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("اوّل۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1.-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1.۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱ پطر س 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱ پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱-پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("۱۔پطرس 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (ur)", ->
		`
		expect(p.parse("yahūdāh kā ʿām ḫaṭ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہُوداہ کا عام خط 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہوداہ کا عام خط 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہُوداہ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہوداہ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAHŪDĀH KĀ ʿĀM ḪAṬ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہُوداہ کا عام خط 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہوداہ کا عام خط 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہُوداہ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("یہوداہ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (ur)", ->
		`
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (ur)", ->
		`
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (ur)", ->
		`
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (ur)", ->
		`
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (ur)", ->
		`
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (ur)", ->
		`
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (ur)", ->
		`
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (ur)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (ur)", ->
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
		expect(p.languages).toEqual ["ur"]

	it "should handle ranges (ur)", ->
		expect(p.parse("Titus 1:1 تا 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1تا2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 تا 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (ur)", ->
		expect(p.parse("Titus 1:1, باب 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 باب 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, ابواب 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ابواب 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (ur)", ->
		expect(p.parse("Exod 1:1 آیت 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm آیت 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 آیات 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm آیات 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (ur)", ->
		expect(p.parse("Exod 1:1 ، 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 ، 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 ؛ 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 ؛ 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 ۔ 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 ۔ 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (ur)", ->
		expect(p.parse("Ps 3 title, 4:2, 5:title").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 TITLE, 4:2, 5:TITLE").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (ur)", ->
		expect(p.parse("Rev 3ff, 4:2ff").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 FF, 4:2 FF").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (ur)", ->
		expect(p.parse("Lev 1 (ERV)").osis_and_translations()).toEqual [["Lev.1", "ERV"]]
		expect(p.parse("lev 1 erv").osis_and_translations()).toEqual [["Lev.1", "ERV"]]
	it "should handle book ranges (ur)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("اوّل تا تیسرا  یوحنّا").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (ur)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
