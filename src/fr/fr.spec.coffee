bcv_parser = require("../../js/fr_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (fr)", ->
		`
		expect(p.parse("Genese 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Genèse 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Ge 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gn 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GENESE 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GENÈSE 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GE 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GN 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (fr)", ->
		`
		expect(p.parse("Exode 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exo 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Ex 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EXODE 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXO 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EX 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (fr)", ->
		`
		expect(p.parse("Bel et le Serpent 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel et le serpent 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel et le Dragon 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel et le dragon 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (fr)", ->
		`
		expect(p.parse("Levitique 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lévitique 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lév 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Le 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lv 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lé 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LEVITIQUE 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LÉVITIQUE 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LÉV 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LE 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LV 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LÉ 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (fr)", ->
		`
		expect(p.parse("Nombres 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Nomb 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Nom 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Nb 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Nm 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("No 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NOMBRES 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NOMB 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NOM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NB 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NO 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (fr)", ->
		`
		expect(p.parse("La Sagesse de Ben Sira 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sagesse de Ben Sira 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Ecclesiastique 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Ecclésiastique 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Siracide 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Si 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (fr)", ->
		`
		expect(p.parse("Sagesse de Salomon 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Sagesse 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Sg 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (fr)", ->
		`
		expect(p.parse("Lamentations de Jeremie 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lamentations de Jerémie 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lamentations de Jéremie 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lamentations de Jérémie 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lamentations 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("La 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lm 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LAMENTATIONS DE JEREMIE 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAMENTATIONS DE JERÉMIE 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAMENTATIONS DE JÉREMIE 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAMENTATIONS DE JÉRÉMIE 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAMENTATIONS 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LA 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LM 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (fr)", ->
		`
		expect(p.parse("Epitre de Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Epitre de Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Epitre de Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Epitre de Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Epître de Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Epître de Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Epître de Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Epître de Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épitre de Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épitre de Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épitre de Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épitre de Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épître de Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épître de Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épître de Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Épître de Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep. Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep. Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep. Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep. Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép. Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép. Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép. Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép. Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép Jeremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép Jerémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép Jéremie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép Jérémie 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep. Jer 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep. Jér 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép. Jer 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép. Jér 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep Jer 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ep Jér 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép Jer 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Ép Jér 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (fr)", ->
		`
		expect(p.parse("Apocalypse de Jean 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Apocalypse 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Apoc 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Apc 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Apo 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Ap 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("APOCALYPSE DE JEAN 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("APOCALYPSE 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("APOC 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("APC 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("APO 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("AP 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (fr)", ->
		`
		expect(p.parse("La Priere de Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("La Priere de Manassé 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("La Prière de Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("La Prière de Manassé 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Priere de Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Priere de Manassé 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Prière de Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Prière de Manassé 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Pr. Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Pr. Manassé 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Pr Manasse 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Pr Manassé 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Pr. Man 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Pr Man 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (fr)", ->
		`
		expect(p.parse("Deuteronome 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deutéronome 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deu 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Dt 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUTERONOME 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUTÉRONOME 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEU 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DT 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (fr)", ->
		`
		expect(p.parse("Josue 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josué 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Jos 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOSUE 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSUÉ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOS 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (fr)", ->
		`
		expect(p.parse("Juges 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Jug 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Jg 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JUGES 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JG 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (fr)", ->
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
describe "Localized book 1Esd (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (fr)", ->
		`
		expect(p.parse("Premieres Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Premières Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Premiere Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Premiers Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Première Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Premier Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1ere. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1ère. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1er. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1ere Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1re. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1ère Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1er Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1re Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I. Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("I Esdras 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esdr 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Esd 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1 Es 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (fr)", ->
		`
		expect(p.parse("Deuxiemes Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Deuxièmes Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Deuxieme Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Deuxième Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2eme. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2ème. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2de. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2eme Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2ème Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2d. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2de Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2e. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2. Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2d Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2e Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("II Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esdras 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esdr 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Esd 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2 Es 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (fr)", ->
		`
		expect(p.parse("Esaie 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Esaïe 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isaie 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isaïe 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ésaie 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ésaïe 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Esa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ésa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Es 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Is 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("És 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESAIE 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ESAÏE 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISAIE 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISAÏE 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ÉSAIE 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ÉSAÏE 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ESA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ÉSA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ES 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("IS 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ÉS 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (fr)", ->
		`
		expect(p.parse("Deuxiemes Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Deuxièmes Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Deuxieme Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Deuxième Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2eme. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2ème. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2de. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2eme Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2ème Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2d. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2de Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2e. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2d Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2e Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Samuel 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 Sa 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 S 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("DEUXIÈMES SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("DEUXIEME SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("DEUXIÈME SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2EME. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2ÈME. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2DE. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2EME SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2ÈME SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2D. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2DE SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2E. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2D SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2E SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("II SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUEL 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SA 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 S 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (fr)", ->
		`
		expect(p.parse("Premieres Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Premières Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Premiere Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Premiers Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Première Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Premier Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ere. Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ère. Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1er. Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ere Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1re. Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ère Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1er Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1re Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I. Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I Samuel 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 Sa 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 S 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("PREMIÈRES SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("PREMIERE SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("PREMIERS SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("PREMIÈRE SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("PREMIER SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ERE. SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ÈRE. SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ER. SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ERE SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1RE. SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ÈRE SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1ER SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1RE SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I. SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("I SAMUEL 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SA 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 S 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (fr)", ->
		`
		expect(p.parse("Deuxiemes Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Deuxièmes Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Deuxieme Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Deuxième Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2eme. Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2ème. Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2de. Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2eme Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2ème Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2d. Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2de Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2e. Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II. Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2d Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2e Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 Rois 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 R 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("DEUXIÈMES ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("DEUXIEME ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("DEUXIÈME ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2EME. ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2ÈME. ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2DE. ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2EME ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2ÈME ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2D. ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2DE ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2E. ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II. ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2D ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2E ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("II ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 ROIS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 R 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (fr)", ->
		`
		expect(p.parse("Premieres Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Premières Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Premiere Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Premiers Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Première Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Premier Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ere. Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ère. Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1er. Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ere Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1re. Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ère Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1er Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1re Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I. Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I Rois 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 R 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("PREMIÈRES ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("PREMIERE ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("PREMIERS ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("PREMIÈRE ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("PREMIER ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ERE. ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ÈRE. ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ER. ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ERE ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1RE. ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ÈRE ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1ER ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1RE ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I. ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("I ROIS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 R 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (fr)", ->
		`
		expect(p.parse("Deuxiemes Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Deuxièmes Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Deuxieme Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Deuxième Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2eme. Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2ème. Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2de. Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2eme Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2ème Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2d. Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2de Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2e. Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II. Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2d Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2e Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Chroniques 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Chron 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Chro 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Chr 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 Ch 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("DEUXIÈMES CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("DEUXIEME CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("DEUXIÈME CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2EME. CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2ÈME. CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2DE. CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2EME CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2ÈME CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2D. CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2DE CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2E. CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II. CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2D CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2E CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("II CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 CHRONIQUES 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 CHRON 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 CHRO 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 CHR 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 CH 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (fr)", ->
		`
		expect(p.parse("Premieres Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Premières Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Premiere Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Premiers Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Première Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Premier Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ere. Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ère. Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1er. Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ere Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1re. Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ère Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1er Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1re Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I. Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I Chroniques 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Chron 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Chro 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Chr 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 Ch 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("PREMIÈRES CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("PREMIERE CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("PREMIERS CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("PREMIÈRE CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("PREMIER CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ERE. CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ÈRE. CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ER. CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ERE CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1RE. CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ÈRE CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1ER CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1RE CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I. CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("I CHRONIQUES 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 CHRON 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 CHRO 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 CHR 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 CH 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (fr)", ->
		`
		expect(p.parse("Esdras 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Esdr 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Esd 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESDRAS 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ESDR 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ESD 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (fr)", ->
		`
		expect(p.parse("Nehemie 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Nehémie 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Néhemie 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Néhémie 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Néh 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Ne 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Né 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NEHEMIE 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEHÉMIE 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NÉHEMIE 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NÉHÉMIE 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NÉH 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NE 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NÉ 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (fr)", ->
		`
		expect(p.parse("Esther (Grec) 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Esther (grec) 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Esther Grec 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Esther grec 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Esther Gr 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Esther gr 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Esth Gr 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Esth gr 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (fr)", ->
		`
		expect(p.parse("Esther 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Est 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESTHER 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("EST 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (fr)", ->
		`
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Jb 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (fr)", ->
		`
		expect(p.parse("Psaumes 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Psaume 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Psau 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Psa 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PSAUMES 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PSAUME 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PSAU 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PSA 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (fr)", ->
		`
		expect(p.parse("La Priere d'Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("La Priere d'Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("La Priere d’Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("La Priere d’Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("La Prière d'Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("La Prière d'Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("La Prière d’Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("La Prière d’Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Priere d'Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Priere d'Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Priere d’Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Priere d’Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Prière d'Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Prière d'Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Prière d’Azariah 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Prière d’Azarias 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Pr. Azar 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Pr Azar 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (fr)", ->
		`
		expect(p.parse("Proverbes 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Pro 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prv 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Pr 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PROVERBES 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PRO 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PRV 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PR 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (fr)", ->
		`
		expect(p.parse("Ecclesiaste 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Ecclésiaste 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Qoheleth 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Qohelet 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccles 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Ecclés 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Ec 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ECCLESIASTE 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCLÉSIASTE 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("QOHELETH 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("QOHELET 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCLES 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCLÉS 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("EC 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (fr)", ->
		`
		expect(p.parse("Cantique des Trois Enfants 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Cantique des 3 Enfants 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Ct 3 E 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (fr)", ->
		`
		expect(p.parse("Cantique des Cantiques 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Cantique des cantiques 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Cantiques 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Cantique 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Cnt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ca 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ct 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("CANTIQUE DES CANTIQUES 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CANTIQUE DES CANTIQUES 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CANTIQUES 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CANTIQUE 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CNT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CA 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("CT 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (fr)", ->
		`
		expect(p.parse("Jeremie 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jerémie 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jéremie 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jérémie 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jerem 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jerém 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jérem 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jérém 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jér 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Je 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jr 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jé 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JEREMIE 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JERÉMIE 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JÉREMIE 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JÉRÉMIE 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JEREM 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JERÉM 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JÉREM 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JÉRÉM 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JÉR 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JE 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JR 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JÉ 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (fr)", ->
		`
		expect(p.parse("Ezechiel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezéchiel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ézechiel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ézéchiel 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezech 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezéch 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ézech 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ézéch 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Eze 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezé 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ez 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EZECHIEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZÉCHIEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ÉZECHIEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ÉZÉCHIEL 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZECH 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZÉCH 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ÉZECH 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ÉZÉCH 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZE 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZÉ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZ 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (fr)", ->
		`
		expect(p.parse("Daniel 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Da 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dn 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DANIEL 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DA 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (fr)", ->
		`
		expect(p.parse("Osee 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Osée 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Os 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("OSEE 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("OSÉE 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("OS 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (fr)", ->
		`
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joël 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joe 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joë 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Jl 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOËL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOE 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOË 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JL 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (fr)", ->
		`
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amo 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Am 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMO 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AM 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (fr)", ->
		`
		expect(p.parse("Abdias 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Abd 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Ab 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ABDIAS 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ABD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("AB 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (fr)", ->
		`
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonas 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jon 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAS 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JON 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (fr)", ->
		`
		expect(p.parse("Michee 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Michée 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mich 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mi 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MICHEE 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MICHÉE 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MICH 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MI 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (fr)", ->
		`
		expect(p.parse("Nahoum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nahum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Na 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHOUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAHUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NA 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (fr)", ->
		`
		expect(p.parse("Habacuc 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Habakuk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Habaquq 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Habac 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Habak 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Ha 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HABACUC 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAKUK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAQUQ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAC 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HA 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (fr)", ->
		`
		expect(p.parse("Sophonie 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Soph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("So 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SOPHONIE 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SOPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SO 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (fr)", ->
		`
		expect(p.parse("Aggee 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Aggée 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Agg 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Ag 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AGGEE 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("AGGÉE 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("AGG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("AG 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (fr)", ->
		`
		expect(p.parse("Zaccharie 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zacharie 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zacch 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zacc 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zach 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zac 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zah 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Za 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zc 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ZACCHARIE 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZACHARIE 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZACCH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZACC 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZACH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZAC 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZAH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZC 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (fr)", ->
		`
		expect(p.parse("Malachie 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Malach 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Malac 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Malch 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Malc 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Ml 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MALACHIE 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALACH 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALAC 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALCH 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALC 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("ML 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (fr)", ->
		`
		expect(p.parse("Matthieu 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matth 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Mat 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Mt 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MATTHIEU 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTH 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MAT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MT 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (fr)", ->
		`
		expect(p.parse("Marc 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mar 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mc 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mr 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MARC 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MAR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MC 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MR 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (fr)", ->
		`
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luc 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lc 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Lu 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUC 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LC 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LU 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (fr)", ->
		`
		expect(p.parse("Premieres Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Premières Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Premiere Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Premiers Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Première Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Premier Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ere. Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ère. Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1er. Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ere Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1re. Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ère Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1er Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1re Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I. Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I Jean 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 Jn 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("PREMIÈRES JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("PREMIERE JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("PREMIERS JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("PREMIÈRE JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("PREMIER JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ERE. JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ÈRE. JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ER. JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ERE JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1RE. JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ÈRE JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1ER JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1RE JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I. JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("I JEAN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 JN 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (fr)", ->
		`
		expect(p.parse("Deuxiemes Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Deuxièmes Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Deuxieme Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Deuxième Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2eme. Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2ème. Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2de. Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2eme Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2ème Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2d. Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2de Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2e. Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II. Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2d Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2e Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Jean 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 Jn 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("DEUXIÈMES JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("DEUXIEME JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("DEUXIÈME JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2EME. JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2ÈME. JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2DE. JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2EME JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2ÈME JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2D. JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2DE JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2E. JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II. JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2D JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2E JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("II JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JEAN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 JN 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (fr)", ->
		`
		expect(p.parse("Troisiemes Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Troisièmes Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Troisieme Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Troisième Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3eme. Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3ème. Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3eme Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3ème Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III. Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3e. Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3e Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Jean 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 Jn 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TROISIEMES JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TROISIÈMES JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TROISIEME JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("TROISIÈME JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3EME. JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3ÈME. JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3EME JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3ÈME JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III. JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3E. JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("III JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3E JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JEAN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 JN 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (fr)", ->
		`
		expect(p.parse("Jean 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Jn 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JEAN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JN 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (fr)", ->
		`
		expect(p.parse("Actes des Apotres 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Actes des Apôtres 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Actes 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Act 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Ac 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ACTES DES APOTRES 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTES DES APÔTRES 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTES 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACT 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("AC 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (fr)", ->
		`
		expect(p.parse("Romains 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rm 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Ro 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ROMAINS 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("RM 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("RO 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (fr)", ->
		`
		expect(p.parse("Deuxiemes Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Deuxièmes Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Deuxieme Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Deuxième Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2eme. Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2ème. Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2de. Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2eme Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2ème Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2d. Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2de Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2e. Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II. Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2d Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2e Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Corinthiens 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Cor 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 Co 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("DEUXIÈMES CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("DEUXIEME CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("DEUXIÈME CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2EME. CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2ÈME. CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2DE. CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2EME CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2ÈME CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2D. CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2DE CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2E. CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II. CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2D CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2E CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("II CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 CORINTHIENS 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 COR 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 CO 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (fr)", ->
		`
		expect(p.parse("Premieres Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Premières Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Premiere Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Premiers Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Première Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Premier Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ere. Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ère. Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1er. Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ere Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1re. Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ère Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1er Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1re Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I. Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I Corinthiens 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Cor 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 Co 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PREMIÈRES CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PREMIERE CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PREMIERS CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PREMIÈRE CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("PREMIER CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ERE. CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ÈRE. CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ER. CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ERE CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1RE. CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ÈRE CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1ER CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1RE CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I. CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("I CORINTHIENS 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 COR 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 CO 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (fr)", ->
		`
		expect(p.parse("Galates 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Ga 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gl 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GALATES 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GL 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (fr)", ->
		`
		expect(p.parse("Ephesiens 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ephésiens 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Éphesiens 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Éphésiens 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ephes 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ephés 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Éphes 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Éphés 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ephe 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ephé 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Éphe 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Éphé 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Éph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ep 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Ép 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("EPHESIENS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPHÉSIENS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉPHESIENS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉPHÉSIENS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPHES 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPHÉS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉPHES 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉPHÉS 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPHE 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPHÉ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉPHE 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉPHÉ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EP 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ÉP 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (fr)", ->
		`
		expect(p.parse("Philippiens 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Ph 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PHILIPPIENS 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PH 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (fr)", ->
		`
		expect(p.parse("Colossiens 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("COLOSSIENS 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (fr)", ->
		`
		expect(p.parse("Deuxiemes Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Deuxièmes Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Deuxieme Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Deuxiemes Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Deuxième Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Deuxièmes Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Deuxieme Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Deuxième Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2eme. Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ème. Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2de. Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2eme Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2eme. Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ème Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ème. Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2d. Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2de Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2de. Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2e. Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2eme Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ème Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II. Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2d Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2d. Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2de Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2e Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2e. Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II. Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thessaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2d Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2e Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thesaloniciens 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Thes 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 Th 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("DEUXIÈMES THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("DEUXIEME THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("DEUXIEMES THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("DEUXIÈME THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("DEUXIÈMES THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("DEUXIEME THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("DEUXIÈME THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2EME. THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ÈME. THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2DE. THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2EME THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2EME. THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ÈME THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ÈME. THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2D. THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2DE THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2DE. THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2E. THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2EME THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2ÈME THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II. THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2D THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2D. THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2DE THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2E THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2E. THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II. THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESSALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2D THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2E THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("II THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESALONICIENS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 THES 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TH 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (fr)", ->
		`
		expect(p.parse("Premieres Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premières Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premiere Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premieres Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premiers Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Première Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premières Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premier Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premiere Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premiers Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Première Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Premier Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ere. Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ère. Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1er. Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ere Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ere. Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1re. Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ère Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ère. Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1er Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1er. Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ere Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1re Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1re. Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ère Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1er Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1re Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I. Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I Thessaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I. Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I Thesaloniciens 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Thes 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 Th 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIÈRES THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIERE THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIERES THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIERS THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIÈRE THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIÈRES THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIER THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIERE THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIERS THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIÈRE THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("PREMIER THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ERE. THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ÈRE. THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ER. THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ERE THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ERE. THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1RE. THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ÈRE THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ÈRE. THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ER THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ER. THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ERE THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1RE THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1RE. THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ÈRE THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1ER THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1RE THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I. THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I THESSALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I. THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("I THESALONICIENS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 THES 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TH 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (fr)", ->
		`
		expect(p.parse("Deuxiemes Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Deuxiemes Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Deuxièmes Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Deuxièmes Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Deuxieme Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Deuxieme Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Deuxième Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Deuxième Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2eme. Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2eme. Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ème. Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ème. Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2de. Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2de. Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2eme Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2eme Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ème Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ème Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2d. Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2d. Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2de Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2de Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2e. Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2e. Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II. Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II. Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2d Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2d Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2e Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2e Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timothee 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Timothée 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Tim 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Ti 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 Tm 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("DEUXIEMES TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("DEUXIÈMES TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("DEUXIÈMES TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("DEUXIEME TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("DEUXIEME TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("DEUXIÈME TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("DEUXIÈME TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2EME. TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2EME. TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ÈME. TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ÈME. TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2DE. TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2DE. TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2EME TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2EME TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ÈME TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2ÈME TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2D. TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2D. TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2DE TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2DE TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2E. TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2E. TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II. TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II. TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2D TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2D TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2E TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2E TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("II TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTHEE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTHÉE 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TM 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (fr)", ->
		`
		expect(p.parse("Premieres Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premieres Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premières Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premières Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premiere Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premiere Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premiers Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premiers Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Première Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Première Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premier Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Premier Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ere. Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ere. Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ère. Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ère. Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1er. Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1er. Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ere Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ere Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1re. Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1re. Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ère Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ère Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1er Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1er Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1re Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1re Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I. Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I. Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I Timothee 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I Timothée 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Tim 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Ti 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 Tm 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIERES TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIÈRES TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIÈRES TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIERE TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIERE TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIERS TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIERS TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIÈRE TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIÈRE TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIER TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("PREMIER TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ERE. TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ERE. TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ÈRE. TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ÈRE. TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ER. TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ER. TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ERE TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ERE TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1RE. TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1RE. TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ÈRE TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ÈRE TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ER TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1ER TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1RE TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1RE TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I. TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I. TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I TIMOTHEE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("I TIMOTHÉE 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TM 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (fr)", ->
		`
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tite 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tit 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Tt 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITE 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TIT 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TT 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (fr)", ->
		`
		expect(p.parse("Philemon 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Philémon 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PHILEMON 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHILÉMON 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (fr)", ->
		`
		expect(p.parse("Hebreux 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hébreux 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hebr 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hébr 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Héb 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("He 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Hé 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HEBREUX 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HÉBREUX 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEBR 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HÉBR 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HÉB 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HE 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HÉ 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (fr)", ->
		`
		expect(p.parse("Jacques 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jaques 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jacq 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jac 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Ja 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jc 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JACQUES 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAQUES 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JACQ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAC 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JC 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (fr)", ->
		`
		expect(p.parse("Deuxiemes Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Deuxièmes Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Deuxieme Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Deuxième Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2eme. Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2ème. Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2de. Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2eme Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2ème Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2d. Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2de Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2e. Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II. Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2d Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2e Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pierre 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 Pi 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 P 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DEUXIEMES PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("DEUXIÈMES PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("DEUXIEME PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("DEUXIÈME PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2EME. PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2ÈME. PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2DE. PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2EME PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2ÈME PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2D. PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2DE PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2E. PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II. PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2D PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2E PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("II PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PIERRE 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PI 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 P 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (fr)", ->
		`
		expect(p.parse("Premieres Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Premières Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Premiere Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Premiers Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Première Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Premier Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ere. Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ère. Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1er. Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ere Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1re. Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ère Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1er Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1re Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I. Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I Pierre 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 Pi 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 P 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PREMIERES PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PREMIÈRES PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PREMIERE PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PREMIERS PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PREMIÈRE PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("PREMIER PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ERE. PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ÈRE. PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ER. PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ERE PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1RE. PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ÈRE PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1ER PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1RE PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I. PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("I PIERRE 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PI 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 P 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (fr)", ->
		`
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jud 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jd 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUD 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JD 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (fr)", ->
		`
		expect(p.parse("Tobie 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tb 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (fr)", ->
		`
		expect(p.parse("Judith 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (fr)", ->
		`
		expect(p.parse("Baruch 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Ba 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (fr)", ->
		`
		expect(p.parse("Susanne et les deux vieillards 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Suzanne et les deux vieillards 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Susanne et les vieillards 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Suzanne et les vieillards 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Susanne au bain 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Suzanne au bain 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Susanne 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Suzanne 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Suz 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (fr)", ->
		`
		expect(p.parse("Deuxiemes Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Deuxiemes Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Deuxièmes Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Deuxièmes Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Deuxieme Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Deuxieme Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Deuxième Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Deuxième Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2eme. Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2eme. Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2ème. Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2ème. Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2de. Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2de. Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2eme Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2eme Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2ème Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2ème Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2d. Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2d. Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2de Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2de Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2e. Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2e. Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("II. Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("II. Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2. Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2d Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2d Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2e Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2e Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("II Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("II Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Maccabees 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Maccabées 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 Macc 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2 M 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (fr)", ->
		`
		expect(p.parse("Troisiemes Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Troisiemes Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Troisièmes Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Troisièmes Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Troisieme Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Troisieme Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Troisième Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Troisième Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3eme. Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3eme. Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3ème. Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3ème. Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3eme Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3eme Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3ème Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3ème Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("III. Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("III. Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e. Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e. Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("III Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("III Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3. Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3e Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Maccabees 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Maccabées 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 Macc 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3 M 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (fr)", ->
		`
		expect(p.parse("Quatriemes Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quatriemes Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quatrièmes Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quatrièmes Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quatrieme Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quatrieme Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quatrième Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Quatrième Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4eme. Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4eme. Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4ème. Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4ème. Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4eme Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4eme Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4ème Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4ème Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4e. Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4e. Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("IV. Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("IV. Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4. Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4e Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4e Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("IV Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("IV Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Maccabees 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Maccabées 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 Macc 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4 M 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (fr)", ->
		`
		expect(p.parse("Premieres Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premieres Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premières Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premières Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premiere Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premiere Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premiers Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premiers Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Première Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Première Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premier Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Premier Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ere. Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ere. Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ère. Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ère. Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1er. Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1er. Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ere Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ere Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1re. Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1re. Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ère Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1ère Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1er Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1er Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1re Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1re Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1. Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("I. Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("I. Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("I Maccabees 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("I Maccabées 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 Macc 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1Macc 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("1 M 1:1").osis()).toEqual("1Macc.1.1")
		`
		true
describe "Localized book Jonah,Job,Josh,Joel (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah,Job,Josh,Joel (fr)", ->
		`
		expect(p.parse("Jo 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JO 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Judg,Jude (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg,Jude (fr)", ->
		`
		expect(p.parse("Ju 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JU 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Phil,Phlm (fr)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil,Phlm (fr)", ->
		`
		expect(p.parse("Phl 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Ph 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PHL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PH 1:1").osis()).toEqual("Phil.1.1")
		`
		true

describe "Miscellaneous tests", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore", book_sequence_strategy: "ignore", osis_compaction_strategy: "bc", captive_end_digits_strategy: "delete"
		p.include_apocrypha true

	it "should return the expected language", ->
		expect(p.languages).toEqual ["fr"]

	it "should handle ranges (fr)", ->
		expect(p.parse("Titus 1:1 á 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1á2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 Á 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (fr)", ->
		expect(p.parse("Titus 1:1, chapitres 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHAPITRES 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, chapitre 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHAPITRE 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, chap. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHAP. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, chap 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHAP 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, chs. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHS. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, chs 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHS 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, ch. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CH. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, ch 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CH 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (fr)", ->
		expect(p.parse("Exod 1:1 versets 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSETS 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 verset 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSET 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 vers. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERS. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 vers 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERS 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 ver. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VER. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 ver 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VER 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 vv. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VV. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 vv 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VV 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v. 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V. 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 v 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm V 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (fr)", ->
		expect(p.parse("Exod 1:1 et 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 ET 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
		expect(p.parse("Exod 1:1 comparer 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 COMPARER 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (fr)", ->
		expect(p.parse("Ps 3 titre, 4:2, 5:titre").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 TITRE, 4:2, 5:TITRE").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (fr)", ->
		expect(p.parse("Rev 3et suivant, 4:2et suivant").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 ET SUIVANT, 4:2 ET SUIVANT").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (fr)", ->
		expect(p.parse("Lev 1 (BDS)").osis_and_translations()).toEqual [["Lev.1", "BDS"]]
		expect(p.parse("lev 1 bds").osis_and_translations()).toEqual [["Lev.1", "BDS"]]
		expect(p.parse("Lev 1 (LSG)").osis_and_translations()).toEqual [["Lev.1", "LSG"]]
		expect(p.parse("lev 1 lsg").osis_and_translations()).toEqual [["Lev.1", "LSG"]]
		expect(p.parse("Lev 1 (LSG21)").osis_and_translations()).toEqual [["Lev.1", "LSG21"]]
		expect(p.parse("lev 1 lsg21").osis_and_translations()).toEqual [["Lev.1", "LSG21"]]
		expect(p.parse("Lev 1 (NEG1979)").osis_and_translations()).toEqual [["Lev.1", "NEG1979"]]
		expect(p.parse("lev 1 neg1979").osis_and_translations()).toEqual [["Lev.1", "NEG1979"]]
	it "should handle book ranges (fr)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("Premières á Troisièmes  Jean").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (fr)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
