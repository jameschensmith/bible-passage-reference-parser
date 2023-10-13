bcv_parser = require("../../js/da_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (da)", ->
		`
		expect(p.parse("Første Mosebog 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. Mosebog 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Første Mos 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 Mosebog 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Genesis 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. Mos 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 Mos 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FØRSTE MOSEBOG 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. MOSEBOG 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("FØRSTE MOS 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 MOSEBOG 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GENESIS 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1. MOS 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("1 MOS 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (da)", ->
		`
		expect(p.parse("Anden Mosebog 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. Mosebog 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 Mosebog 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Anden Mos 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. Mos 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exodus 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 Mos 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDEN MOSEBOG 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. MOSEBOG 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 MOSEBOG 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ANDEN MOS 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2. MOS 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXODUS 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("2 MOS 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (da)", ->
		`
		expect(p.parse("Bel og Dragen 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (da)", ->
		`
		expect(p.parse("Tredje Mosebog 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. Mosebog 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Tredje Mos 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 Mosebog 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Leviticus 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. Mos 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 Mos 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TREDJE MOSEBOG 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. MOSEBOG 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("TREDJE MOS 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 MOSEBOG 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVITICUS 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3. MOS 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("3 MOS 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (da)", ->
		`
		expect(p.parse("Fjerde Mosebog 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. Mosebog 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Fjerde Mos 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 Mosebog 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. Mos 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Numeri 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 Mos 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FJERDE MOSEBOG 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. MOSEBOG 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("FJERDE MOS 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 MOSEBOG 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4. MOS 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUMERI 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("4 MOS 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (da)", ->
		`
		expect(p.parse("Siraks Bog 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sirak 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (da)", ->
		`
		expect(p.parse("Visdommens Bog 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Visdommen 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (da)", ->
		`
		expect(p.parse("Klagesangene 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Klages 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Klag 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("KLAGESANGENE 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("KLAGES 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("KLAG 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (da)", ->
		`
		expect(p.parse("Jeremias' Brev 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Jeremias’ Brev 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (da)", ->
		`
		expect(p.parse("Johannes' Abenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johannes' Åbenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johannes’ Abenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johannes’ Åbenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johannesapokalypsen 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Abenbaringsbogen 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johs. Abenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johs. Åbenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Åbenbaringsbogen 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johs Abenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Johs Åbenbaring 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Aabenbaringen 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Abenbaringen 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Åbenbaringen 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Apokalypsen 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Ab 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Åb 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOHANNES' ABENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHANNES' ÅBENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHANNES’ ABENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHANNES’ ÅBENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHANNESAPOKALYPSEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ABENBARINGSBOGEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHS. ABENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHS. ÅBENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ÅBENBARINGSBOGEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHS ABENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("JOHS ÅBENBARING 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("AABENBARINGEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ABENBARINGEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ÅBENBARINGEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("APOKALYPSEN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("AB 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ÅB 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (da)", ->
		`
		expect(p.parse("Manasses Bøn 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (da)", ->
		`
		expect(p.parse("Deuteronomium 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Femte Mosebog 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. Mosebog 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 Mosebog 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Femte Mos 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. Mos 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 Mos 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUTERONOMIUM 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("FEMTE MOSEBOG 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. MOSEBOG 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 MOSEBOG 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("FEMTE MOS 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5. MOS 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("5 MOS 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (da)", ->
		`
		expect(p.parse("Josvabogen 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josvas Bog 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josvabog 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josua 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Jos 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOSVABOGEN 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSVAS BOG 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSVABOG 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSUA 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOS 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (da)", ->
		`
		expect(p.parse("Dommerbogen 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Dommer 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Dom 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DOMMERBOGEN 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("DOMMER 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("DOM 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (da)", ->
		`
		expect(p.parse("Ruths Bog 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Rut 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTHS BOG 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUT 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (da)", ->
		`
		expect(p.parse("Første Esdrasbog 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Tredje Esdrasbog 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1. Esdrasbog 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3. Esdrasbog 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esdrasbog 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("3 Esdrasbog 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (da)", ->
		`
		expect(p.parse("Fjerde Esdrasbog 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Anden Esdrasbog 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2. Esdrasbog 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4. Esdrasbog 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esdrasbog 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("4 Esdrasbog 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (da)", ->
		`
		expect(p.parse("Esajas' Bog 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Esajas’ Bog 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Esajas 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Jesaia 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Es 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESAJAS' BOG 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ESAJAS’ BOG 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ESAJAS 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("JESAIA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ES 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (da)", ->
		`
		expect(p.parse("Anden Kongerigernes Bog 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Kongerigernes Bog 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Kongerigernes Bog 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Anden Samuelsbog 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Samuelsbog 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Samuelsbog 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Anden Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Anden Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDEN KONGERIGERNES BOG 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. KONGERIGERNES BOG 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 KONGERIGERNES BOG 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ANDEN SAMUELSBOG 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMUELSBOG 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUELSBOG 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ANDEN SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ANDEN SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (da)", ->
		`
		expect(p.parse("Første Kongerigernes Bog 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Kongerigernes Bog 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Kongerigernes Bog 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Første Samuelsbog 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Samuelsbog 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Første Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Samuelsbog 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Første Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FØRSTE KONGERIGERNES BOG 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. KONGERIGERNES BOG 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 KONGERIGERNES BOG 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("FØRSTE SAMUELSBOG 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMUELSBOG 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("FØRSTE SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUELSBOG 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("FØRSTE SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (da)", ->
		`
		expect(p.parse("Fjerde Kongerigernes Bog 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. Kongerigernes Bog 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 Kongerigernes Bog 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Anden Kongebog 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Kongebog 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Kongebog 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Anden Kong 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Kong 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Kong 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FJERDE KONGERIGERNES BOG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4. KONGERIGERNES BOG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("4 KONGERIGERNES BOG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ANDEN KONGEBOG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. KONGEBOG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 KONGEBOG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ANDEN KONG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. KONG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 KONG 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (da)", ->
		`
		expect(p.parse("Tredje Kongerigernes Bog 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. Kongerigernes Bog 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 Kongerigernes Bog 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Første Kongebog 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Kongebog 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Første Kong 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Kongebog 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Kong 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Kong 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TREDJE KONGERIGERNES BOG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3. KONGERIGERNES BOG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("3 KONGERIGERNES BOG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("FØRSTE KONGEBOG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. KONGEBOG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("FØRSTE KONG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 KONGEBOG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. KONG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 KONG 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (da)", ->
		`
		expect(p.parse("Anden Krønikebog 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Krønikebog 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Krønikebog 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Anden Kron 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Anden Krøn 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Kron 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Krøn 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Kron 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Krøn 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDEN KRØNIKEBOG 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. KRØNIKEBOG 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRØNIKEBOG 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ANDEN KRON 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ANDEN KRØN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. KRON 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. KRØN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRON 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 KRØN 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (da)", ->
		`
		expect(p.parse("Første Krønikebog 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Krønikebog 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Krønikebog 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Første Kron 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Første Krøn 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Kron 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Krøn 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Kron 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Krøn 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FØRSTE KRØNIKEBOG 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. KRØNIKEBOG 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRØNIKEBOG 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("FØRSTE KRON 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("FØRSTE KRØN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. KRON 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. KRØN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRON 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 KRØN 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (da)", ->
		`
		expect(p.parse("Ezras Bog 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EZRAS BOG 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (da)", ->
		`
		expect(p.parse("Nehemias’ Bog 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Nehemias 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NEHEMIAS’ BOG 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEHEMIAS 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (da)", ->
		`
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (da)", ->
		`
		expect(p.parse("Esters Bog 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Ester 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Est 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESTERS BOG 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTER 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("EST 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (da)", ->
		`
		expect(p.parse("Jobs Bog 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Hiob 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOBS BOG 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("HIOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (da)", ->
		`
		expect(p.parse("Salmernes Bog 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Salmerne 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Salme 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Sl 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SALMERNES BOG 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("SALMERNE 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("SALME 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("SL 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (da)", ->
		`
		expect(p.parse("Azarjas Bøn 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Azarjas bøn 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (da)", ->
		`
		expect(p.parse("Ordsprogenes Bog 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Ordsprogene 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Ordsp 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ORDSPROGENES BOG 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ORDSPROGENE 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ORDSP 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (da)", ->
		`
		expect(p.parse("Prædikerens Bog 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Prædikeren 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Prad 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Præd 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRÆDIKERENS BOG 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("PRÆDIKEREN 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("PRAD 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("PRÆD 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (da)", ->
		`
		expect(p.parse("De Tre Mænds Lovsang 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("De tre mænds lovsang 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (da)", ->
		`
		expect(p.parse("Salomons Højsang 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Højsangen 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Hojs 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Højs 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SALOMONS HØJSANG 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HØJSANGEN 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HOJS 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("HØJS 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (da)", ->
		`
		expect(p.parse("Jeremias' Bog 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jeremias’ Bog 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jeremias 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JEREMIAS' BOG 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JEREMIAS’ BOG 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JEREMIAS 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (da)", ->
		`
		expect(p.parse("Ezekiels’ Bog 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezekiels Bog 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Hezechiel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezekiel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ez 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EZEKIELS’ BOG 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEKIELS BOG 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("HEZECHIEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEKIEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZ 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (da)", ->
		`
		expect(p.parse("Daniels Bog 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Daniel 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DANIELS BOG 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DANIEL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (da)", ->
		`
		expect(p.parse("Hoseas’ Bog 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hoseas 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HOSEAS’ BOG 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOSEAS 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (da)", ->
		`
		expect(p.parse("Joels Bog 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOELS BOG 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (da)", ->
		`
		expect(p.parse("Amos' Bog 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amos’ Bog 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Am 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMOS' BOG 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS’ BOG 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AM 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (da)", ->
		`
		expect(p.parse("Obadias' Bog 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obadias’ Bog 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obadias 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("OBADIAS' BOG 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBADIAS’ BOG 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBADIAS 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (da)", ->
		`
		expect(p.parse("Jonas' Bog 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonas’ Bog 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonas 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jon 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JONAS' BOG 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAS’ BOG 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAS 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JON 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (da)", ->
		`
		expect(p.parse("Mikas Bog 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mikas 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mika 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MIKAS BOG 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIKAS 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIKA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (da)", ->
		`
		expect(p.parse("Nahums Bog 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nahum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHUMS BOG 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAHUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (da)", ->
		`
		expect(p.parse("Habakkuks Bog 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Habakkuk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HABAKKUKS BOG 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAKKUK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (da)", ->
		`
		expect(p.parse("Sefanias' Bog 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Sefanias’ Bog 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zefanias’ Bog 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zefanias 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Sef 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zef 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SEFANIAS' BOG 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SEFANIAS’ BOG 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEFANIAS’ BOG 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEFANIAS 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SEF 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEF 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (da)", ->
		`
		expect(p.parse("Haggajs Bog 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Haggaj 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hagg 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HAGGAJS BOG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAGGAJ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAGG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (da)", ->
		`
		expect(p.parse("Zakarias' Bog 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zakarias’ Bog 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zakarias 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zak 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZAKARIAS' BOG 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZAKARIAS’ BOG 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZAKARIAS 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZAK 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (da)", ->
		`
		expect(p.parse("Malakias’ Bog 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Malakias 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MALAKIAS’ BOG 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALAKIAS 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (da)", ->
		`
		expect(p.parse("Matthæusevangeliet 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Mattæusevangeliet 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matthæus 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MATTHÆUSEVANGELIET 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTÆUSEVANGELIET 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTHÆUS 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (da)", ->
		`
		expect(p.parse("Markusevangeliet 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Markus 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MARKUSEVANGELIET 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKUS 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (da)", ->
		`
		expect(p.parse("Lukasevangeliet 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lukas 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luk 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lk 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LUKASEVANGELIET 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKAS 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUK 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LK 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (da)", ->
		`
		expect(p.parse("Første Johannes' Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Første Johannes’ Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes' Første Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes’ Første Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Første Johannesbrev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Johannes' Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Johannes’ Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes' 1. Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes’ 1. Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Johannes' Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Johannes’ Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes' 1 Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Johannes’ 1 Brev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Johannesbrev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Første Johannes 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Johannesbrev 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Johannes 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Johannes 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Første Joh 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Joh 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Joh 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("FØRSTE JOHANNES' BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("FØRSTE JOHANNES’ BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES' FØRSTE BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES’ FØRSTE BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("FØRSTE JOHANNESBREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. JOHANNES' BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. JOHANNES’ BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES' 1. BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES’ 1. BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JOHANNES' BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JOHANNES’ BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES' 1 BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("JOHANNES’ 1 BREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. JOHANNESBREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("FØRSTE JOHANNES 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JOHANNESBREV 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. JOHANNES 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JOHANNES 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("FØRSTE JOH 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. JOH 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JOH 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (da)", ->
		`
		expect(p.parse("Anden Johannes' Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Anden Johannes’ Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Johannes' Andet Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Johannes’ Andet Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Anden Johannesbrev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Andet Johannesbrev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Johannes' Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Johannes’ Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Johannes' Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Johannes’ Brev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Johannesbrev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Johannesbrev 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Anden Johannes 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Johannes 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Johannes 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Anden Joh 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Joh 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Joh 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ANDEN JOHANNES' BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ANDEN JOHANNES’ BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("JOHANNES' ANDET BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("JOHANNES’ ANDET BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ANDEN JOHANNESBREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ANDET JOHANNESBREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. JOHANNES' BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. JOHANNES’ BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JOHANNES' BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JOHANNES’ BREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. JOHANNESBREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JOHANNESBREV 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ANDEN JOHANNES 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. JOHANNES 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JOHANNES 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ANDEN JOH 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. JOH 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JOH 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (da)", ->
		`
		expect(p.parse("Johannes' Tredje Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Johannes’ Tredje Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Tredje Johannes' Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Tredje Johannes’ Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Tredje Johannesbrev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Johannes' Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Johannes’ Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Johannes' 3. Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Johannes’ 3. Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Johannes' Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Johannes’ Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Johannes' 3 Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Johannes’ 3 Brev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Johannesbrev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Tredje Johannes 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Johannesbrev 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Johannes 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Johannes 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Tredje Joh 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Joh 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Joh 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOHANNES' TREDJE BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("JOHANNES’ TREDJE BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TREDJE JOHANNES' BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TREDJE JOHANNES’ BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TREDJE JOHANNESBREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. JOHANNES' BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. JOHANNES’ BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("JOHANNES' 3. BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("JOHANNES’ 3. BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JOHANNES' BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JOHANNES’ BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("JOHANNES' 3 BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("JOHANNES’ 3 BREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. JOHANNESBREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TREDJE JOHANNES 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JOHANNESBREV 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. JOHANNES 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JOHANNES 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TREDJE JOH 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. JOH 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JOH 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (da)", ->
		`
		expect(p.parse("Johannesevangeliet 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Johannes 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Joh 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOHANNESEVANGELIET 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHANNES 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOH 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (da)", ->
		`
		expect(p.parse("Apostlenes Gerninger 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Gerninger 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Ap.G 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ApG 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Apg 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("APOSTLENES GERNINGER 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("GERNINGER 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("AP.G 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("APG 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("APG 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (da)", ->
		`
		expect(p.parse("Paulus' Brev til Romerne 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Paulus’ Brev til Romerne 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Romerbrevet 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Romerne 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' BREV TIL ROMERNE 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("PAULUS’ BREV TIL ROMERNE 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMERBREVET 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMERNE 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (da)", ->
		`
		expect(p.parse("Paulus' Andet Brev til Korintherne 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Paulus’ Andet Brev til Korintherne 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Anden Korintherbrev 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Andet Korintherbrev 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Anden Korinterbrev 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korintherbrev 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Anden Korinterne 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korintherbrev 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korinterbrev 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korinterbrev 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Korinterne 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Korinterne 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Anden Kor 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Kor 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Kor 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' ANDET BREV TIL KORINTHERNE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("PAULUS’ ANDET BREV TIL KORINTHERNE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDEN KORINTHERBREV 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDET KORINTHERBREV 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDEN KORINTERBREV 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTHERBREV 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDEN KORINTERNE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTHERBREV 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTERBREV 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTERBREV 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTERNE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTERNE 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ANDEN KOR 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KOR 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KOR 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (da)", ->
		`
		expect(p.parse("Paulus' Første Brev til Korintherne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Paulus’ Første Brev til Korintherne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Paulus' 1. Brev til Korintherne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Paulus’ 1. Brev til Korintherne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Paulus' 1 Brev til Korintherne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Paulus’ 1 Brev til Korintherne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Første Korintherbrev 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Første Korinterbrev 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Første Korinterne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korintherbrev 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korintherbrev 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korinterbrev 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korinterbrev 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Korinterne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Korinterne 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Første Kor 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Kor 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Kor 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' FØRSTE BREV TIL KORINTHERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PAULUS’ FØRSTE BREV TIL KORINTHERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PAULUS' 1. BREV TIL KORINTHERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PAULUS’ 1. BREV TIL KORINTHERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PAULUS' 1 BREV TIL KORINTHERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PAULUS’ 1 BREV TIL KORINTHERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FØRSTE KORINTHERBREV 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FØRSTE KORINTERBREV 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FØRSTE KORINTERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTHERBREV 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTHERBREV 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTERBREV 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTERBREV 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTERNE 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("FØRSTE KOR 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KOR 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KOR 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (da)", ->
		`
		expect(p.parse("Paulus' Brev til Galaterne 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Paulus’ Brev til Galaterne 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Brevet til Galaterne 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Galaterbrevet 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Galaterne 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' BREV TIL GALATERNE 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("PAULUS’ BREV TIL GALATERNE 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("BREVET TIL GALATERNE 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATERBREVET 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATERNE 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (da)", ->
		`
		expect(p.parse("Paulus' Brev til Efeserne 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Paulus’ Brev til Efeserne 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Efeserbrevet 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Efeserne 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ef 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' BREV TIL EFESERNE 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("PAULUS’ BREV TIL EFESERNE 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EFESERBREVET 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EFESERNE 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EF 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (da)", ->
		`
		expect(p.parse("Paulus' Brev til Filipperne 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Paulus’ Brev til Filipperne 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Filipperbrevet 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Filipperne 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Fil 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' BREV TIL FILIPPERNE 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PAULUS’ BREV TIL FILIPPERNE 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FILIPPERBREVET 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FILIPPERNE 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("FIL 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (da)", ->
		`
		expect(p.parse("Paulus' Brev til Kolossenserne 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Paulus’ Brev til Kolossenserne 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Kolossenserbrevet 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Kolossensern 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Kol 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' BREV TIL KOLOSSENSERNE 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("PAULUS’ BREV TIL KOLOSSENSERNE 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KOLOSSENSERBREVET 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KOLOSSENSERN 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KOL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (da)", ->
		`
		expect(p.parse("Paulus' Andet Brev til Thessalonikerne 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Paulus’ Andet Brev til Thessalonikerne 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Anden Thessalonikerbrev 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Andet Thessalonikerbrev 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Thessalonikerbrev 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Anden Tessalonikerne 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thessalonikerbrev 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Tessalonikerne 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Tessalonikerne 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Anden Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' ANDET BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("PAULUS’ ANDET BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ANDEN THESSALONIKERBREV 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ANDET THESSALONIKERBREV 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. THESSALONIKERBREV 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ANDEN TESSALONIKERNE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESSALONIKERBREV 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TESSALONIKERNE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TESSALONIKERNE 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ANDEN THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (da)", ->
		`
		expect(p.parse("Paulus' Første Brev til Thessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Paulus’ Første Brev til Thessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Paulus' 1. Brev til Thessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Paulus’ 1. Brev til Thessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Paulus' 1 Brev til Thessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Paulus’ 1 Brev til Thessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Første Thessalonikerbrev 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Første Tessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Thessalonikerbrev 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thessalonikerbrev 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Tessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Tessalonikerne 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Første Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' FØRSTE BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PAULUS’ FØRSTE BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PAULUS' 1. BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PAULUS’ 1. BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PAULUS' 1 BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PAULUS’ 1 BREV TIL THESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("FØRSTE THESSALONIKERBREV 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("FØRSTE TESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. THESSALONIKERBREV 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESSALONIKERBREV 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TESSALONIKERNE 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("FØRSTE THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (da)", ->
		`
		expect(p.parse("Paulus' Andet Brev til Timotheus 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Paulus’ Andet Brev til Timotheus 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Anden Timotheusbrev 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Andet Timotheusbrev 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Anden Timoteusbrev 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timotheusbrev 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timotheusbrev 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timoteusbrev 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timoteusbrev 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Anden Timoteus 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timoteus 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timoteus 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Anden Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' ANDET BREV TIL TIMOTHEUS 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("PAULUS’ ANDET BREV TIL TIMOTHEUS 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ANDEN TIMOTHEUSBREV 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ANDET TIMOTHEUSBREV 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ANDEN TIMOTEUSBREV 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTHEUSBREV 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTHEUSBREV 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTEUSBREV 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTEUSBREV 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ANDEN TIMOTEUS 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTEUS 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTEUS 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ANDEN TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (da)", ->
		`
		expect(p.parse("Paulus' Første Brev til Timotheus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Paulus’ Første Brev til Timotheus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Paulus' 1. Brev til Timotheus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Paulus’ 1. Brev til Timotheus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Paulus' 1 Brev til Timotheus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Paulus’ 1 Brev til Timotheus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Første Timotheusbrev 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Første Timoteusbrev 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timotheusbrev 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timotheusbrev 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timoteusbrev 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Første Timoteus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timoteusbrev 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timoteus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timoteus 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Første Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' FØRSTE BREV TIL TIMOTHEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PAULUS’ FØRSTE BREV TIL TIMOTHEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PAULUS' 1. BREV TIL TIMOTHEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PAULUS’ 1. BREV TIL TIMOTHEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PAULUS' 1 BREV TIL TIMOTHEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PAULUS’ 1 BREV TIL TIMOTHEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("FØRSTE TIMOTHEUSBREV 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("FØRSTE TIMOTEUSBREV 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTHEUSBREV 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTHEUSBREV 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTEUSBREV 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("FØRSTE TIMOTEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTEUSBREV 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTEUS 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("FØRSTE TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (da)", ->
		`
		expect(p.parse("Paulus' Brev til Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Paulus’ Brev til Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titusbrevet 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tit 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' BREV TIL TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("PAULUS’ BREV TIL TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUSBREVET 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TIT 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (da)", ->
		`
		expect(p.parse("Paulus' Brev til Filemon 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Paulus’ Brev til Filemon 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filemonbrevet 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filemon 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Filem 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Flm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PAULUS' BREV TIL FILEMON 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PAULUS’ BREV TIL FILEMON 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILEMONBREVET 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILEMON 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FILEM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("FLM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (da)", ->
		`
		expect(p.parse("Brevet til Hebræerne 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hebræerbrevet 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hebræerne 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hebr 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("BREVET TIL HEBRÆERNE 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEBRÆERBREVET 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEBRÆERNE 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEBR 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (da)", ->
		`
		expect(p.parse("Jakobsbrevet 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jakobs Brev 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jakob 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jak 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JAKOBSBREVET 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAKOBS BREV 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAKOB 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAK 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (da)", ->
		`
		expect(p.parse("Peters Andet Brev 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Anden Petersbrev 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Andet Petersbrev 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Petersbrev 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Petersbrev 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Anden Peter 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Anden Pet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Peter 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Peter 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Pet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PETERS ANDET BREV 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ANDEN PETERSBREV 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ANDET PETERSBREV 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PETERSBREV 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETERSBREV 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ANDEN PETER 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ANDEN PET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PETER 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PETER 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (da)", ->
		`
		expect(p.parse("Peters Første Brev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Første Petersbrev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Peters 1. Brev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Petersbrev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Peters 1 Brev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Petersbrev 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Første Peter 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Første Pet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Peter 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Peter 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Pet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PETERS FØRSTE BREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("FØRSTE PETERSBREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PETERS 1. BREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PETERSBREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PETERS 1 BREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETERSBREV 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("FØRSTE PETER 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("FØRSTE PET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PETER 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PETER 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (da)", ->
		`
		expect(p.parse("Judas' Brev 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Judasbrevet 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Judas’ Brev 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Judas 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jud 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JUDAS' BREV 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDASBREVET 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDAS’ BREV 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDAS 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUD 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (da)", ->
		`
		expect(p.parse("Tobits Bog 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tobit 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (da)", ->
		`
		expect(p.parse("Judits Bog 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Judit 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (da)", ->
		`
		expect(p.parse("Baruks Bog 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Baruk 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (da)", ->
		`
		expect(p.parse("Susanna 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (da)", ->
		`
		expect(p.parse("Anden Makkabæerbog 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Makkabæerbog 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Makkabæerbog 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Anden Makk 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Makk 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Makk 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (da)", ->
		`
		expect(p.parse("Tredje Makkabæerbog 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Makkabæerbog 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Makkabæerbog 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Tredje Makk 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Makk 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Makk 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (da)", ->
		`
		expect(p.parse("Fjerde Makkabæerbog 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Makkabæerbog 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Makkabæerbog 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Fjerde Makk 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Makk 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Makk 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (da)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (da)", ->
		`
		expect(p.parse("Første Makkabæerbog 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Makkabæerbog 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Makkabæerbog 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Første Makk 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Makk 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Makk 1:1").osis()).toEqual("1Macc.1.1")
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
		expect(p.languages).toEqual ["da"]

	it "should handle ranges (da)", ->
		expect(p.parse("Titus 1:1 - 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1-2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 - 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (da)", ->
		expect(p.parse("Titus 1:1, kapitlerne 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAPITLERNE 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, kapitel 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAPITEL 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, kap. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAP. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, kap 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 KAP 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (da)", ->
		expect(p.parse("Exod 1:1 vers 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERS 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (da)", ->
		expect(p.parse("Exod 1:1 og 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 OG 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 jf 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 JF 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (da)", ->
		expect(p.parse("Ps 3 title, 4:2, 5:title").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 TITLE, 4:2, 5:TITLE").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (da)", ->
		expect(p.parse("Rev 3ff, 4:2ff").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 FF, 4:2 FF").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (da)", ->
		expect(p.parse("Lev 1 (BPH)").osis_and_translations()).toEqual [["Lev.1", "BPH"]]
		expect(p.parse("lev 1 bph").osis_and_translations()).toEqual [["Lev.1", "BPH"]]
		expect(p.parse("Lev 1 (DO33)").osis_and_translations()).toEqual [["Lev.1", "DO33"]]
		expect(p.parse("lev 1 do33").osis_and_translations()).toEqual [["Lev.1", "DO33"]]
		expect(p.parse("Lev 1 (DO92)").osis_and_translations()).toEqual [["Lev.1", "DO92"]]
		expect(p.parse("lev 1 do92").osis_and_translations()).toEqual [["Lev.1", "DO92"]]
	it "should handle book ranges (da)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("Første - Tredje  Joh").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (da)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
