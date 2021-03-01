		{
			osis: ["Ps"],
			extra: "1",
			// Allow 151st Psalm
			regexp: new RegExp(`(\\b)((?:\
(?:(?:1[02-5]|[2-9])?(?:1${bcv_parser.prototype.regexps.space}*st|2${bcv_parser.prototype.regexps.space}*nd|3${bcv_parser.prototype.regexps.space}*rd))\
|1?1[123]${bcv_parser.prototype.regexps.space}*th\
|(?:150|1[0-4][04-9]|[1-9][04-9]|[4-9])${bcv_parser.prototype.regexps.space}*th\
)\
${bcv_parser.prototype.regexps.space}*Psalm\
)\\b`, 'gi')
		},
