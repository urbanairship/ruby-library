/**
 * HORIZONTAL SLIDE OUT MENU TAKEN FROM:
 *
 * cbpHorizontalSlideOutMenu.js v1.0.0
 * http://www.codrops.com
 *
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Copyright 2013, Codrops
 * http://www.codrops.com
 */
 
;( function( window ) {
     
    'use strict';
 
    var document = window.document;
 
    function extend( a, b ) {
        for( var key in b ) { 
            if( b.hasOwnProperty( key ) ) {
                a[key] = b[key];
            }
        }
        return a;
    }
 
    function cbpHorizontalSlideOutMenu( el, options ) { 
        this.el = el;
        this.options = extend( this.defaults, options );
        this._init();
    }
 
    cbpHorizontalSlideOutMenu.prototype = {
        defaults : {},
        _init : function() {
            this.current = -1;
            this.touch = Modernizr.touch;
            this.menu = this.el.querySelector( '.main-menu' );
            this.menuItems = this.el.querySelectorAll( '.main-menu > li' );
            this.menuBg = document.createElement( 'div' );
            this.menuBg.className = 'menubg';
            this.el.appendChild( this.menuBg );
            this._initEvents();
        },
        _openMenu : function( el, ev ) {
             
            var self = this,
                item = el.parentNode,
                items = Array.prototype.slice.call( this.menuItems ),
                submenu = item.querySelector( '.submenu' ),
                closeCurrent = function( current ) {
                    var current = current || self.menuItems[ self.current ];
                    current.className = '';
                    current.setAttribute( 'data-open', '' );    
                },
                closePanel = function() {
                    self.current = -1;
                    self.menuBg.style.height = '0px';
                };
 
            if( submenu ) {
 
                ev.preventDefault();
 
                if( item.getAttribute( 'data-open' ) === 'open' ) {
                    closeCurrent( item );
                    closePanel();
                }
                else {
                    item.setAttribute( 'data-open', 'open' );
                    if( self.current !== -1 ) {
                        closeCurrent();
                    }
                    self.current = items.indexOf( item );
                    item.className = 'item-open';
                    self.menuBg.style.height = submenu.offsetHeight + 'px';
                }
            }
            else {
                if( self.current !== -1 ) {
                    closeCurrent();
                    closePanel();
                }
            }
 
        },
        _initEvents : function() {
             
            var self = this;
 
            Array.prototype.slice.call( this.menuItems ).forEach( function( el, i ) {
                var trigger = el.querySelector( 'a' );
                if( self.touch ) {
                    trigger.addEventListener( 'touchstart', function( ev ) { self._openMenu( this, ev ); } );
                }
                else {
                    trigger.addEventListener( 'click', function( ev ) { self._openMenu( this, ev ); } );    
                }
            } );
             
            window.addEventListener( 'resize', function( ev ) { self._resizeHandler(); } );
 
        },
        // taken from https://github.com/desandro/vanilla-masonry/blob/master/masonry.js by David DeSandro
        // original debounce by John Hann
        // http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
        _resizeHandler : function() {
            var self = this;
            function delayed() {
                self._resize();
                self._resizeTimeout = null;
            }
 
            if ( this._resizeTimeout ) {
                clearTimeout( this._resizeTimeout );
            }
 
            this._resizeTimeout = setTimeout( delayed, 50 );
        },
        _resize : function() {
            if( this.current !== -1 ) {
                this.menuBg.style.height = this.menuItems[ this.current ].querySelector( '.submenu' ).offsetHeight + 'px';
            }
        }
    }
 
    // add to global namespace
    window.cbpHorizontalSlideOutMenu = cbpHorizontalSlideOutMenu;
 
} )( window );