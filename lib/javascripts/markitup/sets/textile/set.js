// -------------------------------------------------------------------
// markItUp!
// -------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// Textile tags example
// http://en.wikipedia.org/wiki/Textile_(markup_language)
// http://www.textism.com/
// -------------------------------------------------------------------
// Feel free to add more tags
// -------------------------------------------------------------------
markitup_settings = {
	previewParserPath:	'', // path to your Textile parser
	onShiftEnter:		{keepDefault:false, replaceWith:'\n\n'},
	markupSet: [
		{name:'Negrita', key:'B', className:'negrita', closeWith:'*', openWith:'*'},
		{name:'Cursiva', key:'I', className:'cursiva', closeWith:'_', openWith:'_'},
		{name:'Tachado', key:'S', className:'tachado', closeWith:'-', openWith:'-'},
		{separator:'---------------' },
		{name:'Lista de viñetas', className: 'lista', openWith:'(!(* |!|*)!)'},
		{name:'Lista numerada', className:'numerada', openWith:'(!(# |!|#)!)'},
		{separator:'---------------' },
		{name:'Imagen', className: 'imagen', replaceWith:'![![Ruta:!:http://]!]([![Texto alternativo]!])!'},
		{name:'Enlace', className:'enlace', openWith:'"', closeWith:'":[![Ruta:!:http://]!]', placeHolder:'Texto del enlace aquí...' },
		{separator:'---------------' },
		{name:'Cita', className:'cita', openWith:'bq(!(([![Class]!]))!). '}
	]
}