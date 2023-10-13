bcv_parser = require("../../js/it_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (it)", ->
		`
		expect(p.parse("Genesi 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Ge 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GENESI 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GE 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (it)", ->
		`
		expect(p.parse("Esodo 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Es 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESODO 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ES 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (it)", ->
		`
		expect(p.parse("Bel e il Drago 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (it)", ->
		`
		expect(p.parse("Levitico 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Le 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lv 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LEVITICO 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LE 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LV 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (it)", ->
		`
		expect(p.parse("Numeri 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Nm 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Nu 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NUMERI 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NU 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (it)", ->
		`
		expect(p.parse("Sapienza di Siracide 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sapienza di Sirach 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Ecclesiastico 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Siracide 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Siràcide 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (it)", ->
		`
		expect(p.parse("Sapienza di Salomone 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Sapienza 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Sap 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (it)", ->
		`
		expect(p.parse("Lamentazioni 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("La 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LAMENTAZIONI 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LA 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (it)", ->
		`
		expect(p.parse("Lettera di Geremia 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Let-ger 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (it)", ->
		`
		expect(p.parse("Apocalisse di Giovanni 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rivelazione 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Apocalisse 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Riv 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Ap 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("APOCALISSE DI GIOVANNI 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("RIVELAZIONE 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("APOCALISSE 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("RIV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("AP 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (it)", ->
		`
		expect(p.parse("Orazione di Manasse Re di Giuda 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Preghiera di Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Orazione di Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (it)", ->
		`
		expect(p.parse("Deuteronomio 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("De 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Dt 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUTERONOMIO 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DE 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DT 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (it)", ->
		`
		expect(p.parse("Giosue 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Giosuè 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Giosué 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Gs 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GIOSUE 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("GIOSUÈ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("GIOSUÉ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("GS 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (it)", ->
		`
		expect(p.parse("Giudici 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Gdc 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GIUDICI 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("GDC 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (it)", ->
		`
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Rut 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Rt 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Ru 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUT 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RT 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RU 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (it)", ->
		`
		expect(p.parse("Prima Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Prima Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Primo Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Primo Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Esdra greco 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Prima Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Primo Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Terza Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Terzo Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1°. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1°. Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("III. Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1. Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1° Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1° Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1°. Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3°. Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I. Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("III Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1. Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1° Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3. Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3° Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I Ésdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I. Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3 Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I Esdra 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esd 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (it)", ->
		`
		expect(p.parse("Seconda Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Seconda Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Secondo Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Secondo Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Seconda Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Secondo Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Quarta Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Quarto Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2°. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2°. Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II. Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2. Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2° Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2° Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2°. Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4°. Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II. Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("IV. Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Ésdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2. Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2° Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4. Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4° Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("IV Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4 Esdra 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esd 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (it)", ->
		`
		expect(p.parse("Isaia 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Is 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ISAIA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("IS 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (it)", ->
		`
		expect(p.parse("Seconda Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Secondo Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2°. Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II. Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2° Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Samuele 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 S 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("SECONDO SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2°. SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II. SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2° SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUELE 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 S 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (it)", ->
		`
		expect(p.parse("Prima Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Primo Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1°. Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1° Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I. Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I Samuele 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 S 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("PRIMO SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1°. SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1° SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I. SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I SAMUELE 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 S 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (it)", ->
		`
		expect(p.parse("Seconda Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Secondo Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2°. Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II. Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2° Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Re 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 R 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("SECONDO RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2°. RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II. RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2° RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 R 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (it)", ->
		`
		expect(p.parse("Prima Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Primo Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1°. Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1° Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I. Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I Re 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 R 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("PRIMO RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1°. RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1° RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I. RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I RE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 R 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (it)", ->
		`
		expect(p.parse("Seconda Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Secondo Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2°. Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II. Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2° Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Cronache 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Cr 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("SECONDO CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2°. CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II. CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2° CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 CRONACHE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 CR 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (it)", ->
		`
		expect(p.parse("Prima Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Primo Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1°. Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1° Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I. Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I Cronache 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Cr 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("PRIMO CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1°. CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1° CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I. CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I CRONACHE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 CR 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (it)", ->
		`
		expect(p.parse("Esdra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Esd 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ed 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESDRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ESD 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ED 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (it)", ->
		`
		expect(p.parse("Neemia 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Ne 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NEEMIA 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NE 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (it)", ->
		`
		expect(p.parse("Ester \(versione greca\) 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Ester \(greco\) 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Ester greco 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (it)", ->
		`
		expect(p.parse("Ester 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Est 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Et 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESTER 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("EST 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ET 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (it)", ->
		`
		expect(p.parse("Giobbe 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Gb 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GIOBBE 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("GB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (it)", ->
		`
		expect(p.parse("Salmi 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Salmo 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Sal 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Sl 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SALMI 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("SALMO 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("SAL 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("SL 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (it)", ->
		`
		expect(p.parse("Preghiera di Azaria 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (it)", ->
		`
		expect(p.parse("Proverbi 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Pr 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PROVERBI 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PR 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (it)", ->
		`
		expect(p.parse("Ecclesiaste 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Qohelet 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Qohèlet 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Qoelet 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Qoèlet 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Ecc 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Ec 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Qo 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ECCLESIASTE 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("QOHELET 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("QOHÈLET 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("QOELET 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("QOÈLET 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECC 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("EC 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("QO 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (it)", ->
		`
		expect(p.parse("Cantico dei tre giovani nella fornace 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Cantico dei tre fanciulli 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (it)", ->
		`
		expect(p.parse("Cantico dei Cantici 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Cantico dei cantici 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Cantico di Salomone 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Cantico 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ca 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ct 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("CANTICO DEI CANTICI 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CANTICO DEI CANTICI 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CANTICO DI SALOMONE 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CANTICO 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CA 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CT 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (it)", ->
		`
		expect(p.parse("Jeremiah 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Geremia 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Ger 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Gr 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JEREMIAH 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("GEREMIA 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("GER 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("GR 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (it)", ->
		`
		expect(p.parse("Ezechiele 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ez 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EZECHIELE 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZ 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (it)", ->
		`
		expect(p.parse("Daniele 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Da 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dn 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DANIELE 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DA 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (it)", ->
		`
		expect(p.parse("Osea 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Os 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("OSEA 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("OS 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (it)", ->
		`
		expect(p.parse("Gioele 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Gioe 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Gl 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GIOELE 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("GIOE 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("GL 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (it)", ->
		`
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Am 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AM 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (it)", ->
		`
		expect(p.parse("Ovadia 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Abdia 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Abd 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Ad 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("OVADIA 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ABDIA 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ABD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("AD 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (it)", ->
		`
		expect(p.parse("Giona 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Gio 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Gn 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GIONA 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("GIO 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("GN 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (it)", ->
		`
		expect(p.parse("Michea 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mi 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MICHEA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MI 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (it)", ->
		`
		expect(p.parse("Nahum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Naum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Na 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NA 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (it)", ->
		`
		expect(p.parse("Abacuc 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Ab 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Ac 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ABACUC 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("AB 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("AC 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (it)", ->
		`
		expect(p.parse("Sofonia 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Sof 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("So 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SOFONIA 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SOF 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SO 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (it)", ->
		`
		expect(p.parse("Aggeo 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Ag 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AGGEO 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("AG 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (it)", ->
		`
		expect(p.parse("Zaccaria 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zac 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Za 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zc 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZACCARIA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZAC 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZC 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (it)", ->
		`
		expect(p.parse("Malachia 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Ml 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MALACHIA 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("ML 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (it)", ->
		`
		expect(p.parse("Vangelo di San Matteo 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Vangelo di Matteo 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matteo 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Mt 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("VANGELO DI SAN MATTEO 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("VANGELO DI MATTEO 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTEO 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MT 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (it)", ->
		`
		expect(p.parse("Vangelo di San Marco 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Vangelo di Marco 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Marco 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mc 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mr 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("VANGELO DI SAN MARCO 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("VANGELO DI MARCO 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARCO 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MC 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MR 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (it)", ->
		`
		expect(p.parse("Vangelo di San Luca 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Vangelo di Luca 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luca 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lc 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lu 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("VANGELO DI SAN LUCA 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("VANGELO DI LUCA 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUCA 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LC 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LU 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (it)", ->
		`
		expect(p.parse("Prima lettera di Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Prima Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Primo Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1°. Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1° Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I. Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I Giovanni 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Gv 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA LETTERA DI GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("PRIMA GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("PRIMO GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1°. GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1° GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I. GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I GIOVANNI 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 GV 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (it)", ->
		`
		expect(p.parse("Seconda lettera di Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Seconda Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Secondo Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2°. Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II. Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2° Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Giovanni 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Gv 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA LETTERA DI GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("SECONDA GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("SECONDO GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2°. GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II. GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2° GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 GIOVANNI 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 GV 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (it)", ->
		`
		expect(p.parse("Terza lettera di Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Terza Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Terzo Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III. Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3°. Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3° Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Giovanni 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Gv 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TERZA LETTERA DI GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TERZA GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TERZO GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III. GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3°. GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3° GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 GIOVANNI 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 GV 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (it)", ->
		`
		expect(p.parse("Vangelo di San Giovanni 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Vangelo di Giovanni 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Giovanni 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Gv 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("VANGELO DI SAN GIOVANNI 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("VANGELO DI GIOVANNI 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("GIOVANNI 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("GV 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (it)", ->
		`
		expect(p.parse("Atti degli Apostoli 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Atti 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("At 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ATTI DEGLI APOSTOLI 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ATTI 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("AT 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (it)", ->
		`
		expect(p.parse("Lettera ai Romani 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Romani 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rm 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Ro 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA AI ROMANI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMANI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("RM 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("RO 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (it)", ->
		`
		expect(p.parse("Seconda lettera ai Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Seconda Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Secondo Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2°. Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II. Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2° Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Corinzi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Cor 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Co 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA LETTERA AI CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("SECONDA CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("SECONDO CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2°. CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II. CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2° CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 CORINZI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 COR 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 CO 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (it)", ->
		`
		expect(p.parse("Prima lettera ai Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Prima Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Primo Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1°. Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1° Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I. Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I Corinzi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Cor 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Co 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA LETTERA AI CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PRIMA CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PRIMO CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1°. CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1° CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I. CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I CORINZI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 COR 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 CO 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (it)", ->
		`
		expect(p.parse("Lettera ai Galati 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Galati 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gàlati 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Ga 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA AI GALATI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GÀLATI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GA 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (it)", ->
		`
		expect(p.parse("Lettera agli Efesini 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Efesini 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ef 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA AGLI EFESINI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EFESINI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EF 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (it)", ->
		`
		expect(p.parse("Lettera ai Filippesi 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Filippesi 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Fil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Fl 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA AI FILIPPESI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FILIPPESI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FL 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (it)", ->
		`
		expect(p.parse("Lettera ai Colossesi 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Colossesi 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Cl 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA AI COLOSSESI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COLOSSESI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("CL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (it)", ->
		`
		expect(p.parse("Seconda lettera ai Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Seconda Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Secondo Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2°. Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II. Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2° Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Tessalonicesi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Te 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Ts 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA LETTERA AI TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("SECONDA TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("SECONDO TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2°. TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II. TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2° TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TESSALONICESI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TS 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (it)", ->
		`
		expect(p.parse("Prima lettera ai Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Prima Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Primo Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1°. Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1° Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I. Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I Tessalonicesi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Te 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Ts 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA LETTERA AI TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PRIMA TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PRIMO TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1°. TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1° TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I. TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I TESSALONICESI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TS 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (it)", ->
		`
		expect(p.parse("Seconda lettera a Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Seconda Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Secondo Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2°. Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II. Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2° Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timoteo 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Ti 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Tm 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA LETTERA A TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("SECONDA TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("SECONDO TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2°. TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II. TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2° TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTEO 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (it)", ->
		`
		expect(p.parse("Prima lettera a Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Prima Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Primo Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1°. Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1° Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I. Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I Timoteo 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Ti 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Tm 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA LETTERA A TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PRIMA TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PRIMO TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1°. TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1° TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I. TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I TIMOTEO 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (it)", ->
		`
		expect(p.parse("Lettera a Tito 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tito 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tt 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA A TITO 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITO 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TT 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (it)", ->
		`
		expect(p.parse("Lettera a Filemone 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filemone 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filèmone 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Fi 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Fm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA A FILEMONE 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILEMONE 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILÈMONE 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FI 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (it)", ->
		`
		expect(p.parse("Lettera agli Ebrei 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Ebrei 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Eb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA AGLI EBREI 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("EBREI 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("EB 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (it)", ->
		`
		expect(p.parse("Lettera di Giacomo 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Giacomo 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Gc 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Gm 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA DI GIACOMO 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("GIACOMO 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("GC 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("GM 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (it)", ->
		`
		expect(p.parse("Seconda lettera di Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Seconda Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Secondo Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2°. Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II. Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2° Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pietro 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pt 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 P 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SECONDA LETTERA DI PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("SECONDA PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("SECONDO PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2°. PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II. PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2° PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PIETRO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PT 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 P 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (it)", ->
		`
		expect(p.parse("Prima lettera di Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Prima Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Primo Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1°. Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1° Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I. Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I Pietro 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pt 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 P 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRIMA LETTERA DI PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PRIMA PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PRIMO PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1°. PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1° PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I. PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I PIETRO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PT 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 P 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (it)", ->
		`
		expect(p.parse("Lettera di Giuda 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Giuda 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Gd 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LETTERA DI GIUDA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("GIUDA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("GD 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (it)", ->
		`
		expect(p.parse("Tobiolo 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tobia 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tobi 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tb 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (it)", ->
		`
		expect(p.parse("Giuditta 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Gdt 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (it)", ->
		`
		expect(p.parse("Baruch 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Baruc 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (it)", ->
		`
		expect(p.parse("Storia di Susanna 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Susanna 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (it)", ->
		`
		expect(p.parse("Secondo libro dei Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Seconda Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Secondo Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2°. Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("II. Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2° Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("II Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Maccabei 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Mac 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (it)", ->
		`
		expect(p.parse("Terzo libro dei Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Terza Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Terzo Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("III. Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3°. Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("III Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3° Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Maccabei 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Mac 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (it)", ->
		`
		expect(p.parse("Quarto libro dei Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quarta Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quarto Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4°. Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("IV. Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4° Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("IV Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Maccabei 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Mac 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (it)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (it)", ->
		`
		expect(p.parse("Primo libro dei Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Prima Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Primo Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1°. Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1° Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("I. Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("I Maccabei 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Mac 1:1").osis()).toEqual("1Macc.1.1")
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
		expect(p.languages).toEqual ["it"]

	it "should handle ranges (it)", ->
		expect(p.parse("Titus 1:1 al 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1al2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 AL 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (it)", ->
		expect(p.parse("Titus 1:1, capitoli 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CAPITOLI 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, capitolo 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CAPITOLO 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, capp. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CAPP. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, capp 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CAPP 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, cap. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CAP. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, cap 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CAP 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, cc. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CC. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, cc 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CC 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (it)", ->
		expect(p.parse("Exod 1:1 versetto 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSETTO 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 versetti 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSETTI 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 versi 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSI 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 vv. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VV. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 vv 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VV 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (it)", ->
		expect(p.parse("Exod 1:1 vedi anche 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 VEDI ANCHE 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 vedi 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 VEDI 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 cfr 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 CFR 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 e 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 E 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (it)", ->
		expect(p.parse("Ps 3 titolo, 4:2, 5:titolo").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 TITOLO, 4:2, 5:TITOLO").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (it)", ->
		p.set_options {case_sensitive: "books"}
		expect(p.parse("Rev 3ss, 4:2ss").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("Rev 3, ecc, 4:2, ecc").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("Rev 3ecc, 4:2ecc").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		p.set_options {case_sensitive: "none"}
	it "should handle translations (it)", ->
		expect(p.parse("Lev 1 (CEI)").osis_and_translations()).toEqual [["Lev.1", "CEI"]]
		expect(p.parse("lev 1 cei").osis_and_translations()).toEqual [["Lev.1", "CEI"]]
		expect(p.parse("Lev 1 (LND)").osis_and_translations()).toEqual [["Lev.1", "LND"]]
		expect(p.parse("lev 1 lnd").osis_and_translations()).toEqual [["Lev.1", "LND"]]
		expect(p.parse("Lev 1 (ND)").osis_and_translations()).toEqual [["Lev.1", "ND"]]
		expect(p.parse("lev 1 nd").osis_and_translations()).toEqual [["Lev.1", "ND"]]
		expect(p.parse("Lev 1 (NR)").osis_and_translations()).toEqual [["Lev.1", "NR"]]
		expect(p.parse("lev 1 nr").osis_and_translations()).toEqual [["Lev.1", "NR"]]
		expect(p.parse("Lev 1 (NR1994)").osis_and_translations()).toEqual [["Lev.1", "NR1994"]]
		expect(p.parse("lev 1 nr1994").osis_and_translations()).toEqual [["Lev.1", "NR1994"]]
		expect(p.parse("Lev 1 (NR2006)").osis_and_translations()).toEqual [["Lev.1", "NR2006"]]
		expect(p.parse("lev 1 nr2006").osis_and_translations()).toEqual [["Lev.1", "NR2006"]]
	it "should handle book ranges (it)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("Primo al Terzo  Giovanni").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (it)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
