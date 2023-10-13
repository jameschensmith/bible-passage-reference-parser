bcv_parser = require("../../js/el_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (el)", ->
		`
		expect(p.parse("Γένεσις 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Γενεσις 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Γένεση 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Γενεση 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Γέν 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Γεν 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Γε 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΓΈΝΕΣΙΣ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("ΓΕΝΕΣΙΣ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("ΓΈΝΕΣΗ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("ΓΕΝΕΣΗ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("ΓΈΝ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("ΓΕΝ 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("ΓΕ 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (el)", ->
		`
		expect(p.parse("Έξοδος 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Εξοδος 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Εξ 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Ἔξ 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΈΞΟΔΟΣ 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ΕΞΟΔΟΣ 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ΕΞ 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("ἜΞ 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (el)", ->
		`
		expect(p.parse("Βηλ και Δράκων 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Βηλ και Δρακων 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Βηλ 1:1").osis()).toEqual("Bel.1.1")
		expect(p.parse("Βὴλ 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (el)", ->
		`
		expect(p.parse("Λευιτικον 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευιτικόν 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευϊτικον 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευϊτικόν 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευιτικο 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευιτικό 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευϊτικο 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευϊτικό 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευιτ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευϊτ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λευ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Λε 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΛΕΥΙΤΙΚΟΝ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΙΤΙΚΌΝ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΪΤΙΚΟΝ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΪΤΙΚΌΝ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΙΤΙΚΟ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΙΤΙΚΌ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΪΤΙΚΟ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΪΤΙΚΌ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΙΤ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥΪΤ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕΥ 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("ΛΕ 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (el)", ->
		`
		expect(p.parse("Αριθμοί 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Αριθμοι 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Αριθ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Αρ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Ἀρ 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΑΡΙΘΜΟΊ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("ΑΡΙΘΜΟΙ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("ΑΡΙΘ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("ΑΡ 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("ἈΡ 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (el)", ->
		`
		expect(p.parse("Σοφία Σειράχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Σοφία Σειραχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Σοφια Σειράχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Σοφια Σειραχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Σοφία Σιραχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Σοφια Σιραχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Σειράχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Σειραχ 1:1").osis()).toEqual("Sir.1.1")
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (el)", ->
		`
		expect(p.parse("Σοφία Σαλωμωντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφία Σαλωμώντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφία Σολομωντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφία Σολομώντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφια Σαλωμωντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφια Σαλωμώντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφια Σολομωντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφια Σολομώντος 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφία Σολ 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφια Σολ 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφία 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφια 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		expect(p.parse("Σοφ 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (el)", ->
		`
		expect(p.parse("Θρήνοι Ιερεμίου 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Θρήνοι Ιερεμιου 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Θρηνοι Ιερεμίου 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Θρηνοι Ιερεμιου 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Θρήνοι 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Θρηνοι 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Θρ 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΘΡΉΝΟΙ ΙΕΡΕΜΊΟΥ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("ΘΡΉΝΟΙ ΙΕΡΕΜΙΟΥ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("ΘΡΗΝΟΙ ΙΕΡΕΜΊΟΥ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("ΘΡΗΝΟΙ ΙΕΡΕΜΙΟΥ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("ΘΡΉΝΟΙ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("ΘΡΗΝΟΙ 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("ΘΡ 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (el)", ->
		`
		expect(p.parse("Επιστολή Ιερεμίου 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Επιστολή Ιερεμιου 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Επιστολη Ιερεμίου 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Επιστολη Ιερεμιου 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Επιστολη ᾿Ιερ 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("Επιστολὴ ᾿Ιερ 1:1").osis()).toEqual("EpJer.1.1")
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (el)", ->
		`
		expect(p.parse("Αποκάλυψις Ιωάννου 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκάλυψις Ιωαννου 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκαλυψις Ιωάννου 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκαλυψις Ιωαννου 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκαλυψεις 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκαλύψεις 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκάλυψη 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκαλυψη 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Αποκ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("᾿Απ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Απ 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΑΠΟΚΆΛΥΨΙΣ ΙΩΆΝΝΟΥ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚΆΛΥΨΙΣ ΙΩΑΝΝΟΥ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚΑΛΥΨΙΣ ΙΩΆΝΝΟΥ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚΑΛΥΨΙΣ ΙΩΑΝΝΟΥ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚΑΛΥΨΕΙΣ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚΑΛΎΨΕΙΣ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚΆΛΥΨΗ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚΑΛΥΨΗ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠΟΚ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("᾿ΑΠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("ΑΠ 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (el)", ->
		`
		expect(p.parse("Προσευχή Μανασσή 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Προσευχή Μανασση 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Προσευχη Μανασσή 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Προσευχη Μανασση 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("Πρ Μαν 1:1").osis()).toEqual("PrMan.1.1")
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (el)", ->
		`
		expect(p.parse("Δευτερονομιον 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Δευτερονόμιον 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Δευτερονομιο 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Δευτερονόμιο 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Δευτερ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Δευτ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Δε 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΕΥΤΕΡΟΝΟΜΙΟΝ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ΔΕΥΤΕΡΟΝΌΜΙΟΝ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ΔΕΥΤΕΡΟΝΟΜΙΟ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ΔΕΥΤΕΡΟΝΌΜΙΟ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ΔΕΥΤΕΡ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ΔΕΥΤ 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("ΔΕ 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (el)", ->
		`
		expect(p.parse("Ιησους του Ναυή 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ιησους του Ναυη 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ιησούς του Ναυή 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ιησούς του Ναυη 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ιησ Ναυή 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ιησ Ναυη 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ιησ Ναυ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ιη 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Ἰη 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΗΣΟΥΣ ΤΟΥ ΝΑΥΉ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ΙΗΣΟΥΣ ΤΟΥ ΝΑΥΗ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ΙΗΣΟΎΣ ΤΟΥ ΝΑΥΉ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ΙΗΣΟΎΣ ΤΟΥ ΝΑΥΗ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ΙΗΣ ΝΑΥΉ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ΙΗΣ ΝΑΥΗ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ΙΗΣ ΝΑΥ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ΙΗ 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("ἸΗ 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (el)", ->
		`
		expect(p.parse("Κριτές 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Κριταί 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Κριται 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Κριτες 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Κριτ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Κρ 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΚΡΙΤΈΣ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ΚΡΙΤΑΊ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ΚΡΙΤΑΙ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ΚΡΙΤΕΣ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ΚΡΙΤ 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("ΚΡ 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (el)", ->
		`
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Ρουθ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("῾Ρθ 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("ΡΟΥΘ 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("῾ΡΘ 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (el)", ->
		`
		expect(p.parse("Έσδρας Α' 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Έσδρας Αʹ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Έσδρας Αʹ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Έσδρας Α΄ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Έσδρας Α’ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α' Έσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α' Εσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Έσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Εσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Έσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Εσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α΄ Έσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α΄ Εσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α’ Έσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α’ Εσδρας 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Εσδρας Α' 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Εσδρας Αʹ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Εσδρας Αʹ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Εσδρας Α΄ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Εσδρας Α’ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α' Έσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α' Εσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Έσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Εσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Έσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Εσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α΄ Έσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α΄ Εσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α’ Έσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α’ Εσδρ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α' Έσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α' Εσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Έσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Εσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Έσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Αʹ Εσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α΄ Έσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α΄ Εσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α’ Έσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("Α’ Εσδ 1:1").osis()).toEqual("1Esd.1.1")
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (el)", ->
		`
		expect(p.parse("Έσδρας Β' 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Έσδρας Βʹ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Έσδρας Βʹ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Έσδρας Β΄ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Έσδρας Β’ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β' Έσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β' Εσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Έσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Εσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Έσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Εσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β΄ Έσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β΄ Εσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β’ Έσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β’ Εσδρας 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Εσδρας Β' 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Εσδρας Βʹ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Εσδρας Βʹ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Εσδρας Β΄ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Εσδρας Β’ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β' Έσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β' Εσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Έσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Εσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Έσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Εσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β΄ Έσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β΄ Εσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β’ Έσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β’ Εσδρ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β' Έσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β' Εσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Έσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Εσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Έσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Βʹ Εσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β΄ Έσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β΄ Εσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β’ Έσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("Β’ Εσδ 1:1").osis()).toEqual("2Esd.1.1")
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (el)", ->
		`
		expect(p.parse("ΗΣΑΊΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΪ́ΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΊΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΙΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ησαΐας 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ησαιας 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ησ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Ἠσ 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΗΣΑΊΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΪ́ΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΊΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΙΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΪ́ΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣΑΙΑΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ΗΣ 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ἨΣ 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (el)", ->
		`
		expect(p.parse("δυτικος Σαμουήλ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειων Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειων Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειων Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειων Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειων Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειών Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειών Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειών Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειών Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βασιλειών Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β' Σαμουήλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β' Σαμουηλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ Σαμουήλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ Σαμουηλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ Σαμουήλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ Σαμουηλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β΄ Σαμουήλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β΄ Σαμουηλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β’ Σαμουήλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β’ Σαμουηλ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β' Σαμ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ Σαμ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ Σαμ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β΄ Σαμ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β’ Σαμ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Β' 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Βʹ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Β΄ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Β’ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β' ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β' ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β΄ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β΄ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β’ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β’ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β' ΣΑΜ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ ΣΑΜ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Βʹ ΣΑΜ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β΄ ΣΑΜ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("Β’ ΣΑΜ 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (el)", ->
		`
		expect(p.parse("δυτικος Σαμουήλ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουήλ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικος Σαμουηλ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουήλ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("δυτικός Σαμουηλ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειων Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειων Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειων Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειων Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειων Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειών Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειών Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειών Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειών Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Βασιλειών Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α' Σαμουήλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α' Σαμουηλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ Σαμουήλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ Σαμουηλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ Σαμουήλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ Σαμουηλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α΄ Σαμουήλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α΄ Σαμουηλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α’ Σαμουήλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α’ Σαμουηλ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α' Σαμ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ Σαμ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ Σαμ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α΄ Σαμ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α’ Σαμ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΉΛ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΣΑΜΟΥΗΛ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΉΛ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΣΑΜΟΥΗΛ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Α' 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Αʹ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Α΄ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Α’ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α' ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α' ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α΄ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α΄ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α’ ΣΑΜΟΥΉΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α’ ΣΑΜΟΥΗΛ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α' ΣΑΜ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ ΣΑΜ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Αʹ ΣΑΜ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α΄ ΣΑΜ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("Α’ ΣΑΜ 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (el)", ->
		`
		expect(p.parse("δυτικος Βασιλέων Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειων Δ' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειων Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειων Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειων Δ΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειων Δ’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειών Δ' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειών Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειών Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειών Δ΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βασιλειών Δ’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' Βασιλέων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' Βασιλεων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βασιλέων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βασιλεων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βασιλέων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βασιλεων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ Βασιλέων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ Βασιλεων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ Βασιλέων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ Βασιλεων 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' Βασ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βασ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βασ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ Βασ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ Βασ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' Βα 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βα 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ Βα 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ Βα 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ Βα 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Β' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Βʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Β΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Β’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Δ' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Δ΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Δ’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Δ' 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Δʹ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Δ΄ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Δ’ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' ΒΑΣ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑΣ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑΣ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ ΒΑΣ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ ΒΑΣ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β' ΒΑ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Βʹ ΒΑ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β΄ ΒΑ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("Β’ ΒΑ 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (el)", ->
		`
		expect(p.parse("δυτικος Βασιλέων Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλέων Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικος Βασιλεων Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλέων Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("δυτικός Βασιλεων Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειων Γ' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειων Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειων Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειων Γ΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειων Γ’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειών Γ' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειών Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειών Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειών Γ΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Βασιλειών Γ’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' Βασιλέων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' Βασιλεων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βασιλέων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βασιλεων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βασιλέων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βασιλεων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ Βασιλέων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ Βασιλεων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ Βασιλέων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ Βασιλεων 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' Βασ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βασ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βασ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ Βασ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ Βασ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' Βα 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βα 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ Βα 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ Βα 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ Βα 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΈΩΝ Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΒΑΣΙΛΕΩΝ Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΈΩΝ Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Α' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Αʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Α΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΒΑΣΙΛΕΩΝ Α’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Γ' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Γ΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΩΝ Γ’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Γ' 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Γʹ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Γ΄ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("ΒΑΣΙΛΕΙΏΝ Γ’ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ ΒΑΣΙΛΈΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ ΒΑΣΙΛΕΩΝ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' ΒΑΣ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑΣ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑΣ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ ΒΑΣ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ ΒΑΣ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α' ΒΑ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Αʹ ΒΑ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α΄ ΒΑ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("Α’ ΒΑ 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (el)", ->
		`
		expect(p.parse("δυτικος Χρονικων Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομένων Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομένων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομένων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομένων Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομένων Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομενων Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομενων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομενων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομενων Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Παραλειπομενων Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' Χρονικων 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' Χρονικών 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρονικων 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρονικών 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρονικων 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρονικών 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ Χρονικων 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ Χρονικών 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ Χρονικων 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ Χρονικών 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικων Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικων Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικων Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικων Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικών Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικών Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικών Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικών Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Χρονικών Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' Χρον 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρον 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρον 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ Χρον 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ Χρον 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' Παρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Παρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Παρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ Παρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ Παρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' Πα 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' Χρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Πα 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Πα 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ Χρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ Πα 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ Χρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ Πα 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ Χρ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Β' 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Βʹ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Β΄ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Β’ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' ΧΡΟΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡΟΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡΟΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ ΧΡΟΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ ΧΡΟΝ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' ΠΑΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΠΑΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΠΑΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ ΠΑΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ ΠΑΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' ΠΑ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β' ΧΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΠΑ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΠΑ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Βʹ ΧΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ ΠΑ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β΄ ΧΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ ΠΑ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("Β’ ΧΡ 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (el)", ->
		`
		expect(p.parse("δυτικος Χρονικων Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικων Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικος Χρονικών Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικων Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("δυτικός Χρονικών Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομένων Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομένων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομένων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομένων Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομένων Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομενων Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομενων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομενων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομενων Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Παραλειπομενων Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' Χρονικων 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' Χρονικών 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρονικων 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρονικών 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρονικων 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρονικών 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ Χρονικων 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ Χρονικών 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ Χρονικων 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ Χρονικών 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικων Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικων Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικων Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικων Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικών Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικών Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικών Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικών Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Χρονικών Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' Χρον 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρον 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρον 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ Χρον 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ Χρον 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' Παρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Παρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Παρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ Παρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ Παρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' Πα 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' Χρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Πα 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Πα 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ Χρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ Πα 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ Χρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ Πα 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ Χρ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΩΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΟΣ ΧΡΟΝΙΚΏΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΩΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΔΥΤΙΚΌΣ ΧΡΟΝΙΚΏΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΈΝΩΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΠΑΡΑΛΕΙΠΟΜΕΝΩΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ ΧΡΟΝΙΚΩΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ ΧΡΟΝΙΚΏΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΩΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Α' 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Αʹ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Α΄ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ΧΡΟΝΙΚΏΝ Α’ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' ΧΡΟΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡΟΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡΟΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ ΧΡΟΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ ΧΡΟΝ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' ΠΑΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΠΑΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΠΑΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ ΠΑΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ ΠΑΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' ΠΑ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α' ΧΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΠΑ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΠΑ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Αʹ ΧΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ ΠΑ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α΄ ΧΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ ΠΑ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("Α’ ΧΡ 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (el)", ->
		`
		expect(p.parse("Έσδρας 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Εσδρας 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Εσ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ἔσ 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΈΣΔΡΑΣ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ΕΣΔΡΑΣ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ΕΣ 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("ἜΣ 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (el)", ->
		`
		expect(p.parse("Νεεμίας 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Νεεμιας 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Νε 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΝΕΕΜΊΑΣ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("ΝΕΕΜΙΑΣ 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("ΝΕ 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (el)", ->
		`
		expect(p.parse("Εσθήρ στα ελληνικά 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Εσθήρ στα ελληνικα 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Εσθηρ στα ελληνικά 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("Εσθηρ στα ελληνικα 1:1").osis()).toEqual("GkEsth.1.1")
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (el)", ->
		`
		expect(p.parse("Εσθήρ 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Εσθηρ 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Εσθ 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΕΣΘΉΡ 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ΕΣΘΗΡ 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ΕΣΘ 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (el)", ->
		`
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Ιωβ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Ιώβ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Ιβ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Ἰβ 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ΙΩΒ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ΙΏΒ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ΙΒ 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ἸΒ 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (el)", ->
		`
		expect(p.parse("Ψαλμοί του Δαυίδ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψαλμοί του Δαυιδ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψαλμοι του Δαυίδ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψαλμοι του Δαυιδ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψαλμοί 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψαλμοι 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψαλμος 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψαλμός 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ψα 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΨΑΛΜΟΊ ΤΟΥ ΔΑΥΊΔ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑΛΜΟΊ ΤΟΥ ΔΑΥΙΔ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑΛΜΟΙ ΤΟΥ ΔΑΥΊΔ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑΛΜΟΙ ΤΟΥ ΔΑΥΙΔ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑΛΜΟΊ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑΛΜΟΙ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑΛΜΟΣ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑΛΜΌΣ 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("ΨΑ 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (el)", ->
		`
		expect(p.parse("Προσευχή Αζαρίου 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Προσευχή Αζαριου 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Προσευχη Αζαρίου 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Προσευχη Αζαριου 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("Πρ Αζαρ 1:1").osis()).toEqual("PrAzar.1.1")
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (el)", ->
		`
		expect(p.parse("Παροιμίαι 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Παροιμίες 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Παροιμιαι 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Παροιμιες 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Πρμ 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΑΡΟΙΜΊΑΙ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ΠΑΡΟΙΜΊΕΣ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ΠΑΡΟΙΜΙΑΙ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ΠΑΡΟΙΜΙΕΣ 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("ΠΡΜ 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (el)", ->
		`
		expect(p.parse("Εκκλησιαστής 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Εκκλησιαστης 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Εκ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Ἐκ 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΕΚΚΛΗΣΙΑΣΤΉΣ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ΕΚΚΛΗΣΙΑΣΤΗΣ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ΕΚ 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ἘΚ 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (el)", ->
		`
		expect(p.parse("Ύμνος των Τριων Παίδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Ύμνος των Τριων Παιδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Ύμνος των Τριών Παίδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Ύμνος των Τριών Παιδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Υμνος των Τριων Παίδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Υμνος των Τριων Παιδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Υμνος των Τριών Παίδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("Υμνος των Τριών Παιδων 1:1").osis()).toEqual("SgThree.1.1")
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (el)", ->
		`
		expect(p.parse("Άσμα Ασμάτων 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Άσμα Ασματων 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ασμα Ασμάτων 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ασμα Ασματων 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ασ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Ἆσ 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΆΣΜΑ ΑΣΜΆΤΩΝ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ΆΣΜΑ ΑΣΜΑΤΩΝ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ΑΣΜΑ ΑΣΜΆΤΩΝ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ΑΣΜΑ ΑΣΜΑΤΩΝ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ΑΣ 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("ἎΣ 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (el)", ->
		`
		expect(p.parse("Ιερεμίας 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Ιερεμιας 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Ιε 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Ἰε 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΕΡΕΜΊΑΣ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ΙΕΡΕΜΙΑΣ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ΙΕ 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("ἸΕ 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (el)", ->
		`
		expect(p.parse("Ιεζεκιήλ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ιεζεκιηλ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ιεζεκ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ιεζκ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ιεζ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("᾿Ιζ 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΕΖΕΚΙΉΛ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ΙΕΖΕΚΙΗΛ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ΙΕΖΕΚ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ΙΕΖΚ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("ΙΕΖ 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("᾿ΙΖ 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (el)", ->
		`
		expect(p.parse("Δανιήλ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Δανιηλ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Δαν 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Δα 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Δν 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΔΑΝΙΉΛ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ΔΑΝΙΗΛ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ΔΑΝ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ΔΑ 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("ΔΝ 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (el)", ->
		`
		expect(p.parse("Ωσηέ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Ωσηε 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Ωσ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Ὠσ 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΩΣΗΈ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ΩΣΗΕ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ΩΣ 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("ὨΣ 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (el)", ->
		`
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Ιωήλ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Ιωηλ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Ιλ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Ἰλ 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ΙΩΉΛ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ΙΩΗΛ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ΙΛ 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("ἸΛ 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (el)", ->
		`
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Αμως 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Αμώς 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Αμ 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Ἀμ 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ΑΜΩΣ 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ΑΜΏΣ 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ΑΜ 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ἈΜ 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (el)", ->
		`
		expect(p.parse("Αβδιου 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Αβδιού 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Οβδίας 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Οβδιας 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Αβδ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Ἀβδ 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΑΒΔΙΟΥ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ΑΒΔΙΟΎ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ΟΒΔΊΑΣ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ΟΒΔΙΑΣ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ΑΒΔ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ἈΒΔ 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (el)", ->
		`
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Ιωνάς 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Ιωνας 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Ιν 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Ἰν 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ΙΩΝΆΣ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ΙΩΝΑΣ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ΙΝ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("ἸΝ 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (el)", ->
		`
		expect(p.parse("ΜΙΧΑΊΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΪ́ΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΊΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΙΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Μιχαΐας 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Μιχαίας 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Μιχαιας 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Μχ 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΜΙΧΑΊΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΪ́ΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΊΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΙΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΪ́ΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΊΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΙΧΑΙΑΣ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("ΜΧ 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (el)", ->
		`
		expect(p.parse("Ναουμ 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Ναούμ 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Να 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΝΑΟΥΜ 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ΝΑΟΎΜ 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("ΝΑ 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (el)", ->
		`
		expect(p.parse("Αββακουμ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Αββακούμ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Αμβακουμ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Αμβακούμ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Αβ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Ἀβ 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΑΒΒΑΚΟΥΜ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ΑΒΒΑΚΟΎΜ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ΑΜΒΑΚΟΥΜ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ΑΜΒΑΚΟΎΜ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ΑΒ 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("ἈΒ 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (el)", ->
		`
		expect(p.parse("Σοφονίας 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Σοφονιας 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Σφν 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΣΟΦΟΝΊΑΣ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ΣΟΦΟΝΙΑΣ 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ΣΦΝ 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (el)", ->
		`
		expect(p.parse("Αγγαίος 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Αγγαιος 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Αγ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Ἀγ 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΑΓΓΑΊΟΣ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ΑΓΓΑΙΟΣ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ΑΓ 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("ἈΓ 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (el)", ->
		`
		expect(p.parse("Ζαχαρίας 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Ζαχαριας 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Ζαχ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Ζα 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Ζχ 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΖΑΧΑΡΊΑΣ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ΖΑΧΑΡΙΑΣ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ΖΑΧ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ΖΑ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ΖΧ 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (el)", ->
		`
		expect(p.parse("Μαλαχίας 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Μαλαχιας 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Μαλ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Μα 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΜΑΛΑΧΊΑΣ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("ΜΑΛΑΧΙΑΣ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("ΜΑΛ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("ΜΑ 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (el)", ->
		`
		expect(p.parse("Κατά Ματθαίον 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Κατά Ματθαιον 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Κατα Ματθαίον 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Κατα Ματθαιον 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Ματθαίος 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Ματθαιος 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Ματθ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Μθ 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΚΑΤΆ ΜΑΤΘΑΊΟΝ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ΚΑΤΆ ΜΑΤΘΑΙΟΝ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ΚΑΤΑ ΜΑΤΘΑΊΟΝ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ΚΑΤΑ ΜΑΤΘΑΙΟΝ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ΜΑΤΘΑΊΟΣ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ΜΑΤΘΑΙΟΣ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ΜΑΤΘ 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("ΜΘ 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (el)", ->
		`
		expect(p.parse("Κατά Μάρκον 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Κατά Μαρκον 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Κατα Μάρκον 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Κατα Μαρκον 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Μάρκος 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Μαρκος 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Μάρκ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Μαρκ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Μρ 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΚΑΤΆ ΜΆΡΚΟΝ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΚΑΤΆ ΜΑΡΚΟΝ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΚΑΤΑ ΜΆΡΚΟΝ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΚΑΤΑ ΜΑΡΚΟΝ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΜΆΡΚΟΣ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΜΑΡΚΟΣ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΜΆΡΚ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΜΑΡΚ 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("ΜΡ 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (el)", ->
		`
		expect(p.parse("Κατά Λουκάν 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Κατά Λουκαν 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Κατα Λουκάν 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Κατα Λουκαν 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Λουκάς 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Λουκας 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Λουκ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Λκ 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΚΑΤΆ ΛΟΥΚΆΝ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ΚΑΤΆ ΛΟΥΚΑΝ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ΚΑΤΑ ΛΟΥΚΆΝ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ΚΑΤΑ ΛΟΥΚΑΝ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ΛΟΥΚΆΣ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ΛΟΥΚΑΣ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ΛΟΥΚ 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("ΛΚ 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (el)", ->
		`
		expect(p.parse("Ιωάννου Α' 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωάννου Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωάννου Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωάννου Α΄ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωάννου Α’ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωαννου Α' 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωαννου Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωαννου Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωαννου Α΄ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Ιωαννου Α’ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' Ιωάννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' Ιωαννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ Ιωάννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ Ιωαννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ Ιωάννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ Ιωαννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ Ιωάννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ Ιωαννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ Ιωάννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ Ιωαννη 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' ᾿Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ᾿Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ᾿Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ ᾿Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ ᾿Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ Ιω 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ Ιω 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΩΆΝΝΟΥ Α' 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Α΄ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Α’ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Α' 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Αʹ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Α΄ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Α’ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' ΙΩΆΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' ΙΩΑΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ΙΩΆΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ΙΩΑΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ΙΩΆΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ΙΩΑΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ ΙΩΆΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ ΙΩΑΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ ΙΩΆΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ ΙΩΑΝΝΗ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' ᾿ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ᾿ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ᾿ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ ᾿ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ ᾿ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α' ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Αʹ ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α΄ ΙΩ 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("Α’ ΙΩ 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (el)", ->
		`
		expect(p.parse("Ιωάννου Β' 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωάννου Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωάννου Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωάννου Β΄ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωάννου Β’ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωαννου Β' 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωαννου Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωαννου Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωαννου Β΄ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Ιωαννου Β’ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' Ιωάννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' Ιωαννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ Ιωάννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ Ιωαννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ Ιωάννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ Ιωαννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ Ιωάννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ Ιωαννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ Ιωάννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ Ιωαννη 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' ᾿Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ᾿Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ᾿Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ ᾿Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ ᾿Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ Ιω 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ Ιω 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΩΆΝΝΟΥ Β' 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Β΄ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Β’ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Β' 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Βʹ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Β΄ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Β’ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' ΙΩΆΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' ΙΩΑΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ΙΩΆΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ΙΩΑΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ΙΩΆΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ΙΩΑΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ ΙΩΆΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ ΙΩΑΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ ΙΩΆΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ ΙΩΑΝΝΗ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' ᾿ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ᾿ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ᾿ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ ᾿ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ ᾿ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β' ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Βʹ ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β΄ ΙΩ 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("Β’ ΙΩ 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (el)", ->
		`
		expect(p.parse("Ιωάννου Γ' 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωάννου Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωάννου Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωάννου Γ΄ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωάννου Γ’ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωαννου Γ' 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωαννου Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωαννου Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωαννου Γ΄ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Ιωαννου Γ’ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' Ιωάννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' Ιωαννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ Ιωάννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ Ιωαννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ Ιωάννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ Ιωαννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ Ιωάννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ Ιωαννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ Ιωάννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ Ιωαννη 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' ᾿Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ᾿Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ᾿Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ ᾿Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ ᾿Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ Ιω 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ Ιω 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΩΆΝΝΟΥ Γ' 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Γ΄ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΆΝΝΟΥ Γ’ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Γ' 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Γʹ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Γ΄ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("ΙΩΑΝΝΟΥ Γ’ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' ΙΩΆΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' ΙΩΑΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ΙΩΆΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ΙΩΑΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ΙΩΆΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ΙΩΑΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ ΙΩΆΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ ΙΩΑΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ ΙΩΆΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ ΙΩΑΝΝΗ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' ᾿ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ᾿ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ᾿ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ ᾿ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ ᾿ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ' ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γʹ ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ΄ ΙΩ 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("Γ’ ΙΩ 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (el)", ->
		`
		expect(p.parse("Κατά Ιωάννην 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Κατά Ιωαννην 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Κατα Ιωάννην 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Κατα Ιωαννην 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Ιωάννης 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Ιωαννης 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Ιωάν 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Ιωαν 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Ιω 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("Ἰω 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΚΑΤΆ ΙΩΆΝΝΗΝ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΚΑΤΆ ΙΩΑΝΝΗΝ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΚΑΤΑ ΙΩΆΝΝΗΝ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΚΑΤΑ ΙΩΑΝΝΗΝ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΙΩΆΝΝΗΣ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΙΩΑΝΝΗΣ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΙΩΆΝ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΙΩΑΝ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ΙΩ 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("ἸΩ 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (el)", ->
		`
		expect(p.parse("Πράξεις των Αποστολων 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πράξεις των Αποστόλων 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πραξεις των Αποστολων 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πραξεις των Αποστόλων 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πράξεις 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πραξεις 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πράξ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πραξ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Πρξ 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΆΞΕΙΣ ΤΩΝ ΑΠΟΣΤΟΛΩΝ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΆΞΕΙΣ ΤΩΝ ΑΠΟΣΤΌΛΩΝ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΑΞΕΙΣ ΤΩΝ ΑΠΟΣΤΟΛΩΝ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΑΞΕΙΣ ΤΩΝ ΑΠΟΣΤΌΛΩΝ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΆΞΕΙΣ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΑΞΕΙΣ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΆΞ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΑΞ 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ΠΡΞ 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (el)", ->
		`
		expect(p.parse("Προς Ρωμαίους 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Προς Ρωμαιους 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Ρωμαίους 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Ρωμαιους 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Ρωμ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("῾Ρω 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΡΩΜΑΊΟΥΣ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ΠΡΟΣ ΡΩΜΑΙΟΥΣ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ΡΩΜΑΊΟΥΣ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ΡΩΜΑΙΟΥΣ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ΡΩΜ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("῾ΡΩ 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (el)", ->
		`
		expect(p.parse("Προς Κορινθίους Β' 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθίους Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθίους Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθίους Β΄ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθίους Β’ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθιους Β' 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθιους Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθιους Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθιους Β΄ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Προς Κορινθιους Β’ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' Κορινθίους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' Κορινθιους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κορινθίους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κορινθιους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κορινθίους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κορινθιους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ Κορινθίους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ Κορινθιους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ Κορινθίους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ Κορινθιους 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' Κορ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κορ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κορ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ Κορ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ Κορ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' Κο 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κο 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ Κο 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ Κο 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ Κο 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Β' 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Β΄ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Β’ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Β' 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Βʹ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Β΄ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Β’ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' ΚΟΡ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟΡ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟΡ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ ΚΟΡ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ ΚΟΡ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β' ΚΟ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Βʹ ΚΟ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β΄ ΚΟ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("Β’ ΚΟ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (el)", ->
		`
		expect(p.parse("Προς Κορινθίους Α' 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθίους Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθίους Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθίους Α΄ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθίους Α’ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθιους Α' 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθιους Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθιους Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθιους Α΄ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Προς Κορινθιους Α’ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' Κορινθίους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' Κορινθιους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κορινθίους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κορινθιους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κορινθίους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κορινθιους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ Κορινθίους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ Κορινθιους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ Κορινθίους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ Κορινθιους 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' Κορ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κορ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κορ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ Κορ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ Κορ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' Κο 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κο 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ Κο 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ Κο 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ Κο 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Α' 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Α΄ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΊΟΥΣ Α’ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Α' 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Αʹ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Α΄ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΡΙΝΘΙΟΥΣ Α’ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ ΚΟΡΙΝΘΊΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ ΚΟΡΙΝΘΙΟΥΣ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' ΚΟΡ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟΡ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟΡ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ ΚΟΡ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ ΚΟΡ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α' ΚΟ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Αʹ ΚΟ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α΄ ΚΟ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("Α’ ΚΟ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (el)", ->
		`
		expect(p.parse("Προς Γαλάτας 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Προς Γαλατας 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Γαλάτες 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Γαλατες 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Γαλ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Γα 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΓΑΛΆΤΑΣ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ΠΡΟΣ ΓΑΛΑΤΑΣ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ΓΑΛΆΤΕΣ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ΓΑΛΑΤΕΣ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ΓΑΛ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("ΓΑ 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (el)", ->
		`
		expect(p.parse("Προς Εφεσίους 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Προς Εφεσιους 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Εφεσίους 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Εφεσιους 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("᾿Εφ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Εφ 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΕΦΕΣΊΟΥΣ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ΠΡΟΣ ΕΦΕΣΙΟΥΣ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ΕΦΕΣΊΟΥΣ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ΕΦΕΣΙΟΥΣ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("᾿ΕΦ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("ΕΦ 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (el)", ->
		`
		expect(p.parse("Προς Φιλιππησίους 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Προς Φιλιππησιους 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Φιλιππησίους 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Φιλιππησιους 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Φι 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΦΙΛΙΠΠΗΣΊΟΥΣ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ΠΡΟΣ ΦΙΛΙΠΠΗΣΙΟΥΣ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ΦΙΛΙΠΠΗΣΊΟΥΣ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ΦΙΛΙΠΠΗΣΙΟΥΣ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("ΦΙ 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (el)", ->
		`
		expect(p.parse("Προς Κολοσσαείς 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Προς Κολοσσαεις 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Κολοσσαείς 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Κολοσσαεις 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Κολ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Κλ 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΚΟΛΟΣΣΑΕΊΣ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("ΠΡΟΣ ΚΟΛΟΣΣΑΕΙΣ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("ΚΟΛΟΣΣΑΕΊΣ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("ΚΟΛΟΣΣΑΕΙΣ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("ΚΟΛ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("ΚΛ 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (el)", ->
		`
		expect(p.parse("Προς Θεσσαλονικείς Β' 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Β΄ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Β’ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Β' 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Β΄ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Β’ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' Θεσσαλονικείς 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' Θεσσαλονικεις 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θεσσαλονικείς 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θεσσαλονικεις 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θεσσαλονικείς 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θεσσαλονικεις 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ Θεσσαλονικείς 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ Θεσσαλονικεις 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ Θεσσαλονικείς 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ Θεσσαλονικεις 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' Θεσ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θεσ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θεσ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ Θεσ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ Θεσ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' Θε 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θε 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ Θε 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ Θε 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ Θε 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Β' 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Β΄ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Β’ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Β' 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Βʹ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Β΄ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Β’ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' ΘΕΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ ΘΕΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ ΘΕΣ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β' ΘΕ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Βʹ ΘΕ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β΄ ΘΕ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("Β’ ΘΕ 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (el)", ->
		`
		expect(p.parse("Προς Θεσσαλονικείς Α' 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Α΄ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικείς Α’ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Α' 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Α΄ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Προς Θεσσαλονικεις Α’ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' Θεσσαλονικείς 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' Θεσσαλονικεις 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θεσσαλονικείς 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θεσσαλονικεις 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θεσσαλονικείς 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θεσσαλονικεις 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ Θεσσαλονικείς 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ Θεσσαλονικεις 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ Θεσσαλονικείς 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ Θεσσαλονικεις 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' Θεσ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θεσ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θεσ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ Θεσ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ Θεσ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' Θε 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θε 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ Θε 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ Θε 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ Θε 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Α' 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Α΄ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΊΣ Α’ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Α' 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Αʹ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Α΄ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("ΠΡΟΣ ΘΕΣΣΑΛΟΝΙΚΕΙΣ Α’ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ ΘΕΣΣΑΛΟΝΙΚΕΊΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ ΘΕΣΣΑΛΟΝΙΚΕΙΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' ΘΕΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ ΘΕΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ ΘΕΣ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α' ΘΕ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Αʹ ΘΕ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α΄ ΘΕ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("Α’ ΘΕ 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (el)", ->
		`
		expect(p.parse("Προς Τιμοθεον Β' 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Β΄ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Β’ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Β' 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Β΄ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Β’ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' Τιμοθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' Τιμόθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τιμοθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τιμόθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τιμοθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τιμόθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ Τιμοθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ Τιμόθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ Τιμοθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ Τιμόθεο 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' Τιμ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τιμ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τιμ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ Τιμ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ Τιμ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' Τι 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τι 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ Τι 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ Τι 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ Τι 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Β' 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Β΄ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Β’ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Β' 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Βʹ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Β΄ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Β’ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' ΤΙΜ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙΜ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙΜ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ ΤΙΜ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ ΤΙΜ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β' ΤΙ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Βʹ ΤΙ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β΄ ΤΙ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("Β’ ΤΙ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (el)", ->
		`
		expect(p.parse("Προς Τιμοθεον Α' 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Α΄ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμοθεον Α’ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Α' 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Α΄ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Προς Τιμόθεον Α’ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' Τιμοθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' Τιμόθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τιμοθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τιμόθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τιμοθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τιμόθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ Τιμοθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ Τιμόθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ Τιμοθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ Τιμόθεο 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' Τιμ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τιμ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τιμ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ Τιμ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ Τιμ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' Τι 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τι 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ Τι 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ Τι 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ Τι 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Α' 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Α΄ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΟΘΕΟΝ Α’ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Α' 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Αʹ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Α΄ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΜΌΘΕΟΝ Α’ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ ΤΙΜΟΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ ΤΙΜΌΘΕΟ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' ΤΙΜ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙΜ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙΜ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ ΤΙΜ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ ΤΙΜ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α' ΤΙ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Αʹ ΤΙ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α΄ ΤΙ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("Α’ ΤΙ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (el)", ->
		`
		expect(p.parse("Προς Τίτον 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Προς Τιτον 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Τίτο 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Τιτο 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Τίτ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Τιτ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Ττ 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΤΊΤΟΝ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ΠΡΟΣ ΤΙΤΟΝ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ΤΊΤΟ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ΤΙΤΟ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ΤΊΤ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ΤΙΤ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("ΤΤ 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (el)", ->
		`
		expect(p.parse("Προς Φιλήμονα 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Προς Φιλημονα 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Φιλήμονα 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Φιλημονα 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Φλμ 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΦΙΛΉΜΟΝΑ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ΠΡΟΣ ΦΙΛΗΜΟΝΑ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ΦΙΛΉΜΟΝΑ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ΦΙΛΗΜΟΝΑ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("ΦΛΜ 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (el)", ->
		`
		expect(p.parse("Προς Εβραίους 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Προς Εβραιους 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Εβραίους 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Εβραιους 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Εβρ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Εβ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Ἑβ 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΠΡΟΣ ΕΒΡΑΊΟΥΣ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ΠΡΟΣ ΕΒΡΑΙΟΥΣ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ΕΒΡΑΊΟΥΣ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ΕΒΡΑΙΟΥΣ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ΕΒΡ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ΕΒ 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("ἙΒ 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (el)", ->
		`
		expect(p.parse("Ιακωβου 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Ιακώβου 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("᾿Ια 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΑΚΩΒΟΥ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("ΙΑΚΏΒΟΥ 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("᾿ΙΑ 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (el)", ->
		`
		expect(p.parse("Β' Πέτρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' Πετρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέτρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πετρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέτρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πετρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πέτρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πετρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πέτρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πετρου 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πέτρου Β' 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πέτρου Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πέτρου Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πέτρου Β΄ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πέτρου Β’ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πετρου Β' 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πετρου Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πετρου Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πετρου Β΄ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Πετρου Β’ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' Πέτρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' Πετρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέτρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πετρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέτρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πετρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πέτρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πετρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πέτρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πετρ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' Πέτ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' Πετ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέτ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πετ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέτ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πετ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πέτ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πετ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πέτ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πετ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' Πέ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' Πε 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πε 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πέ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ Πε 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πέ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ Πε 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πέ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ Πε 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("Β' ΠΈΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' ΠΕΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΈΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΕΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΈΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΕΤΡΟΥ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Β' 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Β΄ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Β’ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Β' 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Βʹ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Β΄ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Β’ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' ΠΈΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' ΠΕΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΈΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΕΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΈΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΕΤΡ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' ΠΈΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' ΠΕΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΈΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΕΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΈΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΕΤ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' ΠΈ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β' ΠΕ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΈ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Βʹ ΠΕ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΈ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β΄ ΠΕ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΈ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("Β’ ΠΕ 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (el)", ->
		`
		expect(p.parse("Α' Πέτρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' Πετρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέτρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πετρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέτρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πετρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πέτρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πετρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πέτρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πετρου 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πέτρου Α' 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πέτρου Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πέτρου Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πέτρου Α΄ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πέτρου Α’ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πετρου Α' 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πετρου Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πετρου Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πετρου Α΄ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Πετρου Α’ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' Πέτρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' Πετρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέτρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πετρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέτρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πετρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πέτρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πετρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πέτρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πετρ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' Πέτ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' Πετ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέτ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πετ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέτ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πετ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πέτ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πετ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πέτ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πετ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' Πέ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' Πε 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πε 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πέ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ Πε 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πέ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ Πε 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πέ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ Πε 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("Α' ΠΈΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' ΠΕΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΈΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΕΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΈΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΕΤΡΟΥ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Α' 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Α΄ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΈΤΡΟΥ Α’ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Α' 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Αʹ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Α΄ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("ΠΕΤΡΟΥ Α’ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' ΠΈΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' ΠΕΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΈΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΕΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΈΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΕΤΡ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' ΠΈΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' ΠΕΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΈΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΕΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΈΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΕΤ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' ΠΈ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α' ΠΕ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΈ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Αʹ ΠΕ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΈ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α΄ ΠΕ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΈ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("Α’ ΠΕ 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (el)", ->
		`
		expect(p.parse("Ιουδα 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Ιούδα 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("᾿Ιδ 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ΙΟΥΔΑ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("ΙΟΎΔΑ 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("᾿ΙΔ 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (el)", ->
		`
		expect(p.parse("Τωβίτ 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Τωβιτ 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		expect(p.parse("Τωβ 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (el)", ->
		`
		expect(p.parse("Ιουδίθ 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Ιουδιθ 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		expect(p.parse("Ιδθ 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (el)", ->
		`
		expect(p.parse("Βαρουχ 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Βαρούχ 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Βαρ 1:1").osis()).toEqual("Bar.1.1")
		expect(p.parse("Βρ 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (el)", ->
		`
		expect(p.parse("Σουσάννα 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Σουσαννα 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Σωσάννα 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Σωσαννα 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Σουσ 1:1").osis()).toEqual("Sus.1.1")
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (el)", ->
		`
		expect(p.parse("Β' Μακκαβαίων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β' Μακκαβαιων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Βʹ Μακκαβαίων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Βʹ Μακκαβαιων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Βʹ Μακκαβαίων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Βʹ Μακκαβαιων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β΄ Μακκαβαίων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β΄ Μακκαβαιων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β’ Μακκαβαίων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β’ Μακκαβαιων 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαίων Β' 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαίων Βʹ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαίων Βʹ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαίων Β΄ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαίων Β’ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαιων Β' 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαιων Βʹ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαιων Βʹ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαιων Β΄ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Μακκαβαιων Β’ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β' Μακκ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Βʹ Μακκ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Βʹ Μακκ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β΄ Μακκ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("Β’ Μακκ 1:1").osis()).toEqual("2Macc.1.1")
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (el)", ->
		`
		expect(p.parse("Γ' Μακκαβαίων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ' Μακκαβαιων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γʹ Μακκαβαίων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γʹ Μακκαβαιων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γʹ Μακκαβαίων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γʹ Μακκαβαιων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ΄ Μακκαβαίων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ΄ Μακκαβαιων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ’ Μακκαβαίων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ’ Μακκαβαιων 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαίων Γ' 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαίων Γʹ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαίων Γʹ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαίων Γ΄ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαίων Γ’ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαιων Γ' 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαιων Γʹ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαιων Γʹ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαιων Γ΄ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Μακκαβαιων Γ’ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ' Μακκ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γʹ Μακκ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γʹ Μακκ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ΄ Μακκ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("Γ’ Μακκ 1:1").osis()).toEqual("3Macc.1.1")
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (el)", ->
		`
		expect(p.parse("Δ' Μακκαβαίων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ' Μακκαβαιων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δʹ Μακκαβαίων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δʹ Μακκαβαιων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δʹ Μακκαβαίων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δʹ Μακκαβαιων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ΄ Μακκαβαίων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ΄ Μακκαβαιων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ’ Μακκαβαίων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ’ Μακκαβαιων 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαίων Δ' 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαίων Δʹ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαίων Δʹ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαίων Δ΄ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαίων Δ’ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαιων Δ' 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαιων Δʹ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαιων Δʹ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαιων Δ΄ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Μακκαβαιων Δ’ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ' Μακκ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δʹ Μακκ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δʹ Μακκ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ΄ Μακκ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("Δ’ Μακκ 1:1").osis()).toEqual("4Macc.1.1")
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (el)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (el)", ->
		`
		expect(p.parse("Α' Μακκαβαίων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α' Μακκαβαιων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Αʹ Μακκαβαίων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Αʹ Μακκαβαιων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Αʹ Μακκαβαίων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Αʹ Μακκαβαιων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α΄ Μακκαβαίων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α΄ Μακκαβαιων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α’ Μακκαβαίων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α’ Μακκαβαιων 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαίων Α' 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαίων Αʹ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαίων Αʹ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαίων Α΄ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαίων Α’ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαιων Α' 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαιων Αʹ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαιων Αʹ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαιων Α΄ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Μακκαβαιων Α’ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α' Μακκ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Αʹ Μακκ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Αʹ Μακκ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α΄ Μακκ 1:1").osis()).toEqual("1Macc.1.1")
		expect(p.parse("Α’ Μακκ 1:1").osis()).toEqual("1Macc.1.1")
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
		expect(p.languages).toEqual ["el"]

	it "should handle ranges (el)", ->
		expect(p.parse("Titus 1:1 - 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1-2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 - 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (el)", ->
		expect(p.parse("Titus 1:1, κεφάλαια 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦΆΛΑΙΑ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, κεφαλαια 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦΑΛΑΙΑ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, κεφάλαιον 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦΆΛΑΙΟΝ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, κεφαλαιον 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦΑΛΑΙΟΝ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, κεφάλαιο 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦΆΛΑΙΟ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, κεφαλαιο 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦΑΛΑΙΟ 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, κεφ. 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦ. 6").osis()).toEqual "Matt.3.4,Matt.6"
		expect(p.parse("Titus 1:1, κεφ 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 ΚΕΦ 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (el)", ->
		expect(p.parse("Exod 1:1 στίχος 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm ΣΤΊΧΟΣ 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 στιχος 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm ΣΤΙΧΟΣ 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 στίχοι 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm ΣΤΊΧΟΙ 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 στιχοι 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm ΣΤΙΧΟΙ 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 στίχοσ 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm ΣΤΊΧΟΣ 6").osis()).toEqual "Phlm.1.6"
		expect(p.parse("Exod 1:1 στιχοσ 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm ΣΤΙΧΟΣ 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (el)", ->
		expect(p.parse("Exod 1:1 και 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 ΚΑΙ 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (el)", ->
		expect(p.parse("Ps 3 ο τίτλος, 4:2, 5:ο τίτλος").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 Ο ΤΊΤΛΟΣ, 4:2, 5:Ο ΤΊΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("Ps 3 ο τιτλος, 4:2, 5:ο τιτλος").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 Ο ΤΙΤΛΟΣ, 4:2, 5:Ο ΤΙΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("Ps 3 ο τίτλοσ, 4:2, 5:ο τίτλοσ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 Ο ΤΊΤΛΟΣ, 4:2, 5:Ο ΤΊΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("Ps 3 ο τιτλοσ, 4:2, 5:ο τιτλοσ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 Ο ΤΙΤΛΟΣ, 4:2, 5:Ο ΤΙΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("Ps 3 τίτλος, 4:2, 5:τίτλος").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 ΤΊΤΛΟΣ, 4:2, 5:ΤΊΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("Ps 3 τιτλος, 4:2, 5:τιτλος").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 ΤΙΤΛΟΣ, 4:2, 5:ΤΙΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("Ps 3 τίτλοσ, 4:2, 5:τίτλοσ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 ΤΊΤΛΟΣ, 4:2, 5:ΤΊΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("Ps 3 τιτλοσ, 4:2, 5:τιτλοσ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 ΤΙΤΛΟΣ, 4:2, 5:ΤΙΤΛΟΣ").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (el)", ->
		expect(p.parse("Rev 3και μετά, 4:2και μετά").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 ΚΑΙ ΜΕΤΆ, 4:2 ΚΑΙ ΜΕΤΆ").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("Rev 3και μετα, 4:2και μετα").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 ΚΑΙ ΜΕΤΑ, 4:2 ΚΑΙ ΜΕΤΑ").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (el)", ->
		expect(p.parse("Lev 1 (SEPT)").osis_and_translations()).toEqual [["Lev.1", "SEPT"]]
		expect(p.parse("lev 1 sept").osis_and_translations()).toEqual [["Lev.1", "SEPT"]]
		expect(p.parse("Lev 1 (SEPTUAGINT)").osis_and_translations()).toEqual [["Lev.1", "SEPTUAGINT"]]
		expect(p.parse("lev 1 septuagint").osis_and_translations()).toEqual [["Lev.1", "SEPTUAGINT"]]
	it "should handle book ranges (el)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("Α' - Γ'  Ιω").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (el)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
