bcv_parser = require("../../js/ne_bcv_parser.js").bcv_parser

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

describe "Localized book Gen (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gen (ne)", ->
		`
		expect(p.parse("उत्पत्तिको पुस्तक 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("utpattiko pustak 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("उत्पत्तिको 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("utpattiko 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("उत्पत्ति 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("Gen 1:1").osis()).toEqual("Gen.1.1")
		p.include_apocrypha(false)
		expect(p.parse("उत्पत्तिको पुस्तक 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("UTPATTIKO PUSTAK 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("उत्पत्तिको 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("UTPATTIKO 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("उत्पत्ति 1:1").osis()).toEqual("Gen.1.1")
		expect(p.parse("GEN 1:1").osis()).toEqual("Gen.1.1")
		`
		true
describe "Localized book Exod (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Exod (ne)", ->
		`
		expect(p.parse("prastʰanko pustak 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("prastʰānko pustak 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("प्रस्थानको पुस्तक 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("prastʰanko 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("prastʰānko 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("प्रस्थानको 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("प्रस्थान 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("Exod 1:1").osis()).toEqual("Exod.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRASTʰANKO PUSTAK 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("PRASTʰĀNKO PUSTAK 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("प्रस्थानको पुस्तक 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("PRASTʰANKO 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("PRASTʰĀNKO 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("प्रस्थानको 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("प्रस्थान 1:1").osis()).toEqual("Exod.1.1")
		expect(p.parse("EXOD 1:1").osis()).toEqual("Exod.1.1")
		`
		true
describe "Localized book Bel (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bel (ne)", ->
		`
		expect(p.parse("Bel 1:1").osis()).toEqual("Bel.1.1")
		`
		true
describe "Localized book Lev (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lev (ne)", ->
		`
		expect(p.parse("leviharuko pustak 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("leviharūko pustak 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("levīharuko pustak 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("levīharūko pustak 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवीहरूको पुस्तक 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("leviharuko 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("leviharūko 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("levīharuko 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("levīharūko 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवीहरूको 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवि 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवी 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("Lev 1:1").osis()).toEqual("Lev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LEVIHARUKO PUSTAK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVIHARŪKO PUSTAK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVĪHARUKO PUSTAK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVĪHARŪKO PUSTAK 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवीहरूको पुस्तक 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVIHARUKO 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVIHARŪKO 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVĪHARUKO 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEVĪHARŪKO 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवीहरूको 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवि 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("लेवी 1:1").osis()).toEqual("Lev.1.1")
		expect(p.parse("LEV 1:1").osis()).toEqual("Lev.1.1")
		`
		true
describe "Localized book Num (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Num (ne)", ->
		`
		expect(p.parse("gantiko pustak 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("gantīko pustak 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गन्तीको पुस्तक 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("gantiko 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("gantīko 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गन्तीको 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गन्ती 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("Num 1:1").osis()).toEqual("Num.1.1")
		p.include_apocrypha(false)
		expect(p.parse("GANTIKO PUSTAK 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("GANTĪKO PUSTAK 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गन्तीको पुस्तक 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("GANTIKO 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("GANTĪKO 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गन्तीको 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("गन्ती 1:1").osis()).toEqual("Num.1.1")
		expect(p.parse("NUM 1:1").osis()).toEqual("Num.1.1")
		`
		true
describe "Localized book Sir (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sir (ne)", ->
		`
		expect(p.parse("Sir 1:1").osis()).toEqual("Sir.1.1")
		`
		true
describe "Localized book Wis (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Wis (ne)", ->
		`
		expect(p.parse("Wis 1:1").osis()).toEqual("Wis.1.1")
		`
		true
describe "Localized book Lam (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Lam (ne)", ->
		`
		expect(p.parse("yarmiyako vilap 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("yarmiyako vilāp 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("yarmiyāko vilap 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("yarmiyāko vilāp 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("यर्मियाको विलाप 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("विलाप 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("Lam 1:1").osis()).toEqual("Lam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YARMIYAKO VILAP 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("YARMIYAKO VILĀP 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("YARMIYĀKO VILAP 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("YARMIYĀKO VILĀP 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("यर्मियाको विलाप 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("विलाप 1:1").osis()).toEqual("Lam.1.1")
		expect(p.parse("LAM 1:1").osis()).toEqual("Lam.1.1")
		`
		true
describe "Localized book EpJer (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: EpJer (ne)", ->
		`
		expect(p.parse("EpJer 1:1").osis()).toEqual("EpJer.1.1")
		`
		true
describe "Localized book Rev (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rev (ne)", ->
		`
		expect(p.parse("yuhannalai bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalai bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalai bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalai bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalaī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalaī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalaī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalaī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāi bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāi bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāi bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāi bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannalāī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālai bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālai bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālai bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālai bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālaī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālaī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālaī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālaī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāi bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāi bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāi bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāi bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yuhannālāī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalai bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalai bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalai bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalai bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalaī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalaī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalaī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalaī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāi bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāi bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāi bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāi bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannalāī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālai bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālai bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālai bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālai bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālaī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālaī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālaī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālaī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāi bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāi bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāi bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāi bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāī bʰaeko prakas 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāī bʰaeko prakaš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāī bʰaeko prakās 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("yūhannālāī bʰaeko prakāš 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("यूहन्नालाई भएको प्रकाश 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("प्रकाश 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("Rev 1:1").osis()).toEqual("Rev.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YUHANNALAI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALAI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALAI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALAI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALAĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALAĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALAĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALAĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNALĀĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLAĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YUHANNĀLĀĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALAĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNALĀĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLAĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀI BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀI BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀI BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀI BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀĪ BʰAEKO PRAKAS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀĪ BʰAEKO PRAKAŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀĪ BʰAEKO PRAKĀS 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("YŪHANNĀLĀĪ BʰAEKO PRAKĀŠ 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("यूहन्नालाई भएको प्रकाश 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("प्रकाश 1:1").osis()).toEqual("Rev.1.1")
		expect(p.parse("REV 1:1").osis()).toEqual("Rev.1.1")
		`
		true
describe "Localized book PrMan (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrMan (ne)", ->
		`
		expect(p.parse("PrMan 1:1").osis()).toEqual("PrMan.1.1")
		`
		true
describe "Localized book Deut (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Deut (ne)", ->
		`
		expect(p.parse("vyavastʰako pustak 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("vyavastʰāko pustak 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यवस्थाको पुस्तक 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("vyavastʰako 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("vyavastʰāko 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यवस्थाको 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यावस्था 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यवस्था 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("Deut 1:1").osis()).toEqual("Deut.1.1")
		p.include_apocrypha(false)
		expect(p.parse("VYAVASTʰAKO PUSTAK 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("VYAVASTʰĀKO PUSTAK 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यवस्थाको पुस्तक 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("VYAVASTʰAKO 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("VYAVASTʰĀKO 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यवस्थाको 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यावस्था 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("व्यवस्था 1:1").osis()).toEqual("Deut.1.1")
		expect(p.parse("DEUT 1:1").osis()).toEqual("Deut.1.1")
		`
		true
describe "Localized book Josh (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Josh (ne)", ->
		`
		expect(p.parse("yahosuko pustak 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahosūko pustak 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahošuko pustak 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahošūko pustak 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशूको पुस्तक 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahosuko 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahosūko 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahošuko 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("yahošūko 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशूको 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशू 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("Josh 1:1").osis()).toEqual("Josh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAHOSUKO PUSTAK 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOSŪKO PUSTAK 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOŠUKO PUSTAK 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOŠŪKO PUSTAK 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशूको पुस्तक 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOSUKO 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOSŪKO 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOŠUKO 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("YAHOŠŪKO 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशूको 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("यहोशू 1:1").osis()).toEqual("Josh.1.1")
		expect(p.parse("JOSH 1:1").osis()).toEqual("Josh.1.1")
		`
		true
describe "Localized book Judg (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Judg (ne)", ->
		`
		expect(p.parse("nyayakarttaharuko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyayakarttaharūko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyayakarttāharuko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyayakarttāharūko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttaharuko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttaharūko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttāharuko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttāharūko pustak 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्त्ताहरूको पुस्तक 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्ताहरूको पुस्तक 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyayakarttaharuko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyayakarttaharūko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyayakarttāharuko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyayakarttāharūko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttaharuko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttaharūko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttāharuko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("nyāyakarttāharūko 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्त्ताहरूको 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्ता 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("Judg 1:1").osis()).toEqual("Judg.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NYAYAKARTTAHARUKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYAYAKARTTAHARŪKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYAYAKARTTĀHARUKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYAYAKARTTĀHARŪKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTAHARUKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTAHARŪKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTĀHARUKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTĀHARŪKO PUSTAK 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्त्ताहरूको पुस्तक 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्ताहरूको पुस्तक 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYAYAKARTTAHARUKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYAYAKARTTAHARŪKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYAYAKARTTĀHARUKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYAYAKARTTĀHARŪKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTAHARUKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTAHARŪKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTĀHARUKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("NYĀYAKARTTĀHARŪKO 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्त्ताहरूको 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("न्यायकर्ता 1:1").osis()).toEqual("Judg.1.1")
		expect(p.parse("JUDG 1:1").osis()).toEqual("Judg.1.1")
		`
		true
describe "Localized book Ruth (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ruth (ne)", ->
		`
		expect(p.parse("rutʰko pustak 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("rūtʰko pustak 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथको पुस्तक 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("rutʰko 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("rūtʰko 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथको 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("Ruth 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथ 1:1").osis()).toEqual("Ruth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("RUTʰKO PUSTAK 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RŪTʰKO PUSTAK 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथको पुस्तक 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUTʰKO 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RŪTʰKO 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथको 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("RUTH 1:1").osis()).toEqual("Ruth.1.1")
		expect(p.parse("रूथ 1:1").osis()).toEqual("Ruth.1.1")
		`
		true
describe "Localized book 1Esd (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Esd (ne)", ->
		`
		expect(p.parse("1Esd 1:1").osis()).toEqual("1Esd.1.1")
		`
		true
describe "Localized book 2Esd (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Esd (ne)", ->
		`
		expect(p.parse("2Esd 1:1").osis()).toEqual("2Esd.1.1")
		`
		true
describe "Localized book Isa (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Isa (ne)", ->
		`
		expect(p.parse("yasəiyako pustak 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yasəiyāko pustak 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yašəiyako pustak 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yašəiyāko pustak 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशैयाको पुस्तक 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yasəiyako 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yasəiyāko 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yašəiyako 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("yašəiyāko 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशैयाको 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("येशैया 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशैया 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("Isa 1:1").osis()).toEqual("Isa.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YASƏIYAKO PUSTAK 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YASƏIYĀKO PUSTAK 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YAŠƏIYAKO PUSTAK 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YAŠƏIYĀKO PUSTAK 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशैयाको पुस्तक 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YASƏIYAKO 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YASƏIYĀKO 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YAŠƏIYAKO 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("YAŠƏIYĀKO 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशैयाको 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("येशैया 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("यशैया 1:1").osis()).toEqual("Isa.1.1")
		expect(p.parse("ISA 1:1").osis()).toEqual("Isa.1.1")
		`
		true
describe "Localized book 2Sam (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Sam (ne)", ->
		`
		expect(p.parse("शमूएलको दोस्रो पुस्तक 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. samuelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. samūelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. šamuelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. šamūelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 samuelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 samūelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 šamuelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 šamūelko 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. शमूएलको 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शमूएलको 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. शामुएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शामुएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. शमूएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शमूएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2Sam 1:1").osis()).toEqual("2Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("शमूएलको दोस्रो पुस्तक 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMUELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. SAMŪELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. ŠAMUELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. ŠAMŪELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMUELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 SAMŪELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 ŠAMUELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 ŠAMŪELKO 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. शमूएलको 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शमूएलको 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. शामुएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शामुएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2. शमूएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2 शमूएल 1:1").osis()).toEqual("2Sam.1.1")
		expect(p.parse("2SAM 1:1").osis()).toEqual("2Sam.1.1")
		`
		true
describe "Localized book 1Sam (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Sam (ne)", ->
		`
		expect(p.parse("शमूएलको पहिलो पुस्तक 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("samuelko pustak 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("samūelko pustak 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("šamuelko pustak 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("šamūelko pustak 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. samuelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. samūelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. šamuelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. šamūelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 samuelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 samūelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 šamuelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 šamūelko 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. शमूएलको 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शमूएलको 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. शामुएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शामुएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. शमूएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शमूएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1Sam 1:1").osis()).toEqual("1Sam.1.1")
		p.include_apocrypha(false)
		expect(p.parse("शमूएलको पहिलो पुस्तक 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("SAMUELKO PUSTAK 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("SAMŪELKO PUSTAK 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ŠAMUELKO PUSTAK 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("ŠAMŪELKO PUSTAK 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMUELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. SAMŪELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. ŠAMUELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. ŠAMŪELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMUELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 SAMŪELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 ŠAMUELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 ŠAMŪELKO 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. शमूएलको 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शमूएलको 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. शामुएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शामुएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1. शमूएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1 शमूएल 1:1").osis()).toEqual("1Sam.1.1")
		expect(p.parse("1SAM 1:1").osis()).toEqual("1Sam.1.1")
		`
		true
describe "Localized book 2Kgs (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Kgs (ne)", ->
		`
		expect(p.parse("राजाहरूको दोस्रो पुस्तक 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. raǳaharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. raǳaharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. raǳāharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. raǳāharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. rāǳaharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. rāǳaharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. rāǳāharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. rāǳāharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 raǳaharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 raǳaharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 raǳāharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 raǳāharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 rāǳaharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 rāǳaharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 rāǳāharuko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 rāǳāharūko 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. राजाहरूको 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 राजाहरूको 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. राजा 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 राजा 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2Kgs 1:1").osis()).toEqual("2Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("राजाहरूको दोस्रो पुस्तक 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RAǱAHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RAǱAHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RAǱĀHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RAǱĀHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RĀǱAHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RĀǱAHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RĀǱĀHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. RĀǱĀHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RAǱAHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RAǱAHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RAǱĀHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RAǱĀHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RĀǱAHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RĀǱAHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RĀǱĀHARUKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 RĀǱĀHARŪKO 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. राजाहरूको 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 राजाहरूको 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2. राजा 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2 राजा 1:1").osis()).toEqual("2Kgs.1.1")
		expect(p.parse("2KGS 1:1").osis()).toEqual("2Kgs.1.1")
		`
		true
describe "Localized book 1Kgs (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Kgs (ne)", ->
		`
		expect(p.parse("राजाहरूक पहिल पुस्तक 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("raǳaharuko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("raǳaharūko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("raǳāharuko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("raǳāharūko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("rāǳaharuko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("rāǳaharūko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("rāǳāharuko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("rāǳāharūko pustak 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. raǳaharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. raǳaharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. raǳāharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. raǳāharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. rāǳaharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. rāǳaharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. rāǳāharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. rāǳāharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 raǳaharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 raǳaharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 raǳāharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 raǳāharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 rāǳaharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 rāǳaharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 rāǳāharuko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 rāǳāharūko 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. राजाहरूको 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 राजाहरूको 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. राजा 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 राजा 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1Kgs 1:1").osis()).toEqual("1Kgs.1.1")
		p.include_apocrypha(false)
		expect(p.parse("राजाहरूक पहिल पुस्तक 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RAǱAHARUKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RAǱAHARŪKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RAǱĀHARUKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RAǱĀHARŪKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RĀǱAHARUKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RĀǱAHARŪKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RĀǱĀHARUKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("RĀǱĀHARŪKO PUSTAK 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RAǱAHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RAǱAHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RAǱĀHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RAǱĀHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RĀǱAHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RĀǱAHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RĀǱĀHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. RĀǱĀHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RAǱAHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RAǱAHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RAǱĀHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RAǱĀHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RĀǱAHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RĀǱAHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RĀǱĀHARUKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 RĀǱĀHARŪKO 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. राजाहरूको 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 राजाहरूको 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1. राजा 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1 राजा 1:1").osis()).toEqual("1Kgs.1.1")
		expect(p.parse("1KGS 1:1").osis()).toEqual("1Kgs.1.1")
		`
		true
describe "Localized book 2Chr (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Chr (ne)", ->
		`
		expect(p.parse("इतिहासको दोस्रो पुस्तक 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. itihasko 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. itihāsko 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. इतिहासको 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 itihasko 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 itihāsko 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 इतिहासको 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2Chr 1:1").osis()).toEqual("2Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("इतिहासको दोस्रो पुस्तक 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. ITIHASKO 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. ITIHĀSKO 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. इतिहासको 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ITIHASKO 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 ITIHĀSKO 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 इतिहासको 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2. इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2 इतिहास 1:1").osis()).toEqual("2Chr.1.1")
		expect(p.parse("2CHR 1:1").osis()).toEqual("2Chr.1.1")
		`
		true
describe "Localized book 1Chr (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Chr (ne)", ->
		`
		expect(p.parse("इतिहासको पहिलो पुस्तक 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("itihasko pustak 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("itihāsko pustak 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. itihasko 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. itihāsko 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. इतिहासको 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 itihasko 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 itihāsko 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 इतिहासको 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1Chr 1:1").osis()).toEqual("1Chr.1.1")
		p.include_apocrypha(false)
		expect(p.parse("इतिहासको पहिलो पुस्तक 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ITIHASKO PUSTAK 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("ITIHĀSKO PUSTAK 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. ITIHASKO 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. ITIHĀSKO 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. इतिहासको 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ITIHASKO 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 ITIHĀSKO 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 इतिहासको 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1. इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1 इतिहास 1:1").osis()).toEqual("1Chr.1.1")
		expect(p.parse("1CHR 1:1").osis()).toEqual("1Chr.1.1")
		`
		true
describe "Localized book Ezra (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezra (ne)", ->
		`
		expect(p.parse("एज्राको पुस्तक 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("एज्राको 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("eǳrako 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("eǳrāko 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("एज्रा 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("Ezra 1:1").osis()).toEqual("Ezra.1.1")
		p.include_apocrypha(false)
		expect(p.parse("एज्राको पुस्तक 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("एज्राको 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EǱRAKO 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EǱRĀKO 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("एज्रा 1:1").osis()).toEqual("Ezra.1.1")
		expect(p.parse("EZRA 1:1").osis()).toEqual("Ezra.1.1")
		`
		true
describe "Localized book Neh (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Neh (ne)", ->
		`
		expect(p.parse("nahemyahko pustak 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("nahemyāhko pustak 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्याहको पुस्तक 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("nahemyahko 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("nahemyāhko 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्याहको 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्याह 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("Neh 1:1").osis()).toEqual("Neh.1.1")
		p.include_apocrypha(false)
		expect(p.parse("NAHEMYAHKO PUSTAK 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NAHEMYĀHKO PUSTAK 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्याहको पुस्तक 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NAHEMYAHKO 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NAHEMYĀHKO 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्याहको 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("नहेम्याह 1:1").osis()).toEqual("Neh.1.1")
		expect(p.parse("NEH 1:1").osis()).toEqual("Neh.1.1")
		`
		true
describe "Localized book GkEsth (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: GkEsth (ne)", ->
		`
		expect(p.parse("GkEsth 1:1").osis()).toEqual("GkEsth.1.1")
		`
		true
describe "Localized book Esth (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Esth (ne)", ->
		`
		expect(p.parse("estarko pustak 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("एस्तरको पुस्तक 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("estarko 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("एस्तरको 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("एस्तर 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("Esth 1:1").osis()).toEqual("Esth.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ESTARKO PUSTAK 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("एस्तरको पुस्तक 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTARKO 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("एस्तरको 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("एस्तर 1:1").osis()).toEqual("Esth.1.1")
		expect(p.parse("ESTH 1:1").osis()).toEqual("Esth.1.1")
		`
		true
describe "Localized book Job (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Job (ne)", ->
		`
		expect(p.parse("अय्यूबको पुस्तक 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ayyubko pustak 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ayyūbko pustak 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("अय्यूबको 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ayyubko 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("ayyūbko 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("अय्यूब 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("Job 1:1").osis()).toEqual("Job.1.1")
		p.include_apocrypha(false)
		expect(p.parse("अय्यूबको पुस्तक 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("AYYUBKO PUSTAK 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("AYYŪBKO PUSTAK 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("अय्यूबको 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("AYYUBKO 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("AYYŪBKO 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("अय्यूब 1:1").osis()).toEqual("Job.1.1")
		expect(p.parse("JOB 1:1").osis()).toEqual("Job.1.1")
		`
		true
describe "Localized book Ps (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ps (ne)", ->
		`
		expect(p.parse("bʰaǳansamgrah 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("bʰaǳansaṃgrah 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("भजनसंग्रह 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("भजनसग्रह 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("भजन 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("Ps 1:1").osis()).toEqual("Ps.1.1")
		p.include_apocrypha(false)
		expect(p.parse("BʰAǱANSAMGRAH 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("BʰAǱANSAṂGRAH 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("भजनसंग्रह 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("भजनसग्रह 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("भजन 1:1").osis()).toEqual("Ps.1.1")
		expect(p.parse("PS 1:1").osis()).toEqual("Ps.1.1")
		`
		true
describe "Localized book PrAzar (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: PrAzar (ne)", ->
		`
		expect(p.parse("PrAzar 1:1").osis()).toEqual("PrAzar.1.1")
		`
		true
describe "Localized book Prov (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Prov (ne)", ->
		`
		expect(p.parse("hitopadesko pustak 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("hitopadeško pustak 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("हितोपदेशको पुस्तक 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("hitopadesko 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("hitopadeško 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("हितोपदेशको 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("हितोपदेश 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("Prov 1:1").osis()).toEqual("Prov.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HITOPADESKO PUSTAK 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("HITOPADEŠKO PUSTAK 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("हितोपदेशको पुस्तक 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("HITOPADESKO 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("HITOPADEŠKO 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("हितोपदेशको 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("हितोपदेश 1:1").osis()).toEqual("Prov.1.1")
		expect(p.parse("PROV 1:1").osis()).toEqual("Prov.1.1")
		`
		true
describe "Localized book Eccl (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eccl (ne)", ->
		`
		expect(p.parse("upadesakko pustak 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("upadešakko pustak 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशकको पुस्तक 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("upadesakko 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("upadešakko 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशकको 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशक 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("Eccl 1:1").osis()).toEqual("Eccl.1.1")
		p.include_apocrypha(false)
		expect(p.parse("UPADESAKKO PUSTAK 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("UPADEŠAKKO PUSTAK 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशकको पुस्तक 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("UPADESAKKO 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("UPADEŠAKKO 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशकको 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("उपदेशक 1:1").osis()).toEqual("Eccl.1.1")
		expect(p.parse("ECCL 1:1").osis()).toEqual("Eccl.1.1")
		`
		true
describe "Localized book SgThree (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: SgThree (ne)", ->
		`
		expect(p.parse("SgThree 1:1").osis()).toEqual("SgThree.1.1")
		`
		true
describe "Localized book Song (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Song (ne)", ->
		`
		expect(p.parse("sulemanko srestʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko srestʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko sresṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko sresṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko sreṣtʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko sreṣtʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko sreṣṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko sreṣṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šrestʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šrestʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šresṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šresṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šreṣtʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šreṣtʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šreṣṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemanko šreṣṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko srestʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko srestʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko sresṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko sresṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko sreṣtʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko sreṣtʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko sreṣṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko sreṣṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šrestʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šrestʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šresṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šresṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šreṣtʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šreṣtʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šreṣṭʰagit 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("sulemānko šreṣṭʰagīt 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("सुलेमानको श्रेष्ठगीत 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("श्रेष्ठगीत 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("Song 1:1").osis()).toEqual("Song.1.1")
		p.include_apocrypha(false)
		expect(p.parse("SULEMANKO SRESTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO SRESTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO SRESṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO SRESṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO SREṢTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO SREṢTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO SREṢṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO SREṢṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠRESTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠRESTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠRESṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠRESṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠREṢTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠREṢTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠREṢṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMANKO ŠREṢṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SRESTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SRESTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SRESṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SRESṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SREṢTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SREṢTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SREṢṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO SREṢṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠRESTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠRESTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠRESṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠRESṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠREṢTʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠREṢTʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠREṢṬʰAGIT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SULEMĀNKO ŠREṢṬʰAGĪT 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("सुलेमानको श्रेष्ठगीत 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("श्रेष्ठगीत 1:1").osis()).toEqual("Song.1.1")
		expect(p.parse("SONG 1:1").osis()).toEqual("Song.1.1")
		`
		true
describe "Localized book Jer (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jer (ne)", ->
		`
		expect(p.parse("yarmiyako pustak 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("yarmiyāko pustak 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यर्मियाको पुस्तक 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("yarmiyako 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("yarmiyāko 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यर्मियाको 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यर्मिया 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("Jer 1:1").osis()).toEqual("Jer.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YARMIYAKO PUSTAK 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("YARMIYĀKO PUSTAK 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यर्मियाको पुस्तक 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("YARMIYAKO 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("YARMIYĀKO 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यर्मियाको 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("यर्मिया 1:1").osis()).toEqual("Jer.1.1")
		expect(p.parse("JER 1:1").osis()).toEqual("Jer.1.1")
		`
		true
describe "Localized book Ezek (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Ezek (ne)", ->
		`
		expect(p.parse("iǳakielko pustak 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("इजकिएलको पुस्तक 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("iǳakielko 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("इजकिएलको 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("इजकिएल 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("Ezek 1:1").osis()).toEqual("Ezek.1.1")
		p.include_apocrypha(false)
		expect(p.parse("IǱAKIELKO PUSTAK 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("इजकिएलको पुस्तक 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("IǱAKIELKO 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("इजकिएलको 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("इजकिएल 1:1").osis()).toEqual("Ezek.1.1")
		expect(p.parse("EZEK 1:1").osis()).toEqual("Ezek.1.1")
		`
		true
describe "Localized book Dan (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Dan (ne)", ->
		`
		expect(p.parse("daniyalko pustak 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("dāniyalko pustak 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानियलको पुस्तक 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("daniyalko 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("dāniyalko 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानियलको 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानियल 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("Dan 1:1").osis()).toEqual("Dan.1.1")
		p.include_apocrypha(false)
		expect(p.parse("DANIYALKO PUSTAK 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DĀNIYALKO PUSTAK 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानियलको पुस्तक 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DANIYALKO 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DĀNIYALKO 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानियलको 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("दानियल 1:1").osis()).toEqual("Dan.1.1")
		expect(p.parse("DAN 1:1").osis()).toEqual("Dan.1.1")
		`
		true
describe "Localized book Hos (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hos (ne)", ->
		`
		expect(p.parse("होशेको पुस्तक 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("hose 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("hoše 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("होशे 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("Hos 1:1").osis()).toEqual("Hos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("होशेको पुस्तक 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOSE 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOŠE 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("होशे 1:1").osis()).toEqual("Hos.1.1")
		expect(p.parse("HOS 1:1").osis()).toEqual("Hos.1.1")
		`
		true
describe "Localized book Joel (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Joel (ne)", ->
		`
		expect(p.parse("योएलको पुस्तक 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("Joel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("yoel 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("योएल 1:1").osis()).toEqual("Joel.1.1")
		p.include_apocrypha(false)
		expect(p.parse("योएलको पुस्तक 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("JOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("YOEL 1:1").osis()).toEqual("Joel.1.1")
		expect(p.parse("योएल 1:1").osis()).toEqual("Joel.1.1")
		`
		true
describe "Localized book Amos (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Amos (ne)", ->
		`
		expect(p.parse("आमोसको पुस्तक 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("Amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("amos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("āmos 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("अमोस 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("आमोस 1:1").osis()).toEqual("Amos.1.1")
		p.include_apocrypha(false)
		expect(p.parse("आमोसको पुस्तक 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("AMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("ĀMOS 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("अमोस 1:1").osis()).toEqual("Amos.1.1")
		expect(p.parse("आमोस 1:1").osis()).toEqual("Amos.1.1")
		`
		true
describe "Localized book Obad (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Obad (ne)", ->
		`
		expect(p.parse("ओबदियाको पुस्तक 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("obadiya 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("obadiyā 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ओबदिया 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("Obad 1:1").osis()).toEqual("Obad.1.1")
		p.include_apocrypha(false)
		expect(p.parse("ओबदियाको पुस्तक 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBADIYA 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBADIYĀ 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("ओबदिया 1:1").osis()).toEqual("Obad.1.1")
		expect(p.parse("OBAD 1:1").osis()).toEqual("Obad.1.1")
		`
		true
describe "Localized book Jonah (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jonah (ne)", ->
		`
		expect(p.parse("योनाको पुस्तक 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("Jonah 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("yona 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("yonā 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("योना 1:1").osis()).toEqual("Jonah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("योनाको पुस्तक 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("JONAH 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("YONA 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("YONĀ 1:1").osis()).toEqual("Jonah.1.1")
		expect(p.parse("योना 1:1").osis()).toEqual("Jonah.1.1")
		`
		true
describe "Localized book Mic (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mic (ne)", ->
		`
		expect(p.parse("मीकाको पुस्तक 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mika 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mikā 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mīka 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("mīkā 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("मिका 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("मीका 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("Mic 1:1").osis()).toEqual("Mic.1.1")
		p.include_apocrypha(false)
		expect(p.parse("मीकाको पुस्तक 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIKA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIKĀ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MĪKA 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MĪKĀ 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("मिका 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("मीका 1:1").osis()).toEqual("Mic.1.1")
		expect(p.parse("MIC 1:1").osis()).toEqual("Mic.1.1")
		`
		true
describe "Localized book Nah (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Nah (ne)", ->
		`
		expect(p.parse("नहूमको पुस्तक 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("nahum 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("nahūm 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("नहूम 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("Nah 1:1").osis()).toEqual("Nah.1.1")
		p.include_apocrypha(false)
		expect(p.parse("नहूमको पुस्तक 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAHUM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAHŪM 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("नहूम 1:1").osis()).toEqual("Nah.1.1")
		expect(p.parse("NAH 1:1").osis()).toEqual("Nah.1.1")
		`
		true
describe "Localized book Hab (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hab (ne)", ->
		`
		expect(p.parse("हबकूकको पुस्तक 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("habakuk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("habakūk 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("हबकूक 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("Hab 1:1").osis()).toEqual("Hab.1.1")
		p.include_apocrypha(false)
		expect(p.parse("हबकूकको पुस्तक 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAKUK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HABAKŪK 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("हबकूक 1:1").osis()).toEqual("Hab.1.1")
		expect(p.parse("HAB 1:1").osis()).toEqual("Hab.1.1")
		`
		true
describe "Localized book Zeph (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zeph (ne)", ->
		`
		expect(p.parse("सपन्याहको पुस्तक 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("sapanyah 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("sapanyāh 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("सपन्याह 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("Zeph 1:1").osis()).toEqual("Zeph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("सपन्याहको पुस्तक 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SAPANYAH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("SAPANYĀH 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("सपन्याह 1:1").osis()).toEqual("Zeph.1.1")
		expect(p.parse("ZEPH 1:1").osis()).toEqual("Zeph.1.1")
		`
		true
describe "Localized book Hag (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Hag (ne)", ->
		`
		expect(p.parse("हाग्गैको पुस्तक 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("haggəi 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("hāggəi 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("हाग्गै 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("Hag 1:1").osis()).toEqual("Hag.1.1")
		p.include_apocrypha(false)
		expect(p.parse("हाग्गैको पुस्तक 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAGGƏI 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HĀGGƏI 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("हाग्गै 1:1").osis()).toEqual("Hag.1.1")
		expect(p.parse("HAG 1:1").osis()).toEqual("Hag.1.1")
		`
		true
describe "Localized book Zech (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Zech (ne)", ->
		`
		expect(p.parse("जकरियाको पुस्तक 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("jakariya 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("jakariyā 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("जकरिया 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("Zech 1:1").osis()).toEqual("Zech.1.1")
		p.include_apocrypha(false)
		expect(p.parse("जकरियाको पुस्तक 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("JAKARIYA 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("JAKARIYĀ 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("जकरिया 1:1").osis()).toEqual("Zech.1.1")
		expect(p.parse("ZECH 1:1").osis()).toEqual("Zech.1.1")
		`
		true
describe "Localized book Mal (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mal (ne)", ->
		`
		expect(p.parse("मलाकीको पुस्तक 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("malaki 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("malakī 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("malāki 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("malākī 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("मलाकी 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("मलकी 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("Mal 1:1").osis()).toEqual("Mal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("मलाकीको पुस्तक 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALAKI 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALAKĪ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALĀKI 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MALĀKĪ 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("मलाकी 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("मलकी 1:1").osis()).toEqual("Mal.1.1")
		expect(p.parse("MAL 1:1").osis()).toEqual("Mal.1.1")
		`
		true
describe "Localized book Matt (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Matt (ne)", ->
		`
		expect(p.parse("mattile lekʰeko susmacar 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattile lekʰeko susmacār 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattile lekʰeko susmācar 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattile lekʰeko susmācār 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattīle lekʰeko susmacar 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattīle lekʰeko susmacār 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattīle lekʰeko susmācar 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattīle lekʰeko susmācār 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तीले लेखेको सुसमाचार 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तीको सुसमाचार 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattile 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("mattīle 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तीले 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्ति 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्ती 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("Matt 1:1").osis()).toEqual("Matt.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MATTILE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTILE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTILE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTILE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTĪLE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTĪLE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTĪLE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTĪLE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तीले लेखेको सुसमाचार 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तीको सुसमाचार 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTILE 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATTĪLE 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्तीले 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्ति 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("मत्ती 1:1").osis()).toEqual("Matt.1.1")
		expect(p.parse("MATT 1:1").osis()).toEqual("Matt.1.1")
		`
		true
describe "Localized book Mark (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Mark (ne)", ->
		`
		expect(p.parse("markusle lekʰeko susmacar 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markusle lekʰeko susmacār 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markusle lekʰeko susmācar 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markusle lekʰeko susmācār 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markūsle lekʰeko susmacar 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markūsle lekʰeko susmacār 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markūsle lekʰeko susmācar 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markūsle lekʰeko susmācār 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूसले लेखेको सुसमाचार 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूसको सुसमाचार 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markusle 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("markūsle 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूसले 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कुस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूश 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("र्मकूस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("र्मकस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("Mark 1:1").osis()).toEqual("Mark.1.1")
		p.include_apocrypha(false)
		expect(p.parse("MARKUSLE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKUSLE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKUSLE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKUSLE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKŪSLE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKŪSLE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKŪSLE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKŪSLE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूसले लेखेको सुसमाचार 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूसको सुसमाचार 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKUSLE 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARKŪSLE 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूसले 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कुस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूश 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("मर्कूस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("र्मकूस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("र्मकस 1:1").osis()).toEqual("Mark.1.1")
		expect(p.parse("MARK 1:1").osis()).toEqual("Mark.1.1")
		`
		true
describe "Localized book Luke (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Luke (ne)", ->
		`
		expect(p.parse("lukale lekʰeko susmacar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukale lekʰeko susmacār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukale lekʰeko susmācar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukale lekʰeko susmācār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāle lekʰeko susmacar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāle lekʰeko susmacār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāle lekʰeko susmācar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāle lekʰeko susmācār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkale lekʰeko susmacar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkale lekʰeko susmacār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkale lekʰeko susmācar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkale lekʰeko susmācār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāle lekʰeko susmacar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāle lekʰeko susmacār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāle lekʰeko susmācar 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāle lekʰeko susmācār 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाले लेखेको सुसमाचार 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाको सुसमाचार 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukale 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lukāle 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkale 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("lūkāle 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाले 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("Luke 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लुका 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूका 1:1").osis()).toEqual("Luke.1.1")
		p.include_apocrypha(false)
		expect(p.parse("LUKALE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKALE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKALE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKALE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀLE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀLE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀLE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀLE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKALE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKALE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKALE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKALE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀLE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀLE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀLE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀLE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाले लेखेको सुसमाचार 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाको सुसमाचार 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKALE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKĀLE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKALE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LŪKĀLE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूकाले 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("LUKE 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लुका 1:1").osis()).toEqual("Luke.1.1")
		expect(p.parse("लूका 1:1").osis()).toEqual("Luke.1.1")
		`
		true
describe "Localized book 1John (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1John (ne)", ->
		`
		expect(p.parse("yuhannako pahilo patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yuhannāko pahilo patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yūhannako pahilo patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("yūhannāko pahilo patra 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("यूहन्नाको पहिलो पत्र 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. yuhannako 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. yuhannāko 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. yūhannako 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. yūhannāko 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. यूहन्नाको 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yuhannako 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yuhannāko 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yūhannako 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 yūhannāko 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 यूहन्नाको 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. यूहन्ना 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 यूहन्ना 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1John 1:1").osis()).toEqual("1John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YUHANNAKO PAHILO PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YUHANNĀKO PAHILO PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YŪHANNAKO PAHILO PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("YŪHANNĀKO PAHILO PATRA 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("यूहन्नाको पहिलो पत्र 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. YUHANNAKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. YUHANNĀKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. YŪHANNAKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. YŪHANNĀKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. यूहन्नाको 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YUHANNAKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YUHANNĀKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YŪHANNAKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 YŪHANNĀKO 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 यूहन्नाको 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1. यूहन्ना 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1 यूहन्ना 1:1").osis()).toEqual("1John.1.1")
		expect(p.parse("1JOHN 1:1").osis()).toEqual("1John.1.1")
		`
		true
describe "Localized book 2John (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2John (ne)", ->
		`
		expect(p.parse("यूहन्नाको दोस्त्रो पत्र 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yuhannako dostro patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yuhannāko dostro patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yūhannako dostro patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("yūhannāko dostro patra 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("यूहन्नाको दोस्रो पत्र 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. yuhannako 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. yuhannāko 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. yūhannako 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. yūhannāko 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. यूहन्नाको 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yuhannako 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yuhannāko 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yūhannako 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 yūhannāko 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 यूहन्नाको 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. यूहन्ना 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 यूहन्ना 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2John 1:1").osis()).toEqual("2John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("यूहन्नाको दोस्त्रो पत्र 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YUHANNAKO DOSTRO PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YUHANNĀKO DOSTRO PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YŪHANNAKO DOSTRO PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("YŪHANNĀKO DOSTRO PATRA 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("यूहन्नाको दोस्रो पत्र 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. YUHANNAKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. YUHANNĀKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. YŪHANNAKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. YŪHANNĀKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. यूहन्नाको 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YUHANNAKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YUHANNĀKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YŪHANNAKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 YŪHANNĀKO 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 यूहन्नाको 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2. यूहन्ना 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2 यूहन्ना 1:1").osis()).toEqual("2John.1.1")
		expect(p.parse("2JOHN 1:1").osis()).toEqual("2John.1.1")
		`
		true
describe "Localized book 3John (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3John (ne)", ->
		`
		expect(p.parse("यूहन्नाको तेस्त्रो पत्र 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yuhannako testro patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yuhannāko testro patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yūhannako testro patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("yūhannāko testro patra 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("यूहन्नाको तेस्रो पत्र 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. yuhannako 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. yuhannāko 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. yūhannako 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. yūhannāko 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. यूहन्नाको 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yuhannako 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yuhannāko 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yūhannako 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 yūhannāko 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 यूहन्नाको 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. यूहन्ना 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 यूहन्ना 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3John 1:1").osis()).toEqual("3John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("यूहन्नाको तेस्त्रो पत्र 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YUHANNAKO TESTRO PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YUHANNĀKO TESTRO PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YŪHANNAKO TESTRO PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("YŪHANNĀKO TESTRO PATRA 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("यूहन्नाको तेस्रो पत्र 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. YUHANNAKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. YUHANNĀKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. YŪHANNAKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. YŪHANNĀKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. यूहन्नाको 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YUHANNAKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YUHANNĀKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YŪHANNAKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 YŪHANNĀKO 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 यूहन्नाको 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3. यूहन्ना 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3 यूहन्ना 1:1").osis()).toEqual("3John.1.1")
		expect(p.parse("3JOHN 1:1").osis()).toEqual("3John.1.1")
		`
		true
describe "Localized book John (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: John (ne)", ->
		`
		expect(p.parse("yuhannale lekʰeko susmacar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannale lekʰeko susmacār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannale lekʰeko susmācar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannale lekʰeko susmācār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannāle lekʰeko susmacar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannāle lekʰeko susmacār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannāle lekʰeko susmācar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannāle lekʰeko susmācār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannale lekʰeko susmacar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannale lekʰeko susmacār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannale lekʰeko susmācar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannale lekʰeko susmācār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannāle lekʰeko susmacar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannāle lekʰeko susmacār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannāle lekʰeko susmācar 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannāle lekʰeko susmācār 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्नाले लेखेको सुसमाचार 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्नाको सुसमाचार 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannale 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yuhannāle 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannale 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("yūhannāle 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्नाले 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहान्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यहून्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("युहन्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("John 1:1").osis()).toEqual("John.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YUHANNALE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNALE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNALE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNALE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNĀLE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNĀLE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNĀLE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNĀLE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNALE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNALE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNALE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNALE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNĀLE LEKʰEKO SUSMACAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNĀLE LEKʰEKO SUSMACĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNĀLE LEKʰEKO SUSMĀCAR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNĀLE LEKʰEKO SUSMĀCĀR 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्नाले लेखेको सुसमाचार 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्नाको सुसमाचार 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNALE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YUHANNĀLE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNALE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("YŪHANNĀLE 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्नाले 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहान्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यहून्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("युहन्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहन्ना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("यूहना 1:1").osis()).toEqual("John.1.1")
		expect(p.parse("JOHN 1:1").osis()).toEqual("John.1.1")
		`
		true
describe "Localized book Acts (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Acts (ne)", ->
		`
		expect(p.parse("preritharuka kam 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("preritharuka kām 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("preritharukā kam 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("preritharukā kām 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("preritharūka kam 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("preritharūka kām 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("preritharūkā kam 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("preritharūkā kām 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेरितहरूका काम 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेरित 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("Acts 1:1").osis()).toEqual("Acts.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PRERITHARUKA KAM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRERITHARUKA KĀM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRERITHARUKĀ KAM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRERITHARUKĀ KĀM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRERITHARŪKA KAM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRERITHARŪKA KĀM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRERITHARŪKĀ KAM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("PRERITHARŪKĀ KĀM 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेरितहरूका काम 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("प्रेरित 1:1").osis()).toEqual("Acts.1.1")
		expect(p.parse("ACTS 1:1").osis()).toEqual("Acts.1.1")
		`
		true
describe "Localized book Rom (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Rom (ne)", ->
		`
		expect(p.parse("रोमीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulai patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulaī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulāi patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulāī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlai patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlaī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlāi patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlāī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulai patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulaī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulāi patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulāī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlai patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlaī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlāi patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlāī patra 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमीहरूलाई पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulai 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulaī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulāi 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharulāī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlai 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlaī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlāi 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romiharūlāī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulai 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulaī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulāi 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharulāī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlai 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlaī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlāi 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("romīharūlāī 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमीहरूलाई 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमी 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("Rom 1:1").osis()).toEqual("Rom.1.1")
		p.include_apocrypha(false)
		expect(p.parse("रोमीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULAI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULAĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULĀI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULĀĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLAI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLAĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLĀI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLĀĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULAI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULAĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULĀI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULĀĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLAI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLAĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLĀI PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLĀĪ PATRA 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमीहरूलाई पत्र 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULAI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULAĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULĀI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARULĀĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLAI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLAĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLĀI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMIHARŪLĀĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULAI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULAĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULĀI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARULĀĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLAI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLAĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLĀI 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROMĪHARŪLĀĪ 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमीहरूलाई 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("रोमी 1:1").osis()).toEqual("Rom.1.1")
		expect(p.parse("ROM 1:1").osis()).toEqual("Rom.1.1")
		`
		true
describe "Localized book 2Cor (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Cor (ne)", ->
		`
		expect(p.parse("कोरिन्थीहरूलाई पावलको दोस्रो पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharulai dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharulaī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharulāi dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharulāī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharūlai dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharūlaī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharūlāi dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰiharūlāī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharulai dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharulaī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharulāi dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharulāī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharūlai dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharūlaī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharūlāi dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("korintʰīharūlāī dostro patra 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("कोरिन्थीहरूलाई दोस्त्रो पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharulai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharulaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharulāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharulāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharūlai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharūlaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharūlāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰiharūlāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharulai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharulaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharulāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharulāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharūlai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharūlaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharūlāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. korintʰīharūlāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharulai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharulaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharulāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharulāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharūlai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharūlaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharūlāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰiharūlāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharulai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharulaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharulāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharulāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharūlai 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharūlaī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharūlāi 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 korintʰīharūlāī 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. कोरिन्थीहरूलाई 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 कोरिन्थीहरूलाई 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. कोरिन्थी 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 कोरिन्थी 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2Cor 1:1").osis()).toEqual("2Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("कोरिन्थीहरूलाई पावलको दोस्रो पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARULAI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARULAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARULĀI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARULĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLAI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLĀI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARULAI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARULAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARULĀI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARULĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLAI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLĀI DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("कोरिन्थीहरूलाई दोस्त्रो पत्र 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARULAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARULAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARULĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARULĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARŪLAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARŪLAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARŪLĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰIHARŪLĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARULAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARULAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARULĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARULĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARŪLAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARŪLAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARŪLĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. KORINTʰĪHARŪLĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARULAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARULAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARULĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARULĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARŪLAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARŪLAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARŪLĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰIHARŪLĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARULAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARULAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARULĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARULĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARŪLAI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARŪLAĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARŪLĀI 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 KORINTʰĪHARŪLĀĪ 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. कोरिन्थीहरूलाई 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 कोरिन्थीहरूलाई 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2. कोरिन्थी 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2 कोरिन्थी 1:1").osis()).toEqual("2Cor.1.1")
		expect(p.parse("2COR 1:1").osis()).toEqual("2Cor.1.1")
		`
		true
describe "Localized book 1Cor (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Cor (ne)", ->
		`
		expect(p.parse("कोरिन्थीहरूलाई पावलको पहिलो पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharulai pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharulaī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharulāi pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharulāī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharūlai pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharūlaī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharūlāi pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰiharūlāī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharulai pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharulaī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharulāi pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharulāī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharūlai pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharūlaī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharūlāi pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("korintʰīharūlāī pahilo patra 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("कोरिन्थीहरूलाई पहिलो पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharulai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharulaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharulāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharulāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharūlai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharūlaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharūlāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰiharūlāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharulai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharulaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharulāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharulāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharūlai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharūlaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharūlāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. korintʰīharūlāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharulai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharulaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharulāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharulāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharūlai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharūlaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharūlāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰiharūlāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharulai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharulaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharulāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharulāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharūlai 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharūlaī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharūlāi 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 korintʰīharūlāī 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. कोरिन्थीहरूलाई 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 कोरिन्थीहरूलाई 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. कोरिन्थी 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 कोरिन्थी 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1Cor 1:1").osis()).toEqual("1Cor.1.1")
		p.include_apocrypha(false)
		expect(p.parse("कोरिन्थीहरूलाई पावलको पहिलो पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARULAI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARULAĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARULĀI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARULĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLAI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLAĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLĀI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰIHARŪLĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARULAI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARULAĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARULĀI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARULĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLAI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLAĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLĀI PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("KORINTʰĪHARŪLĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("कोरिन्थीहरूलाई पहिलो पत्र 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARULAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARULAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARULĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARULĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARŪLAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARŪLAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARŪLĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰIHARŪLĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARULAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARULAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARULĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARULĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARŪLAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARŪLAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARŪLĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. KORINTʰĪHARŪLĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARULAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARULAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARULĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARULĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARŪLAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARŪLAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARŪLĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰIHARŪLĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARULAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARULAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARULĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARULĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARŪLAI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARŪLAĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARŪLĀI 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 KORINTʰĪHARŪLĀĪ 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. कोरिन्थीहरूलाई 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 कोरिन्थीहरूलाई 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1. कोरिन्थी 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1 कोरिन्थी 1:1").osis()).toEqual("1Cor.1.1")
		expect(p.parse("1COR 1:1").osis()).toEqual("1Cor.1.1")
		`
		true
describe "Localized book Gal (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Gal (ne)", ->
		`
		expect(p.parse("गलातीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlai patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlaī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlāi patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlāī patra 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलातीहरूलाई पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharulāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatiharūlāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharulāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galatīharūlāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharulāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātiharūlāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharulāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlai 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlaī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlāi 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("galātīharūlāī 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलातीहरूलाई 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलाती 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("Gal 1:1").osis()).toEqual("Gal.1.1")
		p.include_apocrypha(false)
		expect(p.parse("गलातीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLAI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLAĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLĀI PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLĀĪ PATRA 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलातीहरूलाई पत्र 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARULĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATIHARŪLĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARULĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALATĪHARŪLĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARULĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTIHARŪLĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARULĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLAI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLAĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLĀI 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GALĀTĪHARŪLĀĪ 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलातीहरूलाई 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("गलाती 1:1").osis()).toEqual("Gal.1.1")
		expect(p.parse("GAL 1:1").osis()).toEqual("Gal.1.1")
		`
		true
describe "Localized book Eph (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Eph (ne)", ->
		`
		expect(p.parse("एफिसीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulai patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulaī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulāi patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulāī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlai patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlaī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlāi patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlāī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulai patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulaī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulāi patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulāī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlai patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlaī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlāi patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlāī patra 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("एफिसीहरूलाई पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulai 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulaī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulāi 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharulāī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlai 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlaī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlāi 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisiharūlāī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulai 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulaī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulāi 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharulāī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlai 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlaī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlāi 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("epʰisīharūlāī 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("एफिसीहरूलाई 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("एफिसी 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("Eph 1:1").osis()).toEqual("Eph.1.1")
		p.include_apocrypha(false)
		expect(p.parse("एफिसीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULAI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULAĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULĀI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULĀĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLAI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLAĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLĀI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLĀĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULAI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULAĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULĀI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULĀĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLAI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLAĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLĀI PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLĀĪ PATRA 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("एफिसीहरूलाई पत्र 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULAI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULAĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULĀI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARULĀĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLAI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLAĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLĀI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISIHARŪLĀĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULAI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULAĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULĀI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARULĀĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLAI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLAĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLĀI 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPʰISĪHARŪLĀĪ 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("एफिसीहरूलाई 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("एफिसी 1:1").osis()).toEqual("Eph.1.1")
		expect(p.parse("EPH 1:1").osis()).toEqual("Eph.1.1")
		`
		true
describe "Localized book Phil (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phil (ne)", ->
		`
		expect(p.parse("फिलिप्पीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulai patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulaī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulāi patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulāī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlai patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlaī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlāi patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlāī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulai patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulaī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulāi patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulāī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlai patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlaī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlāi patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlāī patra 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पीहरूलाई पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulai 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulaī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulāi 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharulāī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlai 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlaī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlāi 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippiharūlāī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulai 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulaī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulāi 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharulāī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlai 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlaī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlāi 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("pʰilippīharūlāī 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पीहरूलाई 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पी 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("Phil 1:1").osis()).toEqual("Phil.1.1")
		p.include_apocrypha(false)
		expect(p.parse("फिलिप्पीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULAI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULAĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULĀI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULĀĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLAI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLAĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLĀI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLĀĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULAI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULAĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULĀI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULĀĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLAI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLAĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLĀI PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLĀĪ PATRA 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पीहरूलाई पत्र 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULAI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULAĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULĀI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARULĀĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLAI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLAĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLĀI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPIHARŪLĀĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULAI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULAĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULĀI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARULĀĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLAI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLAĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLĀI 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PʰILIPPĪHARŪLĀĪ 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पीहरूलाई 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("फिलिप्पी 1:1").osis()).toEqual("Phil.1.1")
		expect(p.parse("PHIL 1:1").osis()).toEqual("Phil.1.1")
		`
		true
describe "Localized book Col (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Col (ne)", ->
		`
		expect(p.parse("कलस्सीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulai patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulaī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulāi patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulāī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlai patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlaī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlāi patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlāī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulai patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulaī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulāi patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulāī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlai patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlaī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlāi patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlāī patra 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सीहरूलाई पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulai 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulaī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulāi 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharulāī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlai 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlaī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlāi 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassiharūlāī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulai 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulaī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulāi 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharulāī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlai 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlaī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlāi 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("kalassīharūlāī 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सीहरूलाई 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सी 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("Col 1:1").osis()).toEqual("Col.1.1")
		p.include_apocrypha(false)
		expect(p.parse("कलस्सीहरूलाई पावलको पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULAI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULAĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULĀI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULĀĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLAI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLAĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLĀI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLĀĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULAI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULAĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULĀI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULĀĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLAI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLAĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLĀI PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLĀĪ PATRA 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सीहरूलाई पत्र 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULAI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULAĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULĀI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARULĀĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLAI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLAĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLĀI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSIHARŪLĀĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULAI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULAĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULĀI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARULĀĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLAI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLAĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLĀI 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("KALASSĪHARŪLĀĪ 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सीहरूलाई 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("कलस्सी 1:1").osis()).toEqual("Col.1.1")
		expect(p.parse("COL 1:1").osis()).toEqual("Col.1.1")
		`
		true
describe "Localized book 2Thess (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Thess (ne)", ->
		`
		expect(p.parse("थिस्सलोनिकीहरूलाई पावलको दोस्रो पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharulai dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharulaī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharulāi dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharulāī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharūlai dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharūlaī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharūlāi dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikiharūlāī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharulai dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharulaī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharulāi dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharulāī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharūlai dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharūlaī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharūlāi dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("tʰissalonikīharūlāī dostro patra 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("थिस्सलोनिकीहरूलाई दोस्त्रो पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharulai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharulaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharulāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharulāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharūlai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharūlaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharūlāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikiharūlāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharulai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharulaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharulāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharulāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharūlai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharūlaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharūlāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. tʰissalonikīharūlāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharulai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharulaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharulāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharulāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharūlai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharūlaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharūlāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikiharūlāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharulai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharulaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharulāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharulāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharūlai 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharūlaī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharūlāi 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 tʰissalonikīharūlāī 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. थिस्सलोनिकी 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 थिस्सलोनिकी 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2Thess 1:1").osis()).toEqual("2Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("थिस्सलोनिकीहरूलाई पावलको दोस्रो पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULAI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULĀI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLAI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLĀI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULAI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULĀI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLAI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLĀI DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("थिस्सलोनिकीहरूलाई दोस्त्रो पत्र 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARULAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARULAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARULĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARULĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARŪLAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARŪLAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARŪLĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKIHARŪLĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARULAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARULAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARULĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARULĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARŪLAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARŪLAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARŪLĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. TʰISSALONIKĪHARŪLĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARULAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARULAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARULĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARULĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARŪLAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARŪLAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARŪLĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKIHARŪLĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARULAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARULAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARULĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARULĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARŪLAI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARŪLAĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARŪLĀI 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 TʰISSALONIKĪHARŪLĀĪ 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2. थिस्सलोनिकी 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2 थिस्सलोनिकी 1:1").osis()).toEqual("2Thess.1.1")
		expect(p.parse("2THESS 1:1").osis()).toEqual("2Thess.1.1")
		`
		true
describe "Localized book 1Thess (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Thess (ne)", ->
		`
		expect(p.parse("थिस्सलोनिकीहरूलाई पावलको पहिलो पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharulai pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharulaī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharulāi pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharulāī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharūlai pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharūlaī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharūlāi pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikiharūlāī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharulai pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharulaī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharulāi pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharulāī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharūlai pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharūlaī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharūlāi pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("tʰissalonikīharūlāī pahilo patra 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("थिस्सलोनिकीहरूलाई पहिलो पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharulai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharulaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharulāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharulāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharūlai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharūlaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharūlāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikiharūlāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharulai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharulaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharulāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharulāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharūlai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharūlaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharūlāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. tʰissalonikīharūlāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharulai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharulaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharulāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharulāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharūlai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharūlaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharūlāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikiharūlāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharulai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharulaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharulāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharulāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharūlai 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharūlaī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharūlāi 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 tʰissalonikīharūlāī 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. थिस्सलोनिकी 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 थिस्सलोनिकी 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1Thess 1:1").osis()).toEqual("1Thess.1.1")
		p.include_apocrypha(false)
		expect(p.parse("थिस्सलोनिकीहरूलाई पावलको पहिलो पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULAI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULAĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULĀI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARULĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLAI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLAĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLĀI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKIHARŪLĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULAI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULAĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULĀI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARULĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLAI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLAĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLĀI PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("TʰISSALONIKĪHARŪLĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("थिस्सलोनिकीहरूलाई पहिलो पत्र 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARULAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARULAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARULĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARULĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARŪLAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARŪLAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARŪLĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKIHARŪLĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARULAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARULAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARULĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARULĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARŪLAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARŪLAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARŪLĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. TʰISSALONIKĪHARŪLĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARULAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARULAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARULĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARULĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARŪLAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARŪLAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARŪLĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKIHARŪLĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARULAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARULAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARULĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARULĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARŪLAI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARŪLAĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARŪLĀI 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 TʰISSALONIKĪHARŪLĀĪ 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 थिस्सलोनिकीहरूलाई 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1. थिस्सलोनिकी 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1 थिस्सलोनिकी 1:1").osis()).toEqual("1Thess.1.1")
		expect(p.parse("1THESS 1:1").osis()).toEqual("1Thess.1.1")
		`
		true
describe "Localized book 2Tim (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Tim (ne)", ->
		`
		expect(p.parse("तिमोथीलाई पावलको दोस्रो पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰilai dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰilaī dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰilāi dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰilāī dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰīlai dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰīlaī dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰīlāi dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("timotʰīlāī dostro patra 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("तिमोथीलाई दोस्त्रो पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰilai 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰilaī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰilāi 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰilāī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰīlai 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰīlaī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰīlāi 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. timotʰīlāī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰilai 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰilaī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰilāi 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰilāī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰīlai 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰīlaī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰīlāi 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 timotʰīlāī 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. तिमोथीलाई 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 तिमोथीलाई 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. तिमोथी 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 तिमोथी 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2Tim 1:1").osis()).toEqual("2Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("तिमोथीलाई पावलको दोस्रो पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰILAI DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰILAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰILĀI DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰILĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰĪLAI DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰĪLAĪ DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰĪLĀI DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("TIMOTʰĪLĀĪ DOSTRO PATRA 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("तिमोथीलाई दोस्त्रो पत्र 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰILAI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰILAĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰILĀI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰILĀĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰĪLAI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰĪLAĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰĪLĀI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. TIMOTʰĪLĀĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰILAI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰILAĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰILĀI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰILĀĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰĪLAI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰĪLAĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰĪLĀI 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 TIMOTʰĪLĀĪ 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. तिमोथीलाई 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 तिमोथीलाई 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2. तिमोथी 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2 तिमोथी 1:1").osis()).toEqual("2Tim.1.1")
		expect(p.parse("2TIM 1:1").osis()).toEqual("2Tim.1.1")
		`
		true
describe "Localized book 1Tim (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Tim (ne)", ->
		`
		expect(p.parse("तिमोथीलाईर् पावलको पहिलो पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰilai pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰilaī pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰilāi pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰilāī pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰīlai pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰīlaī pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰīlāi pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("timotʰīlāī pahilo patra 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("तिमोथीलाई पहिलो पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰilai 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰilaī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰilāi 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰilāī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰīlai 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰīlaī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰīlāi 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. timotʰīlāī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰilai 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰilaī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰilāi 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰilāī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰīlai 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰīlaī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰīlāi 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 timotʰīlāī 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. तिमोथीलाई 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तिमोथीलाई 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. तिमोथी 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तिमोथी 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1Tim 1:1").osis()).toEqual("1Tim.1.1")
		p.include_apocrypha(false)
		expect(p.parse("तिमोथीलाईर् पावलको पहिलो पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰILAI PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰILAĪ PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰILĀI PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰILĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰĪLAI PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰĪLAĪ PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰĪLĀI PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("TIMOTʰĪLĀĪ PAHILO PATRA 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("तिमोथीलाई पहिलो पत्र 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰILAI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰILAĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰILĀI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰILĀĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰĪLAI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰĪLAĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰĪLĀI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. TIMOTʰĪLĀĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰILAI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰILAĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰILĀI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰILĀĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰĪLAI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰĪLAĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰĪLĀI 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 TIMOTʰĪLĀĪ 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. तिमोथीलाई 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तिमोथीलाई 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1. तिमोथी 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1 तिमोथी 1:1").osis()).toEqual("1Tim.1.1")
		expect(p.parse("1TIM 1:1").osis()).toEqual("1Tim.1.1")
		`
		true
describe "Localized book Titus (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Titus (ne)", ->
		`
		expect(p.parse("तीतसलाई पावलको पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslai patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslaī patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslāi patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslāī patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslai patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslaī patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslāi patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslāī patra 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीतसलाई पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslai 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslaī 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslāi 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("titaslāī 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslai 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslaī 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslāi 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("tītaslāī 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीतसलाई 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("Titus 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीतस 1:1").osis()).toEqual("Titus.1.1")
		p.include_apocrypha(false)
		expect(p.parse("तीतसलाई पावलको पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLAI PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLAĪ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLĀI PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLĀĪ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLAI PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLAĪ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLĀI PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLĀĪ PATRA 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीतसलाई पत्र 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLAI 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLAĪ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLĀI 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITASLĀĪ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLAI 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLAĪ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLĀI 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TĪTASLĀĪ 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीतसलाई 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("TITUS 1:1").osis()).toEqual("Titus.1.1")
		expect(p.parse("तीतस 1:1").osis()).toEqual("Titus.1.1")
		`
		true
describe "Localized book Phlm (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Phlm (ne)", ->
		`
		expect(p.parse("फिलेमोनलाई पावलको पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlai patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlaī patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlāi patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlāī patra 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनलाई पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlai 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlaī 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlāi 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("pʰilemonlāī 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनलाई 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोन 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("Phlm 1:1").osis()).toEqual("Phlm.1.1")
		p.include_apocrypha(false)
		expect(p.parse("फिलेमोनलाई पावलको पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLAI PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLAĪ PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLĀI PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLĀĪ PATRA 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनलाई पत्र 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLAI 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLAĪ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLĀI 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PʰILEMONLĀĪ 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोनलाई 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("फिलेमोन 1:1").osis()).toEqual("Phlm.1.1")
		expect(p.parse("PHLM 1:1").osis()).toEqual("Phlm.1.1")
		`
		true
describe "Localized book Heb (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Heb (ne)", ->
		`
		expect(p.parse("hibruharuko nimti patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("hibruharūko nimti patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("hibrūharuko nimti patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("hibrūharūko nimti patra 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("हिब्रूहरूको निम्ति पत्र 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("हिब्रूहरूको निम्ति 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("hibruharuko nimti 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("hibruharūko nimti 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("hibrūharuko nimti 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("hibrūharūko nimti 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("हिब्रू 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("Heb 1:1").osis()).toEqual("Heb.1.1")
		p.include_apocrypha(false)
		expect(p.parse("HIBRUHARUKO NIMTI PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HIBRUHARŪKO NIMTI PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HIBRŪHARUKO NIMTI PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HIBRŪHARŪKO NIMTI PATRA 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("हिब्रूहरूको निम्ति पत्र 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("हिब्रूहरूको निम्ति 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HIBRUHARUKO NIMTI 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HIBRUHARŪKO NIMTI 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HIBRŪHARUKO NIMTI 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HIBRŪHARŪKO NIMTI 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("हिब्रू 1:1").osis()).toEqual("Heb.1.1")
		expect(p.parse("HEB 1:1").osis()).toEqual("Heb.1.1")
		`
		true
describe "Localized book Jas (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jas (ne)", ->
		`
		expect(p.parse("yakubko patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakūbko patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākubko patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākūbko patra 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकूबको पत्र 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakubko 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yakūbko 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākubko 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("yākūbko 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकूबको 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकूब 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("Jas 1:1").osis()).toEqual("Jas.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAKUBKO PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKŪBKO PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKUBKO PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKŪBKO PATRA 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकूबको पत्र 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKUBKO 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YAKŪBKO 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKUBKO 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("YĀKŪBKO 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकूबको 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("याकूब 1:1").osis()).toEqual("Jas.1.1")
		expect(p.parse("JAS 1:1").osis()).toEqual("Jas.1.1")
		`
		true
describe "Localized book 2Pet (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Pet (ne)", ->
		`
		expect(p.parse("पत्रुसको दोस्त्रो पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("patrusko dostro patra 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("पत्रुसको दोस्रो पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. patrusko 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. पत्रुसको 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 patrusko 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पत्रुसको 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. पत्रुस 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पत्रुस 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2Pet 1:1").osis()).toEqual("2Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("पत्रुसको दोस्त्रो पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("PATRUSKO DOSTRO PATRA 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("पत्रुसको दोस्रो पत्र 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. PATRUSKO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. पत्रुसको 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 PATRUSKO 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पत्रुसको 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2. पत्रुस 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2 पत्रुस 1:1").osis()).toEqual("2Pet.1.1")
		expect(p.parse("2PET 1:1").osis()).toEqual("2Pet.1.1")
		`
		true
describe "Localized book 1Pet (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Pet (ne)", ->
		`
		expect(p.parse("patrusko pahilo patra 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("पत्रुसको पहिलो पत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. patrusko 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. पत्रुसको 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 patrusko 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पत्रुसको 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. पत्रुस 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पत्रुस 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1Pet 1:1").osis()).toEqual("1Pet.1.1")
		p.include_apocrypha(false)
		expect(p.parse("PATRUSKO PAHILO PATRA 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("पत्रुसको पहिलो पत्र 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. PATRUSKO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. पत्रुसको 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 PATRUSKO 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पत्रुसको 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1. पत्रुस 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1 पत्रुस 1:1").osis()).toEqual("1Pet.1.1")
		expect(p.parse("1PET 1:1").osis()).toEqual("1Pet.1.1")
		`
		true
describe "Localized book Jude (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jude (ne)", ->
		`
		expect(p.parse("yahudako patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudāko patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdako patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdāko patra 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाको पत्र 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudako 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahudāko 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdako 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("yahūdāko 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाको 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदा 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("Jude 1:1").osis()).toEqual("Jude.1.1")
		p.include_apocrypha(false)
		expect(p.parse("YAHUDAKO PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDĀKO PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDAKO PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDĀKO PATRA 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाको पत्र 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDAKO 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHUDĀKO 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDAKO 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("YAHŪDĀKO 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदाको 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("यहूदा 1:1").osis()).toEqual("Jude.1.1")
		expect(p.parse("JUDE 1:1").osis()).toEqual("Jude.1.1")
		`
		true
describe "Localized book Tob (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Tob (ne)", ->
		`
		expect(p.parse("Tob 1:1").osis()).toEqual("Tob.1.1")
		`
		true
describe "Localized book Jdt (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Jdt (ne)", ->
		`
		expect(p.parse("Jdt 1:1").osis()).toEqual("Jdt.1.1")
		`
		true
describe "Localized book Bar (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Bar (ne)", ->
		`
		expect(p.parse("Bar 1:1").osis()).toEqual("Bar.1.1")
		`
		true
describe "Localized book Sus (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: Sus (ne)", ->
		`
		expect(p.parse("Sus 1:1").osis()).toEqual("Sus.1.1")
		`
		true
describe "Localized book 2Macc (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 2Macc (ne)", ->
		`
		expect(p.parse("2Macc 1:1").osis()).toEqual("2Macc.1.1")
		`
		true
describe "Localized book 3Macc (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 3Macc (ne)", ->
		`
		expect(p.parse("3Macc 1:1").osis()).toEqual("3Macc.1.1")
		`
		true
describe "Localized book 4Macc (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 4Macc (ne)", ->
		`
		expect(p.parse("4Macc 1:1").osis()).toEqual("4Macc.1.1")
		`
		true
describe "Localized book 1Macc (ne)", ->
	p = {}
	beforeEach ->
		p = new bcv_parser
		p.set_options book_alone_strategy: "ignore",book_sequence_strategy: "ignore",osis_compaction_strategy: "bc",captive_end_digits_strategy: "delete"
		p.include_apocrypha true
	it "should handle book: 1Macc (ne)", ->
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
		expect(p.languages).toEqual ["ne"]

	it "should handle ranges (ne)", ->
		expect(p.parse("Titus 1:1 - 2").osis()).toEqual "Titus.1.1-Titus.1.2"
		expect(p.parse("Matt 1-2").osis()).toEqual "Matt.1-Matt.2"
		expect(p.parse("Phlm 2 - 3").osis()).toEqual "Phlm.1.2-Phlm.1.3"
	it "should handle chapters (ne)", ->
		expect(p.parse("Titus 1:1, chapter 2").osis()).toEqual "Titus.1.1,Titus.2"
		expect(p.parse("Matt 3:4 CHAPTER 6").osis()).toEqual "Matt.3.4,Matt.6"
	it "should handle verses (ne)", ->
		expect(p.parse("Exod 1:1 verse 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm VERSE 6").osis()).toEqual "Phlm.1.6"
	it "should handle 'and' (ne)", ->
		expect(p.parse("Exod 1:1 and 3").osis()).toEqual "Exod.1.1,Exod.1.3"
		expect(p.parse("Phlm 2 AND 6").osis()).toEqual "Phlm.1.2,Phlm.1.6"
	it "should handle titles (ne)", ->
		expect(p.parse("Ps 3 title, 4:2, 5:title").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
		expect(p.parse("PS 3 TITLE, 4:2, 5:TITLE").osis()).toEqual "Ps.3.1,Ps.4.2,Ps.5.1"
	it "should handle 'ff' (ne)", ->
		expect(p.parse("Rev 3ff, 4:2ff").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
		expect(p.parse("REV 3 FF, 4:2 FF").osis()).toEqual "Rev.3-Rev.22,Rev.4.2-Rev.4.11"
	it "should handle translations (ne)", ->
		expect(p.parse("Lev 1 (ERV)").osis_and_translations()).toEqual [["Lev.1", "ERV"]]
		expect(p.parse("lev 1 erv").osis_and_translations()).toEqual [["Lev.1", "ERV"]]
	it "should handle book ranges (ne)", ->
		p.set_options {book_alone_strategy: "full", book_range_strategy: "include"}
		expect(p.parse("1 - 3  yuhannako").osis()).toEqual "1John.1-3John.1"
		expect(p.parse("1 - 3  yuhannāko").osis()).toEqual "1John.1-3John.1"
		expect(p.parse("1 - 3  yūhannako").osis()).toEqual "1John.1-3John.1"
		expect(p.parse("1 - 3  yūhannāko").osis()).toEqual "1John.1-3John.1"
	it "should handle boundaries (ne)", ->
		p.set_options {book_alone_strategy: "full"}
		expect(p.parse("\u2014Matt\u2014").osis()).toEqual "Matt.1-Matt.28"
		expect(p.parse("\u201cMatt 1:1\u201d").osis()).toEqual "Matt.1.1"
