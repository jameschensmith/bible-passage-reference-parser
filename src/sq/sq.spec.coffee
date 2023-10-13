bcv_parser = require("../../js/sq_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (sq)", ->
		`
		expect(p.parse("Zanafilla 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Zan 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZANAFILLA 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("ZAN 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (sq)", ->
		`
		expect(p.parse("Eksodi 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Dalja 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Dal 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Eks 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EKSODI 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("DALJA 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("DAL 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EKS 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (sq)", ->
		`
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (sq)", ->
		`
		expect(p.parse("Levitiket 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Levitikët 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Levitiku 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LEVITIKET 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVITIKËT 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVITIKU 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (sq)", ->
		`
		expect(p.parse("Numrat 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NUMRAT 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (sq)", ->
		`
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (sq)", ->
		`
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (sq)", ->
		`
		expect(p.parse("Vajtimet 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Vaj 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("VAJTIMET 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("VAJ 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (sq)", ->
		`
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (sq)", ->
		`
		expect(p.parse("Zbulesa 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Zbu 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Zb 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZBULESA 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ZBU 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ZB 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (sq)", ->
		`
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (sq)", ->
		`
		expect(p.parse("Ligji i Perterire 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i Perterirë 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i Pertërire 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i Pertërirë 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i Përterire 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i Përterirë 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i Përtërire 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i Përtërirë 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Ligji i përtërirë 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LiP 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LIGJI I PERTERIRE 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PERTERIRË 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PERTËRIRE 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PERTËRIRË 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PËRTERIRE 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PËRTERIRË 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PËRTËRIRE 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PËRTËRIRË 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIGJI I PËRTËRIRË 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("LIP 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (sq)", ->
		`
		expect(p.parse("Jozueu 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Joz 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOZUEU 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOZ 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (sq)", ->
		`
		expect(p.parse("Gjyqtaret 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Gjyqtarët 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Gjy 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GJYQTARET 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("GJYQTARËT 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("GJY 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (sq)", ->
		`
		expect(p.parse("Ruthi 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTHI 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (sq)", ->
		`
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (sq)", ->
		`
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (sq)", ->
		`
		expect(p.parse("Jesaja 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isaia 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JESAJA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISAIA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (sq)", ->
		`
		expect(p.parse("2 e. Samuelit 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 i. Samuelit 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 e Samuelit 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 i Samuelit 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Samuelit 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Samuelit 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. SAMUELIT 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 I. SAMUELIT 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 E SAMUELIT 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 I SAMUELIT 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMUELIT 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUELIT 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (sq)", ->
		`
		expect(p.parse("1 e. Samuelit 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 i. Samuelit 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 e Samuelit 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 i Samuelit 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Samuelit 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Samuelit 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. SAMUELIT 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 I. SAMUELIT 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 E SAMUELIT 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 I SAMUELIT 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMUELIT 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUELIT 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (sq)", ->
		`
		expect(p.parse("2 e. Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 e. Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 i. Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 i. Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 e. Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 e. Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 i. Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 i. Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 e Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 e Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 i Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 i Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 e Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 e Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 i Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 i Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 Mbreterve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 Mbretërve 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Mb 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 E. MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 I. MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 I. MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 E. MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 E. MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 I. MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 I. MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 E MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 E MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 I MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 I MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 E MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 E MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 I MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 I MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 MBRETERVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 MBRETËRVE 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 MB 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (sq)", ->
		`
		expect(p.parse("1 e. Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 e. Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 i. Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 i. Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 e. Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 e. Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 i. Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 i. Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 e Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 e Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 i Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 i Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 e Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 e Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 i Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 i Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 Mbreterve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 Mbretërve 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Mb 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 E. MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 I. MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 I. MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 E. MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 E. MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 I. MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 I. MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 E MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 E MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 I MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 I MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 E MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 E MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 I MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 I MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 MBRETERVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 MBRETËRVE 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 MB 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (sq)", ->
		`
		expect(p.parse("2 e. Kronikave 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 i. Kronikave 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 e Kronikave 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 i Kronikave 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 e. Kronika 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 i. Kronika 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Kronikave 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Kronikave 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 e Kronika 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 i Kronika 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Kronika 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Kronika 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Kr 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. KRONIKAVE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 I. KRONIKAVE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 E KRONIKAVE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 I KRONIKAVE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 E. KRONIKA 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 I. KRONIKA 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. KRONIKAVE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRONIKAVE 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 E KRONIKA 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 I KRONIKA 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. KRONIKA 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRONIKA 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KR 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (sq)", ->
		`
		expect(p.parse("1 e. Kronikave 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 i. Kronikave 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 e Kronikave 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 i Kronikave 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 e. Kronika 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 i. Kronika 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Kronikave 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Kronikave 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 e Kronika 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 i Kronika 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Kronika 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Kronika 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Kr 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. KRONIKAVE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 I. KRONIKAVE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 E KRONIKAVE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 I KRONIKAVE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 E. KRONIKA 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 I. KRONIKA 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. KRONIKAVE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRONIKAVE 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 E KRONIKA 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 I KRONIKA 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. KRONIKA 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRONIKA 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KR 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (sq)", ->
		`
		expect(p.parse("Esdra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Esd 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESDRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ESD 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (sq)", ->
		`
		expect(p.parse("Nehemia 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NEHEMIA 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (sq)", ->
		`
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (sq)", ->
		`
		expect(p.parse("Ester 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Est 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESTER 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("EST 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (sq)", ->
		`
		expect(p.parse("Hiobi 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Jobi 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HIOBI 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOBI 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (sq)", ->
		`
		expect(p.parse("Libri i Psalmeve 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Psalmet 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Psalmi 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LIBRI I PSALMEVE 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PSALMET 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PSALMI 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (sq)", ->
		`
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (sq)", ->
		`
		expect(p.parse("Fjalet e urta 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Fjalët e urta 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FJALET E URTA 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("FJALËT E URTA 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (sq)", ->
		`
		expect(p.parse("Predikuesi 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Pred 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREDIKUESI 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("PRED 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (sq)", ->
		`
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (sq)", ->
		`
		expect(p.parse("Kantiku i Kantikeve 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Kantiku i Kantikëve 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Kant 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("KANTIKU I KANTIKEVE 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("KANTIKU I KANTIKËVE 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("KANT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (sq)", ->
		`
		expect(p.parse("Jeremia 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JEREMIA 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (sq)", ->
		`
		expect(p.parse("Ezekieli 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Eze 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EZEKIELI 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZE 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (sq)", ->
		`
		expect(p.parse("Danieli 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DANIELI 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (sq)", ->
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
describe "Localized book Joel (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (sq)", ->
		`
		expect(p.parse("Joeli 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Jl 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOELI 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JL 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (sq)", ->
		`
		expect(p.parse("Amosi 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Am 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMOSI 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AM 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (sq)", ->
		`
		expect(p.parse("Abdia 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Abd 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ABDIA 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ABD 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (sq)", ->
		`
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jona 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jon 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONA 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JON 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (sq)", ->
		`
		expect(p.parse("Mikea 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mik 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MIKEA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIK 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (sq)", ->
		`
		expect(p.parse("Nahumi 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHUMI 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (sq)", ->
		`
		expect(p.parse("Habakuku 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HABAKUKU 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (sq)", ->
		`
		expect(p.parse("Sofonia 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Sof 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SOFONIA 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SOF 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (sq)", ->
		`
		expect(p.parse("Hagai 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HAGAI 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (sq)", ->
		`
		expect(p.parse("Zakaria 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zak 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZAKARIA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZAK 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (sq)", ->
		`
		expect(p.parse("Malakia 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MALAKIA 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (sq)", ->
		`
		expect(p.parse("Ungjilli i Mateut 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Mateu 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Mt 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("UNGJILLI I MATEUT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATEU 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MT 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (sq)", ->
		`
		expect(p.parse("Ungjilli i Markut 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Marku 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("UNGJILLI I MARKUT 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKU 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (sq)", ->
		`
		expect(p.parse("Ungjilli i Lukes 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Ungjilli i Lukës 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lluka 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luka 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Llu 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("UNGJILLI I LUKES 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("UNGJILLI I LUKËS 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LLUKA 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKA 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LLU 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (sq)", ->
		`
		expect(p.parse("1 e. Gjonit 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 i. Gjonit 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 e Gjonit 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 i Gjonit 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Gjonit 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Gjonit 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Gj 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. GJONIT 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 I. GJONIT 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 E GJONIT 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 I GJONIT 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. GJONIT 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 GJONIT 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 GJ 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (sq)", ->
		`
		expect(p.parse("2 e. Gjonit 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 i. Gjonit 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 e Gjonit 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 i Gjonit 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Gjonit 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Gjonit 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Gj 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. GJONIT 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 I. GJONIT 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 E GJONIT 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 I GJONIT 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. GJONIT 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 GJONIT 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 GJ 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (sq)", ->
		`
		expect(p.parse("3 e. Gjonit 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 i. Gjonit 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 e Gjonit 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 i Gjonit 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Gjonit 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Gjonit 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Gj 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("3 E. GJONIT 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 I. GJONIT 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 E GJONIT 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 I GJONIT 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. GJONIT 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 GJONIT 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 GJ 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (sq)", ->
		`
		expect(p.parse("Ungjilli i Gjonit 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Gjoni 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Gjo 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("UNGJILLI I GJONIT 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("GJONI 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("GJO 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (sq)", ->
		`
		expect(p.parse("Veprat e Apostujve 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Veprat e apostujve 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Veprat 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Vep 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("VEPRAT E APOSTUJVE 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("VEPRAT E APOSTUJVE 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("VEPRAT 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("VEP 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (sq)", ->
		`
		expect(p.parse("Romakeve 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Romakëve 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ROMAKEVE 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMAKËVE 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (sq)", ->
		`
		expect(p.parse("2 e. Korintasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 i. Korintasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 e Korintasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 e. Koritasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 i Korintasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 i. Koritasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 e Koritasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 i Koritasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korintasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korintasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Koritasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Koritasve 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Kor 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. KORINTASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 I. KORINTASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 E KORINTASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 E. KORITASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 I KORINTASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 I. KORITASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 E KORITASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 I KORITASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORITASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORITASVE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KOR 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (sq)", ->
		`
		expect(p.parse("1 e. Korintasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 i. Korintasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 e Korintasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 e. Koritasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 i Korintasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 i. Koritasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 e Koritasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 i Koritasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korintasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korintasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Koritasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Koritasve 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Kor 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. KORINTASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 I. KORINTASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 E KORINTASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 E. KORITASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 I KORINTASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 I. KORITASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 E KORITASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 I KORITASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORITASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORITASVE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KOR 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (sq)", ->
		`
		expect(p.parse("Galatasve 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GALATASVE 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (sq)", ->
		`
		expect(p.parse("Efesianeve 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Efesianëve 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ef 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EFESIANEVE 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EFESIANËVE 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EF 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (sq)", ->
		`
		expect(p.parse("Filipianeve 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Filipianëve 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Fil 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FILIPIANEVE 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FILIPIANËVE 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FIL 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (sq)", ->
		`
		expect(p.parse("Kolosianeve 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Kolosianëve 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Kol 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("KOLOSIANEVE 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KOLOSIANËVE 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KOL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (sq)", ->
		`
		expect(p.parse("2 e. Thesalonikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 i. Thesalonikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 e Thesalonikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 i Thesalonikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Thesalonikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thesalonikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 e. Selanikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 i. Selanikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 e Selanikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 i Selanikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Selanikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Selanikasve 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Th 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. THESALONIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 I. THESALONIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 E THESALONIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 I THESALONIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. THESALONIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESALONIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 E. SELANIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 I. SELANIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 E SELANIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 I SELANIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. SELANIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 SELANIKASVE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TH 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (sq)", ->
		`
		expect(p.parse("1 e. Thesalonikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 i. Thesalonikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 e Thesalonikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 i Thesalonikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Thesalonikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thesalonikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 e. Selanikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 i. Selanikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 e Selanikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 i Selanikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Selanikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Selanikasve 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Th 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. THESALONIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 I. THESALONIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 E THESALONIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 I THESALONIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. THESALONIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESALONIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 E. SELANIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 I. SELANIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 E SELANIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 I SELANIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. SELANIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 SELANIKASVE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TH 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (sq)", ->
		`
		expect(p.parse("2 e. Timoteut 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 i. Timoteut 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 e Timoteut 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 i Timoteut 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timoteut 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timoteut 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. TIMOTEUT 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 I. TIMOTEUT 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 E TIMOTEUT 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 I TIMOTEUT 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTEUT 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTEUT 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (sq)", ->
		`
		expect(p.parse("1 e. Timoteut 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 i. Timoteut 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 e Timoteut 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 i Timoteut 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timoteut 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timoteut 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. TIMOTEUT 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 I. TIMOTEUT 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 E TIMOTEUT 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 I TIMOTEUT 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTEUT 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTEUT 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (sq)", ->
		`
		expect(p.parse("Titit 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titi 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tit 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TITIT 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITI 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TIT 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (sq)", ->
		`
		expect(p.parse("Filemonit 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filem 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FILEMONIT 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILEM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (sq)", ->
		`
		expect(p.parse("Hebrenjve 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HEBRENJVE 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (sq)", ->
		`
		expect(p.parse("Jakobit 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jakobi 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jak 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JAKOBIT 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAKOBI 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAK 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (sq)", ->
		`
		expect(p.parse("2 e. Pjetrit 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 i. Pjetrit 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 e Pjetrit 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 i Pjetrit 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Pjetrit 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pjetrit 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pje 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pj 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("2 E. PJETRIT 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 I. PJETRIT 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 E PJETRIT 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 I PJETRIT 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PJETRIT 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PJETRIT 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PJE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PJ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (sq)", ->
		`
		expect(p.parse("1 e. Pjetrit 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 i. Pjetrit 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 e Pjetrit 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 i Pjetrit 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Pjetrit 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pjetrit 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pje 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pj 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("1 E. PJETRIT 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 I. PJETRIT 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 E PJETRIT 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 I PJETRIT 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PJETRIT 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PJETRIT 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PJE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PJ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (sq)", ->
		`
		expect(p.parse("Juda 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jud 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JUDA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUD 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (sq)", ->
		`
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (sq)", ->
		`
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (sq)", ->
		`
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (sq)", ->
		`
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (sq)", ->
		`
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (sq)", ->
		`
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (sq)", ->
		`
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (sq)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (sq)", ->
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
		expect(p.languages).toEqual ["sq"]

	it "should handle ranges (sq)", ->
		expect(p.parse("Titus 1:1 - 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1-2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 - 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (sq)", ->
		expect(p.parse("Titus 1:1, chapter 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHAPTER 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (sq)", ->
		expect(p.parse("Exod 1:1 verse 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSE 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (sq)", ->
		expect(p.parse("Exod 1:1 and 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 AND 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (sq)", ->
		expect(p.parse("Ps 3 title, 4:2, 5:title").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 TITLE, 4:2, 5:TITLE").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (sq)", ->
		expect(p.parse("Rev 3ff, 4:2ff").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 FF, 4:2 FF").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (sq)", ->
		expect(p.parse("Lev 1 (ALB)").osis_and_translations()).toEqual [["Lev.1", "ALB"]]
		expect(p.parse("lev 1 alb").osis_and_translations()).toEqual [["Lev.1", "ALB"]]
	it "should handle book ranges (sq)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("1 i - 3 i  Gjonit").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (sq)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
