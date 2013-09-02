/*!!
 * Title Alert 0.7
 * 
 * Copyright (c) 2009 ESN | http://esn.me
 * Jonatan Heyman | http://heyman.info
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 */
!function(t){t.titleAlert=function(e,l){if(t.titleAlert._running&&t.titleAlert.stop(),t.titleAlert._settings=l=t.extend({},t.titleAlert.defaults,l),!l.requireBlur||!t.titleAlert.hasFocus){l.originalTitleInterval=l.originalTitleInterval||l.interval,t.titleAlert._running=!0,t.titleAlert._initialText=document.title,document.title=e;var i=!0,n=function(){t.titleAlert._running&&(i=!i,document.title=i?e:t.titleAlert._initialText,t.titleAlert._intervalToken=setTimeout(n,i?l.interval:l.originalTitleInterval))};t.titleAlert._intervalToken=setTimeout(n,l.interval),l.stopOnMouseMove&&t(document).mousemove(function(e){t(this).unbind(e),t.titleAlert.stop()}),l.duration>0&&(t.titleAlert._timeoutToken=setTimeout(function(){t.titleAlert.stop()},l.duration))}},t.titleAlert.defaults={interval:500,originalTitleInterval:null,duration:0,stopOnFocus:!0,requireBlur:!1,stopOnMouseMove:!1},t.titleAlert.stop=function(){clearTimeout(t.titleAlert._intervalToken),clearTimeout(t.titleAlert._timeoutToken),document.title=t.titleAlert._initialText,t.titleAlert._timeoutToken=null,t.titleAlert._intervalToken=null,t.titleAlert._initialText=null,t.titleAlert._running=!1,t.titleAlert._settings=null},t.titleAlert.hasFocus=!0,t.titleAlert._running=!1,t.titleAlert._intervalToken=null,t.titleAlert._timeoutToken=null,t.titleAlert._initialText=null,t.titleAlert._settings=null,t.titleAlert._focus=function(){if(t.titleAlert.hasFocus=!0,t.titleAlert._running&&t.titleAlert._settings.stopOnFocus){var e=t.titleAlert._initialText;t.titleAlert.stop(),setTimeout(function(){t.titleAlert._running||(document.title=".",document.title=e)},1e3)}},t.titleAlert._blur=function(){t.titleAlert.hasFocus=!1},t(window).bind("focus",t.titleAlert._focus),t(window).bind("blur",t.titleAlert._blur)}(jQuery);