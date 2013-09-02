/**
 * MODIFIED CAUSE WE NEEDED OUR OWN MARKUP
 * stacktable.js
 * Author & copyright (c) 2012: John Polacek
 * Dual MIT & GPL license
 *
 * Page: http://johnpolacek.github.com/stacktable.js
 * Repo: https://github.com/johnpolacek/stacktable.js/
 *
 * jQuery plugin for stacking tables on small screens
 *
 */
!function(t){t.fn.stacktable=function(a){var d=this,e={id:"stacktable",hideOriginal:!1},i=t.extend({},e,a);return d.each(function(){var a=t('<table class="'+i.id+'"><tbody></tbody></table>');void 0!==typeof i.myClass&&a.addClass(i.myClass);var d="";$table=t(this),$topRow=$table.find("tr").eq(0),$table.find("tr").each(function(a){var e="";e=0===a%2?"even":"odd",d+='<tr class="'+e+'">',t(this).find("td").each(function(a){""!==t(this).html()&&(d+='<tr class="'+e+'">',d+=$topRow.find("td,th").eq(a).html()?"<td>"+$topRow.find("td,th").eq(a).html()+"</td>":"<td></td>",d+="<td>"+t(this).html()+"</td>",d+="</tr>")})}),a.append(t(d)),$table.before(a),i.hideOriginal&&$table.hide()})}}(jQuery);