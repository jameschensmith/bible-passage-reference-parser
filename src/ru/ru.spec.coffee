bcv_parser = require("../../js/ru_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (ru)", ->
		`
		expect(p.parse("Книга Бытия 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Начало 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Бытие 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Быт 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Нач 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА БЫТИЯ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("НАЧАЛО 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("БЫТИЕ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("БЫТ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("НАЧ 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (ru)", ->
		`
		expect(p.parse("Книга Исход 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Исход 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Исх 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ИСХОД 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ИСХОД 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ИСХ 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (ru)", ->
		`
		expect(p.parse("Виле и драконе 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Бел и Дракон 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Беле 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Бел 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (ru)", ->
		`
		expect(p.parse("Книга Левит 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Левит 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Лев 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ЛЕВИТ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ЛЕВИТ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ЛЕВ 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (ru)", ->
		`
		expect(p.parse("Книга Чисел 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Числа 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Чис 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ЧИСЕЛ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("ЧИСЛА 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("ЧИС 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (ru)", ->
		`
		expect(p.parse("Премудрости Иисуса, сына Сирахова 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Премудрость Сираха 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Ekkleziastik 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Сирахова 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Сир 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (ru)", ->
		`
		expect(p.parse("Премудрости Соломона 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Прем 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (ru)", ->
		`
		expect(p.parse("Плач Иеремии 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Плач 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПЛАЧ ИЕРЕМИИ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("ПЛАЧ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (ru)", ->
		`
		expect(p.parse("Послание Иеремии 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (ru)", ->
		`
		expect(p.parse("Откровение 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Откр 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Отк 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ОТКРОВЕНИЕ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ОТКР 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ОТК 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (ru)", ->
		`
		expect(p.parse("Молитва Манассии 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (ru)", ->
		`
		expect(p.parse("Второзаконие 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Втор 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ВТОРОЗАКОНИЕ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ВТОР 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (ru)", ->
		`
		expect(p.parse("Книга Иисуса Навина 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Иисуса Навина 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Иисус Навин 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Иешуа 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Навин 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Иеш 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Нав 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ИИСУСА НАВИНА 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ИИСУСА НАВИНА 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ИИСУС НАВИН 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ИЕШУА 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("НАВИН 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ИЕШ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("НАВ 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (ru)", ->
		`
		expect(p.parse("Книга Судеи Израилевых 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Книга Судей Израилевых 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Книга Судеи 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Книга Судей 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Судеи 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Судей 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Судьи 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Суд 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА СУДЕИ ИЗРАИЛЕВЫХ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("КНИГА СУДЕЙ ИЗРАИЛЕВЫХ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("КНИГА СУДЕИ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("КНИГА СУДЕЙ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("СУДЕИ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("СУДЕЙ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("СУДЬИ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("СУД 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (ru)", ->
		`
		expect(p.parse("Книга Руфи 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Руфь 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Рут 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Руф 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА РУФИ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("РУФЬ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("РУТ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("РУФ 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (ru)", ->
		`
		expect(p.parse("2-е. Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2-я. Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2-е Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2-я Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2е. Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2я. Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2. Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2е Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2я Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2 Ездры 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("2 Езд 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (ru)", ->
		`
		expect(p.parse("3-е. Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3-я. Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3-е Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3-я Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3е. Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3я. Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3. Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3е Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3я Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3 Ездры 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("3 Езд 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (ru)", ->
		`
		expect(p.parse("Книга пророка Исаии 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Исаии 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Исаия 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Исаи 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ис 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ИСАИИ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ИСАИИ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ИСАИЯ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ИСАИ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ИС 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (ru)", ->
		`
		expect(p.parse("2-е. Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-я. Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-е Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-я Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2е. Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2я. Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2е Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2я Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Книга Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-е. Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-я. Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-е Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-е. Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-я Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-я. Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2е. Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2я. Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-е Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-я Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2е Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2е. Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2я Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2я. Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Самуила 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2е Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2я Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Царств 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Цар 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2-Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Е. САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Я. САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Е САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Е. ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Я САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Я. ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Е. САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Я. САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Е ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2-Я ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Е САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Е. ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Я САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Я. ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 САМУИЛА 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Е ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Я ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 ЦАРСТВ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 ЦАР 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (ru)", ->
		`
		expect(p.parse("1-е. Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-я. Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-е Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-я Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1е. Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1я. Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1е Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1я Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Книга Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-е. Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-я. Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-е Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-е. Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-я Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-я. Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1е. Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1я. Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-е Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-я Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1е Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1е. Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1я Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1я. Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Самуила 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1е Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1я Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Царств 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Цар 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1-Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Е. САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Я. САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Е САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Е. ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Я САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Я. ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Е. САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Я. САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Е ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1-Я ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Е САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Е. ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Я САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Я. ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 САМУИЛА 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Е ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Я ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 ЦАРСТВ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 ЦАР 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (ru)", ->
		`
		expect(p.parse("4-е. Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-я. Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-е Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-я Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4е. Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4я. Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4е Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4я Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 Книга Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-е. Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-я. Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-е. Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-е. Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-я. Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-я. Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-е Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-я Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4е. Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4я. Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-е Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-е Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-я Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-я Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2е. Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2е. Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2я. Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2я. Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4е Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4я Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2е Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2е Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2я Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2я Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 Царств 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Цареи 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Царей 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 Цар 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("4-Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 КНИГА ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-Е. ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-Я. ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Е. ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Е. ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Я. ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Я. ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-Е ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4-Я ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Е. ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Я. ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Е ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Е ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Я ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2-Я ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Е. ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Е. ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Я. ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Я. ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Е ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4Я ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Е ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Е ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Я ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Я ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 ЦАРСТВ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 ЦАРЕИ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 ЦАРЕЙ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 ЦАР 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (ru)", ->
		`
		expect(p.parse("3-е. Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-я. Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-е Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-я Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3е. Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3я. Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3е Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3я Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 Книга Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-е. Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-я. Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-е. Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-е. Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-я. Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-я. Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-е Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-я Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3е. Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3я. Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-е Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-е Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-я Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-я Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1е. Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1е. Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1я. Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1я. Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3е Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3я Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1е Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1е Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1я Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1я Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 Царств 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Цареи 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Царей 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 Цар 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("3-Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Е. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Я. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Е КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Я КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 КНИГА ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-Е. ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-Я. ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Е. ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Е. ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Я. ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Я. ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-Е ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3-Я ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Е. ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Я. ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Е ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Е ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Я ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1-Я ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Е. ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Е. ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Я. ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Я. ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Е ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3Я ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Е ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Е ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Я ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Я ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 ЦАРСТВ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 ЦАРЕИ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 ЦАРЕЙ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 ЦАР 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (ru)", ->
		`
		expect(p.parse("2-е. Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я. Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-е Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е. Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я. Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Книга Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-е. Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я. Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-е Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е. Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я. Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Паралипоменон 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-е. Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я. Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-е Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е. Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я. Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-е. Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я. Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Летопись 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-е Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-я Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е. Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я. Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2е Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2я Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Хроник 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Лет 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Пар 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2-Е. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Е КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Е. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Е ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Е. ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я. ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Е ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е. ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я. ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Е. ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я. ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ЛЕТОПИСЬ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Е ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2-Я ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е. ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я. ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Е ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Я ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ХРОНИК 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ЛЕТ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ПАР 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (ru)", ->
		`
		expect(p.parse("1-е. Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я. Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-е Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е. Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я. Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Книга Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-е. Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я. Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-е Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е. Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я. Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Паралипоменон 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-е. Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я. Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-е Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е. Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я. Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-е. Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я. Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Летопись 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-е Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-я Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е. Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я. Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1е Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1я Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Хроник 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Лет 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Пар 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1-Е. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Е КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 КНИГА ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Е. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Е ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ПАРАЛИПОМЕНОН 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Е. ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я. ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Е ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е. ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я. ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Е. ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я. ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ЛЕТОПИСЬ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Е ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1-Я ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е. ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я. ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Е ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Я ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ХРОНИК 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ЛЕТ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ПАР 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (ru)", ->
		`
		expect(p.parse("Первая Ездры 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Книга Ездры 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("1 Езд 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ездра 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ездры 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Узаир 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Узайр 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Езд 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПЕРВАЯ ЕЗДРЫ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("КНИГА ЕЗДРЫ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("1 ЕЗД 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ЕЗДРА 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ЕЗДРЫ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("УЗАИР 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("УЗАЙР 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ЕЗД 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (ru)", ->
		`
		expect(p.parse("Книга Неемии 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Неемии 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Неемия 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Неем 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА НЕЕМИИ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("НЕЕМИИ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("НЕЕМИЯ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("НЕЕМ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (ru)", ->
		`
		expect(p.parse("Дополнения к Есфири 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (ru)", ->
		`
		expect(p.parse("Книга Есфири 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Есфирь 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Есф 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ЕСФИРИ 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ЕСФИРЬ 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ЕСФ 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (ru)", ->
		`
		expect(p.parse("Книга Иова 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Иова 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Аюб 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Иов 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ИОВА 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ИОВА 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("АЮБ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ИОВ 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (ru)", ->
		`
		expect(p.parse("Псалтирь 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Псалмы 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Псалом 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Забур 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Псал 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Заб 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Пс 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПСАЛТИРЬ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ПСАЛМЫ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ПСАЛОМ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ЗАБУР 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ПСАЛ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ЗАБ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ПС 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (ru)", ->
		`
		expect(p.parse("Молитва Азария 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (ru)", ->
		`
		expect(p.parse("Книга притчеи Соломоновых 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Книга притчей Соломоновых 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Мудрые изречения 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Притчи 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Мудр 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Прит 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Пр 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРИТЧЕИ СОЛОМОНОВЫХ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("КНИГА ПРИТЧЕЙ СОЛОМОНОВЫХ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("МУДРЫЕ ИЗРЕЧЕНИЯ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ПРИТЧИ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("МУДР 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ПРИТ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ПР 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (ru)", ->
		`
		expect(p.parse("Книга Екклесиаста 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Размышления 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Екклесиаст 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Разм 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Екк 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ЕККЛЕСИАСТА 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("РАЗМЫШЛЕНИЯ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ЕККЛЕСИАСТ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("РАЗМ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ЕКК 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (ru)", ->
		`
		expect(p.parse("Благодарственная песнь отроков 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Молитва святых трех отроков 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Песнь трех отроков 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Песнь трёх отроков 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (ru)", ->
		`
		expect(p.parse("Песнь песнеи Соломона 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песнь песней Соломона 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песнь Сулаимона 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песнь Сулаймона 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песнь Сулеимана 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песнь Сулеймана 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песни Песнеи 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песни Песней 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песнь 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Песн 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПЕСНЬ ПЕСНЕИ СОЛОМОНА 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНЬ ПЕСНЕЙ СОЛОМОНА 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНЬ СУЛАИМОНА 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНЬ СУЛАЙМОНА 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНЬ СУЛЕИМАНА 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНЬ СУЛЕЙМАНА 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНИ ПЕСНЕИ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНИ ПЕСНЕЙ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСНЬ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ПЕСН 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (ru)", ->
		`
		expect(p.parse("Книга пророка Иеремии 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Иеремии 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Иеремия 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Иер 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ИЕРЕМИИ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ИЕРЕМИИ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ИЕРЕМИЯ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ИЕР 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (ru)", ->
		`
		expect(p.parse("Книга пророка Иезекииля 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Иезекииль 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Иезекииля 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Езекиил 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Езек 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Иез 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ИЕЗЕКИИЛЯ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ИЕЗЕКИИЛЬ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ИЕЗЕКИИЛЯ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ЕЗЕКИИЛ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ЕЗЕК 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ИЕЗ 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (ru)", ->
		`
		expect(p.parse("Книга пророка Даниила 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Даниила 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Даниил 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Даниял 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Дониел 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Дониёл 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Дан 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Дон 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ДАНИИЛА 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ДАНИИЛА 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ДАНИИЛ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ДАНИЯЛ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ДОНИЕЛ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ДОНИЁЛ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ДАН 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ДОН 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (ru)", ->
		`
		expect(p.parse("Книга пророка Осии 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Осии 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Осия 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Ос 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ОСИИ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ОСИИ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ОСИЯ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ОС 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (ru)", ->
		`
		expect(p.parse("Книга пророка Иоиля 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Иоиль 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Иоиля 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Иоил 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ИОИЛЯ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ИОИЛЬ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ИОИЛЯ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ИОИЛ 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (ru)", ->
		`
		expect(p.parse("Книга пророка Амоса 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Амоса 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Амос 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Ам 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА АМОСА 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("АМОСА 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("АМОС 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("АМ 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (ru)", ->
		`
		expect(p.parse("Книга пророка Авдия 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Авдии 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Авдий 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Авдия 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Авд 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА АВДИЯ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("АВДИИ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("АВДИЙ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("АВДИЯ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("АВД 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (ru)", ->
		`
		expect(p.parse("Книга пророка Ионы 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Иона 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Ионы 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Юнус 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ИОНЫ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ИОНА 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ИОНЫ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ЮНУС 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (ru)", ->
		`
		expect(p.parse("Книга пророка Михея 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Михеи 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Михей 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Михея 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Мих 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА МИХЕЯ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("МИХЕИ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("МИХЕЙ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("МИХЕЯ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("МИХ 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (ru)", ->
		`
		expect(p.parse("Книга пророка Наума 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Наума 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Наум 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА НАУМА 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("НАУМА 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("НАУМ 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (ru)", ->
		`
		expect(p.parse("Книга пророка Аввакума 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Аввакума 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Аввакум 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Авв 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА АВВАКУМА 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("АВВАКУМА 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("АВВАКУМ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("АВВ 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (ru)", ->
		`
		expect(p.parse("Книга пророка Софонии 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Софонии 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Софония 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Соф 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА СОФОНИИ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("СОФОНИИ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("СОФОНИЯ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("СОФ 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (ru)", ->
		`
		expect(p.parse("Книга пророка Аггея 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Аггеи 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Аггей 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Аггея 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Агг 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА АГГЕЯ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("АГГЕИ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("АГГЕЙ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("АГГЕЯ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("АГГ 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (ru)", ->
		`
		expect(p.parse("Книга пророка Захарии 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Закария 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Захарии 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Захария 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Зак 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Зах 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА ЗАХАРИИ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ЗАКАРИЯ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ЗАХАРИИ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ЗАХАРИЯ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ЗАК 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ЗАХ 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (ru)", ->
		`
		expect(p.parse("Книга пророка Малахии 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Малахии 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Малахия 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Мал 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("КНИГА ПРОРОКА МАЛАХИИ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("МАЛАХИИ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("МАЛАХИЯ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("МАЛ 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (ru)", ->
		`
		expect(p.parse("Евангелие от Матфея 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("От Матфея 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Матфея 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Матаи 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Матай 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Матто 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Мат 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Мт 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Мф 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ЕВАНГЕЛИЕ ОТ МАТФЕЯ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ОТ МАТФЕЯ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("МАТФЕЯ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("МАТАИ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("МАТАЙ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("МАТТО 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("МАТ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("МТ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("МФ 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (ru)", ->
		`
		expect(p.parse("Евангелие от Марка 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("От Марка 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Марка 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Марк 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Мк 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Мр 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ЕВАНГЕЛИЕ ОТ МАРКА 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ОТ МАРКА 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("МАРКА 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("МАРК 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("МК 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("МР 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (ru)", ->
		`
		expect(p.parse("Евангелие от Луки 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("От Луки 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Лука 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Луки 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Луко 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Лк 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ЕВАНГЕЛИЕ ОТ ЛУКИ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ОТ ЛУКИ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ЛУКА 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ЛУКИ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ЛУКО 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ЛК 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (ru)", ->
		`
		expect(p.parse("1-е. послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-я. послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-е послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-я послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1е. послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1я. послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1е послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1я послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 послание Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-е. Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-е. Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-я. Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-я. Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-е Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-е Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-я Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-я Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1е. Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1е. Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1я. Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1я. Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1е Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1е Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1я Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1я Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Иоанна 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Иохана 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Ин 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1-Е. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Я. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Е ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Я ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Е. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Я. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Е ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Я ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Е. ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Е. ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Я. ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Я. ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Е ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Е ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Я ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1-Я ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Е. ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Е. ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Я. ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Я. ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Е ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Е ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Я ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1Я ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 ИОАННА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 ИОХАНА 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 ИН 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (ru)", ->
		`
		expect(p.parse("2-е. послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-я. послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-е послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-я послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2е. послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2я. послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2е послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2я послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 послание Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-е. Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-е. Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-я. Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-я. Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-е Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-е Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-я Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-я Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2е. Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2е. Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2я. Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2я. Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2е Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2е Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2я Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2я Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Иоанна 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Иохана 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Ин 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2-Е. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Я. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Е ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Я ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Е. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Я. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Е ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Я ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Е. ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Е. ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Я. ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Я. ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Е ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Е ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Я ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2-Я ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Е. ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Е. ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Я. ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Я. ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Е ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Е ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Я ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2Я ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 ИОАННА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 ИОХАНА 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 ИН 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (ru)", ->
		`
		expect(p.parse("3-е. послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-я. послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-е послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-я послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3е. послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3я. послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3е послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3я послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 послание Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-е. Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-е. Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-я. Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-я. Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-е Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-е Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-я Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-я Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3е. Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3е. Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3я. Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3я. Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3е Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3е Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3я Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3я Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Иоанна 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Иохана 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Ин 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("3-Е. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Я. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Е ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Я ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Е. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Я. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Е ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Я ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 ПОСЛАНИЕ ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Е. ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Е. ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Я. ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Я. ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Е ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Е ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Я ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3-Я ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Е. ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Е. ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Я. ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Я. ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Е ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Е ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Я ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3Я ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 ИОАННА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 ИОХАНА 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 ИН 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (ru)", ->
		`
		expect(p.parse("Евангелие от Иоанна 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("От Иоанна 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Иоанна 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Иохан 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Ин 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ЕВАНГЕЛИЕ ОТ ИОАННА 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ОТ ИОАННА 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ИОАННА 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ИОХАН 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ИН 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (ru)", ->
		`
		expect(p.parse("Деяния 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Деян 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ДЕЯНИЯ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ДЕЯН 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (ru)", ->
		`
		expect(p.parse("Послание к Римлянам 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("К Римлянам 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Римлянам 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Рим 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К РИМЛЯНАМ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("К РИМЛЯНАМ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("РИМЛЯНАМ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("РИМ 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (ru)", ->
		`
		expect(p.parse("2-е. к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-я. к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-е к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-я к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2е. к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2я. к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-е. Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-я. Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2е к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2я к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 к Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-е Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-я Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2е. Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2я. Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2е Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2я Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Коринфянам 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Кор 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2-Е. К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-Я. К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-Е К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-Я К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Е. К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Я. К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-Е. КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-Я. КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Е К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Я К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 К КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-Е КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2-Я КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Е. КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Я. КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Е КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Я КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 КОРИНФЯНАМ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 КОР 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (ru)", ->
		`
		expect(p.parse("1-е. к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-я. к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-е к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-я к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1е. к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1я. к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-е. Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-я. Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1е к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1я к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 к Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-е Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-я Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1е. Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1я. Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1е Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1я Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Коринфянам 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Кор 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1-Е. К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-Я. К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-Е К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-Я К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Е. К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Я. К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-Е. КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-Я. КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Е К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Я К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 К КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-Е КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1-Я КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Е. КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Я. КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Е КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Я КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 КОРИНФЯНАМ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 КОР 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (ru)", ->
		`
		expect(p.parse("Послание к Галатам 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("К Галатам 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Галатам 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Гал 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К ГАЛАТАМ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("К ГАЛАТАМ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ГАЛАТАМ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ГАЛ 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (ru)", ->
		`
		expect(p.parse("Послание к Ефесянам 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("К Ефесянам 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ефесянам 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Эфесянам 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Еф 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Эф 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К ЕФЕСЯНАМ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("К ЕФЕСЯНАМ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ЕФЕСЯНАМ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ЭФЕСЯНАМ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ЕФ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ЭФ 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (ru)", ->
		`
		expect(p.parse("Послание к Филиппиицам 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Послание к Филиппийцам 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("К Филиппиицам 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("К Филиппийцам 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Филиппиицам 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Филиппийцам 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Фил 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Флп 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К ФИЛИППИИЦАМ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ПОСЛАНИЕ К ФИЛИППИЙЦАМ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("К ФИЛИППИИЦАМ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("К ФИЛИППИЙЦАМ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ФИЛИППИИЦАМ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ФИЛИППИЙЦАМ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ФИЛ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ФЛП 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (ru)", ->
		`
		expect(p.parse("Послание к Колоссянам 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("К Колоссянам 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Колоссянам 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Кол 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К КОЛОССЯНАМ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("К КОЛОССЯНАМ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("КОЛОССЯНАМ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("КОЛ 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (ru)", ->
		`
		expect(p.parse("2-е. к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-е. к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я. к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я. к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-е к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-е к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е. к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е. к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я. к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я. к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-е. Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-е. Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я. Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я. Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 к Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 к Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-е Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-е Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-я Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е. Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е. Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я. Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я. Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2е Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2я Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Фессалоникиицам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Фессалоникийцам 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Фес 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2-Е. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Е. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Е К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Е К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Е. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Е. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Е ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Е ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2-Я ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Е ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Я ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 ФЕС 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (ru)", ->
		`
		expect(p.parse("1-е. к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-е. к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я. к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я. к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-е к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-е к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е. к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е. к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я. к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я. к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-е. Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-е. Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я. Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я. Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 к Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 к Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-е Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-е Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-я Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е. Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е. Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я. Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я. Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1е Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1я Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Фессалоникиицам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Фессалоникийцам 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Фес 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1-Е. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Е. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Е К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Е К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Е. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Е. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 К ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 К ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Е ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Е ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1-Я ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Е ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Я ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 ФЕССАЛОНИКИИЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 ФЕССАЛОНИКИЙЦАМ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 ФЕС 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (ru)", ->
		`
		expect(p.parse("2-е. к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-я. к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-е к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-я к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2е. к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2я. к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-е. Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-е. Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-я. Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-я. Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2е к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2я к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 к Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-е Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-е Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-я Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-я Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2е. Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2е. Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2я. Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2я. Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2е Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2е Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2я Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2я Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Тиметею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Тимофею 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Тим 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2-Е. К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Я. К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Е К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Я К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Е. К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Я. К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Е. ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Е. ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Я. ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Я. ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Е К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Я К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 К ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Е ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Е ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Я ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2-Я ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Е. ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Е. ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Я. ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Я. ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Е ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Е ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Я ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Я ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 ТИМЕТЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 ТИМОФЕЮ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 ТИМ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (ru)", ->
		`
		expect(p.parse("1-е. к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-я. к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-е к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-я к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1е. к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1я. к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-е. Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-е. Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-я. Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-я. Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1е к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1я к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 к Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-е Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-е Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-я Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-я Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1е. Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1е. Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1я. Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1я. Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1е Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1е Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1я Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1я Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Тиметею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Тимофею 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Тим 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1-Е. К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Я. К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Е К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Я К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Е. К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Я. К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Е. ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Е. ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Я. ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Я. ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Е К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Я К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 К ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Е ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Е ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Я ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1-Я ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Е. ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Е. ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Я. ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Я. ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Е ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Е ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Я ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Я ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 ТИМЕТЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 ТИМОФЕЮ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 ТИМ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (ru)", ->
		`
		expect(p.parse("Послание к Титу 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("К Титу 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Титу 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Тит 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К ТИТУ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("К ТИТУ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ТИТУ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ТИТ 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (ru)", ->
		`
		expect(p.parse("Послание к Филимону 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("К Филимону 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Филимону 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Флм 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К ФИЛИМОНУ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("К ФИЛИМОНУ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ФИЛИМОНУ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ФЛМ 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (ru)", ->
		`
		expect(p.parse("Послание к Евреям 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("К Евреям 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Евреям 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Евр 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ К ЕВРЕЯМ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("К ЕВРЕЯМ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ЕВРЕЯМ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ЕВР 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (ru)", ->
		`
		expect(p.parse("Послание Иакова 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Иакова 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Якуб 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Иак 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ ИАКОВА 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ИАКОВА 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ЯКУБ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ИАК 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (ru)", ->
		`
		expect(p.parse("2-е. послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я. послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-е послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е. послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я. послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 послание Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-е. Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я. Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-е Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-е. Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я. Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е. Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я. Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-е Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-е. Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я. Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е. Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я. Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Петруса 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-е Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-я Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е. Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я. Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Петира 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2е Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2я Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Петра 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Пет 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2-Е. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Е ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Е. ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я. ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Е ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Е. ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я. ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е. ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я. ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Е ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Е. ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я. ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е. ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я. ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 ПЕТРУСА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Е ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2-Я ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е. ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я. ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 ПЕТИРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Е ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Я ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 ПЕТРА 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 ПЕТ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (ru)", ->
		`
		expect(p.parse("1-е. послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я. послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-е послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е. послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я. послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 послание Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-е. Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я. Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-е Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-е. Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я. Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е. Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я. Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-е Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-е. Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я. Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е. Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я. Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Петруса 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-е Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-я Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е. Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я. Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Петира 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1е Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1я Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Петра 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Пет 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1-Е. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Е ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 ПОСЛАНИЕ ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Е. ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я. ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Е ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Е. ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я. ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е. ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я. ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Е ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Е. ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я. ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е. ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я. ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 ПЕТРУСА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Е ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1-Я ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е. ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я. ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 ПЕТИРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Е ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Я ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 ПЕТРА 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 ПЕТ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (ru)", ->
		`
		expect(p.parse("Послание Иуды 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Иуда 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Иуды 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Иуд 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ПОСЛАНИЕ ИУДЫ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ИУДА 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ИУДЫ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ИУД 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (ru)", ->
		`
		expect(p.parse("Товита 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Тов 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (ru)", ->
		`
		expect(p.parse("Юдифь 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Юди 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (ru)", ->
		`
		expect(p.parse("Книга пророка Вару́ха 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Книга Варуха 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Бару́ха 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Варуха 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Вар 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (ru)", ->
		`
		expect(p.parse("Сказанию о Сусанне и Данииле 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Сусанна и старцы 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Сусанна 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (ru)", ->
		`
		expect(p.parse("Вторая книга Маккавеиская 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Вторая книга Маккавейская 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2-е. Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2-я. Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2-е Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2-я Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2е. Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2я. Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2е Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2я Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Маккавеев 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Макк 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (ru)", ->
		`
		expect(p.parse("Третья книга Маккавеиская 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Третья книга Маккавейская 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3-е. Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3-я. Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3-е Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3-я Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3е. Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3я. Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3е Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3я Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Маккавеев 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Макк 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (ru)", ->
		`
		expect(p.parse("4-е. Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4-я. Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4-е Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4-я Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4е. Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4я. Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4е Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4я Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Маккавеев 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Макк 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (ru)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (ru)", ->
		`
		expect(p.parse("Первая книга Маккавеиская 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Первая книга Маккавейская 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1-е. Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1-я. Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1-е Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1-я Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1е. Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1я. Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1е Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1я Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Маккавеев 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Макк 1:1").osis()).toEqual("1Macc.1.1")
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
		expect(p.languages).toEqual ["ru"]

	it "should handle ranges (ru)", ->
		expect(p.parse("Titus 1:1 — 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1—2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 — 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (ru)", ->
		expect(p.parse("Titus 1:1, главы 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ГЛАВЫ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, глав 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ГЛАВ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, гл. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ГЛ. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, гл 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ГЛ 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (ru)", ->
		expect(p.parse("Exod 1:1 стихи 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm СТИХИ 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 стих 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm СТИХ 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (ru)", ->
		expect(p.parse("Exod 1:1 и 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 И 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (ru)", ->
		expect(p.parse("Ps 3 надписаниях, 4:2, 5:надписаниях").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 НАДПИСАНИЯХ, 4:2, 5:НАДПИСАНИЯХ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (ru)", ->
		expect(p.parse("Rev 3и далее, 4:2и далее").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 И ДАЛЕЕ, 4:2 И ДАЛЕЕ").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (ru)", ->
		expect(p.parse("Lev 1 (RUSV)").osis_and_translations()).toEqual [["Lev.1", "RUSV"]]
		expect(p.parse("lev 1 rusv").osis_and_translations()).toEqual [["Lev.1", "RUSV"]]
		expect(p.parse("Lev 1 (SZ)").osis_and_translations()).toEqual [["Lev.1", "SZ"]]
		expect(p.parse("lev 1 sz").osis_and_translations()).toEqual [["Lev.1", "SZ"]]
	it "should handle book ranges (ru)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("1-я — 3-я  Иоанна").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (ru)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
