var Tree = Tree || ( function () {
    'use strict';
    var _this = this;
    _this.version = '0.01';
    _this.author = 'Hernan Lopes';
    _this.is_initialized = false;
    _this.tree = undefined;
    _this.html_table = undefined;

    _this.endpoint = {
        tree     : function ( id ) {
            return "/endpoint/tree/" + (id||'');
        },
        node_add : function () { return '/endpoint/node/add' },
        node_get : function ( id ) {
            return "/endpoint/node/get/"+id;
        }
    };

    _this.get_tree = function ( id ) {
        console.log( 'getting root node....' );
        _this.jquery_ajax( _this.endpoint.tree( id ), 'GET', _this.set_tree );
        return _this;
    }

    _this.add_node = function ( parent_id ) {
        _this.jquery_ajax( _this.endpoint.node_add(), 'PUT', _this.print_tree, {parent_id : parent_id} );
        return _this;
    }

    _this.print_tree = function ( data ) {
        _this.get_tree();
        _this.draw_tree();
    }

    _this.set_tree = function ( data ) {
        _this.tree = data.tree ;
    }

    _this.draw_tree = function ( ) {
        var elem = _this.html_table.html('');
        var th = $('<thead/>').appendTo(elem);
        var th_depth = $('<th>').html('Depth');
        var th_nodes = $('<th>').html('Tree Nodes');
        th
            .append( th_depth )
            .append( th_nodes )
            .appendTo( th )
            ;
        
        var tr = $('<tr/>').appendTo(elem);
        //console.log( _this.tree );
        var td_depth = $('<td/>').html(_this.tree.level)
            .appendTo(tr);

        var td_node  = $('<td/>').html(_this.node_info( _this.tree.node ) )
            .appendTo(tr);
        
        var tr_children = $('<tr/>').appendTo( elem );
        var td_children = $('<td>');

        _this.draw_children( tr_children, td_children, _this.tree.children )
    } 

    _this.node_info = function ( node ) {
        var parent_id = 
            (node.parent_id)
                ? node.parent_id
                : 'NONE'
                ;
        return $('<div/>').attr('data-node-id', node.id ).attr('data-node-parent_id',node.parent_id).html('P:'+parent_id+' ID:' + node.id );
    }

    _this.draw_children = function ( tr_children, td_children , children ) {
        if ( ! children.length ) return;
console.log( children );
        var elem = _this.html_table;
        var level = children[0].level;
        if ( ! tr_children.find( 'td[data-type]' ).length ) { 
            var td_level = $('<td/>').attr('data-type', 'level').html(level).appendTo( tr_children );
        }
        td_children.appendTo( tr_children );

        var tr_next_level_children = $('<tr/>').appendTo( elem );
        var td_next_level_children = $('<td/>');
    

        for ( var i=0, child; child = children[i]; i++ ) {
            var node = _this.node_info( child.node );
            td_children.append( node );
            ( children[i+1] )
                ? td_children.append( ' | ' )
                : undefined
                ;
        }


        //now draw childrens children
        for ( var i=0, child; child = children[i]; i++ ) {
            _this.draw_children( tr_next_level_children , td_next_level_children, child.children );
        }
    }

    _this.jquery_ajax = function ( url, method, cb, json_content ) {
        $.ajax({
            url         : url,
            contentType : "application/json",
            dataType    : "json",
            cache       : false,
            async       : false,
            data        : JSON.stringify(json_content),
            success     : function (data) {
                console.log('executed jquery ajax');
                cb( data );
            },
            type: method
        }); 
    } 

    _this.init = function () {
        if ( _this.is_initialized ) return;
        _this.is_initialized = true;
        console.log('initialized');
    }

    this;
} );
